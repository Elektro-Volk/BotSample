return {
    creator = {
        screenname = 'Создатель',
        right = true,
        include = 'mainadmin'
    },

    mainadmin = {
        screenname = 'Главный администратор',
        ["right.ban.admin"] = true,
		["right.setright.admin"] = true,
		include = 'admin'
    },

    admin = {
        screenname = 'Администратор',
        ["value.maxbantime"] = -1,
        ["right.ban.moderator"] = true,
        ["right.setright"] = true,
        ["right.setright.moderator"] = true,
        ["right.setright.vip"] = true,
        ["right.setright."] = true,
        include = 'moderator'
    },

    moderator = {
        screenname = 'Модератор',
        ["right.kick"] = true,
		["right.nick.other"] = true,
		["right.otherinfo"] = true,
		["right.ban"] = true,
		["right.ban."] = true,
		["right.ban.vip"] = true,
		["right.razban"] = true,
		["value.maxbantime"] = 86400,
        include = 'vip'
    },

    vip = {
        screenname = "VIP пользователь",
		["right.nick"] = true,
		["value.maxlot"] = 100000,
		["value.lostchance"] = 60,
		include = 'default'
    },

    default = {
        screenname = 'Обычный пользователь',
        ["value.maxlot"] = 10000,
		["value.lostchance"] = 70,
    },
};
