local players = {}

local function isAuthorized(job)
    return Config.authorizedJob[job] ~= nil
end

AddEventHandler("onResourceStart", function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end
    local playerdata = ESX.GetExtendedPlayers()
    for i = 1, #playerdata do
        local xPlayer = playerdata[i]
        local heading = GetEntityHeading(GetPlayerPed(xPlayer.source))
        local net = NetworkGetNetworkIdFromEntity(GetPlayerPed(xPlayer.source))
        local job = xPlayer.job.name
        if isAuthorized(xPlayer.job.name) then
            tableData[job][#tableData[job]+1] = {
                id = xPlayer.source,
                name = xPlayer.job.grade_label .. " | " .. xPlayer.name,
                coords = xPlayer.getCoords(true),
                heading = heading,
                net = net,
                color = Config.authorizedJob[xPlayer.job.name].color
            }
        end

        players[xPlayer.source] = xPlayer
    end
end)

AddEventHandler("esx:playerLoaded", function(playerId, xPlayer, newPlayer)
	local xPlayer = xPlayer
	if not xPlayer then
		return
	end
    local job = xPlayer.job.name
    local lastJob = job
	local heading = GetEntityHeading(GetPlayerPed(playerId))
	local net = NetworkGetNetworkIdFromEntity(GetPlayerPed(playerId))
    if isAuthorized(lastJob) then
        for i = 1, #tableData[lastJob] do
            if tableData[lastJob][i] and tableData[lastJob][i].id == playerId then
                tableData[lastJob][i] = nil
            end
        end
    end
    if not isAuthorized(job) then
        return
    end
    tableData[job][#tableData[job]+1] = {
        id = playerId,
        name = xPlayer.job.grade_label .. " | " .. xPlayer.name,
        coords = xPlayer.getCoords(true),
        heading = heading,
        net = net,
        color = Config.authorizedJob[job].color
    }
end)

AddEventHandler("esx:setJob", function(playerId, job, lastJob)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if not xPlayer then
		return
	end
    players[playerId] = xPlayer
    local job = job.name
    local lastJob = lastJob.name
	local heading = GetEntityHeading(GetPlayerPed(playerId))
	local net = NetworkGetNetworkIdFromEntity(GetPlayerPed(playerId))
    if isAuthorized(lastJob) then
        for i = 1, #tableData[lastJob] do
            if tableData[lastJob][i] and tableData[lastJob][i].id == playerId then
                tableData[lastJob][i] = nil
            end
        end
    end
    if not isAuthorized(job) then
        return
    end
    tableData[job][#tableData[job]+1] = {
        id = playerId,
        name = xPlayer.job.grade_label .. " | " .. xPlayer.name,
        coords = xPlayer.getCoords(true),
        heading = heading,
        net = net,
        color = Config.authorizedJob[job].color
    }
end)

AddEventHandler("playerDropped", function()
	local source = source
    for job, table in pairs(tableData) do
        for i = 1, #tableData[job] do
            if tableData[job][i] and tableData[job][i].id == source then
                tableData[job][i] = nil
                return
            end
        end
    end
end)

RegisterServerEvent("blips:inVehicle", function(state, sprite)
    local source = source
    for job, table in pairs(tableData) do
        for i = 1, #tableData[job] do
            if tableData[job][i] and tableData[job][i].id == source then
                tableData[job][i].sprite = state and sprite or nil
                return
            end
        end
    end
end)

CreateThread(function()
	while true do
        for job, table in pairs(tableData) do
            for i = 1, #tableData[job] do
                if tableData[job][i] then
                    if GetPlayerName(tableData[job][i].id) ~= nil then
                        tableData[job][i].coords = GetEntityCoords(GetPlayerPed(tableData[job][i].id))
                        tableData[job][i].heading = GetEntityHeading(GetPlayerPed(tableData[job][i].id))
                    else
                        tableData[job][i] = nil
                    end
                end
            end
        end
        for id, xPlayer in pairs(players) do
            local data = {}
            if GetPlayerName(id) then
                for job, table in pairs(Config.authorizedJob) do
                    if table.sharedjobs[xPlayer.job.name] then
                        for n = 1, #tableData[job] do
                            data[#data+1] = tableData[job][n]
                        end
                    end
                end
                TriggerClientEvent("send:blipData", id, data)
            end
        end
		Wait(Config.tickupdate * 1000)
    end
end)

AddEventHandler("esx:playerLoaded", function(playerId, xPlayer, isNew)
    players[playerId] = xPlayer
end)

AddEventHandler("esx:playerDropped", function(playerId)
    players[playerId] = nil
end)