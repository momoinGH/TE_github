local group = "hamlet"
local group_label = "哈姆雷特"
AddCustomizeGroup(LEVELCATEGORY.SETTINGS, group, group_label, nil, nil, -1)

-- 世界规则
local settings_items = {
    {
        name = "wind",
        label = "海风",
        category = LEVELCATEGORY.SETTINGS,
        desc = {
            { text = "关闭", data = "none" },
            { text = "开启", data = "always" },
        },
        value = "always",
        -- atlas = nil,
        -- image = "liefs.tex",
        order = -1,
        world = { "forest", "cave" },
        -- master_controlled = nil,
        -- masteroption = nil,
        -- master_sync = nil,
        -- widget_type = nil,
        -- options_remap = {},
        Pre = function(difficulty)
            OverrideTuningVariables({
                pro_wind = difficulty == "always" and true or false
            })
        end,
        Post = function(difficulty)
            TheWorld:PushEvent("pro_setwind", difficulty)
        end
    }
}

-- 世界生成
local worldgen_items = {

}


ProAddCustomizeItems(group, settings_items, worldgen_items)
