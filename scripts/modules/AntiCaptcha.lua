local this = { isCap = false, capCount = 0 };

function this.Wait()
	if not this.isCap then return false end
	while this.isCap do end
	return true;
end

function this.Do(rmsg, other, err)
	if rmsg.captcha_key then return end
	if this.Wait() then SendMessage(rmsg, other); return end
		
	this.isCap = true;
	this.capCount = this.capCount + 1;
	if this.capCount >= 3 then
		VK.status.set { text = "Слишком много капч. Отдыхаю." };
		local a = os.time();
		while a + 120 > os.time() do end
		this.capCount = 0;
	else
		console.log("Getting captcha from AntiCaptcha...");
		VK.status.set { text = "Решаю капчу." };
		local resp = this.Get(err.captcha_img);
		rmsg.captcha_sid = err.captcha_sid;
		rmsg.captcha_key = resp;
		console.log("Captcha: "..resp);
	end
	VK.status.set { text = "Все ок" };
	this.isCap = false;
	SendMessage(rmsg, other);
end

function this.Get(imgurl)
	return net.send("http://ebp.elektro-volk.ru/api/rucaptcha.php", {
		url = imgurl,
		key = this.key
	});
end

function this.GetBalance()
	return net.send("http://rucaptcha.com/res.php", {
		action = 'getbalance',
		key = this.key
	});
end

return this;
