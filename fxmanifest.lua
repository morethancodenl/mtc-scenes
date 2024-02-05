fx_version 'cerulean'
game 'gta5'

name "mtc-scenes"
description "An optimised scene resource utilising ox_lib."
author "More Than Code"
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
	'server/json.lua',
	'server/main.lua'
}

files {
	'storage/save.json',
	'storage/bans.json'
}