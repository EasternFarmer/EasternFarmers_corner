-- Everything in this file should display a full window when called
-- Everything loaded here should be in `src/ui/` folder
local ui_dir = "src/ui/"

-- Minesweeper, functions for ui
assert(SMODS.load_file(ui_dir .. "minesweeper.lua"))()

---@param difficulty "easy"|"medium"|"hard"
---@param main_menu? boolean
function EF.FUNCS.UI.minesweeper(difficulty, main_menu)
	G.SETTINGS.paused = true
	--game vars
	EF.vars.minigames.minesweeper.bombs_placed = false
	EF.vars.minigames.minesweeper.score = 0
	EF.vars.minigames.minesweeper.difficulty = difficulty or "hard"

	EF.vars.minigames.main_menu = main_menu or false

	G.FUNCS.overlay_menu({
		definition = EF.FUNCS.UIDEF.minesweeper(),
	})
end

function EF.FUNCS.UI.minesweeper_score()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = EF.FUNCS.UIDEF.minesweeper_score(),
	})
end

-- Parlor (Blue prince reference)
assert(SMODS.load_file(ui_dir .. "parlor/parlor.lua"))()

---@param main_menu? boolean
function EF.FUNCS.UI.parlor(main_menu)
	G.SETTINGS.paused = true

	EF.vars.minigames.parlor.was_puzzle_chosen = false

	EF.vars.minigames.main_menu = main_menu or false

	G.FUNCS.overlay_menu({
		definition = EF.FUNCS.UIDEF.parlor(),
	})
end

function EF.FUNCS.UI.parlor_score(win)
	G.SETTINGS.paused = true
	if win then
		G.FUNCS.overlay_menu({
			definition = EF.FUNCS.UIDEF.parlor_win(),
		})
	else
		G.FUNCS.overlay_menu({
			definition = EF.FUNCS.UIDEF.parlor_lose(),
		})
	end
end

-- Snake
assert(SMODS.load_file(ui_dir .. "snake.lua"))()

---@param difficulty "easy"|"hard"
---@param main_menu? boolean
function EF.FUNCS.UI.snake(difficulty, main_menu)
	G.SETTINGS.paused = true

	EF.vars.minigames.snake.field = nil --reset the field data in case it's not empty

	EF.vars.minigames.snake.stats.body_stack = {}
	EF.vars.minigames.snake.stats.curr_direction = "up"
	EF.vars.minigames.snake.stats.snake_length = 0 -- score

	EF.vars.minigames.snake.difficulty = difficulty or "hard"

	EF.vars.minigames.main_menu = main_menu or false

	G.FUNCS.overlay_menu({
		definition = EF.FUNCS.UIDEF.snake(),
	})
end

function EF.FUNCS.UI.snake_score()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = EF.FUNCS.UIDEF.snake_score(),
	})
end

if EF.DEBUG then
	function snek(d)
		EF.FUNCS.UI.snake(d or "hard")
	end
end

-- BlackJack
assert(SMODS.load_file(ui_dir .. "blackjack.lua"))()

---@param main_menu? boolean
function EF.FUNCS.UI.blackjack(main_menu)
	EF.vars.minigames.main_menu = main_menu or false

	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = EF.FUNCS.UIDEF.blackjack_pick(),
	})
end
