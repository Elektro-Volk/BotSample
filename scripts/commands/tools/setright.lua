local command = { "сетправо", "Изменить право", use = "<профиль> [право]", right = "setright", smile = '&#128110;', args = 'U' };

function command.exe(msg, args, other, rmsg, user, target)
	local right = args[3] or '';
	ca (RightsSystem.GetType(right), "такого права не бывает");
	ca (user:isRight ('setright.'..right), "вы не можете ставить такое право");
	ca (user:isRight ('setright.'..target.right), "вы не можете снимать с такого права");

	rmsg:line("&#127915; %s", target:r());
	rmsg:line("&#128221; %s » %s", RightsSystem.GetType(target.right).screenname, RightsSystem.GetType(right).screenname);

	target:set('right', right);
end

return command;
