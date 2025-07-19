-- list of puzzles
assert(SMODS.load_file("src/ui/parlor/puzzle_list.lua"))()


function EF.FUNCS.UIDEF.parlor()
    return create_UIBox_generic_options({contents ={create_tabs(
    {tabs = {
        {
          label = "Info",
          chosen = true,
          tab_definition_function = EF.FUNCS.UIDEF.parlor_info,
        },
        {
            label = "Puzzle",
            tab_definition_function = EF.FUNCS.UIDEF.parlor_puzzle,
        },
    },
    tab_h = 8,
    snap_to_nav = true})}, no_back = true})
end

function EF.FUNCS.UIDEF.parlor_info()
    return {
        n=G.UIT.ROOT,
        config = {r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK},
        nodes = {
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}There will always be at least"), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:gold}one {C:white}box which displays"), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}only {C:gold}true {C:white}statements."), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text=" ", scale = 0.7, colour = G.C.UI.TEXT_LIGHT}}}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}There will always be at least"), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:gold}one {C:white}box which displays"), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}only {C:gold}false {C:white}statements."), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text=" ", scale = 0.7, colour = G.C.UI.TEXT_LIGHT}}}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}Only {C:gold}one {C:white}box has a prize within."), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}The other {C:gold}2{C:white} are always empty"), {scale = 2})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text=" ", scale = 0.7, colour = G.C.UI.TEXT_LIGHT}}}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:inactive}Credit to {C:gold}Dogubomb {C:inactive}for this description, puzzle itself and the game Blue Prince <3"), {scale = 1})},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:inactive}Credit to {C:gold}wizard_man98082 {C:inactive}for helping me convert the puzzle to balatro <3"), {scale = 1})},
        }}
end

function EF.FUNCS.UIDEF.parlor_puzzle()
    local box_names = EF.vars.minigames.parlor.boxes
    local box_colors = EF.vars.minigames.parlor.box_colors
    if not EF.vars.minigames.parlor.was_puzzle_chosen then
        EF.vars.minigames.parlor.chosen_puzzle = pseudorandom_element(EF.vars.minigames.parlor.puzzle_list)
        EF.vars.minigames.parlor.was_puzzle_chosen = true
    end
    local chosen_puzzle = EF.vars.minigames.parlor.chosen_puzzle

    return {
        n=G.UIT.ROOT,
        config = {r = 0.1, minw = 15, minh = 10, align = "cm", colour = G.C.BLACK},
        nodes = {
            {n = G.UIT.R, config = { align = "bm", padding = 0.3 }, nodes = {
                {n = G.UIT.C, config = { align = "bm", minw = 3, minh = 1}, nodes = {{n = G.UIT.T, config = { text=box_names[1], scale = 1, colour = G.C.UI.TEXT_LIGHT}, nodes = {}},}},
                {n = G.UIT.C, config = { align = "bm", minw = 3, minh = 1}, nodes = {{n = G.UIT.T, config = { text=box_names[2], scale = 1, colour = G.C.UI.TEXT_LIGHT}, nodes = {}},}},
                {n = G.UIT.C, config = { align = "bm", minw = 3, minh = 1}, nodes = {{n = G.UIT.T, config = { text=box_names[3], scale = 1, colour = G.C.UI.TEXT_LIGHT}, nodes = {}},}},
                
            }},
            {n = G.UIT.R, config = { align = "tm", padding = 0.3, shadow = true }, nodes = {
                {n = G.UIT.C, config = {minw = 3, minh = 3, colour = box_colors[1], r = 0.1, my_index = 1, button = "EF_parlor_box" }, nodes = {}},
                {n = G.UIT.C, config = {minw = 3, minh = 3, colour = box_colors[2], r = 0.1, my_index = 2, button = "EF_parlor_box" }, nodes = {}},
                {n = G.UIT.C, config = {minw = 3, minh = 3, colour = box_colors[3], r = 0.1, my_index = 3, button = "EF_parlor_box" }, nodes = {}},
            }},
            {n = G.UIT.R, config = { align = "tm", padding = 0.3 }, nodes = {
                {n = G.UIT.C, config = { align = "tm", maxw = 3, minh = 1}, nodes = {{n = G.UIT.T, config = { text=table.concat(EF.FUNCS.split_text_3(chosen_puzzle[1]), '\n'), scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}},}},
                {n = G.UIT.C, config = { align = "tm", maxw = 3, minh = 1}, nodes = {{n = G.UIT.T, config = { text=table.concat(EF.FUNCS.split_text_3(chosen_puzzle[2]), '\n'), scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}},}},
                {n = G.UIT.C, config = { align = "tm", maxw = 3, minh = 1}, nodes = {{n = G.UIT.T, config = { text=table.concat(EF.FUNCS.split_text_3(chosen_puzzle[3]), '\n'), scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}},}},
            }},
        }
    }
