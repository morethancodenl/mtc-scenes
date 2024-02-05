local points = {} -- The ox_lib point listeners, usefull for destorying them on change
local scenes = {} -- The scenes that are loaded
local ShowScenes = true -- Whether to show the scenes or not. Can be toggled by the user

-- ETC functions
local function ToRGB(hex)
    hex = hex:gsub("#","")
    return {
        r = tonumber("0x"..hex:sub(1,2)),
        g = tonumber("0x"..hex:sub(3,4)),
        b = tonumber("0x"..hex:sub(5,6)),
    }
end

local function CoordPicker()
    local coords = GetEntityCoords(cache.ped)
    local enabled = true
    local prom = promise.new()

    lib.showTextUI(Lang:t('textUI.select'), {
        position = "left-center",
        icon = "e"
    })


    CreateThread(function()
        while enabled do
            Wait(50)
            local _, _, RayCoords = lib.raycast.cam()
            if RayCoords then
                coords = RayCoords
            end
        end
    end)


    CreateThread(function()
        local offset = 0.2
        while enabled do 
            Wait(0)
            DrawBox(coords.x - offset, coords.y - offset, coords.z - offset, coords.x + offset, coords.y + offset, coords.z + offset, 151, 117, 250, 100)
        end
    end)

    CreateThread(function()
        while enabled do
            Wait(50)
            if IsControlPressed(0, 38) then -- E
                enabled = false
                prom:resolve(coords)
                lib.hideTextUI()
            end
        end
    end)

    return Citizen.Await(prom)
end

-- Events for showing the scenes

--- Draw text on screen
---@param text string the text to draw
---@param coords table the coords to draw the text at (x, y, z)
---@param color table the color of the text (r, g, b, a)
local function DrawText3D(text, coords, color)
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(color.r, color.g, color.b, 255)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 180
    if string.len(text) > 100 then
        factor = (string.len(text)) / 300
    end
    DrawRect(0.0, 0.0 + 0.0150, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--- Setup the scene listener
---@param scenes table the scenes to setup
local function SetupScenes(scenes)
    -- Cleanup current listeners
    for _, point in ipairs(points) do
        point:remove()
    end

    -- Setup new listeners
    for _, scene in ipairs(scenes) do
        local point = lib.points.new({
            coords = scene.coords,
            distance = scene.distance or 3,
        })

        function point:nearby()
            if not ShowScenes then return end
            DrawText3D(scene.text, scene.coords, scene.color)
        end

        points[#points + 1] = point
    end
end


-- Menu options
local function toggleScenes()
    ShowScenes = not ShowScenes
    QBCore.Functions.Notify(Lang:t('notify.scene_visibility') .. (ShowScenes and Lang:t('notify.scene_visibility_visible') or Lang:t('notify.scene_visibility_hidden')), "success")
end

local function createScene()
    local input = lib.inputDialog(Lang:t('createScene.new_scene'), {
        {
            type = "input",
            label = Lang:t('createScene.input_label'),
            description = Lang:t('createScene.input_description'),
            required = true,
        },
        {
            type = "color",
            label = Lang:t('createScene.color_label'),
            description = Lang:t('createScene.color_label'),
            required = true,
            default = "#ffffff"
        },
        {
            type = "slider",
            label = Lang:t('createScene.slider_label'),
            description = Lang:t('createScene.slider_label'),
            required = true,
            default = 7.5,
            min = 1.0,
            max = 15,
        }
    })

    if not input or not input[1] or not input[2] or not input[3] then return end
    local text = input[1]
    local color = ToRGB(input[2])
    local distance = input[3]
    local coords = CoordPicker()

    if not coords then
        QBCore.Functions.Notify(Lang:t('notify.not_placed'), "error")
        return
    end

    local success = lib.callback.await('qb-scenes:server:newScene', nil, text, coords, color, distance)
    if not success then
        QBCore.Functions.Notify(Lang:t('notify.failed'), "error")
    end
end

local function DestoryClosestScene()
    for i, v in ipairs(scenes) do
        local dist = #(v.coords - GetEntityCoords(cache.ped))
        if dist < 3 then
            local success  = lib.callback.await('qb-scenes:server:destoryScene', nil, i)
            if not success then
                QBCore.Functions.Notify(Lang:t('notify.failed_destroy'), "error")
                return
            end
            QBCore.Functions.Notify(Lang:t('notify.succes_destroy'), "success")
            return
        end
    end

    QBCore.Functions.Notify(Lang:t('notify.scene_nearby'), "error")
end


RegisterCommand('scene', function()
    lib.showContext('scenes')
end)

-- The event for adding a new scene, triggered when a new scene is added on the server
RegisterNetEvent('qb-scenes:client:refreshScenes', function(EVscenes)
    scenes = EVscenes
    SetupScenes(scenes) 
end)

-- The thread for loading scenes from the server. This is done in a thread to prevent the client from freezing
CreateThread(function()
    lib.registerContext({
        id = 'scenes',
        title = 'Scenes',
        options = {
            {
                title = Lang:t('optionsScene.toggle'),
                onSelect = toggleScenes,
            },
            {
                title = Lang:t('optionsScene.create'),
                onSelect = createScene,
            },
            {
                title = Lang:t('optionsScene.destroy'),
                onSelect = DestoryClosestScene,
            }
        }
    })
    scenes = lib.callback.await('qb-scenes:server:getScenes')
    SetupScenes(scenes)
end)