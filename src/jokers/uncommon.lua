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
    cost = 6,
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
 		badges[#badges+1] = create_badge('Idea Credit: wimpyzombie22', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
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
    joker_display_def = function (JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
                { text = "x" },
                { text = "Plant", colour = G.C.EF.PLANT },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                if G.jokers then
                    for _, joker_card in ipairs(G.jokers.cards) do
                        if joker_card.config.center.rarity and joker_card.config.center.rarity == "EF_plant" then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.count = count
            end,
            mod_function = function(card, mod_joker)
                return {
                    mult = (card.config.center.rarity == "EF_plant" and mod_joker.ability.extra.mult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil),
                    chips = (card.config.center.rarity == "EF_plant" and mod_joker.ability.extra.chips * JokerDisplay.calculate_joker_triggers(mod_joker) or nil),
                }
            end
        }
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
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
        return {vars = {EF.FUNCS.normal_hour_to_am_pm(card.ability.immutable.min_hour), EF.FUNCS.normal_hour_to_am_pm(card.ability.immutable.max_hour), card.ability.extra.xmult}}
    end,
    joker_display_def = function (JokerDisplay)
        return {
            text = {
                {ref_table = "card.joker_display_values", ref_value = "effective", colour = G.C.GOLD},
                {text = " Plant", colour = G.C.EF.PLANT},
                {text = " jokers"}
            },
            calc_function = function(card)
                local count = 0
                if G.jokers then
                    for _, joker_card in ipairs(G.jokers.cards) do
                        if joker_card.config.center.rarity and joker_card.config.center.rarity == "EF_plant" then
                            count = count + 1
                        end
                    end
                end

                if count == 0 or EF.FUNCS.hour_check(card) then
                    card.joker_display_values.effective = count
                else
                    card.joker_display_values.effective = "Effective 0"
                end
            end,
            mod_function = function(card, mod_joker)
                return {
                    x_mult = (EF.FUNCS.hour_check(mod_joker) and card.config.center.rarity == "EF_plant" and mod_joker.ability.extra.xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil),
                }
            end
        }
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "Jokers",
    pos = {x=6,y=1},
    config = { extra = {xmult = 2}, immutable = { min_hour = 8, max_hour = 20} },
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == "EF_plant" then
            if EF.FUNCS.hour_check(card) then
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
            EF.FUNCS.normal_hour_to_am_pm(card.ability.immutable.min_hour),
            EF.FUNCS.normal_hour_to_am_pm(card.ability.immutable.max_hour),
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            }
        }
    end,
    joker_display_def = function (JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                },
                { text = "+$", colour = G.C.MONEY },
                {ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY},
            },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
            },
            calc_function = function(card)
                if EF.FUNCS.hour_check(card) then
                    card.joker_display_values.xmult = card.ability.extra.xmult
                    card.joker_display_values.dollars = card.ability.extra.dollars
                    card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
                else
                    card.joker_display_values.xmult = 1
                    card.joker_display_values.dollars = 0
                    card.joker_display_values.localized_text = ""
                end
            end
        }
    end,
    config = { extra = {xmult = 0.5, dollars = 10}, immutable = { min_hour = 9, max_hour = 17} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2, -- dunno if change needed
    cost = 6,
    atlas = "Jokers",
    pos = {x=0,y=1},
    calculate = function(self, card, context)
        if EF.FUNCS.hour_check(card) then
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if EF.FUNCS.hour_check(card) then
            return card.ability.extra.dollars
        end
    end
}

