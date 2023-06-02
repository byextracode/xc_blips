if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
Framework = 'qb'

print(("%s: QBCore initialized"):format(GetCurrentResourceName()))