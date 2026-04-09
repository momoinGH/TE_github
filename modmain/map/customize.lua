-- 世界生成选项
-- 数据从modinfo里获取，有world_gen字段就会加进来
-- 因为为了保证主客机数据一致并且modmain里能获取到数据，只能在把世界生成的选项都映射为mod配置项


----------------------------------------------------------------------------------------------------

-- 对configuration_options数据进行一些校验
for _, option in ipairs(modinfo.configuration_options) do
    if option.name ~= "" then --不考虑标题
        for _, opt in ipairs(option.options) do
            assert(type(opt.data) == "string" or type(opt.data) == "number", "modinfo的configuration_options配置数据只支持字符串和数字类型，请检查" .. option.name)
        end

        local gen = option.world_gen
        if gen then
            assert(gen.group and gen.world and type(gen.category) == "table", "modinfo的configuration_options配置数据的world_gen必须包含group和world，请检查" .. option.name)
            assert(tro_modules[gen.group], "世界生成数据的group必须是tro_modules中的一个，请检查" .. option.name .. ", " .. tostring(gen.group))
        end
    end
end

----------------------------------------------------------------------------------------------------

local default_options_enable = {
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_OFF, data = 0 },
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_ON, data = 1 },
}

-- 把coomon放第一个位置
local module_list = { tro_modules.common }
for _, m in pairs(tro_modules) do
    if m ~= tro_modules.common then
        table.insert(module_list, m)
    end
end

for _, m in ipairs(module_list) do
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
        AddCustomizeGroup(LEVELCATEGORY.SETTINGS, m, group_label, default_options_enable, nil, -1)
    end
    if has_worldgen then
        AddCustomizeGroup(LEVELCATEGORY.WORLDGEN, m, group_label, default_options_enable, nil, -1)
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

----------------------------------------------------------------------------------------------------
local function SetOptionValue(name, value)
    if not TheFrontEnd then return end

    local world_tabs
    for _, screen_in_stack in pairs(TheFrontEnd.screenstack) do
        if screen_in_stack.name == "ServerCreationScreen" then
            world_tabs = screen_in_stack.world_tabs
            break
        end
    end
    if not world_tabs then
        return
    end

    for _, tab in ipairs(world_tabs) do
        for _, w in ipairs({
            "settings_widget",
            "worldgen_widget"
        }) do
            widget = tab[w]
            optionitems = widget.settingslist.optionitems
            for i, item in ipairs(optionitems) do
                if item.option and item.option.name == name and table.contains(tro_modules, item.option.group) then
                    local opt = widget.settingslist.scroll_list:GetListWidgets()[i].opt_spinner
                    opt.spinner:SetSelected(value)
                    break
                end
            end
        end
    end
end

-- 初始化一下选项的值
for _, m in pairs(tro_modules) do
    for _, option in ipairs(modinfo.configuration_options) do
        local gen = option.world_gen
        if gen and gen.group == m and option.name ~= "" then
            SetOptionValue(option.name, GetModConfigData(option.name))
        end
    end
end

----------------------------------------------------------------------------------------------------

local config_sync_lock = false --防止递归

-- 修改世界生成时设置mod配置
local SettingsList = require("widgets/redux/worldsettings/settingslist")
Hooks.FnDecorator(SettingsList, "OnSpinnerChanged", function(self, option, spinner, value)
    if option and option.group and tro_modules[option.group] then
        -- print("世界生成修改", option.group, option.name, value)
        if not config_sync_lock then
            config_sync_lock = true
            KnownModIndex:SaveConfigurationOptions(function()
                -- print("保存成功")
            end, modname, { { name = option.name, saved = value } })
            config_sync_lock = false
        end
    end
end)

-- mod配置项修改时更新世界生成里的选项
Hooks.FnDecorator(KnownModIndex, "SetConfigurationOption", function(self, modn, option_name, value)
    if not config_sync_lock and modn == modname then
        config_sync_lock = true
        SetOptionValue(option_name, value)
        config_sync_lock = false
    end
end)
