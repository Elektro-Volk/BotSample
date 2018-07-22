biterr = "недостаточно денег. Требуется %i.";

return {
	enable_history = true,

	CheckInstall = function ()
		if not DbData then
			console.error("MoneySystem", "Для работы данного модуля нужно установить DbData.lua.");
			return;
		end

		DbData.FindColumnOrInstall(DbData.acctable, 'balance', 'MoneySystem', 'INT NOT NULL');
		if MoneySystem.enable_history and not DbData.FindTable('history') then
			console.log("MoneySystem", "Таблица history не найдена.");
			console.log("MoneySystem", "Создаю таблицу history...");
			DbData.mc ([[
				CREATE TABLE `history` (
					`id` int(11) NOT NULL AUTO_INCREMENT,
  					`vkid` int(11) NOT NULL,
  					`desc` text CHARACTER SET utf8 NOT NULL,
  					`count` int(11) NOT NULL,
  					`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
					PRIMARY KEY (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
			]]);
			console.log("MoneySystem", "Таблица history успешно создана!");
		end
	end,

	Start = function ()
		DbData.RegFunc('setMoneys', function (self, moneys) self:set('balance', moneys) end);
		DbData.RegFunc('addMoneys', function (self, moneys, hdata, ...) self:add('balance', moneys)
			if MoneySystem.enable_history and hdata then
				DbData.mc("INSERT INTO `history`(`vkid`, `desc`, `count`) VALUES (%i,'%s',%i)", self.vkid, string.format(hdata, ...), moneys)
			end
		end);
		DbData.RegFunc('checkMoneys', function (self, count) ca(self.balance >= count, string.format(biterr, count)) end);
		if Commands then
			Commands.RegPre(MoneySystem.CheckCmd);
			Commands.RegPost(MoneySystem.Succ);

			argsTypes.m = function (args, arg, offset, user)
				local count = toint(arg);
				if not count then return end
				ca(count > 0, "вы не можете воровать деньги.");
				user:checkMoneys(count);
				return count;
			end
		end
	end,

	CheckCmd = function (msg, args, other, comObj, user)
		return comObj.price and user.balance < comObj.price and { message = comObj.perror or 'У вас нет только денег.' };
	end,

	Succ = function (msg, args, other, comObj, user)
		if comObj.price then user:addMoneys(-comObj.price, "Команда "..comObj[1]) end
	end
};
