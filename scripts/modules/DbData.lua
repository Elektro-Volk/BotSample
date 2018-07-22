local module = {
	acctable = 'accounts',
	uinfo = {
		set = function(self, field, value) self[field] = value; DbData.Set(self.vkid, field, value); end,
		add = function(self, field, value) self[field] = self[field] + value; DbData.Add(self.vkid, field, value); end
	},

	CheckInstall = function ()
		if not DbData.mc then
			console.error("DbData", "MySql подключение не существует.");
			console.error("DbData", "Используйте: DbData.Connect { ip, username, password, database }");
			return;
		end

		if not DbData.FindTable(DbData.acctable) then
			console.log("DbData", "Таблица %s не найдена.", DbData.acctable);
			console.log("DbData", "Создаю таблицу %s...", DbData.acctable);
			DbData.mc ([[
				CREATE TABLE `%s` (
					`id` int(11) NOT NULL AUTO_INCREMENT,
					`vkid` int(11) NOT NULL,
					PRIMARY KEY (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
			]], DbData.acctable);
			console.log("DbData", "Таблица %s успешно создана!", DbData.acctable);
			relua();
		end
	end,

	Start = function ()
		if Commands then
			argsTypes.U = function (args, arg, offset)
				local user_id = getId(arg);
				ca (user_id, "пользователь не найден");
				return ca (DbData.Safe(user_id), 'это не пользователь бота');
			end
		end
	end,

	Connect = function(settings)
		DbData.mc = mysql(settings.ip, settings.username, settings.password, settings.database);
		DbData.mc("SET NAMES utf8mb4");
		DbData.settings = settings;
	end,

	FindTable = function (tablename)
		local index = "Tables_in_"..DbData.settings.database;
		local tables = DbData.mc ("SHOW TABLES");
		for i = 1, #tables do if tables[i][index] == tablename then return tables[i][index] end end
	end,

	FindColumn = function (tablename, columnname)
		local columns = DbData.mc ("SHOW COLUMNS FROM `%s`", tablename);
		for i = 1, #columns do if columns[i].Field == columnname then return columns[i] end end
	end,

	FindColumnOrInstall = function (tablename, columnname, mname, args)
		if not DbData.FindColumn(tablename, columnname) then
			console.log(mname, "Создаю поле %s в %s...", columnname, tablename);
			DbData.mc ("ALTER TABLE `%s` ADD `%s` %s", tablename, columnname, args);
			console.log(mname, "Поле %s в было успешно создано.", columnname);
		end
	end,

	Safe = function (vkid)
		if not vkid then return end
	    local user = DbData.mc('SELECT * FROM `%s` WHERE vkid=%i', DbData.acctable, vkid)[1];
		if not user then return false end
	    setmetatable(user, { __index = DbData.uinfo });
	    return user;
	end,

	S = function (url)
	    return url and DbData.Safe(getId(url));
	end,

	Get = function (vkid)
		local user = DbData.Safe(vkid);
		if not user then DbData.mc("INSERT INTO `%s` (`vkid`) VALUES (%i)", DbData.acctable, vkid); return DbData.Safe(vkid); end
		return user;
	end,

	Set = function (vkid, field, value)
	  	return DbData.mc("UPDATE `%s` SET `%s`='%s' WHERE `vkid`=%i", DbData.acctable, field, value, vkid);
  	end,

  	Add = function (vkid, field, value)
	  	return DbData.mc("UPDATE `%s` SET `%s` = `%s` + %i WHERE `vkid`=%i", DbData.acctable, field, field, value, vkid);
  	end,

  	RegFunc = function (name, func)
	  DbData.uinfo[name] = func;
	end
};

setmetatable(module, { __call = function (t, vkid) return t.Get(vkid) end });
return module;
