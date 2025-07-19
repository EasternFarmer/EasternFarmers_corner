SMODS.Rarity {
    key = "minesweeper_reward",
    loc_txt = { name = "Minesweeper" },
    badge_colour = G.C.EF.MINESWEEPER,
    default_weight = 0,
}

SMODS.Consumable {
    key = 'minesweeper_card_easy',
    set = 'minigame_card',
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
    set = 'minigame_card',
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
    set = 'minigame_card',
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

if true then -- just so i can hide these 15 jokers
    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_easy_1",
        loc_txt = {
            name = "Reward nr. 1 (easy)",
            text = {
                "{C:white,X:mult}X#2#{} Blind size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 1.5 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_easy_2",
        loc_txt = {
            name = "Reward nr. 2 (easy)",
            text = {
                "{C:white,X:mult}X#2#{} Blind Size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 1.25 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_easy_3",
        loc_txt = {
            name = "Reward nr. 3 (easy)",
            text = {
                "{C:white,X:mult}X#2#{} Mult for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xmult } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xmult = 2 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_easy_4",
        loc_txt = {
            name = "Reward nr. 4 (easy)",
            text = {
                "{C:white,X:mult}X#2#{} Blind size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 0.4 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_easy_5",
        loc_txt = {
            name = "Reward nr. 5 (easy)",
            text = {
                "{C:white,X:mult}X#2#{} Mult for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xmult } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xmult = 10 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }
    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_medium_1",
        loc_txt = {
            name = "Reward nr. 1 (medium)",
            text = {
                "{C:white,X:mult}X#2#{} Blind size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 3 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_medium_2",
        loc_txt = {
            name = "Reward nr. 2 (medium)",
            text = {
                "{C:white,X:mult}X#2#{} Blind Size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 2 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_medium_3",
        loc_txt = {
            name = "Reward nr. 3 (medium)",
            text = {
                "{C:white,X:mult}X#2#{} Mult for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xmult } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xmult = 4 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_medium_4",
        loc_txt = {
            name = "Reward nr. 4 (medium)",
            text = {
                "{C:white,X:mult}X#2#{} Blind size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 0.2 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_medium_5",
        loc_txt = {
            name = "Reward nr. 5 (medium)",
            text = {
                "{C:white,X:mult}X#2#{} Mult for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xmult } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xmult = 20 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }
    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_hard_1",
        loc_txt = {
            name = "Reward nr. 1 (hard)",
            text = {
                "{C:white,X:mult}X#2#{} Blind size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 6 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_hard_2",
        loc_txt = {
            name = "Reward nr. 2 (hard)",
            text = {
                "{C:white,X:mult}X#2#{} Blind Size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 4 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_hard_3",
        loc_txt = {
            name = "Reward nr. 3 (hard)",
            text = {
                "{C:white,X:mult}X#2#{} Mult for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xmult } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xmult = 8 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_hard_4",
        loc_txt = {
            name = "Reward nr. 4 (hard)",
            text = {
                "{C:white,X:mult}X#2#{} Blind size for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xblind } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xblind = 0.1 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
            end
        end
    }

    SMODS.Joker{
        rarity="EF_minesweeper_reward",
        blueprint_compat = false,
        key = "minesweeper_hard_5",
        loc_txt = {
            name = "Reward nr. 5 (hard)",
            text = {
                "{C:white,X:mult}X#2#{} Mult for {C:gold}#1#{} rounds",
            }
        },
        loc_vars = function (self, info_queue, card)
            return { vars = { card.ability.extra.rounds_left, card.ability.extra.xmult } }
        end,
        no_collection = true,
        eternal_compat = true,
        set_ability = function (self, card, initial, delay_sprites)
            card:set_eternal(true)
            card:set_edition("e_negative")
        end,
        config = { extra = { rounds_left = 3, xmult = 40 } },
        calculate = function (self, card, context)
            if context.blueprint then
                return
            end
            if context.end_of_round and not context.game_over and context.main_eval then
                card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
                if card.ability.extra.rounds_left == 0 then
                    card:start_dissolve()
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }
end