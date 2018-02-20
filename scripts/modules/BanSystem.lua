-- VERSION 1.0
local _module = {};

function _module.Start()
	DbData.RegFunc('checkBan', function (data) return data.ban == -1 or os.time() <= data.ban end);
	DbData.RegFunc('ban', function (data, time) DbData.Set(data.vkid, 'ban', time and (time + os.time()) or -1) end);
	DbData.RegFunc('unban', function (data) DbData.Set(data.vkid, 'ban', 0) end);
end

return _module;
