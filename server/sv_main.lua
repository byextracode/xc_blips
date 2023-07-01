players = {}
tableData = {}

for job, data in pairs(Config.authorizedJob) do
    tableData[job] = {}
end

function isAuthorized(job)
    return Config.authorizedJob[job] ~= nil
end

AddEventHandler("playerDropped", function()
	local source = source
    local data = tableData
    for job, tables in pairs(data) do
        for i = 1, #data[job] do
            if data[job][i] and data[job][i].id == source then
                table.remove(data[job], i)
                tableData = data
                return
            end
        end
    end
end)

RegisterServerEvent("blips:inVehicle", function(state, sprite, siren)
    local source = source
    for job, tables in pairs(tableData) do
        for i = 1, #tableData[job] do
            if tableData[job][i] and tableData[job][i].id == source then
                if siren and not Config.authorizedJob[job]?.siren then
                    return
                end
                tableData[job][i].sprite = state and sprite or nil
                return
            end
        end
    end
end)

CreateThread(function()
	while true do
        local data = tableData
        for job, tables in pairs(data) do
            for i = 1, #data[job] do
                if data[job][i] then
                    if GetPlayerName(data[job][i].id) ~= nil then
                        data[job][i].coords = GetEntityCoords(GetPlayerPed(data[job][i].id))
                        data[job][i].heading = GetEntityHeading(GetPlayerPed(data[job][i].id))
                    else
                        table.remove(data[job], i)
                    end
                end
            end
        end
        for id, xPlayer in pairs(players) do
            local preparedData = {}
            if GetPlayerName(id) then
                for job, tables in pairs(Config.authorizedJob) do
                    local jobName = QBCore and xPlayer.PlayerData.job.name or xPlayer.job.name
                    if tables.sharedjobs[jobName] then
                        for n = 1, #data[job] do
                            preparedData[#preparedData+1] = data[job][n]
                        end
                    end
                end
                TriggerClientEvent("send:blipData", id, preparedData)
            end
        end
		Wait(Config.tickupdate * 1000)
    end
end)