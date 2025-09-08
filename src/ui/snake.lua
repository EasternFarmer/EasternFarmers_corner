EF.vars.minigames.snake.config = {
	cell_minw = 1,
	cell_minh = 1,
	cell_padding = 0.05,
	cell_color = G.C.GREEN, -- default color if no snake on the tile
	snake_color = G.C.RED,
	apple_color = G.C.YELLOW,
	height = 6,
	width = 14,
	speed_modifier = 1, -- 1.2 = slower because delay*1.2
	speed_per_apple_modifier = 0.01, -- 1 apple = *0.98, 2 apple = *0.96
	minimum_speed = 15, -- because anything lower is literally unplayable. 1/4 of current fps
}
EF.vars.minigames.snake.target_fps = 60 -- so one cycle last one second and isn't affected by lag, is changed later by love.timer.getFPS
local config = EF.vars.minigames.snake.config
EF.vars.minigames.snake.stats = {}

EF.vars.minigames.snake.prizes = {
	chosen = 0,
	easy = {
		{ text = "Grants 1 Tarot Card", id = "easy_tarot" },
		{ text = "Grants 1 Root Spectral", id = "easy_root" },
		{ text = "Grants a Uncommon Tag", id = "easy_rarity_tag" },
		{ text = "Grants a Voucher Tag", id = "easy_tag" },
		{ text = "Grants the Souls", id = "soul" },
	},
	hard = {
		{ text = "Grants 2 Tarot Card", id = "hard_tarot" },
		{ text = "Grants 1 Root Spectral", id = "hard_root" },
		{ text = "Grants a Rare Tag", id = "hard_rarity_tag" },
		{ text = "Grants a Rare Tag and a Negative Tag", id = "hard_tag" },
		{ text = "Grants the Souls", id = "soul" },
	},
}

function EF.FUNCS.UIDEF.snake_game()
	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					align = "tm",
					func = "EF_snake_update",
					object = UIBox({ definition = EF.FUNCS.UIDEF.snake_field(), config = {} }),
				},
			},
		},
	}
end

local function snake_cell(x, y)
	local in_body = nil
	for k, v in pairs(EF.vars.minigames.snake.stats.body_stack) do
		if v.x == x and v.y == y then
			in_body = true
			break
		end
	end
	local color
	local x_, y_ = EF.vars.minigames.snake.stats.curr_head_pos.x, EF.vars.minigames.snake.stats.curr_head_pos.y
	if in_body or (x_ == x and y_ == y) then
		color = config.snake_color
	else
		color = EF.vars.minigames.snake.field[y][x].color
	end
	local x__, y__ = EF.vars.minigames.snake.apple_pos.x, EF.vars.minigames.snake.apple_pos.y
	if x__ == x and y__ == y then
		color = config.apple_color
	end
	local cell = {
		n = G.UIT.C,
		config = {
			cell_pos = { x = x, y = y },
			align = "cm",
			minh = config.cell_minh,
			minw = config.cell_minw,
			colour = color,
			r = 0.1,
			hover = true,
		},
		nodes = {
			{
				n = G.UIT.T,
				config = {
					ref_table = EF.vars.minigames.snake.field[y][x],
					ref_value = "text",
					font = SMODS.Fonts.EF_OpenArrow,
					scale = 0.75,
					colour = G.C.UI.TEXT_LIGHT,
					shadow = true,
				},
			},
		},
	}
	return cell
end

local function snake_row(y)
	local nodes = {}
	for i = 1, config.width do
		table.insert(nodes, snake_cell(i, y))
	end
	return { n = G.UIT.R, config = { align = "cm", minh = 1, minw = 2, padding = config.cell_padding }, nodes = nodes }
end

