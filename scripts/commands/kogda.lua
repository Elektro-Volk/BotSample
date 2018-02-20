local command = { "когда", "Когдатор", use = "<фраза>" };
kogda = {};
local f = io.open(root..'/settings/kogda.txt',"r+");
for line in f:lines() do table.insert(kogda, tostring(line)) end

function command.exe(msg, args)
	return { message = kogda[math.random(#kogda)], forward_messages = tostring(msg.id) };
end

return command;