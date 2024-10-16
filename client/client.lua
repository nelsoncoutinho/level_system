local ESX = exports["es_extended"]:getSharedObject()
local playerLevel = 1
local playerRespect = 0


RegisterNetEvent('respectLevel:syncData')
AddEventHandler('respectLevel:syncData', function(level, respect)
    playerLevel = level
    playerRespect = respect
end)

RegisterNetEvent('respectLevel:levelUp')
AddEventHandler('respectLevel:levelUp', function(newLevel)
    lib.notify({
        title = _L('level_up'),
        description = _L('reached_level'):format(newLevel),
        type = 'success'
    })
end)

RegisterCommand('mylevel', function()
    local nextLevelRespect = Config.RespectPerLevel + (playerLevel * 10)
    lib.notify({
        title = _L('your_level'),
        description = _L('level_info'):format(playerLevel, playerRespect, nextLevelRespect, playerLevel + 1),
        type = 'info'
    })
end, false)

CreateThread(function()
    TriggerServerEvent('respectLevel:playerJoined')
end)
