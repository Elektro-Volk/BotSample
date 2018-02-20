local command = { "инфа", "Вероятность фразы", use = "<фраза>" };

function command.exe(msg, args)
	return { message = "Инфа "..math.random(100).."%", forward_messages = tostring(msg.id) };
end

return command;