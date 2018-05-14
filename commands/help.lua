local command = { 'помощь', 'Список доступных команд', dev = 1, smile='&#128220;' };

--[[
	В объявлении команды: _type = 'typename'
	Пример: local command = { 'яка', 'Сделать яку', _type = 'dev' };
	Список категорий можно пополнять своими.
	Формат: { "Имя категории", "Смайлик категории", "_type для категории" }
]]
local categories = {
	 { "Модерирование", "&#128110;", "moder" },
	 { "Технические", "&#128295;", "dev" },
	 { "Прочее", "&#9827;", "other" },
};

function command.category (msg, args, other, rmsg, user)
	local cat = categories[tonumber(args[2])];
	if not cat then return "err:категория не найдена" end
	rmsg:line (cat[2].." Категория "..cat[1]);
	
	for key, com in pairs(CommandsSystem.commands) do
		if not com.right or other.udata:isRight(com.right) then
			if (not com._type and cat[3] == "other") or com._type == cat[3] then
				local price = com.price and " | 💳 "..com.price or '';
				local name = string.upper(string.sub (com[1], 1, 2))..string.sub (com[1], 3);
				rmsg:line ((com.smile or '📘').." "..name.." "..(com.use or '').." - "..com[2]..price);
			end
		end
	end
end

function command.exe (msg, args, other, rmsg, user)
	if tonumber(args[2]) then return command.category (msg, args, other, rmsg, user) end
	if args[2] and CommandsSystem.commands[args[2]:lower()] then
		local com = CommandsSystem.commands[args[2]:lower()];
		return com.help and com.help(msg, args, other, rmsg) or "err:данная команда не имеет справки.";
	end
	
	rmsg:line ("&#9830; Доступные категории команд");
	for i = 1, #categories do local cat = categories[i]; rmsg:line (cat[2] .. ' ' .. i .. '. ' .. cat[1]) end
	rmsg:line "❕ Вся полезная информация у меня на стене.";
	rmsg:line ("&#10069; Чтобы получить список команд из категории:");
	rmsg:line ("&#10145; помощь <номер категории>");
	rmsg:line ("&#128641; EBotPlatform V".._VERSION);
end

return command;
