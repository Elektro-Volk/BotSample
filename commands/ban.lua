 local command = { "бан", "Забанить пользователя", use = "<профиль> [время]", right = "ban", smile = '&#128695;', _type = 'moder' };

function command.exe(msg, args, other, rmsg, user)
  local target = DbData.S(args[2]);
	if not target then return useerr(command) end

	if not user:isRight('ban.'..target.right) then return "err:ты не можешь его забанить" end

	local limit = user:getValue 'maxbantime';
	if tonumber(args[3]) then
		local bantime = tonumber(args[3]);
		if limit ~= -1 and bantime > limit then return "err:максимальный лимит бана "..limit.." секунд." end
    target:banUser(bantime);
    Notify.Log(37639194, user:r().." забанил "..target:r().." на "..bantime.." сек");
		return target:r().." забанен на "..os.date("!%H:%M:%S", bantime);
	else
		if limit ~= -1 then return "err:максимальный лимит бана "..limit.." секунд." end
		target:banUser();
		Notify.Log(37639194, user:r().." забанил "..target:r());
		return target:r().." забанен навсегда";
	end
end

return command;
