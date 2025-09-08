SMODS.Booster({
	key = "small_plant_booster",
	kind = "Joker",
	atlas = "Boosters",
	pos = { x = 0, y = 0 },
	config = {
		extra = 3,
		choose = 1,
	},
	cost = 4,
	weight = 1.5,
	loc_txt = {
		name = "Garden Pack",
		group_name = "Hello",
		text = { "Select {C:gold}#1#{} of {C:gold}#2#{} {C:ef_plant}Plant{} Jokers" },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	unlocked = true,
	discovered = true,
	create_card = function(self, card)
		return {
			set = "Joker",
			area = G.pack_cards,
			rarity = "EF_plant",
			skip_materialize = true,
			key_append = "Super random string ;)",
		}
	end,
})

SMODS.Booster({
	key = "minigame_booster",
	kind = "minigame_card",
	atlas = "Boosters",
	pos = { x = 1, y = 0 },
	config = {
		extra = 3,
		choose = 1,
	},
	cost = 4,
	weight = 0.75,
	loc_txt = {
		name = "Minigame Booster",
		group_name = "Hello",
		text = { "Select {C:gold}#1#{} of {C:gold}#2#{} {C:minigame_card}Minigame{} Cards" },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	unlocked = true,
	discovered = true,
	create_card = function(self, card)
		return {
			set = "minigame_card",
			area = G.pack_cards,
			skip_materialize = true,
			key_append = "Super random random string ;)",
		}
	end,
})
