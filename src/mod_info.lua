SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

-- https://github.com/nh6574/JoyousSpring/blob/c0a24f9ba7e75f51d8ec09f22f12329c7a837cca/src/mod_info.lua#L216