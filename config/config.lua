Config = {}

--Config.RespectGainInterval = 60 * 60 * 1000 -- 1 hour in milliseconds
Config.RespectGainInterval = 10 * 1000 -- 10 seconds in milliseconds ( tests )
Config.RespectPerLevel = 10
Config.MaxLevel = 20
Config.MoneyRewardPerLevel = 10000

Config.Rewards = {
    -- Add custom rewards here
    -- [level] = {type = 'item', name = 'itemname', amount = 1}
}

Config.Locale = 'en' -- Define the language of the script

Locales = {
    ['en'] = {
        ['respect_gained'] = 'You gained respect!',
        ['level_up'] = 'Congratulations! You reached level %d',
        ['max_level'] = 'You have reached the maximum level!',
        ['your_level'] = 'Your Level',
        ['level_info'] = 'Level: %d\nRespect: %d/%d\nNext Level: %d',
        ['player_data_loaded'] = 'Player data loaded: %s',
        ['reached_level'] = 'You reached level %d',

    },
    ['pt'] = {
        ['respect_gained'] = 'Você ganhou respeito!',
        ['level_up'] = 'Parabéns! Você alcançou o nível %d',
        ['max_level'] = 'Você atingiu o nível máximo!',
        ['your_level'] = 'Seu Nível',
        ['level_info'] = 'Nível: %d\nRespeito: %d/%d\nPróximo Nível: %d',
        ['player_data_loaded'] = 'Dados do jogador carregados: %s',
        ['reached_level'] = 'Você alcançou o nível %d',
        
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
