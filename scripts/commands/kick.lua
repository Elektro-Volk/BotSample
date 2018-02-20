local command = { "кик", "Исключить пользователя", use = "<профиль> <причина>", right = "kick" };

function command.exe(msg, args, other, rmsg)
	if msg.chat_id then
		if #args > 2 then
			local target_id = getId(args[2]);
			if target_id then
				local params =  { chat_id = msg.chat_id, user_id = target_id };
				local resp = vk.jSend("messages.removeChatUser", params);
				if not resp.error then
					console.log("vk.com/id"..msg.user_id.." исключил vk.com/id"..target_id);  
					vk.send('messages.send', {
						peer_id = target_id,
						message = "Вас исключили по причине: <<"..cmd.data(args, 3)..">><br>Исключил: "..NameSystem.GetR(msg.user_id);
					}, true);
					return "Пользователь был исключен.";
				else
					return "err:пользователя нет в беседе.";
				end
			else
				return "err:некорректная ссылка на пользователя.";
			end
		else
			return "err:используйте: "..command[1].." "..command.use;
		end
	else
		return "err:данную команду можно выполнить только в беседе.";
	end
end

return command;