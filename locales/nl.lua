local Translations = {
    notify = {
        scene_visibility = "Scenes zijn nu ",
        scene_visibility_visible = "zichtbaar",
        scene_visibility_hidden = "onzichtbaar",
        not_placed = "Scene kan niet geplaats worden.",
        failed = "Het is niet gelukt om de scene te maken.",
        failed_destory = "Het is niet gelukt om de scene te verwijderen.",
        succes_destroy = "Scene verwijderd.",
        scene_nearby = "Geen scene in de buurt.",
    },

    textUI = {
        select = "Selecteer positie",
    },

    chatMessages = {
        banned = "Speler is verbannen van het gebruiken van scenes."
    },

    commands = {
        ban_description = "Ban een speler van het gebruiken van scenes",
        player_id = "Speler ID",
    },

    createScene = {
        new_scene = "Maak nieuwe scene",
        input_label = "Tekst",
        input_description = "De tekst van de scene",
        color_label = "Kleur",
        color_description = "De kleur van de scene",
        slider_label = "Afstand",
        slider_description = "De afstand waarop je de scene kan zien",
    },

    optionsScene = {
        toggle = "Toggle scenes",
        create = "Maak scene",
        destroy = "Verwijder scene",
    }
}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end