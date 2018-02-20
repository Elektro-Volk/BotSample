-- VERSION 0.1
--[[
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
_module.last_time = 15; -- Время, через которое бот забудет прошлое сообщение
_module.mute_msg = "воу, ты пишешь слишком часто, отдохни пару секунд";
_module.r_msg = "эй, хватит писать мне одно и то же";

--[[ Проверка сообщения на флуд ]]--
function _module.CheckFlood(msg)
	local uid = tostring(msg.user_id);
	local mid = tostring(msg.id);
	local b = _module.users[uid];
	if not b then return true end

	if b.mute then 
		if not b.att then
			resp(msg, _module.mute_msg);
			b.att = true;
		end
		
		if b.mute_time < (os.time() - _module.mute_time) then
			console.log("vk.com/id"..uid.." has been unmuted");
			_module.users[uid] = nil;
			return true;
		end

		console.log("vk.com/id"..uid.." has flood");
		return false;
	end
	return true;
end

--[[ Проверка сообщения на повторение ]]--
function _module.CheckRepeat(msg)
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
			b.att = true;
		end
		
		b.last_block = true;
		console.log("vk.com/id"..uid.." has repeat");
		return false;
	end
	b.last_time = os.time();
	return true;
end

--[[ Запись сообщения ]]--
function _module.Apply(msg)
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
		console.log("vk.com/id"..uid.." has been muted");
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