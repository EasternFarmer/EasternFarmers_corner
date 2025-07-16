SMODS.ConsumableType {
    key = 'minesweeper_card',
    loc_txt = {
        name = 'Minesweeper Card',
        collection = 'Minesweeper Card'
    },
    collection_rows = { 3, 1 },
    primary_colour = G.C.EF.MINESWEEPER,
    secondary_colour = G.C.EF.MINESWEEPER,
}

SMODS.Rarity {
    key = "minesweeper_reward",
    loc_txt = { name = "Minesweeper" },
    badge_colour = G.C.EF.MINESWEEPER,
    default_weight = 0,
}

SMODS.Consumable {
    key = 'minesweeper_card_easy',
    set = 'minesweeper_card',
    config = { extra = {} },
    loc_txt = {
        name = 'Minesweeper Card (easy)',
        text = {
            'Starts a game of Minesweeper',
            'in {C:gold}easy{} difficulty'
        }
    },
    atlas = "missing_joker",
    -- pos = { x = 0, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function() 
                EF.FUNCS.UI.minesweeper("easy")
                return true 
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Consumable {
    key = 'minesweeper_card_medium',
    set = 'minesweeper_card',
    config = { extra = {} },
    loc_txt = {
        name = 'Minesweeper Card (medium)',
        text = {
            'Starts a game of Minesweeper',
            'in {C:gold}medium{} difficulty'
        }
    },
    atlas = "missing_joker",
    -- pos = { x = 0, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function() 
                EF.FUNCS.UI.minesweeper("medium")
                return true 
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Consumable {
    key = 'minesweeper_card_hard',
    set = 'minesweeper_card',
    config = { extra = {} },
    loc_txt = {
        name = 'Minesweeper Card (hard)',
        text = {
            'Starts a game of Minesweeper',
            'in {C:gold}hard{} difficulty'
        }
    },
    atlas = "missing_joker",
    -- pos = { x = 0, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function() 
                EF.FUNCS.UI.minesweeper("hard")
                return true 
            end
        }))
        
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_easy_1",
    loc_txt = {
        name = "Reward nr. 1 (easy)",
        text = {
            "{C:white,X:mult}X1.5{} Blind size for {C:gold}3{} rounds",
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_easy_2",
    loc_txt = {
        name = "Reward nr. 2 (easy)",
        text = {
            "{C:white,X:mult}X1.25{} Blind Size for {C:gold}3{} rounds",
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_easy_3",
    loc_txt = {
        name = "Reward nr. 3 (easy)",
        text = {
            "{C:white,X:mult}X2{} Mult for {C:gold}3{} rounds",
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_easy_4",
    loc_txt = {
        name = "Reward nr. 4 (easy)",
        text = {
            "{C:white,X:mult}X0.4{} Blind size for {C:gold}3{} rounds",
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_easy_5",
    loc_txt = {
        name = "Reward nr. 5 (easy)",
        text = {
            "{C:white,X:mult}X10{} Mult for {C:gold}3{} rounds",
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_medium_1",
    loc_txt = {
        name = "Reward nr. 1 (medium)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_medium_2",
    loc_txt = {
        name = "Reward nr. 2 (medium)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_medium_3",
    loc_txt = {
        name = "Reward nr. 3 (medium)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_medium_4",
    loc_txt = {
        name = "Reward nr. 4 (medium)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_medium_5",
    loc_txt = {
        name = "Reward nr. 5 (medium)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_hard_1",
    loc_txt = {
        name = "Reward nr. 1 (hard)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_hard_2",
    loc_txt = {
        name = "Reward nr. 2 (hard)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_hard_3",
    loc_txt = {
        name = "Reward nr. 3 (hard)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_hard_4",
    loc_txt = {
        name = "Reward nr. 4 (hard)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}
SMODS.Joker{ rarity="EF_minesweeper_reward", blueprint_compat = false,
    key = "minesweeper_hard_5",
    loc_txt = {
        name = "Reward nr. 5 (hard)",
        text = {
            ""
        }
    },
    no_collection = true,
    eternal_compat = true,
    set_ability = function (self, card, initial, delay_sprites)
        card:set_eternal(true)
        card:set_edition("e_negative")
    end,
    calculate = function (self, card, context)
        if context.blueprint then
            return
        end
    end
}