function EF.FUNCS.UIDEF.snake_field()
	if not EF.vars.minigames.snake.difficulty_settings then
		EF.vars.minigames.snake.difficulty_settings = {
			easy = {
				height = 6,
				width = 8,
				speed_modifier = 0.8,
			},
			hard = {
				height = 6,
				width = 14,
				speed_modifier = 0.6,
			},
		}
	end
	config.width = (EF.vars.minigames.snake.difficulty_settings[EF.vars.minigames.snake.difficulty] or {}).width
		or config.width
	config.height = (EF.vars.minigames.snake.difficulty_settings[EF.vars.minigames.snake.difficulty] or {}).height
		or config.height
	config.speed_modifier = (EF.vars.minigames.snake.difficulty_settings[EF.vars.minigames.snake.difficulty] or {}).speed_modifier
		or config.speed_modifier
	if not EF.vars.minigames.snake.field then
		EF.vars.minigames.snake.stats.curr_head_pos = {
			x = math.floor(EF.vars.minigames.snake.config.width / 2),
			y = math.floor(EF.vars.minigames.snake.config.height / 2),
		}
		EF.FUNCS.snake.new_apple_pos()
		EF.vars.minigames.snake.field = {}
		for y = 1, config.height do
			local row = {}
			for x = 1, config.width do
				row[#row + 1] = { color = config.cell_color, text = " " }
			end
			EF.vars.minigames.snake.field[#EF.vars.minigames.snake.field + 1] = row
		end
	end

	local row_nodes = {}
	for i = 1, config.height do
		row_nodes[#row_nodes + 1] = snake_row(i)
	end
	local button_config = {
		button = "EF_snake_button",
		align = "cm",
		r = 0.1,
		minw = 1,
		minh = 1,
		colour = G.C.BLUE,
		active_color = G.C.ORANGE,
	}
	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK, padding = 0.5 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.5 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Current direction: ",
									scale = 0.5,
									colour = G.C.UI.TEXT_LIGHT,
									shadow = true,
								},
							},
							{
								n = G.UIT.T,
								config = {
									ref_table = EF.vars.minigames.snake.stats,
									ref_value = "curr_direction",
									scale = 0.5,
									colour = G.C.UI.TEXT_LIGHT,
									shadow = true,
								},
							},
						},
					},
					{ n = G.UIT.R, config = { align = "tm" }, nodes = row_nodes },
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = { -- buttons
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.C,
								config = {
									id = "EF_snake_up",
									button = button_config.button,
									align = button_config.align,
									r = button_config.r,
									minw = button_config.minw,
									minh = button_config.minh,
									colour = button_config.colour,
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "↑",
											font = SMODS.Fonts.EF_OpenArrow,
											scale = 1,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = true,
										},
									},
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.1 },
						nodes = {
							{
								n = G.UIT.C,
								config = {
									id = "EF_snake_left",
									button = button_config.button,
									align = button_config.align,
									r = button_config.r,
									minw = button_config.minw,
									minh = button_config.minh,
									colour = button_config.colour,
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "←",
											font = SMODS.Fonts.EF_OpenArrow,
											scale = 0.8,
											colour = G.C.UI.TEXT_LIGHT,
										},
									},
								},
							},
							{
								n = G.UIT.C,
								config = {
									id = "EF_snake_down",
									button = button_config.button,
									align = button_config.align,
									r = button_config.r,
									minw = button_config.minw,
									minh = button_config.minh,
									colour = button_config.colour,
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "↓",
											font = SMODS.Fonts.EF_OpenArrow,
											scale = 0.8,
											colour = G.C.UI.TEXT_LIGHT,
										},
									},
								},
							},
							{
								n = G.UIT.C,
								config = {
									id = "EF_snake_right",
									button = button_config.button,
									align = button_config.align,
									r = button_config.r,
									minw = button_config.minw,
									minh = button_config.minh,
									colour = button_config.colour,
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "→",
											font = SMODS.Fonts.EF_OpenArrow,
											scale = 0.8,
											colour = G.C.UI.TEXT_LIGHT,
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
end

function EF.FUNCS.UIDEF.snake_info()
	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = SMODS.localize_box(loc_parse_string("{C:white}Snake"), { scale = 3 }),
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = { { n = G.UIT.T, config = { text = "", scale = 0.7, colour = G.C.WHITE, shadow = true } } },
				{ scale = 1.6 },
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = SMODS.localize_box(loc_parse_string("{C:white}Use arrow keys or the blue"), { scale = 1.6 }),
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = SMODS.localize_box(
					loc_parse_string("{C:white}buttons to change moving direction"),
					{ scale = 1.6 }
				),
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = { { n = G.UIT.T, config = { text = "", scale = 0.7, colour = G.C.WHITE, shadow = true } } },
				{ scale = 1.6 },
			},
		},
	}
