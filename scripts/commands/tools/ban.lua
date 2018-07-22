 local command = { "бан", "Забанить пользователя", use = "<профиль> [время]", right = "ban", smile = '&#128695;', args = 'U' };

function command.exe(msg, args, other, rmsg, user, target)
    ca (user:isRight('ban.'..target.right), "ты не можешь его забанить");

	local limit = user:getValue 'maxbantime';
    local bantime = tonumber(args[3]) or -1;
	if bantime ~= -1 then
		local bantime = tonumber(args[3]);
        ca (bantime <= limit, "максимальный лимит бана "..limit.." секунд.");
        target:banUser(bantime);
		return target:r().." забанен на "..os.date("!%H:%M:%S", bantime);
	else
        ca (limit == -1, "максимальный лимит бана "..limit.." секунд.");
		target:banUser();
		return target:r().." забанен навсегда";
	end
end

return command;
