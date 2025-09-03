SMODS.Consumable {
    key = 'snake_card_easy',
    set = 'minigame_card',
    config = { extra = {} },
    loc_txt = {
        name = 'Snake (easy)',
        text = {
            'Starts a game of Snake',
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
                EF.FUNCS.UI.snake('easy')
                return true 
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Consumable {
    key = 'snake_card_hard',
    set = 'minigame_card',
    config = { extra = {} },
    loc_txt = {
        name = 'Snake (hard)',
        text = {
            'Starts a game of Snake',
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
                EF.FUNCS.UI.snake('hard')
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}