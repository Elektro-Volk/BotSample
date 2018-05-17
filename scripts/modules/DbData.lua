local this = {
	tablename = 'accounts',
	uinfo = {
		set = function(self, field, value) self[field] = value; DbData.Set(self.vkid, field, value); end,
		add = function(self, field, value) self[field] = self[field] + value; DbData.Add(self.vkid, field, value); end
	}
};

setmetatable(this, { __call = function (t, vkid) return t.Get(vkid) end });

function this.Connect(settings)
	this.mc = mysql(settings.ip, settings.username, settings.password, settings.database);
	this.mc("SET NAMES utf8mb4");
end

function this.Safe(vkid)
    local user = this.mc('SELECT * FROM `%s` WHERE vkid=%i', this.tablename, vkid)[1];
		if not user then return false end
    setmetatable(user, { __index = this.uinfo });
    return user;
end

function this.S(url)
    return url and this.Safe(getId(url)) or nil;
end

function this.Get(vkid)
	local user = this.Safe(vkid);
	if not user then this.mc("INSERT INTO `%s` (`vkid`) VALUES (%i)", this.tablename, vkid); return this.Safe(vkid); end
	return user;
end

function this.Set(vkid, field, value)
  return this.mc("UPDATE `%s` SET `%s`='%s' WHERE `vkid`=%i", this.tablename, field, value, vkid);
end

function this.Add(vkid, field, value)
  return this.mc("UPDATE `%s` SET `%s` = `%s` + %i WHERE `vkid`=%i", this.tablename, field, field, value, vkid);
end

function this.RegFunc(name, func)
  this.uinfo[name] = func;
end

return this;
