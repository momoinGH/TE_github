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
            assert(tro_modules[gen.group], "世界生成数据的group必须是tro_modules中的一个，请检查" .. option.name)
        end
    end
end

----------------------------------------------------------------------------------------------------

local default_options_enable = {
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_OFF, data = 0 },
    { text = STRINGS.UI.WARDROBESCREEN.FILTER_ON, data = 1 },
}

for _, m in pairs(tro_modules) do
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

local spinners = {}            --世界生成里的每个选项
local config_sync_lock = false --防止递归

local function SetOptionValue(group, name, value)
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
        optionitems = tab.settings_widget.settingslist.optionitems
        for _, item in ipairs(optionitems) do
            local option = item.option
            if option then
                if (group == nil or option.group == group) and option.name == name then
                    -- TODO
                end
            end
        end
    end
end


-- option:
--  options:
--   1:
--    data: 0
--    text: 禁用
--   2:
--    data: 1
--    text: 启用
--  image: fog.tex
--  name: fog
--  widget_type: optionsspinner
--  group: hamlet
--  default: 1
--  atlas: images/scrapbook_tropical/scrapbook_hamlet.xml
--  grouplabel: <哈姆雷特>

-- 修改世界生成时设置mod配置
local SettingsList = require("widgets/redux/worldsettings/settingslist")
Hooks.FnDecorator(SettingsList, "OnSpinnerChanged", function(self, option, spinner, value)
    if option and option.group and tro_modules[option.group] then
        -- print("世界生成修改", option.group, option.name, value)
        spinners[option.name] = spinner

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
    local spinner = spinners[option_name]
    if spinner and spinner.inst:IsValid() and not config_sync_lock and modn == modname then
        config_sync_lock = true
        spinner:SetSelected(value)
        config_sync_lock = false
    end
end)
