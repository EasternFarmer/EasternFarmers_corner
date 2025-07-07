SMODS.Joker{
    --[[
    Rework to my d100 idea. Rolls the d100, below 50 it subtracts that from mult,
    above 50 adds it to mult, but if you hit 50 exactly it does times 50 to mult instead
    ]]
    key = "gamblersdream", -- Idea Credit: wimpyzombie22 @ discord
    loc_txt = {
        name = 'Gamblers dream',
        text = {
            'Rolls the {C:gold}d100{},',
            'if the result is {C:gold}below 50{} it subtracts it from mult,',
            'if the result is {C:gold}above 50{} adds it to mult,',
            'if the result is {C:gold}exactly 50{} it applies {X:mult,C:white}X#1#{} to mult instead'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Xmult_for_hit_50} }
    end,
    config = { extra = {Xmult_for_hit_50 = 50, FPS = 6, delay = 0, x_pos = 0} },
    atlas = "LetsGoGambling",
    pos = {x=0, y=0},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    demicoloncompat = true,
    rarity = 2,
    cost = 4,
    update = function(self, card, dt)
        if card.ability.extra.delay == 60 / card.ability.extra.FPS then
            card.ability.extra.x_pos = (card.ability.extra.x_pos + 1) % 40
            card.children.center:set_sprite_pos({x=card.ability.extra.x_pos,y=0})
            card.ability.extra.delay = 0
        else
            card.ability.extra.delay = card.ability.extra.delay + 1
        end
    end,

    add_to_deck = function (self, card, dt)
        play_sound("EF_LetsGoGamblingSound", 1, 1)
    end,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: wimpyzombie22', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.forcetrigger or (context.joker_main and card.ability.cry_rigged) then -- cryptid compat
            return { xmult = card.ability.extra.Xmult_for_hit_50}
        elseif context.joker_main then
            local random_num = pseudorandom('GamblersDream', 1, 100)
            if 1 <= random_num and random_num < 50 then
                return {
                    mult = -random_num
                }
            elseif random_num == 50 then
                return {
                    xmult = card.ability.extra.Xmult_for_hit_50
                }
            elseif 50 < random_num and random_num <= 100 then
                return {
                    mult = random_num
                }
            else
                sendErrorMessage("result not in range 1 - 100 (somehow). random_num = "..random_num, "GamblersDream")
            end 
        end
    end
}

SMODS.Joker {
    key = "fertilizer",
    loc_txt = {
        name = 'Fertilizer',
        text = {
            '{C:ef_plant}Plant{} Jokers give',
            '{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult.',
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 4,
    atlas = "Jokers",
    pos = {x=9,y=0},
    config = { extra = { chips = 20, mult = 20 } },
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == "EF_plant" then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end,
}

SMODS.Joker {
    key = "photosynthesis",
    loc_txt = {
        name = 'Photosynthesis',
        text = {
            'If your computer time is',
            'between {C:gold}#1#{} and {C:gold}#2#{} {C:ef_plant}Plant{} jokers',
            'each give {X:mult,C:white}X#3#{} Mult'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {EF.normal_hour_to_am_pm(card.ability.immutable.min_hour), EF.normal_hour_to_am_pm(card.ability.immutable.max_hour), card.ability.extra.xmult}}
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 4,
    atlas = "missing_joker",
    --pos = {x=9,y=0},
    config = { extra = {xmult = 2}, immutable = { min_hour = 8, max_hour = 20} },
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == "EF_plant" then
            if EF.hour_check(card) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end 
        end
    end,
}

SMODS.Joker {
    key = "9-5",
    loc_txt = {
        name = '9-5',
        text = {
            'If your computer time is',
            'between {C:gold}#1#{} and {C:gold}#2#{} {X:mult,C:white}X#3#{} Mult',
            'and {C:money}#4#${} at the end of the round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            EF.normal_hour_to_am_pm(card.ability.immutable.min_hour),
            EF.normal_hour_to_am_pm(card.ability.immutable.max_hour),
            card.ability.extra.xmult,
            card.ability.extra.dollars,
        }
    }
    end,
    config = { extra = {xmult = 0.5, dollars = 10}, immutable = { min_hour = 9, max_hour = 17} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2, -- dunno if change needed
    cost = 4,
    atlas = "missing_joker",
    --pos = {x=9,y=0},
    calculate = function(self, card, context)
        if EF.hour_check(card) then
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if EF.hour_check(card) then
            return card.ability.extra.dollars
        end
    end
}

SMODS.Joker {
    key = "thatsodd",
    loc_txt = {
        name = 'That\'s odd',
        text = {
            '{X:mult,C:white}X#1#{} Mult on even minutes,',
            '{X:mult,C:white}X#2#{} Mult on odd minutes'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            card.ability.extra.good_xmult,
            card.ability.extra.bad_xmult,
        }
    }
    end,
    config = { extra = {good_xmult = 8, bad_xmult = 2} },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2, -- dunno if change needed
    cost = 4,
    atlas = "missing_joker",
    --pos = {x=9,y=0},
    calculate = function(self, card, context)
        if context.joker_main then
            local num = EF.get_time_table().min
            if num % 2 == 1 then -- odd
                return {
                    xmult = card.ability.extra.bad_xmult
                }
            else -- even
                return {
                    xmult = card.ability.extra.good_xmult
                }
            end
        end
    end,
}