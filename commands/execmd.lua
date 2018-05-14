local command = { "!", "do ebp console", use = "<commandline>", dev=1, right='do', smile = '&#128295;', _type = 'dev' };

function command.exe(msg, args, other, rmsg)
	return cmd.exe(cmd.data(args,2));
end

return command;
