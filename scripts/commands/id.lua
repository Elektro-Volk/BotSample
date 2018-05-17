local command = { "ид", "VKID по ссылке", use = "<профиль>", smile = '&#127380;' };

function command.exe(msg, args)
	local id = args[2] and getId(args[2]) or msg.user_id;
	return "&#127380; "..id;
end

return command;