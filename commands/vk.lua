local command = { "vk", "Отправить vk запрос.", right = "vk", smile='&#128295;', _type = 'dev' };

command.exe = function (msg, args, other, rmsg)
	rmsg:line "• Результат выполнения •";
	local data = string.split(msg.body, '\n');
	local method = cmd.parse(data[1], " ")[2];
	local params = {};
	for k,v in ipairs(data) do
	  if k~=1 then
		local line = cmd.parse(v, ' ');
		params[line[1]] = line[2];
	  end
	end
	
	rmsg:line(vk.send(method, params));
end

return command;
