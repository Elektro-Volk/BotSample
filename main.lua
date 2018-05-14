connect "scripts/tokens";
connect "scripts/errors";

NameSystem.botNames = { "пуся", "!" };
admin = 1;

function GetPhotoURL (p) return p.photo_2560 or p.photo_1280 or p.photo_807 or p.photo_604 or p.photo_130 or p.photo_75 end

--[[
	Вот сюда поступает каждое новое сообщение.
	Описание msg - vk.com/dev/objects/message
]]
function NewMessage(msg)
	if not NameSystem.IsMe(msg) then return end -- Проверяет сообщение на наличие имени, а так же очищает его
	status, err = pcall(TreatmentMessage, msg); -- Подобие try catch в Lua :(
	if not status then console.error(err); resp(msg, "[id"..admin.."|🐩] "..err);  end -- Отправляем ошибку пользователю
end

function TreatmentMessage(msg)
	local user = DbData(msg.user_id); -- Получаем юзера из базы данных
	if user:checkBan() then return end -- Проверяем его на бан
	console.log((msg.chat_id and "["..msg.chat_id.."|"..msg.title.."]" or '')..msg.user_id.." -> "..(msg.body or '-'));

	local other = { time = os.clock() }; -- Создаем таблицу с доп. инфой.

	local rmsg = CommandsSystem.Execute(msg, other, user) -- Ищем команды
	--[[
		Если команда не будет найдена, то CommandsSystem.Execute вернет nil.
		В Lua есть тернарный оператор: arg1 or arg2 or...argN
		Если arg1 = nil, то вернется arg2, если arg2 тоже nil, то дальше,
		Если все аргументы = nil, то вернется nil.
		Подробнее: https://ilovelua.wordpress.com/2010/09/22/тернарный-оператор
	]]
	or { message = "Команда не найдена, напиши `"..NameSystem.botNames[1].." помощь`, для получения справки." };
	--[[
		Вместо ошибки можно вернуть что угодно, у Евы это сообщение с базы фраз.
		Вы тоже такое можете такое реализовать, или попросить в группе EBP решение :)
	]]

	if other.nosend then return end -- Если в сообщении написать other.nosend = true, то бот не ответит.
	NameSystem.Apply(msg, other, rmsg, user); -- Установим обращение пользователя'
	
	SendMessage(msg, rmsg, other); -- Отвечаем на сообщение
end

--[[
	Осторожно, магия.
]]
function SendMessage(msg, rmsg, other)
	rmsg.peer_id = msg.from_id or msg.user_id;
	local elapsed = math.floor((os.clock()-other.time)*1000);
	local resp = vk.jSend('messages.send', rmsg);
	if not resp.response then -- Error
		console.error(resp.error.error_msg, "=> "..rmsg.peer_id);
		status, err = pcall(SMessageError, rmsg, other, resp.error);
		if not status then console.error(err); isCap = false; capCount = 0; end
	else -- Normal
		if not rmsg.captcha_key then AntiCaptcha.capCount = 0 end
		console.log("response: "..(rmsg.message or '-').." | time: "..elapsed.."ms");
	end
end

--[[
	Обработка ошибок
]]
function SMessageError(rmsg, other, err)
	VK.messages.setActivity { peer_id = rmsg.peer_id, type = 'typing' };
	if err.error_code == 14 then AntiCaptcha.Do(rmsg, other, err) end
end
