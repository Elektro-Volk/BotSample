local command = { "матген", "Генератор мат. примеров", use = "[сложность]" };

function command.exe(msg, args, other, rmsg, user)
	local complexity = tonumber(args[2]) and math.min(50, tonumber(args[2])) or math.random(5);
	local obj = math.random(100);
	for i = 1, complexity do
		if math.random(100) > 90 then obj = '('..obj..')' end
		local operation = trand { '+', '-', '*', '-' };
		obj = math.random (100) > 50 and obj..' '..operation..' '..math.random(100) or math.random(100)..' '..operation..' '..obj;
	end
	
	return obj..' = '..load("return "..obj)();
end

return command;
