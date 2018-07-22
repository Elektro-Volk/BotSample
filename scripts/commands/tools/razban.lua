local command = { "разбан", "Разбанить пользователя", use = "<профиль>", right = "razban", smile = '&#127939;', args = 'U' };

function command.exe(msg, args, other, rmsg, target)
	target:unban();
	return target:r().." разбанен";
end

return command;
