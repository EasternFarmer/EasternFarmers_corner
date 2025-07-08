SMODS.Joker{
    --[[
    "Everytime Wheel of Fortune misses, it randomly upgrades one of the hands"
    ]]
    key = "spacewheel", -- Idea Credit: alperen_pro @ discord
    loc_txt = {
        name = 'Wheel of Space',
        text = {
            'Everytime {C:tarot}Wheel of Fortune{}',
            'misses, it upgrades the most',
            'played  {C:gold}Poker Hands{}',
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "c_wheel_of_fortune", set="Tarot"}
        return {}
    end,
    config = { extra = {} },
    atlas = "Jokers",
    pos = {x = 4, y = 0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    demicoloncompat = true, immutable = true, --cryptid
    rarity = 3,
    cost = 8,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: alperen_pro', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,
    calculate = function(self, card, context)
        if (context.wheel_of_fortune_fail or context.forcetrigger) and not context.blueprint then -- wheel.toml
                local hand_chosen = EF.get_most_played_hands()[1].key
                SMODS.calculate_effect({message = "Level up!"}, card)
                SMODS.smart_level_up_hand(nil, hand_chosen, false)
                return
        end
    end
}

SMODS.Joker{
    --[[
    oh i got an idea if ur interested, joker that re-triggers plant jokers x times, 
    increased by 1 everytime u beat the plant or water boss blind and uh called good harvest? --._.fr
    ]]
    key = "goodharvest", -- Idea Credit: alperen_pro @ discord
    loc_txt = {
        name = 'Good Harvest',
        text = {
            'Retriggers {C:ef_plant}Plant{} jokers #1# times',
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers}}
    end,
    joker_display_def =function (JokerDisplay)
        return {
            retrigger_joker_function = function (card, retrigger_joker)
                if card ~= retrigger_joker and card.config.center.rarity == "EF_plant" then
                    return retrigger_joker.ability.extra.retriggers
                end
            end
        }
    end,
    config = { extra = {retriggers = 1} },
    atlas = "Jokers",
    pos = {x = 8, y = 0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    rarity = 3,
    cost = 8,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: ._.fr', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,
    calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and not context.blueprint then
            if context.other_card.config.center.rarity == "EF_plant" then
                return {repetitions = card.ability.extra.retriggers}
            end
        end
	end,
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
    ---@param JokerDisplay JokerDisplay
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                }
            },
            calc_function = function(card)
                local num = EF.get_time_table().min
                if num % 2 == 1 then -- odd
                    card.joker_display_values.x_mult = card.ability.extra.bad_xmult
                else -- even
                    card.joker_display_values.x_mult = card.ability.extra.good_xmult
                end
            end
        }
    end,
    config = { extra = {good_xmult = 8, bad_xmult = 2} },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 3, -- dunno if change needed
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