fx_version 'cerulean'
game 'gta5'

name "qb-scenes"
description "An optimised scene resource utilising ox_lib. Made for LegacyRP "
author "L1"
version "1.0.0"
lua54 'yes'
shared_scripts {
	'@ox_lib/init.lua',
	'@qb-core/shared/locale.lua',
    'locales/nl.lua',
    'locales/*.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/bans.lua',
	'server/main.lua'
}

files {
	'storage/bans.json'
}