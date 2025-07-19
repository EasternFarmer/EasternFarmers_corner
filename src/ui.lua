-- Minesweeper, functions for ui
assert(SMODS.load_file("src/ui/minesweeper.lua"))()

function EF.FUNCS.UI.minesweeper(difficulty)

    G.SETTINGS.paused = true
    --game vars
    EF.vars.minigames.minesweeper.bombs_placed = false
    EF.vars.minigames.minesweeper.score = 0
    EF.vars.minigames.minesweeper.difficulty = difficulty or "hard"
    
    G.FUNCS.overlay_menu{
        definition = EF.FUNCS.UIDEF.minesweeper(),
    }
end

function EF.FUNCS.UI.minesweeper_score()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = EF.FUNCS.UIDEF.minesweeper_score(),
    }
end

-- Parlor (Blue prince reference)
assert(SMODS.load_file("src/ui/parlor/parlor.lua"))()

function EF.FUNCS.UI.parlor()

    G.SETTINGS.paused = true

    EF.vars.minigames.parlor.was_puzzle_chosen = false
    
    G.FUNCS.overlay_menu{
        definition = EF.FUNCS.UIDEF.parlor(),
    }
end

function EF.FUNCS.UI.parlor_score(win)
    G.SETTINGS.paused = true
    if win then
        G.FUNCS.overlay_menu{
            definition = EF.FUNCS.UIDEF.parlor_win(),
        }
    else
        G.FUNCS.overlay_menu{
            definition = EF.FUNCS.UIDEF.parlor_lose(),
        }
    end
end