end

function EF.FUNCS.UIDEF.snake()
	return create_UIBox_generic_options({
		contents = {
			create_tabs({
				tabs = {
					{
						label = "Info",
						chosen = true,
						tab_definition_function = EF.FUNCS.UIDEF.snake_info,
					},
					{
						label = "Game",
						tab_definition_function = EF.FUNCS.UIDEF.snake_game,
					},
				},
				tab_h = 8,
				snap_to_nav = true,
			}),
		},
		no_back = true,
	})
end

function EF.FUNCS.snake.new_apple_pos()
	EF.vars.minigames.snake.apple_pos = {
		x = math.random(1, EF.vars.minigames.snake.config.width),
		y = math.random(1, EF.vars.minigames.snake.config.height),
	}
end

--- check if you can move in that direction, return true if can't
---@param direction "up"|"down"|"left"|"right"
function EF.FUNCS.snake.snake_collision(direction)
	local x, y = EF.vars.minigames.snake.stats.curr_head_pos.x, EF.vars.minigames.snake.stats.curr_head_pos.y
	local n_x, n_y
	if direction == "up" then
		n_x, n_y = x, y - 1
	elseif direction == "down" then
		n_x, n_y = x, y + 1
	elseif direction == "left" then
		n_x, n_y = x - 1, y
	elseif direction == "right" then
		n_x, n_y = x + 1, y
	else
		return assert(false, "snake_collision recived invalid direction")
	end
	-- section for wall collision
	if n_x < 1 or n_x > config.width or n_y < 1 or n_y > config.height then
		return true
	end
	-- section for tail collision
	for _, v in ipairs(EF.vars.minigames.snake.stats.body_stack) do
		if v.x == n_x and v.y == n_y then
			return true
		end
	end
end

function EF.FUNCS.snake.prize()
	local difficulty = EF.vars.minigames.snake.difficulty
	local score = tostring(EF.vars.minigames.snake.stats.snake_length)
	local max_score = tostring(config.width * config.height - 1)
	-- 1. 15%
	-- 2. 30%
	-- 3. 40%
	-- 4. 50%
	-- 5. 60%
	if score / max_score <= 0.15 then
		EF.vars.minigames.snake.prizes.chosen = 1
	elseif 0.3 <= score / max_score and score / max_score < 0.4 then
		EF.vars.minigames.snake.prizes.chosen = 2
	elseif 0.4 <= score / max_score and score / max_score < 0.5 then
		EF.vars.minigames.snake.prizes.chosen = 3
	elseif 0.5 <= score / max_score and score / max_score < 0.6 then
		EF.vars.minigames.snake.prizes.chosen = 4
	elseif 0.6 <= score / max_score then
		EF.vars.minigames.snake.prizes.chosen = 5
	end

	local chosen = EF.vars.minigames.snake.prizes.chosen
	local difficulty_prizes = EF.vars.minigames.snake.prizes[difficulty]
	local prize = difficulty_prizes[chosen]

	if EF.vars.minigames.main_menu then
		return
	end

	if prize.id == "easy_tarot" then -- look at EF.vars.minigames.snake.prizes
		SMODS.add_card({ set = "Tarot" })
	elseif prize.id == "easy_root" then
		SMODS.add_card({ set = "plant_spectral" })
	elseif prize.id == "easy_rarity_tag" then
		add_tag(Tag("tag_uncommon"))
	elseif prize.id == "easy_tag" then
		add_tag(Tag("tag_voucher"))
	elseif prize.id == "hard_tarot" then
		SMODS.add_card({ set = "Tarot" })
		SMODS.add_card({ set = "Tarot" })
	elseif prize.id == "hard_root" then
		SMODS.add_card({ set = "plant_spectral" })
	elseif prize.id == "hard_rarity_tag" then
		add_tag(Tag("tag_rare"))
	elseif prize.id == "hard_tag" then
		add_tag(Tag("tag_rare"))
		add_tag(Tag("tag_negative"))
	elseif prize.id == "soul" then
		SMODS.add_card({ key = "c_soul" })
	end
