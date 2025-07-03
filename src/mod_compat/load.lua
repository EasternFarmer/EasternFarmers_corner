local curr_dir = "src/mod_compat/"

---@diagnostic disable-next-line: undefined-global
if JokerDisplay then
    assert(SMODS.load_file(curr_dir.."joker_display.lua"))()
end