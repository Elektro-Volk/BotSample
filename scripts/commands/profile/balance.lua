local command = { 'баланс', 'Ваш баланс', smile='&#128179;' };

function command.exe (msg, args, other, rmsg, user)
	local target = user:isRight 'otherinfo' and DbData.S(args[2]) or user;
	return "&#128179; "..math.floor(target.balance).." бит";
end

return command;
