-- VERSION 0.2
local M = {};
M.lastpnm = 0;
M.lastchat = 0;

-- TR load random phrares
function M.LoadRP(path)
	M.rp = {};
	local f = io.open(root..'/'..path,"r+");
	for line in f:lines() do table.insert(M.rp, tostring(line)) end
end

-- TR load random events
function M.LoadRE(path)
	M.re = require (filesystem.root()..path);
end

-- TR Random PNM message
function M.PNM(msg, wait)
	if msg[4] ~= M.lastchat and os.time() - M.lastpnm >= wait then
		M.lastpnm = os.time();
		M.lastchat = msg[4];
		local t = M.rp[math.random(#M.rp)];
		--resp(msg, t);
		vk.send('messages.send', { peer_id = msg[4], message = t})
		console.log("Send RP: "..t, "RandomEvents");
		return true;
	end
	return false;
end

-- TR Random PNM message
function M.Apply(msg, other, rmsg)
	for i = 1, #M.re.events do 
		local revent = M.re.events[i];
		if revent[2] > random.get(0, 10000) then
			revent[3](msg, other, rmsg, revent[4]);
			addline(rmsg, "✨| "..revent[1]);
			return true;
		end
	end
	return false;
end

return M;