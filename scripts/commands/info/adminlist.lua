local command = { "админлист", "Список администрации", smile = '&#128083;' };

command.printlist = function (rmsg, right)
	local members = DbData.mc("SELECT * FROM `%s` WHERE `right`='%s'", DbData.acctable, right);
	for i = 1,#members do rmsg:line("%s %s", members[i].smile, DbData(members[i].vkid):r()) end
end

command.exe = function (msg, args, other, rmsg)
    rmsg:line ("&#11035; Главный админ:");
    printlist(rmsg, 'mainadmin');
    rmsg:line ("&#9899; Администрация:");
    printlist(rmsg, 'admin');
    rmsg:line ("&#9642; Модерация:");
    printlist(rmsg, 'moderator');
end

return command;
