fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Nelson Coutinho'
description 'Basic Level System'
version '1.0.0'

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
