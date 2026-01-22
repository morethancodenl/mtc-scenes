local import = require('server.json')
local BanIdentifier, IsBanned, SaveScenes, GetSavedScenes = import[1], import[2], import[3], import[4]

local scenes = {}


local function GetIdentifier(player, type)
    local identifiers = GetPlayerIdentifiers(player)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, type) then
            return identifier
        end
    end
    return nil
end

lib.addCommand('sceneban', {
    description = locale('commands.ban_scene_description'),
    params = {
        {
            name = "player",
            type = 'playerId',
            description = locale('commands.player_id')
        }
    },
    restricted = true
}, function(source, args)
    local target = tonumber(args[1])
    if not target then
        return
    end

    local identifier = GetIdentifier(target, 'license')
    if not identifier then
        return
    end

    BanIdentifier(identifier)

    TriggerClientEvent('chat:addMessage', source, {
        args = {'Scene Ban', Lang:t('chatMessages.banned')}
    })
end)


lib.callback.register('mtc-scenes:server:getScenes', function(source)
    return scenes
end)

lib.callback.register('mtc-scenes:server:destoryScene', function(source, id)
    local identifier = GetIdentifier(source, 'license')
    
    
    if not identifier then
        return false
    end

    if IsBanned(identifier) then
        return false
    end

    local scene = scenes[id]
    -- Add your logging here
    scenes[id] = nil
    TriggerClientEvent('mtc-scenes:client:refreshScenes', -1, scenes)
    return true
end)

lib.callback.register('mtc-scenes:server:newScene', function(source, text, coords, color, distance)
    local identifier = GetIdentifier(source, 'license')
    
    
    if not identifier then
        return false
    end

    if IsBanned(identifier) then
        return false
    end

    local scene = {
        text = text,
        coords = coords,
        color = color,
        distance = distance,
        owner = source
    }

    scenes[#scenes + 1] = scene

    TriggerClientEvent('mtc-scenes:client:refreshScenes', -1, scenes)

    -- Add your logging here
    return true
end)

RegisterNetEvent('mtc-scenes:server:LoadScenes', function()

    local reqScenes = GetSavedScenes()

    for k , v in pairs(reqScenes) do
        scenes[#scenes+1] = v
        TriggerClientEvent('mtc-scenes:client:refreshScenes', -1, v)
    end
end)

AddEventHandler('onResourceStop', function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    SaveScenes(scenes)
end)

AddEventHandler('onResourceStart', function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    TriggerEvent('mtc-scenes:server:LoadScenes')
end)