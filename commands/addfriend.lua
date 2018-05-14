local command = { 'добавь', 'Добавит вас в друзья', smile='&#128572;' };

function command.exe (msg, args, other,user)
	local isfr = VK.friends.areFriends { user_ids = tostring(msg.user_id) }.response[1].friend_status;
	if isfr == 0 then return "err:сначала кинь мне заявку" end
	if isfr == 3 then return "err:мы уже друзья <3" end
	VK.friends.add { user_id = msg.user_id };
	return "Мы будем хорошими друзьями)";
end

return command;
