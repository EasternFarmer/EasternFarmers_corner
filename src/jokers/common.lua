SMODS.Joker{
    --[[
    seed
    1 in 6 chance of getting destroyed at the end of the round
    when destroyed, the shop will guarrantee a plant booster pack
    ]]
    key = "seed", -- Idea Credit: plantform @ discord
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
        local nominator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "EF_seed")
        return {vars = {nominator, denominator}}
    end,
    joker_display_def = function (JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "nominator" },
                { text = " in " },
                { ref_table = "card.joker_display_values", ref_value = "denominator" },
                { text = ")" },
            },
            text_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local nominator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "EF_seed")
                card.joker_display_values.nominator = nominator
                card.joker_display_values.denominator = denominator
            end
        }
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
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.forcetrigger or (context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint) then
            if SMODS.pseudorandom_probability(card, "EF_seed", 1, card.ability.extra.odds, "EF_seed") or
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

SMODS.Joker {
    key = "xin4",
    loc_txt = {
        name = 'x in 4',
        text = {
            'Each time a {C:gold}x{} {C:green}in 4{}',
            'fails gain {C:money}4${} times {C:gold}x{}',
            '{s:0.8,C:inactive}(if {s:0.8,C:green}2 in 4{s:0.8,C:inactive} fails gain {s:0.8,C:money}8${s:0.8,C:inactive}){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    config = { extra = {} },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    calculate = function(self, card, context)
        if context.pseudorandom_result and not context.result then
            if context.denominator == 4 then
                local dollars = context.numerator * 4
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + dollars
                return {
                    dollars = dollars,
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
    end,
}

SMODS.Joker {
    key = "highfive",
    loc_txt = {
        name = 'High Five',
        text = {
            '{C:chips}+#1#{} Chips',
            'if hand is a {C:gold}high card{}',
            'and contains {C:gold}5 cards'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.chips} }
    end,
    config = { extra = {chips = 75} },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    atlas = "missing_joker",
    -- pos = {x=5,y=1},
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == "High Card" and #context.full_hand == 5 then
                return {
                    chips = card.ability.extra.chips
                }
           end
        end
    end,
}
