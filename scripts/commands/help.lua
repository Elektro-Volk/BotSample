local command = { 'помощь', 'Список доступных команд', dev = 1 };

function command.exe (msg, args, other, rmsg)
	rmsg:line ("📚 КОМАНДЫ");
	for key, com in pairs(CommandsSystem.commands) do
		if not com.right or other.udata:isRight(com.right) then
			local name = string.upper(string.sub (com[1], 1, 2))..string.sub (com[1], 3);
			rmsg:line ((com.smile or '📘').." "..name.." "..(com.use or '').." - "..com[2]);
		end
	end


	rmsg:line ("❕ Создано на: [ebotp|EBotPlatform V".._VERSION.."]");
end

return command;
