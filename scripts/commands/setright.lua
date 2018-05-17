local command = { "сетправо", "Изменить право", use = "<профиль> [право]", right = "setright", smile = '&#128110;', _type = 'moder' };

function command.exe(msg, args, other, rmsg)
	if #args > 1 then
		local target = DbData.Safe(getId(args[2]));
		if target then
			local right = args[3] or '';
			if RightsSystem.GetType(right) then
				if other.udata:isRight(command.right..'.'..right) then
					if other.udata:isRight(command.right..'.'..target.right) then
						DbData.Set(target.vkid, 'right', right);
						return NameSystem.GetR(target.vkid).." теперь "..RightsSystem.GetType(right).screenname;
					else
						return "err:вы не можете снимать с такого права.";
					end
				else
					return "err:вы не можете ставить такое право.";
				end
			else
				return "err:такого права не бывает";
			end
		else
			return "err:он не пользователь Евы";
		end
	else
		return "err:используйте: "..command[1].." "..command.use;
	end
end

return command;
