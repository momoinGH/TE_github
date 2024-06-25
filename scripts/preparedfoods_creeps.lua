-- 贴图与动画
-- local overridebuild_creeps = ""
local cookbook_atlas_creeps = "images/inventoryimages/creepindeep_cuisine.xml"
local inventoryitems_atlas_creeps = "images/inventoryimages/creepindeep_cuisine.xml"


-- 食谱
local foods_creeps = {
    sponge_cake = {
        test = function(cooker, names, tags) return tags.dairy and tags.sweetener and tags.sponge and tags.sponge >= 2 and not tags.meat end,
        priority = 0,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 0,
        hunger = 25,
        sanity = 50,
        perishtime = TUNING.PERISH_SUPERFAST,
        cooktime = .5,
        tags = { "honeyed" },
        card_def = {ingredients = {{"sweet_potato", 2}, {"bird_egg", 2}} },
    },

    fish_n_chips = {
        test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.veggie and tags.veggie >= 2 end,
        priority = 10,
        weight = 1,
        health = 25,
        hunger = 42.5,
        sanity = 10,
        perishtime = TUNING.PERISH_FAST,
        cooktime = 1,
        tags = {},
    },

    tuna_muffin = {
        test = function(cooker, names, tags) return tags.fish and tags.fish >= 1 and tags.sponge and tags.sponge >= 1 and not tags.twigs end,
        priority = 5,
        weight = 1,
        health = 0,
        hunger = 32.5,
        sanity = 10,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        tags = {},
    },

    tentacle_sushi = {
        test = function(cooker, names, tags) return tags.tentacle and tags.tentacle and tags.sea_veggie and tags.fish >= 0.5 and not tags.twigs end,
        priority = 0,
        weight = 1,
        health = 35,
        hunger = 5,
        sanity = 5,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        tags = {},
    },

    flower_sushi = {
        test = function(cooker, names, tags) return tags.flower and tags.sea_veggie and tags.fish and tags.fish >= 1 and not tags.twigs end,
        priority = 0,
        weight = 1,
        health = 10,
        hunger = 5,
        sanity = 30,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        tags = {},
    },

    fish_sushi = {
        test = function(cooker, names, tags) return tags.tentacle and tags.veggie >= 1 and tags.fish and tags.fish >= 1 and not tags.twigs end,
        priority = 0,
        weight = 1,
        health = 5,
        hunger = 50,
        sanity = 0,
        perishtime = TUNING.PERISH_MED,
        cooktime = 2,
        tags = {},
    },

    seajelly = {
		test = function(cooker, names, tags) return tags.sea_jelly and tags.sea_jelly > 1 and names.saltrock and names.saltrock > 1 and not tags.meat end,
		priority = 0,
		weight = 1,
		health = 20,
		hunger = 40,
		sanity = 3,
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 2,
        tags = {},
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