end

function G.FUNCS.EF_parlor_box(e)
    local index = e.config.my_index
    G.FUNCS.exit_overlay_menu()
    if index == EF.vars.minigames.parlor.chosen_puzzle[4] then
        EF.FUNCS.UI.parlor_score(true)
    else
        EF.FUNCS.UI.parlor_score(false)
    end
end

function EF.FUNCS.UIDEF.parlor_win()
    local reward_dollars = 15
    ease_dollars(reward_dollars)
    return create_UIBox_generic_options{contents = {
        {n = G.UIT.O, config = {object = UIBox{definition = 
        {
            n=G.UIT.ROOT,
            config = {r = 0.1, minw = 8, minh = 2, align = "cm", colour = G.C.BLACK},
            nodes = {
                {n = G.UIT.R, config = {align = "cm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}Congrats you picked the"), {scale = 2})},
                {n = G.UIT.R, config = {align = "cm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}right answer and won {C:money}$"..tostring(reward_dollars)), {scale = 2})},
            }
        }, config = {offset = {x=0,y=0}}
        }}}
    }}
end

function EF.FUNCS.UIDEF.parlor_lose()
    local answer = EF.vars.minigames.parlor.chosen_puzzle[EF.vars.minigames.parlor.chosen_puzzle[4]]
    local box_name = EF.vars.minigames.parlor.boxes[EF.vars.minigames.parlor.chosen_puzzle[4]]
    local box_color = EF.vars.minigames.parlor.box_colors[EF.vars.minigames.parlor.chosen_puzzle[4]]

    local split_answer = EF.FUNCS.split_text_3(tostring(answer))
    local answer_text_nodes = {}
    for _, v in ipairs(split_answer) do
        answer_text_nodes[#answer_text_nodes+1] = {n = G.UIT.R, config = {align = "cm"}, nodes = {{n = G.UIT.T, config = { text=v, scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}}}}
    end
    return create_UIBox_generic_options{contents = {
        {n = G.UIT.O, config = {object = UIBox{definition = 
        {
            n=G.UIT.ROOT,
            config = {r = 0.1, minw = 11, minh = 6, align = "cm", colour = G.C.BLACK},
            nodes = {
                {n = G.UIT.R, config = {align = "cm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}You Lost and didn't win anything"), {scale = 2})},
                {n = G.UIT.R, config = {align = "cm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}The correct answer was:"), {scale = 2})},
                {n = G.UIT.R, config = {align = "cm"}, nodes = {{n = G.UIT.T, config = { text=" ", scale = 1, colour = G.C.UI.TEXT_LIGHT}, nodes = {}}}},
                {n = G.UIT.R, config = {align = "cm"}, nodes = {{n = G.UIT.T, config = { text=box_name, scale = 1, colour = box_color}, nodes = {}}}},
                unpack(answer_text_nodes),
            }
        }, config = {offset = {x=0,y=0}}
        }}}
    }}
end