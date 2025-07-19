SMODS.Consumable {
    key = 'parlor_card',
    set = 'minigame_card',
    config = { extra = {} },
    loc_txt = {
        name = 'Parlor',
        text = {
            'Starts a game of Parlor',
            'from the game {C:gold}Blue Prince{}'
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
                EF.FUNCS.UI.parlor()
                return true 
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}