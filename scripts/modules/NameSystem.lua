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
return {
	CheckInstall = function ()
		if not DbData then
			console.error("NameSystem", "Для работы данного модуля нужно установить DbData.lua.");
			return;
		end

		if not DbData.FindTable(DbData.acctable) then
			console.log("NameSystem", "Таблица %s не найдена.", DbData.acctable);
			return;
		end

		DbData.FindColumnOrInstall(DbData.acctable, 'first_name', 'NameSystem', 'TEXT NOT NULL');
		DbData.FindColumnOrInstall(DbData.acctable, 'last_name', 'NameSystem', 'TEXT NOT NULL');
		DbData.FindColumnOrInstall(DbData.acctable, 'nickname', 'NameSystem', 'TEXT NOT NULL');
	end,

	Start = function ()
		DbData.RegFunc('setName', function (self, name) self:set('nickname', name) end);
		DbData.RegFunc('getName', function (self) return self.nickname ~= '' and self.nickname or NameSystem.SetupName(self) end);
		DbData.RegFunc('r', function (self) return "[id"..self.vkid.."|"..self:getName().."]" end);

		Bot.addCheck(NameSystem.IsMe);
		Bot.addPre(NameSystem.CheckUsername);
		Bot.addPost(NameSystem.Post);
	end,

	IsMe = function (msg)
		local body = string.lower(msg.text or '');
		for i = 1, #NameSystem.botNames, 1 do
			if body:starts(NameSystem.botNames[i]) then
				msg.text = string.sub(msg.text or '', #NameSystem.botNames[i] + 1);
				NameSystem.Clear(msg);
				return true
		 	end
		end
		if not ischat(msg) then NameSystem.Clear(msg) return true end
		return false;
	end,

	Clear = function (msg)
		while msg.text:starts ' ' or msg.text:starts ',' do msg.text = string.sub(msg.text, 2) end
	end,

	CheckUsername = function (msg, other, user)
		if user.first_name == '' then NameSystem.SetupName(user) end
	end,

	SetupName = function (user)
		local userdata = VK.users.get { user_ids = user.vkid }["response"][1];
		user:set('first_name', userdata.first_name);
		user:set('last_name', userdata.last_name);
		user:set('nickname', userdata.first_name);
		return userdata.first_name;
	end,

	GetR = function (userid) return DbData(userid):r() end,

	Post = function (msg, other, user, rmsg)
		if other.sendname then
			rmsg.message = user:getName()..", "..rmsg.message;
	 	end
	end
};