end

local function snake_lose() -- generally end of run
	G.FUNCS.exit_overlay_menu()
	EF.FUNCS.snake.prize()
	EF.FUNCS.UI.snake_score()
end

EF.vars.minigames.snake.clock = 0

---@param e UIElement
function G.FUNCS.EF_snake_update(e)
	EF.vars.minigames.snake.clock = EF.vars.minigames.snake.clock + 1
	if EF.vars.minigames.snake.clock % EF.vars.minigames.snake.target_fps == 0 then
		EF.vars.minigames.snake.clock = 0
		EF.vars.minigames.snake.target_fps = love.timer.getFPS()
			* config.speed_modifier -- difficulty modifier
			* (1 - EF.vars.minigames.snake.stats.snake_length * config.speed_per_apple_modifier) -- per apple modifier
		config.minimum_speed = math.ceil(love.timer.getFPS() / 4)
		EF.vars.minigames.snake.target_fps =
			math.max(config.minimum_speed, math.ceil(EF.vars.minigames.snake.target_fps))
	else
		return
	end

	local curr_direction = EF.vars.minigames.snake.stats.curr_direction
	local x, y = EF.vars.minigames.snake.stats.curr_head_pos.x, EF.vars.minigames.snake.stats.curr_head_pos.y

	if EF.FUNCS.snake.snake_collision(curr_direction) then
		snake_lose()
		return
	end

	if curr_direction == "up" then
		EF.vars.minigames.snake.field[y][x].color = config.cell_color
		EF.vars.minigames.snake.field[y][x].text = " "
		EF.vars.minigames.snake.stats.curr_head_pos.y = EF.vars.minigames.snake.stats.curr_head_pos.y - 1
		EF.vars.minigames.snake.field[y - 1][x].color = config.snake_color
		EF.vars.minigames.snake.field[y - 1][x].text = "↑"

		EF.vars.minigames.snake.stats.body_stack[#EF.vars.minigames.snake.stats.body_stack + 1] = { y = y, x = x }
	elseif curr_direction == "down" then
		EF.vars.minigames.snake.field[y][x].color = config.cell_color
		EF.vars.minigames.snake.field[y][x].text = " "
		EF.vars.minigames.snake.stats.curr_head_pos.y = EF.vars.minigames.snake.stats.curr_head_pos.y + 1
		EF.vars.minigames.snake.field[y + 1][x].color = config.snake_color
		EF.vars.minigames.snake.field[y + 1][x].text = "↓"

		EF.vars.minigames.snake.stats.body_stack[#EF.vars.minigames.snake.stats.body_stack + 1] = { y = y, x = x }
	elseif curr_direction == "left" then
		EF.vars.minigames.snake.field[y][x].color = config.cell_color
		EF.vars.minigames.snake.field[y][x].text = " "
		EF.vars.minigames.snake.stats.curr_head_pos.x = EF.vars.minigames.snake.stats.curr_head_pos.x - 1
		EF.vars.minigames.snake.field[y][x - 1].color = config.snake_color
		EF.vars.minigames.snake.field[y][x - 1].text = "←"

		EF.vars.minigames.snake.stats.body_stack[#EF.vars.minigames.snake.stats.body_stack + 1] = { y = y, x = x }
	elseif curr_direction == "right" then
		EF.vars.minigames.snake.field[y][x].color = config.cell_color
		EF.vars.minigames.snake.field[y][x].text = " "
		EF.vars.minigames.snake.stats.curr_head_pos.x = EF.vars.minigames.snake.stats.curr_head_pos.x + 1
		EF.vars.minigames.snake.field[y][x + 1].color = config.snake_color
		EF.vars.minigames.snake.field[y][x + 1].text = "→"

		EF.vars.minigames.snake.stats.body_stack[#EF.vars.minigames.snake.stats.body_stack + 1] = { y = y, x = x }
	end

	-- apple check
	local n_x, n_y = EF.vars.minigames.snake.stats.curr_head_pos.x, EF.vars.minigames.snake.stats.curr_head_pos.y
	if EF.vars.minigames.snake.apple_pos.x == n_x and EF.vars.minigames.snake.apple_pos.y == n_y then
		EF.FUNCS.snake.new_apple_pos()
		EF.vars.minigames.snake.stats.snake_length = EF.vars.minigames.snake.stats.snake_length + 1
	end

	-- remove not neccessary tail parts
	if #EF.vars.minigames.snake.stats.body_stack > EF.vars.minigames.snake.stats.snake_length then
		table.remove(EF.vars.minigames.snake.stats.body_stack, 1)
	end

	-- regenerate the ui to update it
	e.config.object:remove()
	e.config.object = UIBox({
		definition = EF.FUNCS.UIDEF.snake_field(),
		config = { parent = e, type = "cm" },
	})
	e.UIBox:recalculate()
end

function G.FUNCS.EF_snake_button(e) -- also called from overrides.lua
	local new_dir_table =
		{ EF_snake_up = "up", EF_snake_down = "down", EF_snake_left = "left", EF_snake_right = "right" }
	EF.vars.minigames.snake.stats.curr_direction = new_dir_table[e.config.id]
end

function EF.FUNCS.UIDEF.snake_score_tab()
	local score = tostring(EF.vars.minigames.snake.stats.snake_length)
	local max_score = tostring(config.width * config.height - 1)

	local chosen = EF.vars.minigames.snake.prizes.chosen
	local difficulty_prizes = EF.vars.minigames.snake.prizes[EF.vars.minigames.snake.difficulty]
	local prize = difficulty_prizes[chosen]
	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = { { n = G.UIT.T, config = { text = "Snake", scale = 1, colour = G.C.WHITE, shadow = true } } },
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = "Score: " .. score .. " / " .. max_score,
							scale = 0.7,
							colour = G.C.WHITE,
							shadow = true,
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { align = "tm" },
				nodes = SMODS.localize_box(
					loc_parse_string("{C:white}Reward nr. " .. chosen .. ": " .. prize.text),
					{ scale = 2 }
				),
			},
		},
	}
end

function EF.FUNCS.UIDEF.snake_reward_info()
	local reward_list = EF.vars.minigames.snake.prizes
	local difficulty = EF.vars.minigames.snake.difficulty or "hard"
	local nodes = {
		{
			n = G.UIT.R,
			config = { align = "tm" },
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = difficulty == "hard" and "Snake (hard)" or "Snake (easy)",
						scale = 1,
						colour = G.C.WHITE,
						shadow = true,
					},
				},
			},
		},
	}
	---@diagnostic disable-next-line: param-type-mismatch
	for i, v in ipairs(reward_list[difficulty]) do
		local message = i .. ". " .. v.text
		-- table.insert(nodes, {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text=message, scale = 0.7, colour = G.C.WHITE, shadow = true}}}})
		table.insert(
			nodes,
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.03 },
				nodes = SMODS.localize_box(loc_parse_string("{C:white}" .. message), { scale = 2 }),
			}
		)
	end

	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK },
		nodes = nodes,
	}
end

function EF.FUNCS.UIDEF.snake_score()
	return create_UIBox_generic_options({
		contents = {
			create_tabs({
				tabs = {
					{
						label = "Score",
						chosen = true,
						tab_definition_function = EF.FUNCS.UIDEF.snake_score_tab,
					},
					{
						label = "Reward Table",
						tab_definition_function = EF.FUNCS.UIDEF.snake_reward_info,
					},
				},
				tab_h = 8,
				snap_to_nav = true,
			}),
		},
	})
end
