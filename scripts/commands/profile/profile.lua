local command = { "профиль", "Информация о вашем профиле", use = "[ссылка]", smile = '&#127915;' };

function command.exe(msg, args, other, rmsg, user)
	local target = user:isRight 'otherinfo' and DbData.S(args[2]) or user;

    rmsg:line("&#128523; %s %s [%s]", target.first_name, target.last_name, target:r());
    rmsg:line("&#128273; %s", RightsSystem.GetType(target.right).screenname);
    rmsg:line("&#128179; %s", target.balance);

	if target:checkBan() then
        local ban = target.ban == -1 and '∞' or os.date("!%H:%M:%S", target.ban - os.time());
        rmsg:line("&#128695; Забанен: %s", ban);
    end
end

return command;
