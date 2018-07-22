return {
	CheckInstall = function ()
		if not DbData then
			console.error("RightsSystem", "Для работы данного модуля нужно установить DbData.lua.");
			return;
		end

		DbData.FindColumnOrInstall(DbData.acctable, 'right', 'RightsSystem', 'TEXT NOT NULL');
	end,

	Start = function ()
		DbData.RegFunc('isRight', function (data, right) return RightsSystem.IsRightInType(data["right"], right) end);
		DbData.RegFunc('getValue', function (data, value) return RightsSystem.RightValueInType(data["right"], value) end);
		DbData.RegFunc('getRightName', function (data) return RightsSystem.GetType(data["right"]).screenname end);
		DbData.RegFunc('getRight', function (data) return RightsSystem.GetType(data["right"]) end);
		RightsSystem.rights = dofile(root .. '/settings/rights.lua');
		Commands.RegPre(RightsSystem.CheckCmd);
	end,

	CheckCmd = function (msg, args, other, comObj, user)
		return comObj.right and not user:isRight (comObj.right) and { message = comObj.rerror or 'У вас нет прав.' };
	end,

	-- Получить тип по имени --
	GetType = function (typeName)
		return RightsSystem.rights[typeName == '' and 'default' or typeName];
	end,

	-- Проверка права типа --
	IsRightInType = function (typename, right)
		local tinfo = RightsSystem.GetType(typename);
		return tinfo["right"] or tinfo["right."..right]
		or (tinfo["include"] and RightsSystem.IsRightInType(tinfo["include"], right))
		or false;
	end,

	-- Проверка значения --
	RightValue = function (userId, valname)
		return RightsSystem.RightValueInType(DbData(userId)["right"], right);
	end,

	-- Проверка значения типа --
	RightValueInType = function (typename, valname)
		local tinfo = RightsSystem.GetType(typename);

		return tinfo["value."..valname]
		or (tinfo["include"] and RightsSystem.RightValueInType(tinfo["include"], valname));
	end
};
