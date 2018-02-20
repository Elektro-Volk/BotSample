local command = { "информация", "Некоторая информация о боте." };

command.exe = function (msg, args, other, rmsg)
	rmsg:line "• Мой бот •";
	rmsg:line("⏳ "..os.date("!%H:%M:%S", uptime()));
	local ucount = #DbData.mc('SELECT * FROM `%s` WHERE 1', DbData.tablename);
	rmsg:line("🚶 У меня "..ucount.." пользователей");
	rmsg:line("🔧 Этот бот работает на [ebotp|EBotPlatform] V".._VERSION);
	rmsg.attachment = "photo-131358170_456239038";
end

return command;