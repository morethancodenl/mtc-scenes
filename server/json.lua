local function ReadJson(file)
    local f = LoadResourceFile(GetCurrentResourceName(), 'storage/' .. file .. '.json')
    if not f then
        return nil
    end
    return json.decode(f)
end

local function WriteJson(file, data)
    SaveResourceFile(GetCurrentResourceName(), 'storage/' .. file .. '.json', json.encode(data, nil, 2), -1)
end

local function BanIdentifier(identifier)
    local data = ReadJson('bans')
    if not data then
        data = {}
    end

    data[identifier] = true

    WriteJson('bans', data)
end

local function IsBanned(identifier)
    local data = ReadJson('bans')
    if not data then
        return false
    end

    return data[identifier] or false
end

local function SaveScenes(scenes)
    WriteJson('save', scenes)
end

local function GetSavedScenes()
    local savedScenes = ReadJson('save')

    if not savedScenes then
        return {}
    end

    return savedScenes
end

return {
    BanIdentifier,
    IsBanned,
    SaveScenes,
    GetSavedScenes
}
