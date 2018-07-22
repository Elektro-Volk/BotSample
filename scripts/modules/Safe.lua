local this = {};
this.blacklist = {
	'pornhub', 'накрутк', 'vk', 'com', 'ru', 'net', 'bot', 'porn', 'бот', '%.', '&'
};

function this.Clear(text)
	for i = 1, #this.blacklist do text = text:gsub(this.blacklist[i], string.rep ('*', string.len(this.blacklist[i]))) end
	return text;
end

return this;
