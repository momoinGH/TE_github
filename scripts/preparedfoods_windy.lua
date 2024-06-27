
-- 贴图与动画
-- local overridebuild_windy = "" -- 动画
-- local cookbook_atlas_windy = "" -- 烹饪指南大图路径
-- local inventoryitems_atlas_windy = "" -- 物品栏贴图路径

-- 食谱
local foods_windy = {
    peach_smoothie = {
        test = function(cooker, names, tags)
            return (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.dairy and
                       tags.sweetener and not tags.meat and not tags.egg and not tags.inedible and not tags.monster
        end,
        priority = 100,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 10,
        hunger = 65,
        sanity = 10,
        perishtime = TUNING.PERISH_MED,
        tags = { "honeyed" },
        card_def = {ingredients = {{"peach", 2}, {"goatmilk", 1}, {"honey", 1} } },
    },

    peach_kabobs = {
        test = function(cooker, names, tags)
            return (names.peach or names.grilled_peach) and names.twigs and tags.veggie and tags.veggie >= 1 and
                       tags.meat and tags.meat >= 1 and not tags.egg and not tags.monster
        end,
        priority = 100,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 3,
        hunger = 75,
        sanity = 5,
        perishtime = TUNING.PERISH_MED,
        card_def = {ingredients = {{"peach", 1}, {"carrot", 1}, {"meat", 1}, {"twigs", 1}} },
    },

    peachy_meatloaf = {
        test = function(cooker, names, tags)
            return (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.meat and
                       tags.meat >= 2 and not tags.egg
        end,
        priority = 100,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 10,
        hunger = 80,
        sanity = 5,
        perishtime = TUNING.PERISH_SLOW,
        card_def = {ingredients = {{"peach", 2}, {"meat", 2} } },
    },

    caramel_peach = {
        test = function(cooker, names, tags)
            return (names.peach or names.grilled_peach) and tags.sweetener and tags.sweetener >= 2 and names.twigs and
                       not tags.meat and not tags.egg and not tags.monster
        end,
        priority = 100,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 40,
        hunger = 45,
        sanity = 5,
        perishtime = TUNING.PERISH_SLOW,
        tags = { "honeyed" },
        card_def = {ingredients = {{"peach", 1}, {"honey", 2}, {"twigs", 1} } },
    },

    -- Runar: 没有适配调味的必要
    -- peach_juice_bottle_green = {
    --     test = function(cooker, names, tags)
    --         return
    --             (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.sweetener and
    --                 tags.water and not tags.meat and not tags.egg and not tags.monster
    --     end,
    --     priority = 100,
    --     weight = 1,
    --     foodtype = FOODTYPE.GOODIES,
    --     health = 15,
    --     hunger = 35,
    --     sanity = 5,
    --     tags = { "honeyed" },
    --     card_def = {ingredients = {{"peach", 2}, {"honey", 1}, {"full_bottle_green", 1} } },
    -- },

    -- potion_bottle_green = {
    --     test = function(cooker, names, tags)
    --         return tags.peachy and tags.goddessmagic and tags.loaf and (names.peach or names.grilled_peach)
    --     end,
    --     priority = 100,
    --     weight = 1,
    --     foodtype = FOODTYPE.GOODIES,
    --     health = 75,
    --     hunger = 75,
    --     sanity = 75,
    --     card_def = {ingredients = {{"peach", 1}, {"peach_juice_bottle_green", 1}, {"peachy_meatloaf", 1}, {"magicpowder", 1} } },
    -- },

    peach_custard = {
        test = function(cooker, names, tags)
            return (names.peach or names.grilled_peach) and tags.egg and tags.sweetener and
                       (names.peach or names.grilled_peach) >= 2 and not names.twigs and not tags.meat and
                       not tags.monster
        end,
        priority = 100,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 20,
        hunger = 62,
        sanity = 5,
        perishtime = TUNING.PERISH_SLOW,
        card_def = {ingredients = {{"peach", 2}, {"honey", 1}, {"bird_egg", 1} } },
    },
}

for k, v in pairs(foods_windy) do
    v.name = k
    v.basename = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    -- v.overridebuild = overridebuild_windy
    v.cooktime = .5 -- All the same
    v.floater = v.floater or {"small", 0.05, 0.7}
    v.mod = true
    -- v.cookbook_tex = k..".tex" --独立贴图用这个
    -- v.cookbook_atlas = cookbook_atlas_windy
    v.cookbook_atlas = "images/inventoryimages/"..k..".xml"
    v.atlasname = "images/inventoryimages/"..k..".xml"
    if v.oneatenfn then
        v.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(k)]
    end
end

return foods_windy
