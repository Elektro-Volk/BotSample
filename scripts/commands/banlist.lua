local command = { "банлист", "Список перманентных" };

command.exe = function (msg, args, other, rmsg)
	rmsg:line "• Навсегда в бане 😥 •";
	local members = DbData.mc("SELECT * FROM `accountes` WHERE `ban`=-1");
	for i = 1,#members do
		rmsg:line("😥 "..NameSystem.GetR(members[i].vkid));
	end
end

return command;