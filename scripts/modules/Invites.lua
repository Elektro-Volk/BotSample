return {
	queries = {},

	Start = function ()
		if not Commands then return end
		Commands.commands["принять"] = { "принять", "Принять запрос", use = "<номер>", smile = '&#9989;', args = 'i', exe = Invites.Do, type = 'other' };
		Commands.cmd_count = Commands.cmd_count + 1;
	end,

	Invite = function (user, target, callback, data, timer)
		-- Очистить старые запросы юзера
		for k,v in pairs(Invites.queries) do
			if v.source_id == user.vkid then Invites.queries[k] = nil end
		end

		local qid = math.random(8999) + 1000;

		Invites.queries[qid] = {
			data = data,
			endtime = (timer or 300) + os.time(),
			target_id = target.vkid,
			source_id = user.vkid,
			callback = callback
		};

		return qid;
	end,

	Do = function (msg, args, other, rmsg, user)
		local qid = tonumber(args[2]);
		if not qid then return "err:используйте: принять <номер>" end

		local query = Invites.queries[qid];
		if not query then return "err:запрос не найден" end
		if query.target_id ~= user.vkid then return "err:это не ваш запрос" end
		Invites.queries[qid] = nil;
		if query.endtime < os.time() then return "err:время запроса истекло" end

		return query.callback(query.data, user, DbData(query.source_id), rmsg);
	end
};
