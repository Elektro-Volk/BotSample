local command = { "кик", "Исключить пользователя", use = "<ссылка> <причина>", right = "kick", smile='&#128094;', _type = 'moder' };

function command.exe(msg, args, other, rmsg, user)
	if not msg.chat_id then return "err:только в беседе" end
	local target_id = getId(args[2] or '');
	if not target_id then return useerr(command) end

	local params =  { chat_id = msg.chat_id, user_id = target_id };
	local resp = VK.messages.removeChatUser { chat_id = msg.chat_id, user_id = target_id };
	if resp.error then return "err:пользователя нет в беседе." end
	
	VK.messages.send {
		peer_id = target_id,
		message = string.format("&#128094; Вас исключили по причине: <<%s>><br>&#128003; Исключил: %s", cmd.data(args, 3), user:r())
	};
end

return command;
