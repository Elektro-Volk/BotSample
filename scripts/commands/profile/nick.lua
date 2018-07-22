local command = { "ник", "Сменить ваш никнейм", right = "nick", smile = '&#127913;', args = 'd' };

function command.exe(msg, args, other, rmsg, user, str)
	local nick = Safe.Clear(str:gsub('\n', ' '));
	ca (utf8.len(nick) <= 20, "не многовато-ли вам для никнейма?");
	user:setName(nick);

	rmsg:line ("&#10035; Теперь я буду звать вас: %s", nick);
end

return command;
