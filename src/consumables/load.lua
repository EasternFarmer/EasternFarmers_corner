local curr_dir = "src/consumables/"

assert(SMODS.load_file(curr_dir.."spectrals.lua"))()
assert(SMODS.load_file(curr_dir.."minigames/load.lua"))()