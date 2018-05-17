local command = { "инфа", "Вероятность фразы", use = "<фраза>", smile='&#8265;' };

function command.exe(msg, args)
	return { message = "Инфа "..math.random(100).."%", forward_messages = tostring(msg.id) };
end

return command;
