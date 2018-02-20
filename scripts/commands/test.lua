local command = { 'тест', 'Просто тест' };

function command.exe ()
	return "⏳ Бот работает "..os.date("!%H:%M:%S", uptime());
end

return command;
