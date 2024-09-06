local Utils = require("tropical_utils/utils")
local cooking = require("cooking")
local ingredients = cooking.ingredients

--- 冶炼炉使用
local Attributes = {
    greengem = { gem = 27, }, -- gem
    yellowgem = { gem = 9, },
    orangegem = { gem = 3, },
    purplegem = { gem = 1, },
    bluegem = { gem = .5, },
    redgem = { gem = .5, },
    iron = { iron = 1, }, -- iron
    magnifying_glass = { iron = 1, },
    goldpan = { iron = 1, },
    ballpein_hammer = { iron = 1, },
    shears = { iron = 1, },
    candlehat = { iron = 1, },
    obsidian = { nitro = 2.5, }, -- nitro
    nitre = { nitro = 1, },
    flint = { nitro = .25, },
    goldnugget = { gold = 1, }, -- gold
    dubloon = { gold = .5, },
    gold_dust = { gold = .25, },
    rocks = { mineral = .25, }, -- mineral
}

for name, tags in pairs(Attributes) do
    if ingredients[name] then
        -- 已经有该配方数据了，不能覆盖，只能追加标签
        for tagname, tagval in pairs(tags) do
            ingredients[name].tags[tagname] = tagval
        end
    else
        AddIngredientValues({ name }, tags)
    end
end


-- 熔炼
local Smelter = require("smeltrecipes")
for _, d in pairs(Smelter) do
    AddCookerRecipe("smelter", d)
end
