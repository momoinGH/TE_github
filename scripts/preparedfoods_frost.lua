-- 贴图与动画
-- local overridebuild_frost = ""
local cookbook_atlas_frost = "images/inventoryimages/volcanoinventory.xml"
local inventoryitems_atlas_frost = "images/inventoryimages/volcanoinventory.xml"

-- 食谱
local foods_frost = {
    fruityjuice = {
        test = function(cooker, names, tags)
            return names.blueberries_cooked and names.blueberries_cooked == 2 and names.foliage and tags.frozen or
                       names.blueberries and names.blueberries == 2 and names.foliage and tags.frozen
        end,
        priority = 1,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_MED,
        perishtime = TUNING.PERISH_FAST,
        hunger = TUNING.CALORIES_LARGE,
        sanity = TUNING.SANITY_TINY,
        cooktime = 2,
        tags = {},
        card_def = {ingredients = {{"blueberries", 2}, {"foliage", 2} } },
    }
}

for k, v in pairs(foods_frost) do
    v.name = k
    v.basename = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    -- v.overridebuild = overridebuild_frost 
    v.floater = v.floater or {"small", 0.05, 0.7}
    v.mod = true
    -- v.cookbook_tex = k..".tex" --独立贴图用这个
    v.cookbook_atlas = cookbook_atlas_frost
    v.atlasname = inventoryitems_atlas_frost
    if v.oneatenfn then
        v.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(k)]
    end
end

return foods_frost