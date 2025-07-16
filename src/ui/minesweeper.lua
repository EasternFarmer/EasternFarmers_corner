local minesweeper_table = EF.vars.minigames.minesweeper
EF.vars.minigames.minesweeper.config = {
    cell_minh = 1,
    cell_minw = 1,
    cell_padding = 0.1,
    cell_color = G.C.BLUE,
    width = 12, -- width, height and mines changed based on difficulty!
    height = 6,
    mines = 6, -- (width*height)/mines = the total number of mines
}
EF.vars.minigames.minesweeper.config.reward_list = {
    easy = {
        "{C:white,X:mult}X1.5{C:white} Blind size for {C:gold}3{C:white} rounds",
        "{C:white,X:mult}X1.25{C:white} Blind Size for {C:gold}3{C:white} rounds",
        "{C:white,X:mult}X2{C:white} Mult for {C:gold}3{C:white} rounds",
        "{C:white,X:mult}X0.4{C:white} Blind size for {C:gold}3{C:white} rounds",
        "{C:white,X:mult}X10{C:white} Mult for {C:gold}3{C:white} rounds",
    },
    medium = {
        "1",
        "2",
        "3",
        "4",
        "5",
    },
    hard = {
        "1",
        "2",
        "3",
        "4",
        "5",
    },
}

local function minesweeper_cell(config,x,y)
    return {n = G.UIT.C, config = {button="EF_minesweeper_cell",orginal_config = config,cell_pos = {x=x,y=y}, align = "cm", minh = config.cell_minh, minw = config.cell_minw, colour = config.cell_color, r=0.1,
                tooltip = {title="Click to uncover", text = { "(No flags available)", "Current bombs: "..math.floor(config.width*config.height/config.mines)}}, juice = true, hover = true,
            }, nodes = {{n=G.UIT.T, config={ref_table = EF.vars.minigames.minesweeper.FIELD_TABLE[y][x], ref_value = 'text', scale = 0.75, colour = G.C.WHITE, shadow = true}}}}
end

local function minesweeper_row(config,y)
    local nodes = {}
    for i = 1, config.width do
        table.insert(nodes, minesweeper_cell(config,i,y))
    end
    return {n = G.UIT.R, config = {align = "cm", minh = config.cell_minh, minw = config.cell_minw, padding = config.cell_padding}, 
    nodes = nodes}
end

function EF.FUNCS.UIDEF.minesweeper_field()
    local difficulty_settings = {
        ["easy"] = {width = 5, height = 5, mines = 6},
        ["medium"] = {width = 8, height = 8, mines = 6},
        ["hard"] = {width = 14, height = 8, mines = 6},
    }
    local chosen_settings = difficulty_settings[minesweeper_table.difficulty] or {}
    local config = EF.vars.minigames.minesweeper.config
    config.width = chosen_settings["width"] or config.width
    config.height = chosen_settings['height'] or config.height
    config.mines = chosen_settings['mines'] or config.mines
    --init the game table
    if not minesweeper_table.bombs_placed then
        minesweeper_table.FIELD_TABLE = {}
        for i = 1, config.height do
            local row = {}
            for j = 1, config.width do
                table.insert(row,{bomb = false, text = ""})
            end
            table.insert(minesweeper_table.FIELD_TABLE,row)
        end
    end

    local nodes = {}
    for i = 1, config.height do
        table.insert(nodes, minesweeper_row(config,i))
    end
    return {
        n = G.UIT.ROOT,
        config = {r = 0.1, minw = config.cell_minw*config.width+2, minh = config.cell_minh*config.height+2, align = "cm", colour = G.C.BLACK},
        nodes = nodes
    }
end

---@param e UIBox
function G.FUNCS.EF_minesweeper_cell(e)
    local function placemine(config)
        local x = math.random(1, config.width)
        local y = math.random(1, config.height)
        if x ~= e.config.cell_pos.x and y ~= e.config.cell_pos.y and not minesweeper_table.FIELD_TABLE[y][x].bomb then
            minesweeper_table.FIELD_TABLE[y][x].bomb = true
        else
            placemine(config)
        end
    end
    local config = e.config.orginal_config
    if not minesweeper_table.bombs_placed then
        for i=1, math.floor(config.height*config.width/config.mines) do
            placemine(config)
        end
        minesweeper_table.bombs_placed = true
    end
    if minesweeper_table.FIELD_TABLE[e.config.cell_pos.y][e.config.cell_pos.x].bomb then
        e.config.colour = G.C.ORANGE
        G.FUNCS.exit_overlay_menu()
        EF.FUNCS.minesweeper.give_reward_set_text()
        EF.FUNCS.UI.minesweeper_score()
    else
        local curr_y, curr_x = e.config.cell_pos.y, e.config.cell_pos.x
        local neighbour_pos_table = {
            {curr_x-1, curr_y-1}, {curr_x, curr_y-1}, {curr_x+1, curr_y-1},
            {curr_x-1, curr_y},                       {curr_x+1,curr_y},
            {curr_x-1,curr_y+1}, {curr_x,curr_y+1}, {curr_x+1,curr_y+1}
        }
        local neighbour_bombs = 0
        for _, v in pairs(neighbour_pos_table) do
            local x,y = v[1], v[2]
            if x < 1 or y < 1 or x > config.width or y > config.height then
                goto continue
            end
            if minesweeper_table.FIELD_TABLE[y][x].bomb then
                neighbour_bombs = neighbour_bombs + 1
            end
            ::continue::
        end
        if minesweeper_table.FIELD_TABLE[curr_y][curr_x].text == "" then
            minesweeper_table.score = (minesweeper_table.score or 0) + 1
        end
        minesweeper_table.FIELD_TABLE[curr_y][curr_x].text = number_format(neighbour_bombs)
    end
