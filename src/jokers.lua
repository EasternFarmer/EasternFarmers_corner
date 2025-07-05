SMODS.Joker{
    name = "Pocket Plant",
    key = "pocketplant",
    config = { extra = { discards = 3, hands = 1 } },
    loc_txt = {
        name = 'Pocket Plant',
        text = {
            'When {C:attention}Blind{} is',
            'selected, gain',
            '{C:attention}+#1#{} Discards and',
            '{C:attention}set Hands to 1{}'
        }
    },

    atlas = 'Jokers',
    pos = {x = 0, y = 0},
    
    cost = 6,
    rarity = "EF_plant",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.discards}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind or context.forcetrigger then
            G.GAME.current_round.hands_left = card.ability.extra.hands
            return {
                message = "+"..tostring(card.ability.extra.discards).." Discards",
                func = function()
                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + card.ability.extra.discards
                    return true
                end,
            }
        end
    end
}
SMODS.Joker{
    --[[
    ghost pepper
    3.0xmult
    decreases by 0.1xmult for each joker (including this) you have at the end of the round
    ]]
    name = "Ghost pepper", -- Idea Credit: plantform @ discord
    key = "ghostpepper",
    config = { extra = { xmult = 3.0, lose_rate = 0.1} },
    loc_txt = {
        name = 'Ghost pepper',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            'Decreases by {X:mult,C:white}X0.1{} Mult',
            'for each joker (including this)',
            'you have at the end of the round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.lose_rate}}
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    demicoloncompat = true,
    cost = 6,
    rarity = "EF_plant",
    atlas = "missing_joker",

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local lost_amount = (card.ability.extra.lose_rate * #G.jokers.cards)
            card.ability.extra.xmult = card.ability.extra.xmult - lost_amount
            if card.ability.extra.xmult <= 0 then
                SMODS.calculate_effect({message = "Burnt"}, card)
                card:start_dissolve()
            end
            if card.ability.extra.xmult > 0 then
                SMODS.calculate_effect({ message = "-"..tostring(lost_amount).."X", color = G.C.MULT }, card)
            end
        end
    end
}
SMODS.Joker{
    --[[
        plantform
        uncommon
        1.5x
        all face cards are debuffed
        ]]
    name = "plantform", -- Idea Credit: plantform @ discord
    key = "plantform",
    config = { extra = { xmult = 2 } },
    loc_txt = {
        name = 'Plantform',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            'All face cards are debuffed'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    unlocked = true,
    atlas = "Jokers",
    pos = { x = 2, y = 0},
    discovered = true,
    rarity = "EF_plant",
    eternal_compat = true,
    blueprint_compat = true,
    demicoloncompat = true,
    update = function(self, card, dt)
		if G.deck and card.added_to_deck then
			for i, v in pairs(G.deck.cards) do
				if v:is_face() then
					v:set_debuff(true)
				end
			end
		end
		if G.hand and card.added_to_deck then
			for i, v in pairs(G.hand.cards) do
				if v:is_face() then
					v:set_debuff(true)
				end
			end
		end
	end,
	calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
    		return {
                xmult = card.ability.extra.xmult
            }
        end
	end,
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea & Art Credit: plantform', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,
}

SMODS.Joker{
    --[[
        dandelion
        gains 0.5xmult every time this joker has been sold this game
        (currently 1.0xmult)
        ]]
    name = "Dandelion", -- Idea Credit: plantform @ discord
    key = "dandelion",
    loc_txt = {
        name = 'Dandelion',
        text = {
            'Gains {X:mult,C:white}X0.5{} Mult every time',
            'this joker has been sold this game',
            '{C:inactive}(currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.EF_dandelion_xmult or 1.0}}
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    demicoloncompat = true,
    rarity = "EF_plant",
    atlas = "Jokers",
    pos = {x = 7, y = 0},

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    add_to_deck = function (self, card, from_debuff)
        G.GAME.EF_dandelion_xmult = G.GAME.EF_dandelion_xmult or 1.0
    end,

    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            G.GAME.EF_dandelion_xmult = G.GAME.EF_dandelion_xmult or 1.0
            G.GAME.EF_dandelion_xmult = G.GAME.EF_dandelion_xmult + 0.5
            SMODS.calculate_effect({message = G.GAME.EF_dandelion_xmult.."X", color = G.C.MULT}, card)
        end
        if context.joker_main or context.forcetrigger then
            G.GAME.EF_dandelion_xmult = G.GAME.EF_dandelion_xmult or 1.0
            return {
                xmult = G.GAME.EF_dandelion_xmult
            }
        end
    end
}
SMODS.Joker{
    --[[
        grass
        gains +2 chips per hand played
        (currently +0 chips)
    ]]
    name = "Grass", -- Idea Credit: plantform @ discord
    key = "grass",
    loc_txt = {
        name = 'Grass',
        text = {
            'Gains {C:chips}+2{} Chips{} per hand played',
            '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.current_chips}}
    end,
    config = { extra = { current_chips = 2 } },
    atlas = "Jokers",
    pos = { x = 3, y = 0 },
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    blueprint_compat = true,
    demicoloncompat = true,
    rarity = "EF_plant",

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea & Art Credit: plantform', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = "after", 
                delay = 0.1, 
                func = function()
                    card.ability.extra.current_chips = card.ability.extra.current_chips + 2
                    SMODS.calculate_effect({ message = "+2 Chips", color = G.C.CHIPS}, card)
                    return true
                end
            }))
        end

        if context.joker_main  or context.forcetrigger then
            return {
                chips = card.ability.extra.current_chips
            }
        end

    end
}
SMODS.Joker{
    --[[
    Sunflower
    Gain $1 per hand played
    ]]
    name = "Sunflower", -- Idea Credit: thenumberpie @ discord
    key = "sunflower",
    loc_txt = {
        name = 'Sunflower',
        text = {
            'Gain {C:money}$#1#{} per hand played'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars}}
    end,
    config = { extra = { dollars = 2 } },
    atlas = "Jokers",
    pos = { x = 1, y = 0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    demicoloncompat = true,
    rarity = "EF_plant",

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: thenumberpie', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if (context.joker_main or context.forcetrigger) and not context.blueprint then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, it runs after the dollar manipulation
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end
}

SMODS.Joker{
    name = "Rootabaga", -- Idea Credit: wimpyzombie22 @ discord
    key = "rootabaga",
    loc_txt = {
        name = 'Rootabaga',
        text = {
            'Takes the square root of',
            'your hands {C:chips}Chips{},',
            'and adds that number',
            'to your {C:mult}Mult{}'
        }
    },
    unlocked = true,
    discovered = true,
    atlas = "Jokers",
    pos = {x = 6, y = 0},
    blueprint_compat = true,
    eternal_compat = true,
    demicoloncompat = true,
    rarity = "EF_plant",

    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Idea Credit: wimpyzombie22', G.C.RARITY.Common, G.C.BLACK, 0.8 )
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            local chips = hand_chips or 0
            return {
                mult = math.sqrt(lenient_bignum(chips))
            }
        end

    end
}
SMODS.Joker{
    --[[
    seed
    1 in 6 chance of getting destroyed at the end of the round
    when destroyed, the shop will guarrantee a plant booster pack
    ]]
    name = "Seed", -- Idea Credit: plantform @ discord
    key = "seed",
    loc_txt = {
        name = 'Seed',
        text = {
            '{C:green}#1# in #2#{} chance of getting',
            'destroyed at the end of the round',
            'when destroyed, creates a {C:spectral,T:t_EF_small_plant_pack_tag}Garden tag{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_EF_small_plant_pack_tag', set = 'Tag' }
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,
    config = { extra = {odds = 6} },
    atlas = "Jokers",
    pos = {x=5,y=0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    demicoloncompat = true,
    rarity = 1,
    cost = 4,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.forcetrigger or (context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint) then
            if SMODS.pseudorandom_probability(card, "EF_seed", 1, 6) or
                context.forcetrigger or card.ability.cry_rigged -- cryptid compat
            then
                card:start_dissolve()
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_EF_small_plant_pack_tag'))
                        return true
                    end)
                }))
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker{
    --[[
        Venus fly trap:
        food jokers last thrice as long
    ]]
    name = "Venus fly trap", -- Idea Credit: relatal @ discord
    key = "flytrap",
    loc_txt = {
        name = 'Venus fly trap',
        text = {
            'Make food jokers last {C:gold}#1#{} times',
            'as long when sold',
            '(Divide by #1# the odds of',
            'food jokers breaking.)',
            '{C:green,s:0.8}1 in 6{}{s:0.8} -> {C:green,s:0.8}1 in #2#{}',
            '(Multiply by #1# the rounds lasting.)',
            '{C:green,s:0.8}reduces by 1 each round{}{s:0.8} -> {C:green,s:0.8}reduces by #3# each round{}'
        }
    },
    loc_vars = function(seld, info_queue, card)
        return { vars = { card.ability.extra.Xvar, 6*card.ability.extra.Xvar, 1/card.ability.extra.Xvar} }
    end,
    config = { extra = {Xvar = 3} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    demicoloncompat = true,
    rarity = 'EF_plant',
    atlas = "missing_joker",

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: relatal', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if (context.selling_self or context.forcetrigger) and not context.blueprint then
            for i, joker in ipairs(G.jokers.cards) do
                if joker.ability.name == 'Popcorn' then
                    joker.ability.extra = joker.ability.extra / card.ability.extra.Xvar
                elseif joker.ability.name == 'Ramen' then
                    joker.ability.extra = joker.ability.extra / card.ability.extra.Xvar
                elseif joker.ability.name == 'Seltzer' then
                    joker.ability.extra = joker.ability.extra * card.ability.extra.Xvar
                elseif joker.ability.name == 'Turtle Bean' then
                    joker.ability.extra.h_mod = joker.ability.extra.h_mod / card.ability.extra.Xvar
                elseif joker.ability.name == 'Cavendish' then
                    joker.ability.extra.odds = joker.ability.extra.odds * card.ability.extra.Xvar
                elseif joker.ability.name == 'Ice Cream' then
                    joker.ability.extra.chip_mod = joker.ability.extra.chip_mod / card.ability.extra.Xvar
                elseif joker.ability.name == 'Gros Michel' then
                    joker.ability.extra.odds = joker.ability.extra.odds * card.ability.extra.Xvar
                elseif joker.ability.name == 'Ghost pepper' then
                    joker.ability.extra.lose_rate = joker.ability.extra.lose_rate / 2
                end
            end
        end
    end
}
SMODS.Joker{
    --[[
    grapevine
    +40 mult
    create a negative copy of this joker at the end of the round
    -1 hand size
    ]]
    name = "Grapevine", -- Idea Credit: plantform @ discord
    key = "grapevine",
    loc_txt = {
        name = 'Grapevine',
        text = {
            '{C:mult}+#1#{} Mult',
            'Gains {C:mult}+#2#{} Mult at the end of the round',
            '{C:red}#3#{} hand size',
            'Create one negative copy of this',
            'joker per round at the end of the round',
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.plus_mult, card.ability.immutable.hand_size} }
    end,
    config = { extra = {mult = 4, plus_mult = 2}, immutable = {hand_size = -1} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    demicoloncompat = true,
    rarity = "EF_plant",
    cost = 0,
    atlas = "missing_joker",
    set_badges = function(self, card, badges)
         badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.RARITY.Common, G.C.BLACK, 0.8 )
     end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.immutable.hand_size)
        G.GAME.EF_grapevine_max_copy = 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.immutable.hand_size)
    end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.main_eval and context.game_over == false and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.plus_mult
            SMODS.calculate_effect({message = '+2 Mult', color = G.C.MULT}, card)
        end
        if context.end_of_round and context.game_over == false and not context.blueprint then
            G.GAME.EF_grapevine_curr_copy = G.GAME.EF_grapevine_curr_copy or 0

            if G.GAME.EF_grapevine_curr_copy < G.GAME.EF_grapevine_max_copy then

                G.GAME.EF_grapevine_curr_copy = G.GAME.EF_grapevine_curr_copy + 1
                if #G.jokers.cards <= G.jokers.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after", 
                        delay = 0.2, 
                        func = (function()
                            local card_ = SMODS.create_card{ set = "Joker", area = G.jokers, key = "j_EF_grapevine"}
                            card_:set_edition('e_negative', true)
                            card_:add_to_deck()
                            G.jokers:emplace(card_)
                            return true
                        end)
                    }))
                    
                    return { message = "growth"}
                else
                    return { message = "no room"}
                end
            end
        end
        if context.ending_shop then
            G.GAME.EF_grapevine_curr_copy = 0
        end
    end
}
SMODS.Joker{
    --[[
    Rework to my d100 idea. Rolls the d100, below 50 it subtracts that from mult,
    above 50 adds it to mult, but if you hit 50 exactly it does times 50 to mult instead
    ]]
    name = "Gamblers dream", -- Idea Credit: wimpyzombie22 @ discord
    key = "gamblersdream",
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
SMODS.Joker{
    --[[
    give chips based on how many times youve played the hand for
    ]]
    name = "Spreading Vines", -- Idea Credit: wizard_man98082 @ discord
    key = "spreadingvines",
    loc_txt = {
        name = 'Spreading Vines',
        text = {
            'For every time the {C:gold}Poker hand{} was played',
            'gives {C:chips}+#1#{} Chips the next time that',
            '{C:gold}Poker hand{} has been played',
            '{s:0.8,C:inactive}(eg. If you played highcard {C:gold,s:0.8}10{C:inactive,s:0.8} times{}',
            '{C:inactive,s:0.8}this joker will give {C:chips,s:0.8}+#2#{C:inactive,s:0.8} Chips){}',

        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chips*10 } }
    end,
    config = { extra = { chips = 5 } },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    demicoloncompat = true,
    rarity = "EF_plant",
    atlas = "missing_joker",

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: wizard_man98082', G.C.RARITY.Common, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                chips = G.GAME.hands[context.scoring_name].played * card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker{
    --[[
    "Everytime Wheel of Fortune misses, it randomly upgrades one of the hands"
    ]]
    name = "Wheel of Space", -- Idea Credit: alperen_pro @ discord
    key = "spacewheel",
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
    name = "Good Harvest", -- Idea Credit: alperen_pro @ discord
    key = "goodharvest",
    loc_txt = {
        name = 'Good Harvest',
        text = {
            'Retriggers {C:ef_plant}Plant{} jokers #1# times',
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers}}
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
    name = "Fertilizer",
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
    name = "Photosynthesis",
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
            if EF.photosynthesis_hour_check(card) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end 
        end
    end,
}