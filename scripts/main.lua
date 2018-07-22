connect "scripts/tokens";

NameSystem.botNames = { "пуся", "бот", "!" }; -- Имена бота
admin = 169494689; -- ИД создателя бота ВК

Bot.executes = {
	Commands.Execute,
	function (msg, other, user)
		return { message = "&#127801; Команда не найдена :(" }
	end
};

-- Счетчик баланса
Bot.addPre(function (msg, other, user) other.last_balance = user.balance end);
Bot.addAllPost(function (msg, other, user, rmsg)
	if other.last_balance ~= user.balance then
		local diff = user.balance - other.last_balance;
		addline (rmsg, string.format("💳 &#1013%i;%i » %i бит.", diff > 0 and 3 or 4, math.abs(diff), user.balance));
	end
end);
