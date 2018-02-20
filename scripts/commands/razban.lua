local command = { "разбан", "Разбанить пользователя", use = "<профиль>", right = "razban", dev = 1 };

function command.exe(msg, args, other, rmsg)
	if #args > 1 then
		local target = DbData.Safe(getId(args[2]));
		if target then
			DbData.Set(target.vkid, 'ban', 0);
			return NameSystem.GetR(target.vkid).." разбанен";
		else
			return "err:он не пользователь Евы";
		end
	else
		return "err:используйте: "..command[1].." "..command.use;
	end
end

return command;