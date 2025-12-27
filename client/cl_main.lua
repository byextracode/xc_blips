local blips, updated = {}, {}
local jobEvent = QBCore and "QBCore:Client:OnJobUpdate" or "esx:setJob"
local state = { vehicle = 0, siren = false }

local function applyBlipSettings(blip, prop, ped)
    local rotation = DoesEntityExist(ped) and math.ceil(GetEntityHeading(ped)) or math.ceil(prop.heading or 0)

    SetBlipSprite(blip, prop.sprite or 1)
    SetBlipRotation(blip, rotation)
    SetBlipColour(blip, prop.color or 0)
    SetBlipScale(blip, 0.6)
    SetBlipShrink(blip, true)
    SetBlipPriority(blip, 100)
    SetBlipCategory(blip, 7)
    ShowHeadingIndicatorOnBlip(blip, true)

    if DoesEntityExist(ped) then
        SetBlipShowCone(blip, true)
    else
        local coords = prop.coords
        SetBlipCoords(blip, coords.x, coords.y, coords.z)
    end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(prop.name or "")
    EndTextCommandSetBlipName(blip)
end

local function safeSprite(class)
    local cfg = Config.Sprite[class]
    return cfg and cfg.sprite or 1
end

local function sendVehicleState(inVeh, sprite, siren)
    TriggerServerEvent("blips:inVehicle", inVeh, sprite, siren)
end

RegisterNetEvent(jobEvent, function()
    for id, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
end)

RegisterNetEvent('send:blipData', function(data)
    for i = 1, #data do
        local prop = data[i]
        prop.id = tostring(prop.id)

        local ped = prop.net and NetworkDoesEntityExistWithNetworkId(prop.net) and NetworkGetEntityFromNetworkId(prop.net) or nil
        if ped == PlayerPedId() and not Config.EnableSelfBlip then goto skip end

        local blip = blips[prop.id]

        if DoesEntityExist(ped) then
            if not DoesBlipExist(blip) or GetBlipInfoIdEntityIndex(blip) ~= ped then
                if DoesBlipExist(blip) then RemoveBlip(blip) end
                blip = AddBlipForEntity(ped)
                blips[prop.id] = blip
            end
        else
            if not DoesBlipExist(blip) then
                blip = AddBlipForCoord(prop.coords.x, prop.coords.y, prop.coords.z)
                blips[prop.id] = blip
            end
        end

        applyBlipSettings(blip, prop, ped)
        updated[prop.id] = true
        ::skip::
    end

    for id, blip in pairs(blips) do
        if not updated[id] and DoesBlipExist(blip) then
            RemoveBlip(blip)
            blips[id] = nil
        end
    end

    updated = {}
end)

if Config.ox_lib then
    lib.onCache("vehicle", function(vehicle)
        if not vehicle then
            state.vehicle, state.siren = 0, false
            sendVehicleState(false)
            return
        end

        state.vehicle = vehicle
        sendVehicleState(true, safeSprite(GetVehicleClass(vehicle)))
    end)
elseif QBCore then
    RegisterNetEvent('QBCore:Client:EnteredVehicle', function(data)
        state.vehicle = data.vehicle
        sendVehicleState(true, safeSprite(GetVehicleClass(state.vehicle)))
    end)

    RegisterNetEvent('QBCore:Client:LeftVehicle', function(data)
        state.vehicle, state.siren = 0, false
        sendVehicleState(false)
    end)
elseif ESX then
    AddEventHandler("esx:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
        state.vehicle = vehicle
        sendVehicleState(true, safeSprite(GetVehicleClass(state.vehicle)))
    end)

    AddEventHandler("esx:exitedVehicle", function(vehicle, plate, seat, displayName, netId)
        state.vehicle, state.siren = 0, false
        sendVehicleState(false)
    end)
end

CreateThread(function()
    while true do
        if state.vehicle ~= 0 then
            local sirenNow = IsVehicleSirenOn(state.vehicle)
            if sirenNow ~= state.siren then
                state.siren = sirenNow
                local sprite = state.siren and Config.SirenSprite or safeSprite(GetVehicleClass(state.vehicle))
                sendVehicleState(true, sprite, state.siren)
            end
        end
        Wait(Config.sirenupdate * 1000)
    end
end)

AddEventHandler("onClientResourceStart", function(resource)
    if GetCurrentResourceName() ~= resource then return end
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if vehicle == 0 then
        sendVehicleState(false)
    else
        sendVehicleState(true, safeSprite(GetVehicleClass(vehicle)))
    end
end)