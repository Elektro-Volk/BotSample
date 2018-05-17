local command = { "кто", "Ищет виновника фразы", use = "<фраза>", smile='&#10068;' };

function command.exe(msg, args)
	msg = getmsg(msg.id); -- Fix chat_active
	if msg.chat_id then
		local user = vk.jSend('users.get', { user_ids = tostring(msg.chat_active[math.random(#msg.chat_active)]) }).response[1];
		return { message = "Это "..user.first_name.." "..user.last_name, forward_messages = tostring(msg.id) };
	else 
		return "Ты!";
	end
end

return command;
