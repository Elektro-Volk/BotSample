local command = { "топ", "Топ богатых", smile='&#128176;' };

command.exe = function (msg, args, other, rmsg, user)
	rmsg:line "&#10549; Топ 5 самых богатых пользователей бота:";
	local top = DbData.mc("SELECT * FROM `%s` ORDER BY `balance` DESC", DbData.acctable);
	for i = 1,5 do rmsg:line("%i&#8419; %s • %i яриков.", i, NameSystem.GetR(top[i].vkid), top[i].balance) end

	local toppos = DbData.mc("SELECT COUNT(`id`) FROM `%s` WHERE `balance` >= %i", DbData.acctable, user.balance)[1]['COUNT(`id`)'];
	rmsg:line("&#10145; Вы №%i в топе.", toppos);
end

return command;
