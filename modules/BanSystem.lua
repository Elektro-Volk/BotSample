-- VERSION 1.0
local _module = {};

function _module.Start()
	DbData.RegFunc('checkBan', function (self) return self.ban == -1 or os.time() <= self.ban end);
	DbData.RegFunc('banUser', function (self, t) self:set('ban', t and (t + os.time()) or -1) end);
	DbData.RegFunc('unban', function (self) self:set('ban', 0) end);
end

return _module;
