local command = { "отправить", "Отправить биты", use = "<получатель> <кол-во>", args = 'Um', smile='&#128188;' };

function command.exe(msg, args, other, rmsg, user, target, count)
	ca(target.vkid ~= user.vkid, "вы не можете отправить биты самому себе");

    target:addMoneys(count, "Биты от vk.com/id"..user.vkid);
	user:addMoneys(-count, "Отправка бит на vk.com/id"..target.vkid);
	target:ls("%s отправил вам %i бит", user:r(), count);

	rmsg:line ("&#10035; Вы отправили биты!");
	rmsg:line ("&#127913; Получатель: %s", target:r());
end

return command;
