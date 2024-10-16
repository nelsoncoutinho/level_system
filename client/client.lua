local ESX = exports["es_extended"]:getSharedObject()
local playerLevel = 0
local playerRespect = 0

local function SendNotification(message, type)
    if Config.NotificationType == 'ox' then
        lib.notify({
            title = _L('title_level_system'),
            description = message,
            type = type
        })
    elseif Config.NotificationType == 'okokNotify' then
        exports['okokNotify']:Alert(_L('title_level_system'), message, 5000, type)
    else
        ESX.ShowNotification(message)
    end
end

RegisterNetEvent('respectLevel:syncData')
AddEventHandler('respectLevel:syncData', function(level, respect)
    playerLevel = level
    playerRespect = respect
end)

RegisterNetEvent('respectLevel:levelUp')
AddEventHandler('respectLevel:levelUp', function(newLevel)
    SendNotification(_L('reached_level'):format(newLevel), 'success')
end)

RegisterCommand('mylevel', function()
    local nextLevelRespect = Config.RespectPerLevel + (playerLevel * 10)
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        multiline = true,
        args = {
            _L('chat_my_level'),
            string.format(_L('chat_my_level_info'),
                playerLevel, playerRespect, nextLevelRespect, playerLevel + 1)
        }
    })
end, false)

CreateThread(function()
    TriggerServerEvent('respectLevel:playerJoined')
end)
