fx_version "cerulean"
lua54        "yes"
game "gta5"

name "xc_blips"
version "2.0.0"
description "Blips display for job services."
author "wibowo#7184"

shared_scripts {
    "@es_extended/imports.lua",
    -- "@ox_lib/init.lua"
}

shared_script "config.lua"
client_script "**/cl_*.lua"

server_script "@oxmysql/lib/MySQL.lua"
server_script "**/sv_*.lua"

dependencies {
    "es_extended",
    -- "ox_lib", -- optional
}