end

function EF.FUNCS.UIDEF.minesweeper_info()
    return {
        n=G.UIT.ROOT,
        config = {r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK},
        nodes = {
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Minesweeper", scale = 1.5, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Click on a tile to reveal what is underneath.", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="There can either be a number or a bomb.", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="A number tells you have many bombs are ", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="adjacent to the tile with the number.", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Clicking on a bomb ends the minigame.", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text=" ", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="The more points you get the better reward will be.", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Small amount of points may result in a bad effect.", scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
        }}
end

function EF.FUNCS.UIDEF.minesweeper()
    return create_UIBox_generic_options({contents ={create_tabs(
    {tabs = {
        {
          label = "Info",
          chosen = true,
          tab_definition_function = EF.FUNCS.UIDEF.minesweeper_info,
        },
        {
            label = "Field",
            tab_definition_function = EF.FUNCS.UIDEF.minesweeper_field,
        },
    },
    tab_h = 8,
    snap_to_nav = true})}, no_back = true})
end

-- Score screen:

function EF.FUNCS.UIDEF.minesweeper_score_tab()
    local v = EF.vars.minigames.minesweeper.reward_table
    local game_config = EF.vars.minigames.minesweeper.config
    local max_score = game_config.width * game_config.height - math.floor(game_config.width * game_config.height / game_config.mines)
    return {
        n=G.UIT.ROOT,
        config = {r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK},
        nodes = {
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Minesweeper", scale = 1, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Score: "..EF.vars.minigames.minesweeper.score.." / "..max_score, scale = 0.7, colour = G.C.WHITE, shadow = true}},}},
            {n = G.UIT.R, config = {align = "tm"}, nodes = SMODS.localize_box(loc_parse_string("{C:white}Reward nr. "..v[1]..": "..v[2]), {scale = 2})},
        }}
end

function EF.FUNCS.minesweeper.get_difficulty_title(difficulty)
    local difficulty_nodes = {
        easy = {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Minesweeper (easy)", scale = 1, colour = G.C.WHITE, shadow = true}}}},
        medium = {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Minesweeper (medium)", scale = 1, colour = G.C.WHITE, shadow = true}}}},
        hard = {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text="Minesweeper (hard)", scale = 1, colour = G.C.WHITE, shadow = true}}}},
    }
    return difficulty_nodes[difficulty]
end

function EF.FUNCS.minesweeper.give_reward_set_text()
    local difficulty = EF.vars.minigames.minesweeper.difficulty or "hard"
    local game_config = EF.vars.minigames.minesweeper.config
    local max_points = game_config.width * game_config.height - math.floor(game_config.width * game_config.height / game_config.mines)
    local score = EF.vars.minigames.minesweeper.score
    local reward =  score/max_points
    local reward_chosen = 0
    if reward <= 1/5 then
        reward_chosen = 1
        SMODS.add_card{key = "j_EF_minesweeper_"..difficulty.."_"..number_format(reward_chosen)}
    elseif reward <= 2/5 then
        reward_chosen = 2
        SMODS.add_card{key = "j_EF_minesweeper_"..difficulty.."_"..number_format(reward_chosen)}
    elseif reward <= 3/5 then
        reward_chosen = 3
        SMODS.add_card{key = "j_EF_minesweeper_"..difficulty.."_"..number_format(reward_chosen)}
    elseif reward <= 4/5 then
        reward_chosen = 4
        SMODS.add_card{key = "j_EF_minesweeper_"..difficulty.."_"..number_format(reward_chosen)}
    else
        reward_chosen = 5
        SMODS.add_card{key = "j_EF_minesweeper_"..difficulty.."_"..number_format(reward_chosen)}
    end

    EF.vars.minigames.minesweeper.reward_table = {reward_chosen, EF.vars.minigames.minesweeper.config.reward_list[difficulty][reward_chosen]}
end

function EF.FUNCS.UIDEF.minesweeper_reward_info()
    local reward_list = EF.vars.minigames.minesweeper.config.reward_list
    local difficulty = EF.vars.minigames.minesweeper.difficulty or "hard"
    local nodes = {EF.FUNCS.minesweeper.get_difficulty_title(difficulty)}
    for i,v in ipairs(reward_list[difficulty]) do
        local message = i..". "..v
        -- table.insert(nodes, {n = G.UIT.R, config = {align = "tm"}, nodes = {{n=G.UIT.T, config={text=message, scale = 0.7, colour = G.C.WHITE, shadow = true}}}})
        table.insert(nodes, {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=SMODS.localize_box(loc_parse_string(message), {scale = 2})})
    end

    return {
        n=G.UIT.ROOT,
        config = {r = 0.1, minw = 15, minh = 8, align = "cm", colour = G.C.BLACK},
        nodes = nodes
    }
end

function EF.FUNCS.UIDEF.minesweeper_score()
    return create_UIBox_generic_options({contents ={create_tabs(
    {tabs = {
        {
          label = "Score",
          chosen = true,
          tab_definition_function = EF.FUNCS.UIDEF.minesweeper_score_tab,
        },
        {
            label = "Reward Table",
            tab_definition_function = EF.FUNCS.UIDEF.minesweeper_reward_info,
        },
    },
    tab_h = 8,
    snap_to_nav = true})}})
end