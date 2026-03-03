-- 自定义打印函数，就是简单的把内容拼接在一起，和科雷不同的事不会在每个元素之间加空格
function conprint(...)
    local result = ""
    for i, arg in ipairs({ ... }) do
        result = result .. tostring(arg)
    end
    print(result)
end

GLOBAL.conprint = conprint

----------------------------------------------------------------------------------------------------

--对于忘记写STRINGS.NAMES.XXX的配方，在prefabs/blueprint.lua生成蓝图时会崩溃
local function CanBlueprintRandomRecipe(recipe)
    if recipe.nounlock or recipe.builder_tag ~= nil then
        --Exclude crafting station and character specific
        return false
    end
    local hastech = false
    for k, v in pairs(recipe.level) do
        if v >= 10 then
            --Exclude TECH.LOST
            return false
        elseif v > 0 then
            hastech = true
        end
    end
    --Exclude TECH.NONE
    return hastech
end

AddRecipePostInitAny(function(v)
    if (v.require_special_event == nil or IsSpecialEventActive(v.require_special_event))
        and CanBlueprintRandomRecipe(v)
    then
        local uppername = string.upper(v.name)
        if not STRINGS.NAMES[uppername] then
            STRINGS.NAMES[uppername] = "STRINGS.NAMES." .. uppername .. "未赋值"
            print("LUA ERROR stack traceback:\n提示：STRINGS.NAMES." .. uppername .. "未赋值，生成蓝图时会报错")
        end
    end
end)