SMODS.Joker {
    key = "gardengnome",
    loc_txt = {
        name = 'Garden Gnome',
        text = {
            'Add {C:money}$#1#{} of {C:attention}sell value{}',
            'to every {C:ef_plant}Plant{} jokers',
            'at end of the round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.sell_value} }
    end,
    config = { extra = {sell_value = 2} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "Jokers",
    pos = {x=5,y=1},
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            for _, other_card in ipairs(G.jokers.cards) do
                if other_card.set_cost and other_card.config.center.rarity == "EF_plant" then
                    other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                        card.ability.extra.sell_value
                    other_card:set_cost()
                end
            end
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end,
    set_badges = function (self, card, badges)
        badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
        badges[#badges+1] = create_badge('Art Credit: diamondsapphire', G.C.EF.ART_CREDIT, G.C.BLACK, 0.8 )
    end
}

SMODS.Joker {
    key = "houserules",
    loc_txt = {
        name = 'House Rules',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            '{C:gold}first hand{} drawn face down'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    config = { extra = {xmult = 3} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    calculate = function(self, card, context)
        if context.stay_flipped and context.to_area == G.hand and
            G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
            return {
                stay_flipped = true
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    set_badges = function (self, card, badges)
        badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
    end
}

SMODS.Joker {
    key = "yin",
    loc_txt = {
        name = 'Yin (wip)',
        text = {
            '<effect not decided>',
            'Triggers either when',
            '{C:green}#1# in #2#{} succeeds',
            'or {C:gold}Yang{} fails'
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "EF_yin")
        return { vars = {numerator, denominator} }
    end,
    config = { extra = {odds = 2}, state = {activated = false} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    calculate = function(self, card, context)
        local function yin()
            print("yin")
            SMODS.calculate_effect({message = "hello"}, card)
        end
        if context.pseudorandom_result and context.result and context.identifier == "EF_yang" then
            card.ability.state.activated = true
        end
        if context.joker_main and not context.blueprint and card.ability.state.activated == false then
            if SMODS.pseudorandom_probability(card, "EF_yin", 1, card.ability.extra.odds, "EF_yin") then
                yin()
                card.ability.state.activated = true
            end
            return
        end
        if context.pseudorandom_result and not context.result and card.ability.state.activated == false then
            print(context.identifier)
            print("yinyin")
            if context.identifier == "EF_yang" then
                yin()
                card.ability.state.activated = true
            end
        end
        if context.post_joker then
            card.ability.state.activated = false
        end
    end
}

SMODS.Joker {
    key = "yang",
    loc_txt = {
        name = 'Yang (wip)',
        text = {
            '<effect not decided>',
            'Triggers either when',
            '{C:green}#1# in #2#{} succeeds',
            'or {C:gold}Yin{} fails'
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "EF_yang")
        return { vars = {numerator, denominator} }
    end,
    config = { extra = {odds = 2}, state = {activated = false} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    calculate = function(self, card, context)
        local function yang()
            print("yang")
            SMODS.calculate_effect({message = "hello"}, card)
        end
        if context.pseudorandom_result and context.result and context.identifier == "EF_yin" then
            card.ability.state.activated = true
        end
        if context.joker_main and not context.blueprint and card.ability.state.activated == false then
            if SMODS.pseudorandom_probability(card, "EF_yang", 1, card.ability.extra.odds, "EF_yang") then
                yang()
                card.ability.state.activated = true
            end
            return
        end
        if context.pseudorandom_result and not context.result and card.ability.state.activated == false then
            print(context.identifier)
            print("yangyang")
            if context.identifier == "EF_yin" then
                yang()
                card.ability.state.activated = true
            end
        end
        if context.post_joker then
            card.ability.state.activated = false
        end
    end
}

SMODS.Joker {
    key = "safe",
    loc_txt = {
        name = 'Safe',
        text = {
            'Once you play the correct {C:gold}Poker Hand{}',
            '{C:gold}#1#{} times in a row, the {E:1,C:gold}Safe{}',
            'opens and gives you {C:money}$#2#{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.correct_count, card.ability.extra.dollars} }
    end,
    config = { extra = {correct_count = 3, dollars = 100}, zzz = {hand_chosen = nil, current_streak = 0, flag = false}},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    add_to_deck = function (self, card, from_debuff)
        local viable_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible then
                table.insert(viable_hands, k)
            end
        end
        card.ability.zzz.hand_chosen = pseudorandom_element(viable_hands, "EF_safe")
        -- print(card.ability.zzz.hand_chosen)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == card.ability.zzz.hand_chosen then
                card.ability.zzz.current_streak = card.ability.zzz.current_streak + 1
            else
                card.ability.zzz.current_streak = 0
            end
            if card.ability.zzz.current_streak == 3 then
                card.ability.zzz.flag = true
            end
            if card.ability.zzz.flag then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.calculate_effect({message = "Congrats!!!", colour = G.C.MONEY}, card)
                                card:start_dissolve()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}

SMODS.Joker {
    key = "draw+2",
    loc_txt = {
        name = 'Draw +2',
        text = {
            '{C:gold}+#1#{} hand size',
            'Reduces hand size by {C:gold}1{} after every hand',
            'Resets after {C:gold}blind{} is defeated',
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.curr_hand_size_bonus} }
    end,
    config = { extra = {hand_size = 2, curr_hand_size_bonus = 2}},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    add_to_deck = function (self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    calculate = function(self, card, context)
        if context.after then
            card.ability.extra.curr_hand_size_bonus = card.ability.extra.curr_hand_size_bonus - 1
            G.hand:change_size(-1)
            SMODS.calculate_effect({message = "-1 hand size", colour = G.C.ORANGE}, card)
        end
        if context.end_of_round and context.game_over == false then
            local change = card.ability.extra.hand_size - card.ability.extra.curr_hand_size_bonus
            card.ability.extra.curr_hand_size_bonus = card.ability.extra.hand_size
            G.hand:change_size(change)
            SMODS.calculate_effect({message = "+"..change.." hand size", colour = G.C.ORANGE}, card)
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.curr_hand_size_bonus)
    end
}