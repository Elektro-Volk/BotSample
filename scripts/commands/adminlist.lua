local command = { "админлист", "Список администрации", smile = '&#128083;' };

command.printlist = function (rmsg, right)
	local members = DbData.mc("SELECT * FROM `accounts` WHERE `right`='"..right.."'");
	for i = 1,#members do rmsg:line(members[i].smile.." "..DbData(members[i].vkid):r()) end
end

command.exe = function (msg, args, other, rmsg)
	rmsg:line "• Список администрации •";
	rmsg:line ("Создатель: " .. DbData(admin):r());
	rmsg:line ("Главный админ:");
	command.printlist(rmsg, 'mainadmin');
	rmsg:line ("Администрация:");
	command.printlist(rmsg, 'admin');
	rmsg:line ("Модерация:");
	command.printlist(rmsg, 'moderator');
end

return command;
