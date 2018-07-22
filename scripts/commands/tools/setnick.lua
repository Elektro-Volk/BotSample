local command = { "сетник", "Сменить чужой никнейм", right = "nick.other", use="<профиль> <ник>", args = 'Ud', smile = '&#127913;' };

function command.exe(msg, args, other, rmsg, user, target, nick)
    nick = Safe.Clear(nick:gsub('\n', ' '));
    ca(utf8.len(nick) ~= 0, "походу я не вижу никнейм :/");
    ca(utf8.len(nick) <= 20, "не многовато-ли для никнейма?");

	target:setName(nick);

    return "&#10035; Вы успешно сменили ник для "..target:r();
end

return command;
