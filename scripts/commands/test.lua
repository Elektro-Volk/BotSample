local command = { 'тест', 'Просто тест', smile='&#128187;' };

function command.exe ()
	return "⏳ Бот работает "..os.date("!%H:%M:%S", uptime());
end

return command;
