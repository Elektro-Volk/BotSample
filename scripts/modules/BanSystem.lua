--[[
	Этот модуль позволяет выдавать бан пользователям.
	ООП:
		user:checkBan() -- Если пользователь забанен,то вернет true.
		user:banUser(time or -1) -- Забанить пользователя
		user:unban() -- Разбанить пользователя
]]
return {
	CheckInstall = function ()
		if not DbData then
			console.error("BanSystem", "Для работы данного модуля нужно установить DbData.lua.");
			return;
		end

		if not DbData.FindTable(DbData.acctable) then
			console.log("BanSystem", "Таблица %s не найдена.", DbData.acctable);
			return;
		end

		if not DbData.FindColumn(DbData.acctable, 'ban') then
			console.log("BanSystem", "Создаю поле ban в %s...", DbData.acctable);
			DbData.mc ("ALTER TABLE `%s` ADD `ban` INT NOT NULL", DbData.acctable);
			console.log("BanSystem", "Поле ban в было успешно создано.");
		end
	end,

	Start = function ()
		DbData.RegFunc('checkBan', function (self) return self.ban == -1 or os.time() <= self.ban end);
		DbData.RegFunc('banUser', function (self, t) self:set('ban', t and (t + os.time()) or -1) end);
		DbData.RegFunc('unban', function (self) self:set('ban', 0) end);

		Bot.addPre(function (msg, other, user) if user:checkBan() then return false end end);
	end
}
