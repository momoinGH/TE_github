local Ig = Ingredient

-- 对AddRecipe2的一层封装，添加校验和防止报错
function TroAddRecipe(name, ingredients, tech, config, filters)
    config = config or {}
    --配方秒速没写的时候补全配方描述
    local upperName = string.upper(name)
    if not STRINGS.RECIPE_DESC[upperName] then
        local desc = STRINGS.CHARACTERS.GENERIC.DESCRIBE[upperName]
        STRINGS.RECIPE_DESC[upperName] = type(desc) == "table" and next(desc) or desc
    end

    --防止我忘记给某些会生成蓝图配方的预制件起名字，然后就会在生成随机蓝图的时候报错
    if not (config.builder_tag or config.nounlock or STRINGS.NAMES[upperName]) then
        TroErrorHandle("配方名字缺失: " .. name, false)
        STRINGS.NAMES[upperName] = name
    end
    --防止配方没名字
    if not (STRINGS.NAMES[upperName] or STRINGS.NAMES[config.product]) then
        TroErrorHandle(name .. "配方没有名字")
        if config.product then
            STRINGS.NAMES[config.product] = config.product
        else
            STRINGS.NAMES[upperName] = name
        end
    end

    AddRecipe2(name, ingredients, tech, config, filters)
end

-- 命名和科雷保持一致，随便写几个
local level_str = {
    "ONE",
    "TWO",
    "THREE",
    "FOUR",
    "FIVE",
    "SIX",
    "SEVEN"
}

local TechTree = require("techtree")
---添加一个新科技，科技等级命名方式为TECH.XXX_ONE、TECH.XXX_TWO这种
---@param data.max_level number 最高科技等级，1-7，主要是给不同等级的配方使用，一般1、2就够用了
---@param data.has_filter boolean 是否给该科技添加专门的过滤器菜单
---@param data.atlas string 过滤器菜单的图标atlas
---@param data.image string 过滤器菜单的图标
function TroAddTech(tech, data)
    tech = string.upper(tech)
    data = data or {}
    local max_level = data.max_level or 1

    assert(max_level >= 1 and max_level <= #level_str, "科技等级上限不在有效范围内")

    table.insert(TechTree.AVAILABLE_TECH, tech)
    TECH.NONE[tech] = 0 --扩充一下TECH.NONE

    -- 有几级科技
    for i = 1, max_level do
        TECH[tech .. "_" .. level_str[i]] = { [tech] = i }
    end

    -- 每个配方需要的科技设置默认值
    for _, v in pairs(AllRecipes) do
        for i = 1, max_level do
            v.level[tech] = v.level[tech] or 0
        end
    end

    -- 新增一个制作栏，已经废弃
    -- RECIPETABS[tech .. "TAB"] = {
    --     str = tech .. "TAB",
    --     sort = 90,
    --     icon = data.image,
    --     icon_atlas = data.atlas,
    --     crafting_station = true,
    -- }

    -- 添加一个过滤器菜单
    if data.has_filter then
        if not (STRINGS.UI.CRAFTING_FILTERS[tech]) then
            TroErrorHandle("科技" .. tech .. "没有设置过滤器名", false)
            STRINGS.UI.CRAFTING_FILTERS[tech] = tech
        end
        AddRecipeFilter({
            name = tech,
            atlas = data.atlas or resolvefilepath(CRAFTING_ICONS_ATLAS),
            image = data.image or "filter_none.tex"
        })
    end
end

---注册原型机的科技
---@param data.action_str string: 靠近时交互文本，需要定义STRINGS.ACTIONS.OPEN_CRAFTING[data.action_str]的值
---@param data.icon_image string: 靠近时侧边栏图片
---@param data.icon_atlas string: 靠近时侧边栏图片的atlas
---@param data.is_crafting_station boolean: 是不是一个制作站，如果是就在单独的tab里显示配方
---@param data.trees table: 解锁的科技树，对应科雷的TUNING.PROTOTYPER_TREES.XXX变量的值
function TroAddPrototyperDef(prefab, data)
    if data.action_str and not STRINGS.ACTIONS.OPEN_CRAFTING[data.action_str] then
        TroErrorHandle("错误：你给原型机" .. prefab .. "指定了action_str的值为" .. tostring(data.action_str) .. ",但是没有找到STRINGS.ACTIONS.OPEN_CRAFTING." .. data.action_str .. "的值", false)
    end

    AddPrototyperDef(prefab, {
        action_str = data.action_str,
        icon_image = data.icon_image,
        icon_atlas = data.icon_atlas,
        is_crafting_station = data.is_crafting_station,
    })

    local trees = data.trees
    if trees then
        assert(type(trees) == "table")
        AddPrefabPostInit(prefab, function(inst)
            if not TheWorld.ismastersim then return end

            if not inst.components.prototyper then
                TroErrorHandle("错误：你给原型机" .. prefab .. "添加了科技，但是没有找到components.prototyper组件")
            elseif inst.components.prototyper.trees then
                --预制件文件里已经赋值了，这里不处理
            else
                inst.components.prototyper.trees = trees
            end
        end)
    end
end

---调整配方顺序
---@param id number|nil 不填/10/100
local function SortRecipe(a, b, filter_name, offset)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end
        table.insert(filter.recipes, target_position, a)
    end
end

local function SortAfter(a, b, filter_name) SortRecipe(a, b, filter_name, 1) end

----------------------------------------------------------------------------------------------------

-- Wedbber
TroAddRecipe("mutator_tropical", { Ig("monstermeat", 2), Ig("silk", 1), Ig("venomgland", 1) }, TECH.NONE, { builder_tag = "spiderwhisperer" }, { "CHARACTER" })
TroAddRecipe("mutator_frost", { Ig("monstermeat", 2), Ig("silk", 3), Ig("ice", 4) }, TECH.NONE, { builder_tag = "spiderwhisperer" }, { "CHARACTER" })
