return {
	queries = {},

	Invite = function (user, target, callback, data, timer)
		-- Очистить старые запросы юзера
		for k,v in pairs(this.queries) do
			if v.source_id == user.vkid then this.queries[k] = nil end
		end

		local qid = math.random(8999) + 1000;

		this.queries[qid] = {
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

		local query = this.queries[qid];
		if not query then return "err:запрос не найден" end
		if query.target_id ~= user.vkid then return "err:это не ваш запрос" end
		this.queries[qid] = nil;
		if query.endtime < os.time() then return "err:время запроса истекло" end

		return query.callback(query.data, user, DbData(query.source_id), rmsg);
	end
};
