local function EF_table_init()
  return {
    vars = {
      jokers = { grapevine = {}, },
      minigames = { minesweeper = {}, parlor = {} }
    },
    FUNCS = { UIDEF = {}, UI = {}, minesweeper = {},},
  }
end
EF = EF_table_init()

function EF.FUNCS.destroy_random_joker(seed)
    if not seed then
        seed = 'Destroy_joker'
    end

    local deletable_jokers = {}
    for _, joker in pairs(G.jokers.cards) do
        if not SMODS.is_eternal(joker) then deletable_jokers[#deletable_jokers + 1] = joker end
    end

    local chosen_joker = pseudorandom_element(deletable_jokers, seed)
    if chosen_joker then
        chosen_joker:start_dissolve()
    end
end

function EF.FUNCS.get_most_played_hands()
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

---@param x number
---@return string
function EF.FUNCS.normal_hour_to_am_pm(x) -- maybe add a config option to toggle between 12h and 24h
  if x < 0 or x > 24 then
    return "ERR at EF.FUNCS.normal_hour_to_am_pm"
  elseif x == 0 or x == 24 then
    return "12 AM"
  elseif 1 <= x and x <= 11 then
    return x.." AM"
  elseif 12 <= x and x <= 23 then
    return (x-12).." PM"
  end
  return "wtf at EF.FUNCS.normal_hour_to_am_pm"
end

---@return osdate
function EF.FUNCS.get_time_table()
  ---@diagnostic disable-next-line: return-type-mismatch
  return os.date("*t", os.time())
end

---performs a time check using `immutable.min_hour` and `immutable.max_hour` from card's config
---@param card Card
---@return boolean
function EF.FUNCS.hour_check(card)
  G.GAME.used_vouchers.v_EF_stopwatch = G.GAME.used_vouchers.v_EF_stopwatch or false
  local time = EF.FUNCS.get_time_table()
  local hour = time.hour + time.min/60
  if (card.ability.immutable.min_hour <= hour and hour <= card.ability.immutable.max_hour) -- normal check
      or G.GAME.used_vouchers.v_EF_stopwatch -- voucher
      then
    return true
  end
  return false
end

---performs a year day check using `immutable.min_yday` and `immutable.max_yday` from card's config. the yday is in range 1-365
---@param card Card
---@return boolean
function EF.FUNCS.year_day_check(card)
  G.GAME.used_vouchers.v_EF_stopwatch = G.GAME.used_vouchers.v_EF_stopwatch or false
  local yday = EF.FUNCS.get_time_table().yday

  if (card.ability.immutable.min_yday <= yday and yday <= card.ability.immutable.max_yday) -- normal check
      or G.GAME.used_vouchers.v_EF_stopwatch -- voucher
      then
    return true
  end
  return false
end

---@param text string
---@return string[]
---splits every 3rd word `'a b c d e f'` -> `{'a b c', 'd e f'}`
function EF.FUNCS.split_text_3(text)
    local words = {}

    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end

    local result = {}
    for i = 1, #words, 3 do
        local line = table.concat({words[i], words[i+1], words[i+2]}, " ")
        table.insert(result, line)
    end

    return result
end