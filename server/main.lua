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

QBCore.Commands.Add('sceneban', Lang:t('commands.ban_description'), {name="player", description=Lang:t('commands.player_id') }, false, function(source, args)
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
end, 'admin')


lib.callback.register('qb-scenes:server:getScenes', function(source)
    return scenes
end)

lib.callback.register('qb-scenes:server:destoryScene', function(source, id)
    local identifier = GetIdentifier(source, 'license')
    
    
    if not identifier then
        return false
    end

    if IsBanned(identifier) then
        return false
    end

    local scene = scenes[id]
    TriggerEvent('qb-log:server:CreateLog', 'scenes', 'Removed scene', 'red', '**' .. GetPlayerName(source) .. '** (' .. source .. ') removed the scene with text: **' .. scene.text .. '**' .. " which was created by **" .. GetPlayerName(scene.owner) .. "**")
    scenes[id] = nil
    TriggerClientEvent('qb-scenes:client:refreshScenes', -1, scenes)
    return true
end)

lib.callback.register('qb-scenes:server:newScene', function(source, text, coords, color, distance)
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

    TriggerClientEvent('qb-scenes:client:refreshScenes', -1, scenes)

    TriggerEvent('qb-log:server:CreateLog', 'scenes', 'New Scene', 'green', '**' .. GetPlayerName(source) .. '** (' .. source .. ') created a new scene with the text: **' .. text .. '**')
    return true
end)

RegisterNetEvent('mtc-scenes:server:LoadScenes', function()

    local reqScenes = GetSavedScenes()

    for k , v in pairs(reqScenes) do
        scenes[#scenes+1] = v
        TriggerClientEvent('qb-scenes:client:refreshScenes', -1, v)
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