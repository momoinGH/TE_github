-- 对configuration_options数据进行一些校验
for _, option in ipairs(modinfo.configuration_options) do
    if option.name ~= "" then --不考虑标题
        for _, opt in ipairs(option.options) do
            assert(type(opt.data) == "string" or type(opt.data) == "number", "modinfo的configuration_options配置数据只支持字符串和数字类型，请检查" .. option.name)
        end

        local gen = option.world_gen
        if gen then
            assert(gen.group and gen.world and type(gen.category) == "table", "modinfo的configuration_options配置数据的world_gen必须包含group和world，请检查" .. option.name)
            assert(pro_modules[gen.group], "世界生成数据的group必须是pro_modules中的一个，请检查" .. option.name)
        end
    end
end

----------------------------------------------------------------------------------------------------

local options_enable = {
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_OFF, data = "disabled" },
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_ON, data = "enabled" },
}

for _, m in pairs(pro_modules) do
    local has_settings = false
    local has_worldgen = false
    local group_label = m
    for _, option in ipairs(modinfo.configuration_options) do
        local gen = option.world_gen
        if gen and gen.group == m then
            if option.name == "" then
                group_label = option.label --这是个标题
            else
                has_settings = has_settings or table.contains(gen.category, LEVELCATEGORY.SETTINGS)
                has_worldgen = has_worldgen or table.contains(gen.category, LEVELCATEGORY.WORLDGEN)
            end
        end
    end
    -- 标题
    if has_settings then
        AddCustomizeGroup(LEVELCATEGORY.SETTINGS, m, group_label, options_enable, nil, -1)
    end
    if has_worldgen then
        AddCustomizeGroup(LEVELCATEGORY.WORLDGEN, m, group_label, options_enable, nil, -1)
    end

    -- 选项
    for _, option in ipairs(modinfo.configuration_options) do
        local gen = option.world_gen
        if gen and gen.group == m and option.name ~= "" then
            STRINGS.UI.CUSTOMIZATIONSCREEN[string.upper(option.name)] = option.label
            local desc = {}
            for _, v in ipairs(option.options) do
                table.insert(desc, { text = v.description, data = v.data })
            end

            local itemsettings = shallowcopy(gen)
            itemsettings.label = option.label
            itemsettings.desc = desc
            itemsettings.value = option.default
            itemsettings.image = itemsettings.image or "blank_world.tex" --没有图片会报错
            for _, c in ipairs(itemsettings.category) do
                AddCustomizeItem(c, m, option.name, itemsettings)
            end
        end
    end
end


local spinners = {}             --世界生成里的每个选项
local on_spiner_changed = false --防止递归

-- 修改世界生成时设置mod配置
local SettingsList = require("widgets/redux/worldsettings/settingslist")
Hooks.FnDecorator(SettingsList, "OnSpinnerChanged", function(self, option, spinner, value)
    if option and option.group and pro_modules[option.group] then
        -- print("世界生成修改", option.group, option.name, value)
        spinners[option.name] = spinner
        spinner._pro_option_name = option.name

        on_spiner_changed = true
        KnownModIndex:SaveConfigurationOptions(function()
            -- print("保存成功")
        end, modname, { { name = option.name, saved = value } })
        on_spiner_changed = false
    end
end)

-- mod配置项修改时更新世界生成里的选项
Hooks.FnDecorator(KnownModIndex, "SetConfigurationOption", function(self, modn, option_name, value)
    local spinner = spinners[option_name]
    if spinner and spinner.inst:IsValid() and not on_spiner_changed and modn == modname then
        spinner:SetSelected(value)
    end
end)
