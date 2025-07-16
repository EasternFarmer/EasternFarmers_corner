SMODS.Voucher {
    key = 'shovel',
    atlas = "missing_joker",
    -- pos = {x = 0, y = 0},
    config = { extra = {} },
    discovered = true,
    loc_txt = {
        name = "Shovel",
        text = {
            "{C:ef_plant}Plant{} jokers may be purchased in the shop"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

SMODS.Voucher {
    key = 'rake',
    atlas = "missing_joker",
    -- pos = {x = 0, y = 0},
    config = { extra = {odds = 4} },
    discovered = true,
    loc_txt = {
        name = "Rake",
        text = {
            "{C:ef_plant}Plant{} jokers have a",
            "{C:green}#1# in #2#{} chance of being {C:dark_edition}negative{}"
        }
    },
    requires = {"v_EF_shovel", },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card,1,card.ability.extra.odds,"EF_rake_voucher")
        return { vars = {numerator, denominator} }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                EF.vars.v_rake_odds = card.ability.extra.odds
                return true
            end
        }))
    end
}

SMODS.Voucher {
    key = 'stopwatch',
    atlas = "Vouchers",
    pos = {x = 0, y = 0},
    config = { extra = {} },
    discovered = true,
    loc_txt = {
        name = "Stopwatch",
        text = {
            "Makes {C:gold}All{} {C:blue}time{} based jokers",
            "ignore the current {C:blue}time{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end
}
