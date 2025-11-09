fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Welcome Ped - Greets new players and provides apartment directions'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

server_scripts {
    'config.lua',
    'server/main.lua'
}

dependencies {
    'qb-core',
    'ox_target',
    'ox_lib'
} 