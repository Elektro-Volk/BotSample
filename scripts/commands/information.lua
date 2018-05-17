local command = { "информация", "Некоторая информация о боте.",smile='&#128203;' };

command.exe = function (msg, args, other, rmsg)
	rmsg:line "• Мой бот •";
	local days = os.date("!*t", uptime()).day - 1;
	rmsg:line("⏳ "..days..' дней ' .. os.date("!%H:%M:%S", uptime()));
	local ucount = #DbData.mc('SELECT * FROM '..DbData.tablename);
	rmsg:line("🚶 У меня "..ucount.." пользователей");
	
	rmsg:line("🔧 Этот бот работает на [ebotp|EBotPlatform] V".._VERSION);
	rmsg.attachment = "photo-131358170_456239038";
end

return command;
