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
    for job, table in pairs(tableData) do
        for i = 1, #tableData[job] do
            if tableData[job][i] and tableData[job][i].id == source then
                tableData[job][i] = nil
                return
            end
        end
    end
end)

RegisterServerEvent("blips:inVehicle", function(state, sprite, siren)
    local source = source
    for job, table in pairs(tableData) do
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
                    local jobName = QBCore and xPlayer.PlayerData.job.name or xPlayer.job.name
                    if table.sharedjobs[jobName] then
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