---@diagnostic disable: duplicate-set-field

local set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    set_ability_ref(self, center, initial, delay_sprites)
    if self.config.center.rarity == "EF_plant" and G.GAME.used_vouchers.v_EF_rake then
        if SMODS.pseudorandom_probability(self, "EF_rake_voucher", 1, EF.vars.v_rake_odds, "EF_rake_voucher") then
            self:set_edition("e_negative")
        end
    end
end

-- src/ui/snake.lua - arrow key movement support
local love_keypressed_ref = love.keypressed
function love.keypressed(key)
    if key == "up" or key == "down" or key == "left" or key == "right" then
        G.FUNCS.EF_snake_button({config={id="EF_snake_"..key}})
    end

    love_keypressed_ref(key)
end