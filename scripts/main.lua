dofile "bot/scripts/pnm.lua";

DbData.Connect('host', 'username', 'password', 'dbname');--Ваша база данных для хранения пользователей
RandomEvents.LoadRP('settings/randomPhrases.txt');
--Rucaptcha.key = 'mykey';-- Ваш ключ в Rucaptcha (Если вы хотите автоматически обрабатывать капчу
NameSystem.botNames = {"пуся","\\"};-- Имена бота
admin = 1; -- Сюда ваш ид вконтакте

-- Проверяет сообщение: Стоит ли на него отвечать
function CheckMessage(msg)
	local ok = not isFlag(msg[3], 2) and NameSystem.IsMe(msg)
	if ok then  return NameSystem.Clear(vk.jSend('messages.getById', { message_ids = msg[2] }).response.items[1]) 
	else  pnm(msg) return nil end
end

-- Поток с новым сообщением
function NewMessage(msg)
	if not AntiFlood.CheckRepeat(msg) or not AntiFlood.CheckFlood(msg) then return end
	local other = { time = os.clock() };
	status, err = pcall(TreatmentMessage, msg, other); -- trycatch в lua
	if not status then console.error(err); resp(msg, "[id"..admin.."|🐩] "..err);  end -- Ошибка
end

-- Обработка сообщения
function TreatmentMessage(msg, other)
	other.udata = DbData(msg.user_id); -- Если есть грузим юзера из БД
	if other.udata.ban == -1 or os.time() <= other.udata.ban then return end -- Проверка на бан
	console.log((msg.chat_id and "["..msg.chat_id.."|"..msg.title.."]" or '')..msg.user_id.." -> "..(msg.body or '-'));
	
	local rmsg = CommandsSystem.Execute(msg, other) 
	or { message = string.format('Команда не найдена, напишите "%s помощь", для получения списка команд', NameSystem.botNames[1]) };

	-- Post
	if other.nosend then return end
	AntiFlood.Apply(msg);
	NameSystem.Apply(msg, other, rmsg);
	
	rmsg.peer_id = getPeer(msg);
	SendMessage(rmsg, other);
end

function SendMessage(rmsg, other)
	local resp = VK.messages.send(rmsg);
	if not resp.response then -- Error
		console.error(resp.error.error_msg, "=> "..rmsg.peer_id);
		SMessageError(rmsg, other, resp.error);
	else -- Normal
		local elapsed = math.floor((os.clock()-other.time)*1000);
		console.log("response: "..(rmsg.message or '-').." | time: "..elapsed.."ms");
	end
end

function SMessageError(rmsg, other, err)
	if err.error_code == 14 and Rucaptcha.key then -- CAPTCHA
		if not rmsg.captcha_key then
			console.log("Getting captcha from Rucaptcha...");
			local resp = Rucaptcha.Get(err.captcha_img);
			rmsg.captcha_sid = err.captcha_sid;
			rmsg.captcha_key = resp;
			console.log("Captcha: "..resp);
			SendMessage(rmsg, other);
		end
	elseif err.error_code == 6 then
		console.log("Resending...");
		SendMessage(rmsg, other);
	else
		console.log("Unknow: "..err.error_code);
	end
end