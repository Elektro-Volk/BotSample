local command = { "ид", "VKID по ссылке", use = "<профиль>" };

function command.exe(msg, args)
	local id = args[2] and getId(args[2]) or msg.user_id;
	return "ID: "..id;
end

return command;