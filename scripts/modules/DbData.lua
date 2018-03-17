--[[
	Autor: https://vk.com/elektro_volkts
	Version: 1.0
	Functions:
		DbData.Connect(ip, username, password, database) - Connect to database
		DbData.Safe(vkid) - Safe get user
		DbData(vkid) - Get or create user
		DbData.Set(vkid, field, value) - Set user value
		DbData.RegFunc(name, func) - Add OOP user function
		DbData.mc(sql, ...) - Do SQL query
	OOP:
		user:set(field, value) - Set user value
	Settings:
		DbData.tablename - name to accounts table
]]--
local M = { uinfo = {}, tablename = 'accounts' };

M.uinfo['set'] = function(self, field, value)
	self[field] = value;
	M.Set(self.vkid, field, value);
end

function M.Connect(ip, username, password, database)
  M.mc = mysql(ip, username, password, database);
  M.mc("SET NAMES utf8mb4");
end

local mt = {
  __call = function (t, vkid)
    local data = M.mc('SELECT * FROM '..M.tablename..' WHERE vkid='..vkid)[1];
	if not data then
		DbData.mc("INSERT INTO "..M.tablename.." (`vkid`) VALUES ('"..vkid.."')");
		return t(vkid);	
	end
    setmetatable(data, {__index = M.uinfo});
    return data;
  end
}
setmetatable(M, mt);

function M.Safe(vkid)
	if not vkid then return nil end
  	local data = M.mc('SELECT * FROM '..M.tablename..' WHERE `vkid`='..vkid)[1];
	if not data then return nil end
    setmetatable(data, {__index = M.uinfo});
    return data;
end

function M.Set(vkid, field, value)
  return M.mc('UPDATE '..M.tablename..' SET `'..field..'`=\''..value..'\' WHERE `vkid`='..vkid);
end

function M.RegFunc(name, func)
  M.uinfo[name] = func;
end

return M;
