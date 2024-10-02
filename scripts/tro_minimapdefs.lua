local ICONS = {}

local function AddIcon(prefab, atlas, tex)
    ICONS[prefab] = {
        atlas = atlas or "minimap/minimap_data2.xml",
        tex = tex or (prefab .. ".png")
    }
end

AddIcon("wilson")
AddIcon("sapling")
AddIcon("grass")
AddIcon("evergreen")

return ICONS
