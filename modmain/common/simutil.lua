-- No more inventoryitem atlas register
local InvAtlas = { "frost", "greenworld", "grotto", "hamlet", "lavaarena", "quagmire", "rog", "shipwrecked_plus",
    "shipwrecked", "underwater", "windy", "skins" }
for i = 1, #InvAtlas do
    InvAtlas[i] = "images/inventoryimages/inventory_" .. InvAtlas[i] .. ".xml"
    table.insert(Assets, Asset("ATLAS", InvAtlas[i]))
    table.insert(Assets, Asset("ATLAS_BUILD", InvAtlas[i], 256)) -- for minisign
    InvAtlas[i] = resolvefilepath(InvAtlas[i])
end
local FoodAtlas = { "frost", "ham", "quagmire", "sw", "underwater" }
for i = 1, #FoodAtlas do
    FoodAtlas[i] = "images/inventoryimages/cookpotfoods/cookpotfoods_" .. FoodAtlas[i] .. ".xml"
    table.insert(Assets, Asset("ATLAS", FoodAtlas[i]))
    table.insert(Assets, Asset("ATLAS_BUILD", FoodAtlas[i], 256)) -- for minisign
    FoodAtlas[i] = resolvefilepath(FoodAtlas[i])
end
local MiMapAtlas = { "frost", "volcano", "grotto", "hamlet", "lavaarena", "quagmire", "rog", "shipwrecked_plus",
    "shipwrecked", "underwater", "windy" }
for i = 1, #MiMapAtlas do
    MiMapAtlas[i] = "minimap/minimap_" .. MiMapAtlas[i] .. ".xml"
    table.insert(Assets, Asset("ATLAS", MiMapAtlas[i]))
    AddMinimapAtlas(MiMapAtlas[i])
    MiMapAtlas[i] = resolvefilepath(MiMapAtlas[i])
end

-- hook这个函数实现通过图片名找图集文件
local OldGetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal
GLOBAL.GetInventoryItemAtlas_Internal = function(imagename, no_fallback, ...)
    for _, atlas in ipairs(InvAtlas) do
        if TheSim:AtlasContains(atlas, imagename) then
            return atlas
        end
    end
    for _, atlas in ipairs(FoodAtlas) do
        if TheSim:AtlasContains(atlas, imagename) then
            return atlas
        end
    end
    for _, atlas in ipairs(MiMapAtlas) do
        if TheSim:AtlasContains(atlas, imagename) then
            return atlas
        end
    end

    return OldGetInventoryItemAtlas_Internal(imagename, no_fallback, ...)
end

local OldGetMinimapAtlas_Internal = GetMinimapAtlas_Internal
GLOBAL.GetMinimapAtlas_Internal = function(imagename, ...)
    for _, atlas in ipairs(MiMapAtlas) do
        if TheSim:AtlasContains(atlas, imagename) then
            return atlas
        end
    end
    return OldGetMinimapAtlas_Internal(imagename, ...)
end

----------------------------------------------------------------------------------------------------
-- 把查找失败的图片名记录下来，下次不再查找，算是一个小优化吧
local fail_inv_imagenames = {}
local OldGetInventoryItemAtlas = GetInventoryItemAtlas
GLOBAL.GetInventoryItemAtlas = function(imagename, no_fallback, ...)
    if imagename and fail_inv_imagenames[imagename] then
        return nil
    end
    local atlas = OldGetInventoryItemAtlas(imagename, no_fallback, ...)
    if not atlas then
        fail_inv_imagenames[imagename] = true
    end
    return atlas
end

local fail_minimap_imagenames = {}
local OldGetMinimapAtlas = GetMinimapAtlas
GLOBAL.GetMinimapAtlas = function(imagename, ...)
    if imagename and fail_minimap_imagenames[imagename] then
        return nil
    end
    local atlas = OldGetMinimapAtlas(imagename, ...)
    if not atlas then
        fail_minimap_imagenames[imagename] = true
    end
    return atlas
end
