local blips = {}
local updated = {}
local jobEvent = QBCore and "QBCore:Client:OnJobUpdate" or "esx:setJob"
local currentVehicle = 0
local isSirenOn = false

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
        local ped = NetworkDoesEntityExistWithNetworkId(prop.net) and NetworkGetEntityFromNetworkId(prop.net) or nil
        if ped == PlayerPedId() and not Config.EnableSelfBlip then
            goto skip
        end
        if DoesEntityExist(ped) then
            if DoesBlipExist(blips[prop.id]) then
                if prop.sprite then
                    RemoveBlip(blips[prop.id])
                    local blip = AddBlipForEntity(ped)
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    blips[prop.id] = blip
                    updated[prop.id] = true
                else
                    local pedBlip = GetBlipFromEntity(ped)
                    if DoesBlipExist(pedBlip) then
                        local blip = blips[prop.id]
                        local coords = prop.coords
                        SetBlipSprite(blip, prop.sprite or 1)
                        ShowHeadingIndicatorOnBlip(blip, true)
                        SetBlipShowCone(blip, true) -- Player Blip indicator
                        SetBlipRotation(blip, math.ceil(prop.heading))
                        SetBlipColour(blip, prop.color)
                        SetBlipScale(blip, 0.6)
                        SetBlipShrink(blip, true)
                        SetBlipPriority(blip, 100)
                        SetBlipCategory(blip, 7)
                        BeginTextCommandSetBlipName("STRING");
                        AddTextComponentString(prop.name);
                        EndTextCommandSetBlipName(blip);
                        updated[prop.id] = true
                    else
                        RemoveBlip(blips[prop.id])
                        local blip = AddBlipForEntity(ped)
                        SetBlipSprite(blip, prop.sprite or 1)
                        ShowHeadingIndicatorOnBlip(blip, true)
                        SetBlipShowCone(blip, true) -- Player Blip indicator
                        SetBlipRotation(blip, math.ceil(prop.heading))
                        SetBlipColour(blip, prop.color)
                        SetBlipScale(blip, 0.6)
                        SetBlipShrink(blip, true)
                        SetBlipPriority(blip, 100)
                        SetBlipCategory(blip, 7)
                        BeginTextCommandSetBlipName("STRING");
                        AddTextComponentString(prop.name);
                        EndTextCommandSetBlipName(blip);
                        blips[prop.id] = blip
                        updated[prop.id] = true
                    end
                end
            else
                if prop.sprite then
                    local blip = AddBlipForEntity(ped)
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    blips[prop.id] = blip
                    updated[prop.id] = true
                else
                    local blip = AddBlipForEntity(ped)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    SetBlipShowCone(blip, true) -- Player Blip indicator
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    blips[prop.id] = blip
                    updated[prop.id] = true
                end
            end
        else
            if DoesBlipExist(blips[prop.id]) then
                if prop.sprite then
                    RemoveBlip(blips[prop.id])
                    local coords = prop.coords
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipCoords(blip, coords.x, coords.y, coords.z)
                    SetBlipRotation(blip, math.ceil(prop.heading))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    blips[prop.id] = blip
                    updated[prop.id] = true
                else
                    local coords = prop.coords
                    local blip = blips[prop.id]
                    SetBlipCoords(blip, coords.x, coords.y, coords.z)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    SetBlipShowCone(blip, true) -- Player Blip indicator
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipRotation(blip, math.ceil(prop.heading))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    updated[prop.id] = true
                end
            else
                if prop.sprite then
                    local coords = prop.coords
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipRotation(blip, math.ceil(prop.heading))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    blips[prop.id] = blip
                    updated[prop.id] = true
                else
                    local coords = prop.coords
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    SetBlipShowCone(blip, true) -- Player Blip indicator
                    SetBlipSprite(blip, prop.sprite or 1)
                    SetBlipRotation(blip, math.ceil(prop.heading))
                    SetBlipColour(blip, prop.color)
                    SetBlipScale(blip, 0.6)
                    SetBlipShrink(blip, true)
                    SetBlipPriority(blip, 100)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(prop.name);
                    EndTextCommandSetBlipName(blip);
                    blips[prop.id] = blip
                    updated[prop.id] = true
                end
            end
        end
        ::skip::
    end

    for id, blip in pairs(blips) do
        if not updated[id] then
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
                blips[id] = nil
            end
        end
    end

    updated = {}
end)

if Config.ox_lib then
    lib.onCache("vehicle", function(vehicle)
        if not vehicle then
            currentVehicle = 0
            isSirenOn = false
            TriggerServerEvent("blips:inVehicle", false)
            return
        end

        currentVehicle = vehicle
        TriggerServerEvent("blips:inVehicle", true, Config.Sprite[GetVehicleClass(currentVehicle)].sprite)
    end)
elseif QBCore then
    RegisterNetEvent('QBCore:Client:EnteredVehicle', function(data)
        currentVehicle = data.vehicle
        TriggerServerEvent("blips:inVehicle", true, Config.Sprite[GetVehicleClass(currentVehicle)].sprite)
    end)

    RegisterNetEvent('QBCore:Client:LeftVehicle', function(data)
        currentVehicle = 0
        isSirenOn = false
        TriggerServerEvent("blips:inVehicle", false)
    end)
else
    AddEventHandler("esx:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
        currentVehicle = vehicle
        TriggerServerEvent("blips:inVehicle", true, Config.Sprite[GetVehicleClass(currentVehicle)].sprite)
    end)

    AddEventHandler("esx:exitedVehicle", function(vehicle, plate, seat, displayName, netId)
        currentVehicle = 0
        isSirenOn = false
        TriggerServerEvent("blips:inVehicle", false)
    end)
end

CreateThread(function()
    while true do
        if currentVehicle ~= 0 then
            if IsVehicleSirenOn(currentVehicle) then
                if not isSirenOn then
                    isSirenOn = true
                    TriggerServerEvent("blips:inVehicle", true, Config.SirenSprite, true)
                end
            else
                if isSirenOn then
                    isSirenOn = false
                    TriggerServerEvent("blips:inVehicle", true, Config.Sprite[GetVehicleClass(currentVehicle)].sprite)
                end
            end
        end
        Wait(Config.sirenupdate * 1000)
    end
end)

AddEventHandler("onClientResourceStart", function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if vehicle == 0 then
        TriggerServerEvent("blips:inVehicle", false)
    else
        TriggerServerEvent("blips:inVehicle", true, Config.Sprite[GetVehicleClass(vehicle)].sprite)
    end
end)