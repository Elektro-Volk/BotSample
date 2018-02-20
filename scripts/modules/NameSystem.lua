local M = {}

function M.Start()
	if DbData then
		DbData.RegFunc('setName', function (data, nick)
			 data[M.dbfield] = nick;
			 DbData.Set(data.vkid, 'nickname', nick);
		end);
		
		DbData.RegFunc('getName', function (data)
			local name = data[M.dbfield]
			if name == '' then
				local user = vk.jSend('users.get', { user_ids = tostring(data.vkid), fields = 'photo_50' })["response"][1];
				name = user.first_name;
				DbData.mc(
					"UPDATE `%s` SET first_name='%s',nickname='%s',last_name='%s',photo_url='%s' WHERE vkid='%i'",
					DbData.tablename, name, name, user.last_name, user.photo_50, data.vkid
				);
			end
			return name;
		end);
	end
end

function M.IsMe (msg)
	local body = msg[6];
	for i = 1, #M.botNames, 1 do
		if string.starts(string.lower(body), M.botNames[i]) then
			M.sub = 1 + string.len(M.botNames[i]);
			return true;
		end
	end
	if msg[4] < 2000000000 then M.sub = 1; return true end
	return false;
end

-- Clear spaces and symbols
function M.Clear(msg)
	local text = string.sub(msg.body or '', M.sub); -- Clear name
	-- Clear symbols
	while string.starts(text, " ") or string.starts(text, ",") do
		text = string.sub(text, 2);
	end
	msg.body = text;
	return msg;
end

-- Get Name
function M.Get(uid)
  return DbData(uid):getName();
end

function M.GetR(uid)
	return "[id"..uid.."|"..M.Get(uid).."]";
end

-- Set Name
function M.Set(uid, nick)
	M.names [tostring(uid)] = tostring( nick);
	M.Save();
end

-- Apply to message
function M.Apply(msg, other, rmsg)
	if msg.chat_id and other.sendname then
		rmsg.message = (other.udata and other.udata:getName() or M.Get(msg.user_id))..", "..rmsg.message;
	end
end

return M
