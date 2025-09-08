-- Card Areas
function EF.FUNCS.blackjack.remove_card_areas()
	if EF.CARDAREAS.blackjack_dealer then
		EF.CARDAREAS.blackjack_dealer:remove()
		EF.CARDAREAS.blackjack_dealer = nil
	end
	if EF.CARDAREAS.blackjack_player then
		EF.CARDAREAS.blackjack_player:remove()
		EF.CARDAREAS.blackjack_player = nil
	end
end

function EF.FUNCS.blackjack.init_card_areas()
	EF.FUNCS.blackjack.remove_card_areas()

	EF.CARDAREAS.blackjack_dealer = CardArea(0, 0, G.CARD_W * 4, G.CARD_H, {
		card_limit = 4,
		type = "title",
		highlight_limit = 0,
	})
	EF.CARDAREAS.blackjack_player = CardArea(0, 0, G.CARD_W * 4, G.CARD_H, {
		card_limit = 4,
		type = "title",
		highlight_limit = 0,
	})
end

-- Actual BlackJack Code

-------------
----local----
-------------

local function render_blackjack(bet)
	G.FUNCS.overlay_menu({
		definition = create_UIBox_generic_options({
			contents = {
				{
					n = G.UIT.O,
					config = {
						object = UIBox({ definition = EF.FUNCS.UIDEF.blackjack_game(bet), config = {} }),
					},
				},
			},
			no_back = true,
		}),
	})
end

local function render_blackjack_end(who)
	G.FUNCS.overlay_menu({
		definition = create_UIBox_generic_options({
			contents = {
				{
					n = G.UIT.O,
					config = {
						object = UIBox({ definition = EF.FUNCS.UIDEF.blackjack_end(who), config = {} }),
					},
				},
			},
			no_back = true,
		}),
	})
end

---@param hand Card[]
local function getTotal(hand, dealer)
	local total = 0
	local hasAce = false

	for _, card in ipairs(hand) do
		if dealer and card.facing == "back" then
			return "?"
		end
		if card.base.id == 14 then
			hasAce = true
			total = total + 1
		elseif card.base.id > 10 then
			total = total + 10
		else
			total = total + card.base.id
		end
	end

	if hasAce and total <= 11 then
		total = total + 10
	end

	return total
end

-------------
----UIDEF----
-------------
function EF.FUNCS.UIDEF.blackjack_pick()
	return create_UIBox_generic_options({
		contents = {
			{
				n = G.UIT.O,
				config = {
					object = UIBox({
						definition = {
							n = G.UIT.ROOT,
							config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK },
							nodes = {
								{
									n = G.UIT.C,
									config = {},
									nodes = {
										{
											n = G.UIT.C,
											config = {
												minw = 2,
												minh = 1,
												align = "cm",
												r = 0.1,
												money = 10,
												button = "EF_blackjack_money_select",
												hover = true,
												shadow = true,
												func = "EF_blackjack_money_can_select",
											},
											nodes = {
												{
													n = G.UIT.T,
													config = { text = "$10", scale = 0.75, colour = G.C.MONEY },
													nodes = {},
												},
											},
										},
										{
											n = G.UIT.C,
											config = {
												minw = 2,
												minh = 1,
												align = "cm",
												r = 0.1,
												money = 20,
												button = "EF_blackjack_money_select",
												hover = true,
												shadow = true,
												func = "EF_blackjack_money_can_select",
											},
											nodes = {
												{
													n = G.UIT.T,
													config = { text = "$20", scale = 0.75, colour = G.C.MONEY },
													nodes = {},
												},
											},
										},
										{
											n = G.UIT.C,
											config = {
												minw = 2,
												minh = 1,
												align = "cm",
												r = 0.1,
												money = 30,
												button = "EF_blackjack_money_select",
												hover = true,
												shadow = true,
												func = "EF_blackjack_money_can_select",
											},
											nodes = {
												{
													n = G.UIT.T,
													config = { text = "$30", scale = 0.75, colour = G.C.MONEY },
													nodes = {},
												},
											},
										},
									},
								},
							},
						},
						config = { offset = { x = 0, y = 0 } },
					}),
				},
			},
		},
		no_back = true,
	})
end

