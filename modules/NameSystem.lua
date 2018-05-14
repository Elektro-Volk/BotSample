--[[
	Autor: https://vk.com/elektro_volkts
	Version: 1.0
	Functions:
		NameSystem.IsMe(msg) - Check is MSG have bot name
		NameSystem.Clear(msg) - Remove bot name and symbols pre message
		NameSystem.Apply(msg, other, rmsg) - Print Nickname on message
	OOP:
		user:setName(newname) - Set user nickname
		user:getName() - Get user nickname
		user:r() - URL on user nickname
]]--
local _mod = {}

function _mod.Start()
	DbData.RegFunc('setName', function (self, name) self:set('nickname', name) end);
	DbData.RegFunc('getName', function (self) return self.nickname ~= '' and self.nickname or _mod.SetupName(self) end);
	DbData.RegFunc('r', function (self) return "[id"..self.vkid.."|"..self:getName().."]" end);
end

function _mod.IsMe (msg)
	local body = string.lower(msg.body);
	for i = 1, #_mod.botNames, 1 do
		if body:starts(_mod.botNames[i]) then
			NameSystem.Clear(msg, _mod.botNames[i]:len() + 1);
			return true;
		end
	end
	
	if not msg.chat_id then return true end
	return false;
end

function _mod.Clear(msg, offset)
	local text = string.sub(msg.body or '', offset);
	while text:starts ' ' or text:starts ',' do text = string.sub(text, 2) end
	msg.body = text;
	return msg;
end

function _mod.SetupName(user)
	local userdata = VK.users.get { user_ids = user.vkid }["response"][1];
	user:set('first_name', userdata.first_name);
	user:set('last_name', userdata.last_name);
	user:set('nickname', userdata.first_name);
	return userdata.first_name;
end

function _mod.GetR(userid)
	return DbData(userid):r();
end

function _mod.Apply(msg, other, rmsg, user)
	if msg.chat_id and other.sendname then rmsg.message = user:getName()..", "..rmsg.message end
end

return _mod;
