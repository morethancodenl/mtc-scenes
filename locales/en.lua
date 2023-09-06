local Translations = {
    notify = {
        scene_visibility = "Scenes are now ",
        scene_visibility_visible = "visible",
        scene_visibility_hidden = "hidden",
        not_placed = "Scene could not be placed.",
        failed = "Failed to create scene",
        failed_destory = "Failed to destory scene",
        succes_destroy = "Scene destroyed",
        scene_nearby = "No scene nearby",
    },

    textUI = {
        select = "Select position",
    },

    chatMessages = {
        banned = "Player is banned from using scenes"
    },

    commands = {
        ban_description = "Ban a player from using scenes",
        player_id = "Player ID",
    },

    createScene = {
        new_scene = "Create new scene",
        input_label = "Text",
        input_description = "The text of the scene",
        color_label = "Color",
        color_description = "The color of the scene",
        slider_label = "Distance",
        slider_description = "The distance you can see the scene",
    },

    optionsScene = {
        toggle = "Toggle scenes",
        create = "Create scene",
        destroy = "Destroy scene",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
