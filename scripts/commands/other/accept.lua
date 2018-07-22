local command = { "принять", "Принять запрос", use = "<номер>", smile = '&#9989;' };
function command.exe(msg, args, other, rmsg, user) return Invites.Do(msg, args, other, rmsg, user) end
return command;
