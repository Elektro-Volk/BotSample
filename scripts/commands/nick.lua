local command = { "ник", "Сменить ваш никнейм", right = "nick", rerror = "Эта команда доступна только для VIP пользователей" };

function command.exe(msg, args, other, rmsg)
	if args[2] then
		if not args[3] then
			if string.len(args[2]) <= 18 then
				other.udata:setName(args[2]);
				return "Теперь я буду звать вас "..args[2];
			else
				return "err:ваш ник слишком длинный, сократите его.";		
			end
		else
			if other.udata:isRight 'nick.other' then
				local target = DbData.Safe(getId(args[2]));
				if target then
					target:setName(args[3]);
					return "Вы изменили никнейм для vk.com/id"..target.vkid.." на "..args[3];
				else
					return "err:он не пользователь бота";
				end
			else
				return "err:вы не можете менять чужой никнейм";
			end
		end
	else
		return "err:используйте: ник <ник>";		
	end
end

return command;