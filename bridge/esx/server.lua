if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Framework = 'esx'

print(("%s: ESX initialized"):format(GetCurrentResourceName()))