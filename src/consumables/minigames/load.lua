SMODS.ConsumableType {
    key = 'minigame_card',
    loc_txt = {
        name = 'Minigame Card',
        collection = 'Minigame Card'
    },
    collection_rows = { 3, 1 },
    primary_colour = G.C.EF.MINIGAME,
    secondary_colour = G.C.EF.MINIGAME,
}


local curr_dir = "src/consumables/minigames/"

assert(SMODS.load_file(curr_dir.."minesweeper.lua"))()
assert(SMODS.load_file(curr_dir.."parlor.lua"))()
