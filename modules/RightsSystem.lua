-- VERSION 1.0
local M = {}

function M.Start()
	DbData.RegFunc('isRight', function (data, right) return M.IsRightInType(data["right"], right) end);
	DbData.RegFunc('getValue', function (data, value) return M.RightValueInType(data["right"], value) end);
	DbData.RegFunc('getRightName', function (data) return M.GetType(data["right"]).screenname end);
	DbData.RegFunc('getRight', function (data) return M.GetType(data["right"]) end);
	M.Reload();
	CommandsSystem.RegPre(M.CheckCmd);
end

function M.CheckCmd(msg, args, other, comObj, user)
	return comObj.right and not user:isRight (comObj.right) and { message = comObj.rerror or 'У вас нет прав.' };
end

function M.Reload()
	M.rights = jDecode(fs.read 'settings/rights.json');
end
--M.Reload();

-- Получить тип по имени --
function M.GetType(typeName)
	return M.rights[typeName == '' and 'default' or typeName];
end

-- Проверка права типа --
function M.IsRightInType(typename, right)
	local tinfo = M.GetType(typename);
	return tinfo["right"] or tinfo["right."..right]
	or (tinfo["include"] and M.IsRightInType(tinfo["include"], right))
	or false;
end

-- Проверка значения --
function M.RightValue(userId, valname)
	return M.RightValueInType(DbData(userId)["right"], right);
end

-- Проверка значения типа --
function M.RightValueInType(typename, valname)
	local tinfo = M.GetType(typename);

	return tinfo["value."..valname]
	or (tinfo["include"] and M.RightValueInType(tinfo["include"], valname));
end

return M;
