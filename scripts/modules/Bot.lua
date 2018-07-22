--[[
    Этот модуль организует систему бота по типу "бот с командами".
    Использование:
        Бот сам определяет точку входа, вам лишь остается настроить некоторые
    части и элементы бота.
        NameSystem.botNames = { 'обращения', 'к_боту', 'в_нижнем_регистре' };
        Bot.executes = { CommandsSystem.Execute, CmdNotFound, ... };
]]

local function dolist (list, ...)
    for i = 1, #list do local res = list[i](...); if res==false then return false end end
    return true;
end

local module = {
    check_list = { }, -- Если хоть одна из функций вернет false, то сообщение будет отклонено.
    pre_list = { }, -- Подготовка сообщения
    executes = { }, -- Тут обходим функции, пока не получим RMSG.
    post_list = { }, -- Так же. Один false, и ничего слать не будем.
    all_post_list = { }, -- Эти функции вызываются в конце всех пост функций. Пост пост функция :D

    addCheck    = function (f) table.insert(Bot.check_list   , f) end,
    addPre      = function (f) table.insert(Bot.pre_list     , f) end,
    addPost     = function (f) table.insert(Bot.post_list    , f) end,
    addAllPost  = function (f) table.insert(Bot.all_post_list, f) end
};

vk_events['message_new'] = function (msg)
    if msg.from_id < 0 then return end -- На группы не отвечаем, мы не умеем с ними работать.
    -- Проходим по чеклистам. Там обычно проверяется обращения к боту и прочая фигня.
    if not dolist (Bot.check_list, msg) then return end

    status, err = pcall(TreatmentMessage, msg); -- Некий try catch в Lua.
	if not status and err then
        console.error("MSG", err);
        VK.messages.send {
            peer_id = admin,
            message = string.format(
                "&#9888; В вашем боте произошла ошибка<br>&#9940; %s<br>&#127773; %s [%s]",
                err, "vk.com/id"..msg.from_id, msg.peer_id
            ),
            title = "В вашем боте произошла ошибка"
        }
        resp(msg, "&#9888; Произошла ошибка. Разработчик уже знает об этом!") end
end

TreatmentMessage = function (msg)
    local user = DbData(msg.from_id);
    local other = { clock = os.clock() };

    console.log(ischat(msg) and (msg.peer_id - 2000000000)..'|'..msg.from_id or msg.from_id, msg.text or '[NULL]');

    if not dolist (Bot.pre_list, msg, other, user) then return end
    -- Пока не получим RMSG мы будем обходить эти функции
    local rmsg;
    for i = 1, #Bot.executes do
        rmsg = Bot.executes[i](msg, other, user);
        if rmsg then break end
    end
    if not rmsg then return end -- Так и не нашли.

    if not dolist (Bot.post_list, msg, other, user, rmsg) then return end
    if not dolist (Bot.all_post_list, msg, other, user, rmsg) then return end

    -- Шлем сообщение
    rmsg.peer_id = msg.peer_id;
    local result = VK.messages.send(rmsg);
    local time = math.floor(1000*(os.clock()-other.clock));
    console.log(string.format("I: %s; T: %i ms.", result.response or 'E', time), rmsg.message or '-');
end

return module;
