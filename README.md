# BotSample
1) Setup config.cfg
2) Setup main.lua (Bot names and mysql server)
3) Create accounts table:
CREATE TABLE `accounts` (
`id` int(11) NOT NULL,
`vkid` int(11) NOT NULL,
`first_name` text NOT NULL,
`last_name` text NOT NULL,
`nickname` text NOT NULL,
`ban` int(11) NOT NULL,
`right` text NOT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `accounts` 
ADD PRIMARY KEY (`id`);

ALTER TABLE `accounts`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
