-- VERSION 0.1
--[[
	Этот модуль позволяет отстранить ваших пользователей от флуда.
	Например если они хотят "задудосить" вашего бота, 
	или просто довести до капчи.
	
	Установка:
		1) Подключите модуль в функции LoadModules
		2) В POST обработку добавьте "AntiFlood.Apply(msg);"
		3) Если вам нужна защита от флуда,
		 ) Вставьте "if not AntiFlood.CheckFlood(msg.user_id, mid) then return; end"
		 ) Сразу после получения объекта сообщения
		 ) Должно это выглядить примерно так:
		 )local msg = EbpTools.GetVKMessage(mid);
		 ) if not AntiFlood.CheckFlood(msg) then return; end
		 )
		4) Если вам нужна защита от повторений
		 ) (Когда пользователь пишет боту одно и то же)
		 ) Замените
		 ) EbpTools.vk.SetTyping(msg);
		 ) msg.body = EbpTools.Clear(msg.body, botNames);
		 ) На
		 ) msg.body = EbpTools.Clear(msg.body, botNames);
		 ) if not AntiFlood.CheckRepeat(msg) then return; end
		 ) EbpTools.vk.SetTyping(msg);
		 )
		5) Готово! Теперь ваш бот защитен от флуда!
		 
	Настройка:
		Модуль содержит достаточно настроек, чтобы разнообразить его.
		Менять эти настройки стоит не тут, а в функции Main вашего скрипта.
		Пример: AntiFlood.max_messages = 3;
		Модуль содержит следующие настройки:
			1) AntiFlood.max_messages = 3; -- Максимальное кол-во сообщений в период
			2) AntiFlood.for_time = 10; -- Промежуток сообщений
				(AntiFlood.max_messages сообщений в AntiFlood.for_time секунд)
			3) AntiFlood.mute_time = 20; -- Время мута, если пользователь спамил
			4) AntiFlood.mute_msg = ""; -- Сообщение при флуде
			5) AntiFlood.r_msg = ""; -- Сообщение при повторении
			
		Если вам мало настроек и функций, то вы можете обратиться к создателю модуля
		Вконтакте: https://vk.com/elektro_volkts
		
	Функции модуля:
		AntiFlood.CheckFlood(msg)
			Проверяет сообщение на флуд.
			Вернет false, если флуд есть и true если флуда нет
			
		AntiFlood.CheckRepeat(msg)
			Проверяет сообщение на повторения.
			Вернет false, если повторения есть и true если повторения нет
			
		AntiFlood.Apply(msg)
			Записываем сообщение в таблицу
--]]

local _module = {}

_module.users = {};

_module.max_messages = 3;
_module.for_time = 10;
_module.mute_time = 50;
_module.last_time = 15; -- Время, через которое Ева забудет прошлое сообщение
_module.mute_msg = "воу, ты пишешь слишком часто, отдохни пару секунд";
_module.r_msg = "эй, хватит писать мне одно и то же";

--[[ Проверка сообщения на флуд ]]--
function _module.CheckFlood(msg)
	if cvars.get 'vk_group' == '1' then return true end
	local uid = tostring(msg.user_id);
	local mid = tostring(msg.id);
	local b = _module.users[uid];
	if not b then return true end

	if b.mute then 
		if not b.att then
			resp(msg, _module.mute_msg); 
			--vk.send('messages.send', { peer_id = , message = _module.mute_msg})
			b.att = true;
		end
		
		if b.mute_time < (os.time() - _module.mute_time) then
			console.log("vk.com/id"..uid.." has been unmuted", "AntiFlood");
			_module.users[uid] = nil;
			return true;
		end

		console.log("vk.com/id"..uid.." has flood", "AntiFlood");
		return false;
	end
	return true;
end

--[[ Проверка сообщения на повторение ]]--
function _module.CheckRepeat(msg)
	if cvars.get 'vk_group' == '1' then return true end
	local uid = tostring(msg.user_id);
	local b = _module.users[uid];
	if not b then return true end
	
	if b.last_time < (os.time() - _module.last_time) then
		_module.users[uid].last = '';
		b.last_time = os.time();
		return true;
	end
	
	
	if b.last == msg.body then 
		if b.att == false then
			resp(msg, _module.r_msg);
			--vk.send('messages.send', { peer_id = msg[4], message = _module.r_msg})
			b.att = true;
		end
		
		b.last_block = true;
		console.log("vk.com/id"..uid.." has repeat", "AntiFlood");
		return false;
	end
	b.last_time = os.time();
	return true;
end

--[[ Запись сообщения ]]--
function _module.Apply(msg)
	if cvars.get 'vk_group' == '1' then return end
	local uid = msg.user_id;
	local b = _module.users[tostring(uid)];
	if not b then b = _module.Create(uid) end
		
	if b.last_check < (os.time() - _module.for_time) then
		b.count = 0;
		b.last_check = os.time();
	end
	
	b.count = b.count + 1;
	b.last = msg.body;
	
	if b.count > _module.max_messages then
		b.mute_time = os.time();
		b.mute = true;
		console.log("vk.com/id"..uid.." has been muted", "AntiFlood");
	end
end

function _module.Create(uid)
	local _uid = tostring(uid);
	_module.users[_uid] = 
		{
			count = 0,
			att = false,
			mute = false,
			last_block = false,
			last = "-",
			last_check = 0,
			mute_time = 0,
			last_time = 0
		};
	return _module.users[_uid];
end

return _module
