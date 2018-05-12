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

# How to start EBP in group
1) Enable longpoll in group settings
2) Enable new message event
3) Get group token for full rules
3) Add to config.cfg
vk_group 1
vk_groupid groupid
vk_token grouptoken

# How to start only bot in group and user page
1) Create folder "group"
2) Create links in "group" from bot/scripts and bot/settings
3) Setup group config.cfg to group settings
4) Start ./EBP and ./EBP group
