---@diagnostic disable: undefined-global
local jd_def = JokerDisplay.Definitions

jd_def["j_EF_dandelion"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.xmult =  G.GAME.EF.dandelion_xmult
        end
}

jd_def["j_EF_ghostpepper"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.xmult = card.ability.extra.xmult
    end
}

jd_def["j_EF_plantform"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.xmult = card.ability.extra.xmult
    end
}

jd_def["j_EF_grass"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "current_chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        card.joker_display_values.current_chips = card.ability.extra.current_chips
    end
}

jd_def["j_EF_sunflower"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { text = "(Hands)" },
    },
    calc_function = function(card)
        card.joker_display_values.dollars = card.ability.extra.dollars
    end
}

jd_def["j_EF_rootabaga"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        -- local cards = {
        --     [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6,
        --     [7] = 7, [8] = 8, [9] = 9, [10] = 10,
        --     [11] = 10, [12] = 10, [13] = 10, [14] = 11
        -- }
        -- local chips = 0
        -- local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        -- if text ~= 'Unknown' then
        --     for _, scoring_card in pairs(scoring_hand) do
        --         if scoring_card:get_id() then
        --             chips = chips + (cards[scoring_card:get_id()] * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
        --         end
        --     end
        -- end
        local chips = hand_chips or 0
        local mult = math.sqrt(lenient_bignum(chips))
        card.joker_display_values.mult = mult
    end
}

jd_def["j_EF_seed"] = {
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "gameprob" },
        { text = " in " },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = ")" },
    },
    text_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.gameprob = tostring(G.GAME.probabilities.normal)
        card.joker_display_values.odds = tostring(card.ability.extra.odds)
    end
}

jd_def["j_EF_grapevine"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        card.joker_display_values.mult = card.ability.extra.mult
    end
}

jd_def["j_EF_spreadingvines"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local eval_ = (text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0
        if type(eval_) == "boolean" then
            card.joker_display_values.chips = eval_
        else
            card.joker_display_values.chips = eval_*card.ability.extra.chips
        end
    end
}

jd_def["j_EF_goodharvest"] = {
    retrigger_joker_function = function (card, retrigger_joker)
        if card ~= retrigger_joker and card.config.center.rarity == "EF_plant" then
            return retrigger_joker.ability.extra.retriggers
        end
    end
}