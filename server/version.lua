local function versionCheck()
	local repository = "byextracode/xc_blips"
	local repositorylink = ("https://github.com/%s"):format(repository)
	local resource = GetInvokingResource() or GetCurrentResourceName()
	local currentVersion = GetResourceMetadata(resource, 'version', 0)
	if currentVersion then
		currentVersion = currentVersion:match('%d%.%d+%.%d+')
	end
	if not currentVersion then return print(("^1Unable to determine current resource version for '%s' ^0"):format(resource)) end
	SetTimeout(2500, function()
		PerformHttpRequest(('https://raw.githubusercontent.com/%s/main/fxmanifest.lua'):format(repository), function(status, response)
			if status ~= 200 then return end
			local latestVersion = response:match("%sversion \"(.-)\"")
			if latestVersion == currentVersion then return print(('[INFO] ^2%s^0 is up to date.\r\n(current version: ^2%s.^0)'):format(resource, currentVersion)) end
            local cv = { string.strsplit('.', currentVersion) }
            local lv = { string.strsplit('.', latestVersion) }
            for i = 1, #cv do
                local current, minimum = tonumber(cv[i]), tonumber(lv[i])

                if current ~= minimum then
                    if current < minimum then
                        return print(('^3An update is available for %s.^0\r\ncurrent version: ^3%s.^0\r\nlatest version: ^2%s.^0'):format(resource, currentVersion, latestVersion))
                    else break end
                end
            end
		end, 'GET')
	end)
end

if Config.versionCheck then
    CreateThread(versionCheck)
end