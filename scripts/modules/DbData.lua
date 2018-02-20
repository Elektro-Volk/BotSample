local M = {};

M.uinfo = {};
M.tablename = 'accounts';

function M.Connect(ip, username, password, database)
  M.mc = mysql(ip, username, password, database);
  M.mc("SET NAMES UTF8");
end

local mt = {
  __call = function (t, vkid)
	if not M.mc then 
		error("PLEASE, CONNECT TO YOUR MYSQL SERVER:"
		.."\nDbData.Connect('host', 'username', 'password', 'dbname')");
	end
    local data = M.mc("SELECT * FROM `%s` WHERE vkid='%i'", M.tablename, vkid)[1];
	if not data then
		DbData.mc("INSERT INTO `%s` (`vkid`) VALUES ('%i')", M.tablename, vkid);
		return t(vkid);	
	end
    setmetatable(data, {__index = M.uinfo});
    return data;
  end
}
setmetatable(M, mt);

function M.Safe(vkid)
	if not vkid then return nil end
  	local data = M.mc("SELECT * FROM `%s` WHERE vkid='%i'", M.tablename, vkid)[1];
	if not data then return nil end
    setmetatable(data, {__index = M.uinfo});
    return data;
end

function M.Set(vkid, field, value)
  return M.mc("UPDATE `%s` SET `%s`='%s' WHERE `vkid`='%i'", M.tablename, field, value, vkid);
end

function M.RegFunc(name, func)
  M.uinfo[name] = func;
end

return M;
