local group = "hamlet"
local group_label = "哈姆雷特"
AddCustomizeGroup(LEVELCATEGORY.SETTINGS, group, group_label, nil, nil, -1)

local options_enable = {
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_ON, data = "enabled" },
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_OFF, data = "disabled" },
}

local hamlet_atlas = "images/scrapbook_tropical/scrapbook_hamlet.xml"

-- 世界规则
local settings_items = {
    {
        name = "hamlet",       --设置id，如果Pre没填可以通过TUING.TE_WORLDGEN[name]访问
        label = proenzh("Hamlet", "哈姆雷特"),
        desc = options_enable, --选项列表
        value = "enabled",     --默认值
        -- atlas = nil,
        -- image = "liefs.tex", --图片
        order = -1,                --优先级，越小越在前面
        world = { "forest" },      --在世界和洞穴的世界规则中显示
        Pre = function(difficulty) --赋值
            TUNING.tropical.hamlet = difficulty == "enabled" and true or false
        end,
    },
    {
        name = "vampirebatcave",
        label = "洞穴裂缝",
        desc = options_enable,
        value = "enabled",
        atlas = hamlet_atlas,
        image = "vampire_bat_caves.tex",
        world = { "forest" },
    }
}

-- 世界生成
local worldgen_items = {

}

ProAddCustomizeItems(group, settings_items, worldgen_items)
