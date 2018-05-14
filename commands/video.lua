local command = { "видео", "Поиск видео", use = "<название>", smile = '&#128249;' };

function command.exe(msg, args, other, rmsg)
	if args[2] then
		local response = VK.video.search { q = cmd.data(args, 2), count = 10 }.response;
		local count = response.count;
		if count then
			local data = "";
			local items = response.items;
			for i = 1,count do
				local item = items[i];
				if item then data = data.."video"..item.owner_id.."_"..item.id.."," end
			end
			return { message = "Показаны результаты по вашему запросу:", attachment = data, forward_messages = msg.id };
		else
			return "err:по вашему запросу ничего не найдено.";
		end
	else
		return "err:используйте: видео <название>";
	end
end

return command;