local Customize = require("map/customize")
-- Customize.ITEM_EXPORTS.options = function(item, location) return FunctionOrValue(item.desc or item.group.desc, location) end


local worldsettings_overrides = require("worldsettings_overrides")

TUNING.TE_WORLDGEN = {} --世界生成数据

local MOD_WORLDSETTINGS_GROUP = Hooks.FindUpvalue(AddCustomizeGroup, "MOD_WORLDSETTINGS_GROUP")
local MOD_WORLDGEN_GROUP = Hooks.FindUpvalue(AddCustomizeGroup, "MOD_WORLDGEN_GROUP")
if not (MOD_WORLDSETTINGS_GROUP and MOD_WORLDGEN_GROUP) then
    print("自定义组求上值失败，不再校验")
end
local function ItemPost(group, item, category)
    -- 数据校验
    local MOD_GROUP
    if category == LEVELCATEGORY.SETTINGS then
        MOD_GROUP = MOD_WORLDSETTINGS_GROUP
    elseif category == LEVELCATEGORY.WORLDGEN then
        MOD_GROUP = MOD_WORLDGEN_GROUP
    end
    if MOD_GROUP then
        local group_data = MOD_GROUP[modname] and MOD_GROUP[modname][group] or nil
        prodevassert(group_data, "必须先使用AddCustomizeGroup定义自定义组", group, item.name)
        local desc = item.desc or group_data.desc
        prodevassert(desc, "该设置没有定义选项", group, item.name)
        for _, v in ipairs(desc) do
            prodevassert(type(v.data) == "string" or type(v.data) == "number", "选项类型必须是字符串或数字", group, item.name, v.data) --不能是bool
        end
    end

    item.image = item.image or "blank_world.tex" --没有图片会报错
    STRINGS.UI.CUSTOMIZATIONSCREEN[string.upper(item.name)] = item.label
    worldsettings_overrides.Pre[item.name] = item.Pre or function(difficulty)
        prodevassert(TUNING.TE_WORLDGEN[item.name] == nil, "已经定义过TUNING.tropical." .. tostring(item.name) .. "，请检查是否重复定义")
        TUNING.TE_WORLDGEN[item.name] = difficulty
    end
    worldsettings_overrides.Post[item.name] = item.Post
    worldsettings_overrides.Sync[item.name] = item.Sync
end

function ProAddCustomizeItems(group, settings_items, worldgen_items)
    for _, item in ipairs(settings_items) do
        ItemPost(group, item, LEVELCATEGORY.SETTINGS)
        AddCustomizeItem(LEVELCATEGORY.SETTINGS, group, item.name, item)
    end
    for _, item in ipairs(worldgen_items) do
        ItemPost(group, item, LEVELCATEGORY.WORLDGEN)
        AddCustomizeItem(LEVELCATEGORY.WORLDGEN, group, item.name, item)
    end
end

-- 使用示例
-- local group = "hamlet"
-- local group_label = "哈姆雷特"
-- AddCustomizeGroup(LEVELCATEGORY.SETTINGS, group, group_label, nil, nil, -1)

-- -- 世界规则
-- local settings_items = {
--     {
--         name = "wind", --设置id，如果Pre没填可以通过TUING.TE_WORLDGEN[name]访问
--         label = "海风",
--         desc = {       --选项列表，data不要用true和false，建议字符串
--             { text = "关闭", data = "none" },
--             { text = "开启", data = "always" },
--         },
--         value = "always", --默认值
--         -- atlas = nil,
--         -- image = "liefs.tex", --图片
--         order = -1,                   --优先级，越小越在前面
--         world = { "forest", "cave" }, --在世界和洞穴的世界规则中显示
--         -- master_controlled = nil,
--         -- masteroption = nil,
--         -- master_sync = nil,
--         -- widget_type = nil,
--         -- options_remap = {},
--         Pre = function(difficulty) --赋值，在加载游戏的时候会调用，不填就默认是TUNING.TE_WORLDGEN[name] = value
--             OverrideTuningVariables({
--                 pro_wind = difficulty == "always" and true or false
--             })
--             -- 相当于TUNING.TE_WORLDGEN.pro_wind = true
--         end,
--         Post = function(difficulty) --一般推送事件使用，Post里才有TheWorld对象
--             TheWorld:PushEvent("pro_setwind", difficulty)
--         end
--     }
-- }

-- -- 世界生成
-- local worldgen_items = {

-- }

-- ProAddCustomizeItems(group, settings_items, worldgen_items)
