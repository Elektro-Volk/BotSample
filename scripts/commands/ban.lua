local command = { "бан", "Забанить пользователя", use = "<профиль> [время]", right = "ban" };

function command.exe(msg, args, other, rmsg)
	if #args > 1 then
		local target = DbData.Safe(getId(args[2]));
		if target then
			if args[3] and tonumber(args[3]) then
				local limit = other.udata:getValue 'maxbantime';
				local bantime = tonumber(args[3]);
				if bantime <= limit or limit == -1 then
					DbData.Set(target.vkid, 'ban', bantime + os.time());
					return NameSystem.GetR(target.vkid).." забанен на "..os.date("!%H:%M:%S", bantime);
				else
					return "err:максимальный лимит бана "..limit.." секунд.";
				end
			else
				if other.udata:getValue 'maxbantime' == -1 then
					DbData.Set(target.vkid, 'ban', -1);
					return NameSystem.GetR(target.vkid).." забанен навсегда";
				else
					return "err:максимальный лимит бана "..other.udata:getValue('maxbantime').." секунд.";
				end
			end
		else
			return "err:он не пользователь бота";
		end
	else
		return "err:используйте: "..command[1].." "..command.use;
	end
end

return command;