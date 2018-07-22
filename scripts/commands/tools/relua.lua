local command = { "relua", "Перезагрузить lua скрипты", right = "relua" };

command.exe = function ()
	relua();
	return "Так точно!";
end

return command;
