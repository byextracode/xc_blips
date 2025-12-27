fx_version "cerulean"
lua54        "yes"
game "gta5"

name "xc_blips"
version "2.2.0"
description "Blips display for job services."
author "wibowo#7184"

shared_scripts {
    -- "@ox_lib/init.lua"
}

shared_script "config.lua"

client_script "bridge/**/client.lua"
server_script "bridge/**/server.lua"

client_script "client/*.lua"

server_script "server/*.lua"

dependencies {
    -- "ox_lib", -- optional
}