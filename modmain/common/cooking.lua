local cooking = require("cooking")
-- 更新已有食材的标签值
function TroUpdateCookingIngredientTags(names, newtags)
    for _, name in ipairs(names) do
        for tag, value in pairs(newtags) do
            cooking.ingredients[name].tags[tag] = value
            if cooking.ingredients[name .. "_cooked"] ~= nil then
                cooking.ingredients[name .. "_cooked"].tags[tag] = value
            end
        end
    end
end
