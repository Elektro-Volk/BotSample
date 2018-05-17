local command = { "do", "lua sandbox", use = "<code>",dev=1, right='do', smile = '&#128295;', _type = 'dev' };

function command.exe(msg, args, other, rmsg)
	local data = cmd.data(args,2);
	local ret = load((data:find("return") and "" or "return ")..data)();
	
	return ret and "Result: <br>"..ret or "Code not return";
end

return command;
