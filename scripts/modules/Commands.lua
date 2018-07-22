local module = {
	commands = { },
	pre_list = { },
	post_list = { },
	cmd_count = 0,

	Start = function ()
		Commands.LoadCommands();
		console.log("Commands", "Зарегистрировано %i команнд...", Commands.cmd_count);
	end,

	LoadCommands = function (dir)
		dir = dir or '';
		local files = fs.dirList("scripts/commands"..dir);
		for i = 1,#files do
			if string.ends(files[i], '.lua') then
				local path = string.format("%s/scripts/commands/%s/%s", root, dir, files[i]);
				Commands.LoadCommand(path, string.sub(dir,2));
			else
				Commands.LoadCommands(dir..'/'..files[i]);
			end
		end
	end,

	LoadCommand = function (file, type)
		local command = dofile(file);
		if not command then return console.error("Error loading "..file) end

		command.file = file;
		command.type = type;
		Commands.commands[command[1]] = command;
		Commands.cmd_count = Commands.cmd_count + 1;
		return command;
	end,

	Execute = function (msg, other, user)
		if not msg.text then return end
		local args = cmd.parse(msg.text, ' ');
		if #args == 0 then return end
		local command_name = args[1]:lower();

		local command = Commands.commands[command_name];
		if not command then return end

		-- Проверяем условия выполнения команды.
		for key,value in ipairs(Commands.pre_list) do
			local resp = value(msg, args, other, command, user);
			if resp then return resp end
		end

		-- Перезагружаем команду, если dev = true
		if command.dev then command = Commands.LoadCommand(command.file, command.type) end

		local rmsg = { line = function (self, ...) addline(self, string.format(...)) end };

		local success, result = pcall(function (msg, args, other, rmsg, user)
			local exported = {};

			local cmd_func = args[2] and command.sub and (command.sub[args[2]] or command.help) or command.exe;

			if command.args and cmd_func == command.exe then exported = exportArgs(command, args, command.args, user) end
			if type(cmd_func) == 'table' then
				exported = exportSubArgs(command[1]..' '..cmd_func[1], args, cmd_func[2], user);
				cmd_func = cmd_func[3];
			end

			return cmd_func(msg, args, other, rmsg, user, table.unpack(exported));
		end, msg, args, other, rmsg, user);

		if not success then
			if not result:starts 'err:' then error(result, 0) end
		else
			if result and type(result) == 'string' and result:starts 'err:' then success = false end
		end

		if success then
			-- Пост функции вызываются при успешном выполнении комманд.
			for key,value in ipairs(Commands.post_list) do
				value(msg, args, other, command, user);
			end
		else result = string.sub(result, 5); other.sendname = true end

		rmsg.line = nil;
		rmsg = result and (type(result) == "table" and result or { message = result }) or rmsg;

		return rmsg;
	end,

	RegPre = function (f) table.insert(Commands.pre_list, f) end,
	RegPost = function (f) table.insert(Commands.post_list, f) end
};

-- Tools
argsTypes = {
		i = function (args, arg, offset) return toint(arg) end,
		f = function (args, arg, offset) return tonumber(arg) end,
		s = function (args, arg, offset) return arg end,
		d = function (args, arg, offset) return cmd.data(args, offset + 1) end
};

function exportArgs(com, args, params, user, offset)
	if not offset then offset = 0 end
	ca(#params < #args, useerr(com));
	local resp = { };

	for i = 1, #params do
	    local c = params:sub(i,i)
		ca(argsTypes[c], useerr(com));
		local d = argsTypes[c](args, args[1 + i + offset], offset + i, user);
		ca(d, useerr(com));
		table.insert(resp, d);
	end

	return resp;
end

function exportSubArgs(use, args, params, user) return exportArgs(use, args, params, user, 1) end

function useerr(com)
	if type(com) == 'string' then return "используйте: "..com end
	return "используйте: "..com[1]..' '..(com.use or '')
end
function ca(u, err) if not u then error('err:'..err, 0) end return u end

return module;
