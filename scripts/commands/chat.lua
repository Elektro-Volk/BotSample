local command = { 'беседа', 'Добавит вас в беседу бота' };
command.chat_id = 0; -- ID вашей беседы
command.msg = "Добро пожаловать!"; -- Сообщение при входе

function command.exe (msg, args, other)
	if msg.chat_id and msg.chat_id == chat_id then return "err:Ты уже есть в этой беседе." end
	
	local resp = VK.messages.addChatUser{ chat_id = command.chat_id, user_id = msg.user_id };
	if not resp.response then return "err:что-то пошло не так. Ты есть у меня в друзьях?" end
	
	VK.messages.send { chat_id = command.chat_id, message = command.msg };
	other.nosend = true;
end

return command;