function EF.FUNCS.UIDEF.blackjack_game(bet)
	if not bet then
		bet = 10
	end
	if not EF.vars.minigames.main_menu then
		ease_dollars(-bet, true)
	end
	EF.vars.minigames.blackjack.bet = bet

	EF.vars.minigames.blackjack.won = false

	EF.FUNCS.blackjack.init_card_areas()

	local dealer_card1 = SMODS.create_card({ set = "Base", area = EF.CARDAREAS.blackjack_dealer })
	local dealer_card2 = SMODS.create_card({ set = "Base", area = EF.CARDAREAS.blackjack_dealer })
	dealer_card2:flip()
	EF.CARDAREAS.blackjack_dealer:emplace(dealer_card1, nil, true)
	EF.CARDAREAS.blackjack_dealer:emplace(dealer_card2, nil, true)

	local player_card1 = SMODS.create_card({ set = "Base", area = EF.CARDAREAS.blackjack_player })
	local player_card2 = SMODS.create_card({ set = "Base", area = EF.CARDAREAS.blackjack_player })
	EF.CARDAREAS.blackjack_player:emplace(player_card1)
	EF.CARDAREAS.blackjack_player:emplace(player_card2)

	EF.vars.minigames.blackjack.player_total = getTotal(EF.CARDAREAS.blackjack_player.cards)
	EF.vars.minigames.blackjack.dealer_total = getTotal(EF.CARDAREAS.blackjack_dealer.cards, true)

	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK, padding = 0.5 },
		nodes = {
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.C,
						nodes = {
							{
								n = G.UIT.R,
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "Dealers Cards",
											scale = 0.6,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = false,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "Total: ",
											scale = 0.6,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = false,
										},
									},
									{
										n = G.UIT.T,
										config = {
											ref_table = EF.vars.minigames.blackjack,
											ref_value = "dealer_total",
											scale = 0.6,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = false,
										},
									},
								},
							},
						},
					},
					{ n = G.UIT.O, config = { object = EF.CARDAREAS.blackjack_dealer } },
				},
			},
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.C,
						nodes = {
							{
								n = G.UIT.R,
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "Players Cards",
											scale = 0.6,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = false,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "Total: ",
											scale = 0.6,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = false,
										},
									},
									{
										n = G.UIT.T,
										config = {
											ref_table = EF.vars.minigames.blackjack,
											ref_value = "player_total",
											scale = 0.6,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = false,
										},
									},
								},
							},
						},
					},
					{ n = G.UIT.O, config = { object = EF.CARDAREAS.blackjack_player } },
				},
			},
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.5 },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							minw = 2,
							minh = 1,
							align = "cm",
							r = 0.1,
							colour = G.C.BLUE,
							button = "EF_blackjack_hit",
							hover = true,
							shadow = true,
						},
						nodes = {
							{ n = G.UIT.T, config = { text = "Hit", scale = 0.75, colour = G.C.UI.TEXT_LIGHT } },
						},
					},
					{
						n = G.UIT.C,
						config = {
							minw = 2,
							minh = 1,
							align = "cm",
							r = 0.1,
							colour = G.C.BLUE,
							button = "EF_blackjack_stand",
							hover = true,
							shadow = true,
						},
						nodes = {
							{ n = G.UIT.T, config = { text = "Stand", scale = 0.75, colour = G.C.UI.TEXT_LIGHT } },
						},
					},
				},
			},
		},
	}
end

