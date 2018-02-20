local M = {};

function M.Get(imgurl)
	return net.send("http://ebp.elektro-volk.ru/api/rucaptcha.php", {
		url = imgurl,
		key = M.key
	});
end

return M;