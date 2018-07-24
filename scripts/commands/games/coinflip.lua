local command = { "кф", "Коинфлип", use = "<профиль> [ставка]", smile = '&#127767;', args = 'U' };

function command.exe(msg, args, other, rmsg, user, target)
	local count = tonumber(args[3]) or 1000;

	user:checkMoneys(count);
	ca (count >= 5, "вы не можете ставить так мало яриков");
	ca (target.vkid ~= user.vkid, "вы пытаетесь сделать некультурные вещи :/");

	local qid = Invites.Invite(user, target, command.accept, count);
	rmsg:line("&#127767; %s &#127386; %s", user:r(), target:r());
	rmsg:line("&#128176; Ставка: %i бит.", count);
	rmsg:line("&#9899; %s должен принять запрос командой:", target:r());
	rmsg:line("&#10145; принять %i", qid);
end

command.accept = function (count, target, source, rmsg)
	target:checkMoneys(count);
	ca (source.balance >= count, "оппонент успел потратить свои биты");

	local winner = math.random(100) > 50 and source or target;
	winner:addMoneys(count, "Победа в коинфлипе");
	(winner == target and source or target):addMoneys(-count, "Поражение в коинфлипе");

	rmsg:line("&#127767; %s &#127386; %s", source:r(), target:r());
	rmsg:line("&#128176; Ставка: %i бит.", count);
	rmsg:line("&#10035; Победитель: %s", winner:r());
end

return command;
