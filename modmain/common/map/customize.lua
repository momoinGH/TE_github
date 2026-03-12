local worldsettings_overrides = require("worldsettings_overrides")

local function ItemPost(item)
    item.image = item.image or "blank_world.tex" --没有图片会报错
    STRINGS.UI.CUSTOMIZATIONSCREEN[string.upper(item.name)] = item.label
    worldsettings_overrides.Pre[item.name] = item.Pre
    worldsettings_overrides.Post[item.name] = item.Post
    worldsettings_overrides.Sync[item.name] = item.Sync
end

function ProAddCustomizeItems(group, settings_items, worldgen_items)
    for _, item in ipairs(settings_items) do
        ItemPost(item)
        AddCustomizeItem(LEVELCATEGORY.SETTINGS, group, item.name, item)
    end
    for _, item in ipairs(worldgen_items) do
        ItemPost(item)
        AddCustomizeItem(LEVELCATEGORY.WORLDGEN, group, item.name, item)
    end
end
