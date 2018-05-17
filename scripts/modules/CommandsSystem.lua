-- VERSION 1.0

-- Tools
function useerr(com)
	return "err:используйте: "..com[1]..' '..(com.use or '');
end

local M = { };
M.commands = { };
M.nCmds = 0;
M.checks = {};
M.onsuccess = {};

function M.Start()
	M.LoadCommands();
end

function M.LoadCommands()
	-- TODO
	local files = fs.dirList('scripts/commands');
	for i = 1,#files do M.LoadCommand(root.."/scripts/commands/"..files[i]) end
	console.log("Registered "..M.nCmds.." commands...")
end

function M.LoadCommand(file)
	local command = dofile(file);
	if command then
		command.file = file;
		M.commands[command[1]] = command;
		M.nCmds = M.nCmds + 1;
	else
		console.error("Error loading "..file);
	end
end

function M.RegPre(func)
	table.insert(M.checks, func);
end

function M.RegPost(func)
	table.insert(M.onsuccess, func);
end

function M.Execute(msg, other, user)
	-- Parse
	local command = msg.body;
	if string.find(command, ' ') then command = string.split(msg.body, ' ')[1] end
	local args = cmd.parse(msg.body, ' ');
	command = string.lower(command);
	-- Find
	local comObj = M.commands[command];
	if not comObj then return false end
	-- PreExecute
	for key,value in ipairs(M.checks) do
		local resp = value(msg, args, other, comObj, user);
		if resp then return resp end
	end
	-- Dev check
	if comObj.dev then
		M.LoadCommand(comObj.file);
		comObj = M.commands[command];
	end
	-- Execute
	local rmsg = { line = function (self, ...) addline(self, string.format(...)) end };
	other.udata = user;
	local result = comObj.exe(msg, args, other, rmsg, user);

	-- PostExecute
	rmsg.line = nil;
	local res = result and (type(result) == "table" and result or { message = result }) or rmsg;
	if res.message and string.starts(res.message, 'err:') then
		res.message = string.sub(res.message, 5);
		other.sendname = true;
	else
		for key,value in ipairs(M.onsuccess) do value(msg, args, other, comObj, user) end
	end
	return res;
end

return M;
