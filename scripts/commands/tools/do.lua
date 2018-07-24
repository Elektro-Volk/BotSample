local command = { "do", "lua sandbox", use = "<code>", right='do', args = 's' };

function command.exe(msg, args, other, rmsg, data)
	local ret = load((data:find("return") and "" or "return ")..data)();

	return ret or "Code not return";
end

return command;
