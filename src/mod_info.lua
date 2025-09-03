SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

if math.random() < 1 / 10 then
    love.window.setTitle( "Balalala" )
end

-- https://github.com/nh6574/JoyousSpring/blob/c0a24f9ba7e75f51d8ec09f22f12329c7a837cca/src/mod_info.lua#L216

SMODS.current_mod.extra_tabs = function()
  return {
    {
      label = "Minigames",
      tab_definition_function = function()

        return {
            n = G.UIT.ROOT,
            config = {r = 0.1, minw = 12, minh = 6, align = "cm", colour = G.C.BLACK, padding = 0.5},
            nodes = {
                {n = G.UIT.C,
                    config = {},
                    nodes = {
                        { n = G.UIT.R, config = {align="tm"}, nodes = {{n = G.UIT.T, config = {text= "Also available during the run", scale = 0.6, colour = G.C.UI.TEXT_LIGHT}}}},
                        {
                            n = G.UIT.R,
                            config = {padding = 0.5},
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = {
                                        minw = 4, minh = 1.5, align = "cm", colour = G.C.BLUE, r = 0.1, id = "EF_minesweeper_mainmenu", button = "EF_minigames_mainmenu", hover = true, shadow = true
                                    },
                                    nodes = {
                                        {n = G.UIT.T, config = { text="Minesweeper", scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}}
                                    }
                                },
                                {
                                    n = G.UIT.C,
                                    config = {
                                        minw = 4, minh = 1.5, align = "cm", colour = G.C.BLUE, r = 0.1, id = "EF_parlor_mainmenu", button = "EF_minigames_mainmenu", hover = true, shadow = true
                                    },
                                    nodes = {
                                        {n = G.UIT.T, config = { text="Parlor", scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}}
                                    }
                                },
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {padding = 0.5},
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = {
                                        minw = 4, minh = 1.5, align = "cm", colour = G.C.BLUE, r = 0.1, id = "EF_snake_mainmenu", button = "EF_minigames_mainmenu", hover = true, shadow = true
                                    },
                                    nodes = {
                                        {n = G.UIT.T, config = { text="Snake", scale = 0.75, colour = G.C.UI.TEXT_LIGHT}, nodes = {}}
                                    }
                                },
                            }
                        }
                    }
                }
            }
        }
      end
    },
  }
end

--Minigames button
G.FUNCS.EF_minigames_mainmenu = function(e)
    EF.vars.minigames.main_menu = true
    if e.config.id == "EF_minesweeper_mainmenu" then
        EF.FUNCS.UI.minesweeper("hard")
    elseif e.config.id == "EF_parlor_mainmenu" then
        EF.FUNCS.UI.parlor()
    elseif e.config.id == "EF_snake_mainmenu" then
        EF.FUNCS.UI.snake("hard")
    end
end