-- 贴图与动画
-- local overridebuild_creeps = ""
local cookbook_atlas_creeps = "images/inventoryimages/creepindeep_cuisine.xml"
local inventoryitems_atlas_creeps = "images/inventoryimages/creepindeep_cuisine.xml"


-- 食谱
local foods_creeps = {
    sponge_cake = {
        test = function(cooker, names, tags) return tags.dairy and tags.sweetener and tags.sponge and tags.sponge >= 2 and not tags.meat end,
        foodtype = FOODTYPE.GOODIES,
        health = 0,
        hunger = 25,
        sanity = 50,
        perishtime = TUNING.PERISH_SUPERFAST,
        cooktime = .5,
        tags = { "honeyed" },
        card_def = {ingredients = {{"sponge_piece", 2}, {"goatmilk", 1}, {"honey", 1}} },
    },

    fish_n_chips = {
        test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.veggie and tags.veggie >= 2 end,
        priority = 10,
        health = 25,
        hunger = 42.5,
        sanity = 10,
        perishtime = TUNING.PERISH_FAST,
        cooktime = 1,
        card_def = {ingredients = {{"fish_fillet", 2}, {"potato", 2} } },
    },

    tuna_muffin = {
        test = function(cooker, names, tags) return tags.fish and tags.fish >= 1 and tags.sponge and tags.sponge >= 1 and not tags.twigs end,
        priority = 5,
        health = 0,
        hunger = 32.5,
        sanity = 10,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        card_def = {ingredients = {{"fish_fillet", 1}, {"sponge_piece", 1}, {"carrot", 2}} },
    },

    tentacle_sushi = {
        test = function(cooker, names, tags) return tags.tentacle and tags.tentacle > 1 and tags.sea_veggie and tags.fish >= 0.5 and not tags.twigs end,
        health = 35,
        hunger = 5,
        sanity = 5,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        card_def = {ingredients = {{"trinket_12", 2}, {"fish_fillet", 2} } },
    },

    flower_sushi = {
        test = function(cooker, names, tags) return tags.flower and tags.sea_veggie and tags.fish and tags.fish >= 1 and not tags.twigs end,
        health = 10,
        hunger = 5,
        sanity = 30,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        card_def = {ingredients = {{"sea_petals", 1}, {"seagrass_chunk", 1}, {"fish_fillet", 2} } },
    },

    fish_sushi = {
        test = function(cooker, names, tags) return tags.tentacle and tags.veggie >= 1 and tags.fish and tags.fish >= 1 and not tags.twigs end,
        health = 5,
        hunger = 50,
        sanity = 0,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        card_def = {ingredients = {{"trinket_12", 1}, {"fish_fillet", 1}, {"seagrass_chunk", 2} } },
    },

    seajelly = {
		test = function(cooker, names, tags) return tags.sea_jelly and tags.sea_jelly > 1 and names.saltrock and names.saltrock > 1 and not tags.meat end,
		health = 20,
		hunger = 40,
		sanity = 3,
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 2,
        card_def = {ingredients = {{"jelly_cap", 2}, {"saltrock", 2} } },
    },
    
    fish_gazpacho = {
        test = function(cooker, names, tags) return (names.fish_fillet or names.fish_fillet_cooked) and tags.veggie and tags.veggie >= 1 and tags.frozen and tags.frozen >= 2 end,
        priority = 35, -- or 10?
        health = TUNING.HEALING_MED - TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_LARGE,
        sanity = TUNING.SANITY_SUPERTINY,
        perishtime = TUNING.PERISH_FAST,
        cooktime = 1,
        card_def = {ingredients = {{"fish_fillet", 1}, {"seagrass_chunk", 1}, {"ice", 2}} },
    },
}

for k, v in pairs(foods_creeps) do
    v.name = k
    v.basename = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.foodtype = v.foodtype or FOODTYPE.MEAT -- 除了海绵蛋糕都是肉
    -- v.overridebuild = overridebuild_creeps --Auto generation: overridebuild = name
    v.floater = v.floater or {"small", 0.05, 0.7}
    v.mod = true
    -- v.cookbook_tex = k..".tex" --独立贴图用这个
    v.cookbook_atlas = cookbook_atlas_creeps
    v.atlasname = inventoryitems_atlas_creeps
    if v.oneatenfn then
        v.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(k)]
    end
end

return foods_creeps
