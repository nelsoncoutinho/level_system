local ESX = exports["es_extended"]:getSharedObject()
local players = {}

-- Adicione esta linha no início do arquivo para importar ox_lib
local lib = exports['ox_lib']

local function loadPlayerData(identifier)
    local result = MySQL.Sync.fetchAll("SELECT level, respect FROM player_levels WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result and #result > 0 then
        return result[1].level, result[1].respect
    end
    return nil, nil
end

local function savePlayerData(identifier, level, respect)
    MySQL.Async.execute("INSERT INTO player_levels (identifier, level, respect) VALUES (@identifier, @level, @respect) ON DUPLICATE KEY UPDATE level = @level, respect = @respect", {
        ['@identifier'] = identifier,
        ['@level'] = level,
        ['@respect'] = respect
    })
end

local function ensurePlayerData(identifier)
    if not players[identifier] then
        local level, respect = loadPlayerData(identifier)
        if not level then
            level = 0
            respect = 0
            savePlayerData(identifier, level, respect)
        end
        players[identifier] = {level = level, respect = respect, lastUpdate = os.time()}
    end
    return players[identifier]
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local identifier = xPlayer.identifier
    
    local playerData = ensurePlayerData(identifier)
    
    TriggerClientEvent('respectLevel:syncData', playerId, playerData.level, playerData.respect)
    print(_L('player_data_loaded') .. identifier)
end)


local function giveReward(xPlayer, level)
    xPlayer.addMoney(Config.MoneyRewardPerLevel)
    
    if Config.Rewards[level] then
        local reward = Config.Rewards[level]
        if reward.type == 'item' then
            xPlayer.addInventoryItem(reward.name, reward.amount)
        end
    end
end
CreateThread(function()
    while true do
        Wait(Config.RespectGainInterval)
        for identifier, data in pairs(players) do
            local oldRespect = data.respect
            data.respect = data.respect + 1
            local dataChanged = false
            
            local respectNeeded = 10 + (data.level * 10)
            if data.respect >= respectNeeded then
                local oldLevel = data.level
                data.level = math.min(data.level + 1, Config.MaxLevel)
                data.respect = data.respect - respectNeeded
                dataChanged = true
                
                local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
                if xPlayer then
                    TriggerClientEvent('respectLevel:levelUp', xPlayer.source, data.level)
                    giveReward(xPlayer, data.level)
                    
                end
            end
            
            if data.respect > oldRespect or dataChanged then
                savePlayerData(identifier, data.level, data.respect)
                local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
                if xPlayer then
                    TriggerClientEvent('respectLevel:syncData', xPlayer.source, data.level, data.respect)
                    if data.respect > oldRespect then
                        -- Alteração aqui também
                        TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                            title = _L('respect_gained'),
                            description = _L('respect_gained'),
                            type = 'info'
                        })
                    end
                end
            end
        end
    end
end)

-- Function to check for updates
local function checkForUpdates()
	PerformHttpRequest("https://api.github.com/repos/nelsoncoutinho/level_system/releases/latest", function(err, text, headers)
		if err ~= 200 then
			print("^1Error checking for updates for level_system^7")
			return
		end
		
		local data = json.decode(text)
		if data.tag_name ~= GetResourceMetadata(GetCurrentResourceName(), "version", 0) then
			print("^3A new version of level_system is available!^7")
			print("^3Current version: " .. GetResourceMetadata(GetCurrentResourceName(), "version", 0) .. "^7")
			print("^3New version: " .. data.tag_name .. "^7")
			print("^3Download the new version at: " .. data.html_url .. "^7")
		else
			print("^2level_system is up to date.^7")
		end
	end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Check for updates when the resource starts
Citizen.CreateThread(function()
	Citizen.Wait(5000) -- Wait 5 seconds to ensure everything is loaded
	checkForUpdates()
end)