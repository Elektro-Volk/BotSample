local command = { "информация", "Некоторая информация о боте.",smile='&#128203;' };

command.exe = function (msg, args, other, rmsg)
	rmsg:line("⏳ "..os.date("!%H:%M:%S", uptime()));
	rmsg:line("🔧 Этот бот работает на [ebotp|EBotPlatform] V".._VERSION);
	rmsg.attachment = "photo-131358170_456239058";
end

return command;
