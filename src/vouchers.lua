SMODS.Voucher {
    key = 'uv_lamp',
    atlas = "missing_joker",
    config = { extra = {} },
    discovered = true,
    loc_txt = {
        name = "UV Lamp",
        text = {
            "Makes {C:gold}All{} {C:blue}time{} based jokers",
            "ignore the current {C:blue}time{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.EF_UV_lamp = true
                return true
            end
        }))
    end
}
