SMODS.Atlas({
    key = "JokerForge", 
    path = "JokerForge.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Joker{ --Joker Forge
    name = "Joker Forge",
    key = "jokerforge",
    config = {
        extra = {
            multvar = 1
        }
    },
    loc_txt = {
        ['name'] = 'Joker Forge',
        ['text'] = {
            [1] = '{C:mult}+#1#{} Mult',
            [2] = 'This joker was specifically',
            [3] = '{s:3.0,E:1}Made with {s:3.0,E:1,C:edition}J{}{s:3.0,E:1,C:dark_edition}o{}{s:3.0,E:1,C:red}k{}{s:3.0,E:1,C:blue}e{}{s:3.0,E:1,C:green}r{} {s:3.0,E:1,C:purple}F{}{s:3.0,E:1,C:attention}o{}{s:3.0,E:1,C:money}r{}{s:3.0,E:1,C:inactive}g{}{s:3.0,E:1,C:spectral}e{}',
            [4] = '{s:2.0,E:1}https://jokerforge.jaydchw.com{}',
            [5] = '{s:0.7,C:inactive}(credit to Jaydchw for the image which',
            [6] = '{s:0.7,C:inactive}was directly taken from the site){}'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 0,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'JokerForge',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.multvar}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
                return {
                    mult = card.ability.extra.multvar
                }
        end
    end
}