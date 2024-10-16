Config = {}

--Config.RespectGainInterval = 60 * 60 * 1000 -- 1 hour in milliseconds
Config.RespectGainInterval = 10 * 1000 -- 10 seconds in milliseconds (for testing)
Config.RespectPerLevel = 10
Config.MaxLevel = 20
Config.MoneyRewardPerLevel = 10000

Config.Rewards = {
    -- Add custom rewards here
    -- [level] = {type = 'item', name = 'itemname', amount = 1}
}

Config.Locale = 'en' -- Language
Config.NotificationType = 'ox' -- Notification Type (ox, okokNotify, esx)

-- Add Discord webhook configuration
Config.DiscordWebhook = {
    enabled = false, -- Set to true to enable the webhook
    url = "discord_web_hook", -- Replace with your webhook URL
    username = "Level System", -- Name that will appear as the message author
    avatar = "avatar.png" -- URL for the webhook avatar (optional)
}

Locales = {
    ['en'] = {
        ['respect_gained'] = 'You gained respect!',
        ['level_up'] = 'Congratulations! You reached level %d',
        ['max_level'] = 'You have reached the maximum level!',
        ['your_level'] = 'Your Level',
        ['level_info'] = 'Level: %d\nRespect: %d/%d\nNext Level: %d',
        ['player_data_loaded'] = 'Player data loaded: %s',
        ['reached_level'] = 'You reached level %d',
        ['discord_level_up'] = '**Level Up!**\nPlayer: %s\nLevel: %d',
        ['discord_respect_gained'] = '**Respect Gained!**\nPlayer: %s\nRespect: %d',
        ['chat_my_level'] = 'Level Information',
        ['chat_my_level_info'] = 'Current level: %d\nCurrent respect: %d\nRespect needed for next level: %d\nNext level: %d',
        ['title_level_system'] = 'Level System',
    },
    ['pt'] = {
        ['respect_gained'] = 'Você ganhou respeito!',
        ['level_up'] = 'Parabéns! Você alcançou o nível %d',
        ['max_level'] = 'Você atingiu o nível máximo!',
        ['your_level'] = 'Seu Nível',
        ['level_info'] = 'Nível: %d\nRespeito: %d/%d\nPróximo Nível: %d',
        ['player_data_loaded'] = 'Dados do jogador carregados: %s',
        ['reached_level'] = 'Você alcançou o nível %d',
        ['discord_level_up'] = '**Level Up!**\nPlayer: %s\nLevel: %d',
        ['discord_respect_gained'] = '**Ganhou Respeito!**\nPlayer: %s\nRespeito: %d',
        ['chat_my_level'] = 'Informações de Nível',
        ['chat_my_level_info'] = 'Nível atual: %d\nRespeito atual: %d\nRespeito necessário para o próximo nível: %d\nPróximo nível: %d',
        ['title_level_system'] = 'Sistema de Nível',
    }
}

-- Do Not Touch
-- Function to get translations
function _L(id)
    if Locales[Config.Locale][id] then
        return Locales[Config.Locale][id]
    else
        print("Translation '"..id.."' doesn't exist")
    end
end

function SendDiscordWebhook(message)
    if Config.DiscordWebhook.enabled then
        local timestamp = os.date("%Y-%m-%dT%H:%M:%SZ")
        PerformHttpRequest(Config.DiscordWebhook.url, function(err, text, headers) end, 'POST', json.encode({
            username = Config.DiscordWebhook.username,
            avatar_url = Config.DiscordWebhook.avatar,
            embeds = {
                {
                    description = message,
                    color = 0x0080FF,
                    footer = {
                        text = os.date("%d/%m/%Y %H:%M:%S")
                    },
                    timestamp = timestamp
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end