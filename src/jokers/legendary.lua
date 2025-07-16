SMODS.Joker{
    --[[
    Sunflower
    Gain $1 per hand played
    ]]
    key = "negatron", -- Idea Credit: thenumberpie @ discord
    loc_txt = {
        name = 'Negatron',
        text = {
            '{C:gold}Retriggers{} all jokers {C:gold}#1#{} time',
            'After defeating the {C:gold}Boss Blind{}',
            'make {C:gold}1{} editionless joker negative'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retrigger}}
    end,
    config = { extra = { retrigger = 1} },
    atlas = "missing_joker",
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    rarity = 4,

    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card and not context.blueprint then
            return {repetitions = card.ability.extra.retrigger}
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if G.GAME.blind.boss then
                local viable_jokers = {}
                for _, v in pairs(G.jokers.cards) do
                    if v and not v.edition then
                        table.insert(viable_jokers, v)
                    end
                end
                if #viable_jokers > 0 then
                    local chosen_joker = pseudorandom_element(viable_jokers, "EF_negatron")
                    chosen_joker:set_edition("e_negative")
                end
            end
        end
    end
}