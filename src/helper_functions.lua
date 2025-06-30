destroy_random_joker = function(seed)
    if not seed then
        seed = 'Destroy_joker'
    end

    local deletable_jokers = {}
    for _, joker in pairs(G.jokers.cards) do
        if not joker.ability.eternal then deletable_jokers[#deletable_jokers + 1] = joker end
    end

    local chosen_joker = pseudorandom_element(deletable_jokers, seed)
    if chosen_joker then
        chosen_joker:start_dissolve()
    end
end