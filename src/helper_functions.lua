EF = {}

function EF.destroy_random_joker(seed)
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

function EF.get_most_played_hands()
  local hands = {}

  for _, v in ipairs(G.P_CENTER_POOLS.Planet) do
    if v.config and v.config.hand_type then
      local hand = G.GAME.hands[v.config.hand_type]

      if hand and hand.visible then
        hands[#hands + 1] = {
          key = v.config.hand_type,
          hand = hand,
          planet_key = v.key
        }
      end
    end
  end

  table.sort(hands, function(a, b)
    if a.hand.played ~= b.hand.played then
      return a.hand.played > b.hand.played
    end

    -- Sort by base values if the played amount is equal
    return (a.hand.s_mult * a.hand.s_chips) > (b.hand.s_mult * b.hand.s_chips)
  end)

  return hands
end