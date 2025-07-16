SMODS.Rarity {
    key = "plant",
    loc_txt = { name = "Plant" },
    badge_colour = G.C.EF.PLANT,
    pools = {
        ["Joker"] = true,
    },
    get_weight = function (self, weight, object_type)
        if G.GAME.used_vouchers.v_EF_shovel then
            return 0.45
        else
            return 0
        end
    end
}