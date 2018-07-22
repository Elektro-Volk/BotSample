local command = { 'помощь', 'Список доступных команд', dev = 1, smile='&#128220;' };

local categories = {
	{ "Профиль", "&#128107;", "profile" },
	{ "Игровые", "&#127923;", "games" },
	{ "Информация", "&#128240;", "info" },
	{ "Фото", "&#9989;", "photo" },
	{ "Технические", "&#128295;", "tools" },
	{ "Прочее", "&#9827;", "other" }
};

function command.category (msg, args, other, rmsg, user)
	local cat = categories[tonumber(args[2])];
	if not cat then return "err:категория не найдена" end
	rmsg:line ("%s Категория %s", cat[2], cat[1]);

	for key, com in pairs(Commands.commands) do
		if not com.right or user:isRight(com.right) then
			if (not com.type and cat[3] == "other") or com.type == cat[3] then
				local price = com.price and " | 💳 "..com.price or '';
				rmsg:line ("%s %s %s - %s %s", com.smile or '📘', com[1], com.use or '', com[2], price);
			end
		end
	end
end

function command.exe (msg, args, other, rmsg, user)
	if tonumber(args[2]) then return command.category (msg, args, other, rmsg, user) end
	if args[2] and Commands.commands[args[2]:lower()] then
		local com = Commands.commands[args[2]:lower()];
		return com.help and com.help(msg, args, other, rmsg) or "err:данная команда не имеет справки.";
	end

	rmsg:line ("&#9830; Доступные категории команд");
	for i = 1, #categories do rmsg:line ("%s %i. %s", categories[i][2], i, categories[i][1]) end
	rmsg:line ("&#10145; помощь <номер категории>");
end

return command;