---@param who "player"|"dealer"|"tie"
function EF.FUNCS.UIDEF.blackjack_end(who)
	local win_text
	if who == "player" then
		win_text = "Won: " .. EF.vars.minigames.blackjack.bet
	elseif who == "dealer" then
		win_text = "Lost: " .. EF.vars.minigames.blackjack.bet
	elseif who == "tie" then
		win_text = "Came out net zero :0"
	end

	-- print(#EF.CARDAREAS.blackjack_player.cards)
	-- print(#EF.CARDAREAS.blackjack_dealer.cards)
	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = {
					{ n = G.UIT.T, config = { text = "Blackjack", scale = 1, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
				},
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = { { n = G.UIT.T, config = {
					text = win_text,
					scale = 0.7,
					colour = G.C.UI.TEXT_LIGHT,
					shadow = true,
				} } },
			},
			-- {n=G.UIT.R, nodes={ -- it crashes idk why Oops! The game crashed cardarea.lua:504: bad argument #1 to 'ipairs' (table expected, got nil)
			--   {n=G.UIT.C, nodes={
			--     {n=G.UIT.R, nodes={{n = G.UIT.T, config = { text="Dealers Cards", scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = false}}}},
			--     {n=G.UIT.R, nodes={
			--       {n = G.UIT.T, config = { text = "Total: ", scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = false}},
			--       {n = G.UIT.T, config = { ref_table=EF.vars.minigames.blackjack, ref_value = "dealer_total", scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = false}},
			--     }}
			--   }},
			--   {n = G.UIT.O, config = { object = EF.CARDAREAS.blackjack_dealer }},
			-- }},
			-- {n=G.UIT.R, nodes={
			--   {n=G.UIT.C, nodes={
			--     {n=G.UIT.R, nodes={{n = G.UIT.T, config = { text="Players Cards", scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = false}}}},
			--     {n=G.UIT.R, nodes={
			--       {n = G.UIT.T, config = { text = "Total: ", scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = false}},
			--       {n = G.UIT.T, config = { ref_table=EF.vars.minigames.blackjack, ref_value = "player_total", scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = false}},
			--     }}
			--   }},
			--   {n = G.UIT.O, config = { object = EF.CARDAREAS.blackjack_player }},
			-- }},
		},
	}
end

----------------
----EF.FUNCS----
----------------

---@param who "player"|"dealer"|"tie"
function EF.FUNCS.blackjack.on_end(who)
	EF.vars.minigames.blackjack.won = true
	G.E_MANAGER:add_event(Event({
		func = function()
			if EF.vars.minigames.main_menu or who == "dealer" then
			-- hello
			elseif who == "tie" then
				ease_dollars(EF.vars.minigames.blackjack.bet)
			elseif who == "player" then
				ease_dollars(EF.vars.minigames.blackjack.bet * 2)
			else
				error("ahem, who the hell put wrong param here")
			end
			render_blackjack_end(who)
			return true
		end,
	}))
end

function EF.FUNCS.blackjack.check_win_state()
	local player_total = getTotal(EF.CARDAREAS.blackjack_player.cards)
	local dealer_total = getTotal(EF.CARDAREAS.blackjack_dealer.cards)

	if dealer_total == 21 and player_total == 21 then
		EF.FUNCS.blackjack.on_end("tie")
	elseif dealer_total == 21 then
		EF.FUNCS.blackjack.on_end("dealer")
	elseif player_total == 21 then
		EF.FUNCS.blackjack.on_end("player")
	elseif dealer_total > 21 then
		EF.FUNCS.blackjack.on_end("player")
	elseif player_total > 21 then
		EF.FUNCS.blackjack.on_end("dealer")
	else
		EF.vars.minigames.blackjack.player_total = getTotal(EF.CARDAREAS.blackjack_player.cards or {})
		EF.vars.minigames.blackjack.dealer_total = getTotal(EF.CARDAREAS.blackjack_dealer.cards or {})
	end
end

---------------
----G.FUNCS----
---------------

function G.FUNCS.EF_blackjack_money_can_select(e)
	if EF.vars.minigames.main_menu then
		render_blackjack(0)
	end
	if e.config.money <= (G.GAME and G.GAME.dollars) then
		e.config.colour = G.C.BLUE
		e.config.button = "EF_blackjack_money_select"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

function G.FUNCS.EF_blackjack_money_select(e)
	render_blackjack(e.config.money)
end

function G.FUNCS.EF_blackjack_hit(e)
	local player_card = SMODS.create_card({ set = "Base", area = EF.CARDAREAS.blackjack_player })
	EF.CARDAREAS.blackjack_player:emplace(player_card)

	EF.FUNCS.blackjack.check_win_state()
	EF.vars.minigames.blackjack.dealer_total = getTotal(EF.CARDAREAS.blackjack_dealer.cards, true)
end

function G.FUNCS.EF_blackjack_stand(e)
	EF.FUNCS.blackjack.check_win_state()
	for _, card in ipairs(EF.CARDAREAS.blackjack_dealer.cards) do
		if card.facing == "back" then
			card:flip()
		end
	end

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.5,
		func = function()
			local dealer_card = SMODS.create_card({ set = "Base", area = EF.CARDAREAS.blackjack_dealer })
			EF.CARDAREAS.blackjack_dealer:emplace(dealer_card)

			EF.FUNCS.blackjack.check_win_state()

			if not EF.vars.minigames.blackjack.won then
				G.FUNCS.EF_blackjack_stand(e)
			end

			return true
		end,
	}))
end
