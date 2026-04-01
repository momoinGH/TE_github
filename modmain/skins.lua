-- 允许皮肤合并的物品，即便皮肤不一样也能合并
skin_can_combine_prefabs = {
    cutgrass = true,
    log = true
}

modimport("modmain/skinsapi") --调用皮肤api  来自穹

local itemskinlist = require("datadefs/skin_item_defs").skinlist
for prefabname, prefabdata in pairs(itemskinlist) do
    for skinname, skindata in pairs(prefabdata) do
        local assetname = skindata.assetname or skindata.build or skindata.skinname
        table.insert(Assets, Asset("ANIM", "anim/" .. assetname .. ".zip"))
        MakeItemSkin(skindata.prefabname, skindata.skinname, skindata)
    end
end

local natureskinlist = require("datadefs/skin_nature_defs").skinlist
for prefabname, prefabdata in pairs(natureskinlist) do
    for skinname, skindata in pairs(prefabdata) do
        -- PREFAB_SKINS_SHOULD_NOT_SELECT[skinname] = true --不能用扫帚扫这些皮肤
        local assetname = skindata.assetname or skindata.build or skindata.skinname
        table.insert(Assets, Asset("ANIM", "anim/" .. assetname .. ".zip"))
        MakeItemSkin(skindata.prefabname, skindata.skinname, skindata)
    end
end

----------------------------------------------------------------------------------------------------
-- 根据主题查找相关皮肤
local function GetRelatedSkin(prefab, source)
    local skinname = source:GetSkinName()
    if not skinname then
        return nil
    end

    if prefab == source.prefab then
        return skinname --同款皮肤
    end

    local theme = natureskinlist[source.prefab] and natureskinlist[source.prefab][skinname] and natureskinlist[source.prefab][skinname].theme
    if not theme then
        return nil --来源没有主题
    end

    local skins = natureskinlist[prefab]
    if not skins then
        return nil --prefab这个东西没皮肤
    end

    for name, skindata in pairs(skins) do
        if skindata.theme == theme then
            return name
        end
    end
end

-- 在挖起时生成对应皮肤预制件，这里扩展一下
AddComponentPostInit("lootdropper", function(self)
    Hooks.FnDecorator(self, "SpawnLootPrefab", function(self, lootprefab, pt, linked_skinname, ...)
        if not linked_skinname then
            linked_skinname = GetRelatedSkin(lootprefab, self.inst)
            return nil, false, { self, lootprefab, pt, linked_skinname, ... }
        end
    end)
end)


AddComponentPostInit("pickable", function(self)
    Hooks.FnDecorator(self, "SpawnProductLoot", nil, function(retTab, self)
        local loot = retTab[1] --loot有可能是表
        if not loot then
            return retTab
        end

        loot = EntityScript.is_instance(loot) and { loot } or loot
        for _, v in ipairs(loot) do
            if v:IsValid() then
                local skinname = GetRelatedSkin(v.prefab, self.inst)
                if skinname then
                    TheSim:ReskinEntity(v.GUID, v.skinname, skinname)
                end
            end
        end
        return retTab
    end)
end)

-- 自动关联皮肤，在种下去时有对应的皮肤，hook deployable也行
AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end

    if string.starts(inst.prefab, "dug_") then --延迟一帧，现在GetSkinName还没有皮肤
        inst:DoTaskInTime(0, function(inst)
            if not inst.linked_skinname then
                local plant = string.sub(inst.prefab, 5)
                inst.linked_skinname = GetRelatedSkin(plant, inst) --尝试关联皮肤
            end
        end)
    end
end)

----------------------------------------------------------------------------------------------------
-- 允许将两个不同皮肤的物品合并
AddComponentPostInit("inventory", function(self)
    local OldAddAllOfActiveItemToSlot = self.AddAllOfActiveItemToSlot
    function self:AddAllOfActiveItemToSlot(slot, ...)
        local active_item = self:GetActiveItem()
        local item = self:GetItemInSlot(slot)
        if active_item ~= nil and
            item ~= nil and
            self:CanTakeItemInSlot(active_item, slot) and
            item.prefab == active_item.prefab and
            skin_can_combine_prefabs[item.prefab] and
            item.skinname ~= active_item.skinname and --皮肤不相等
            item.components.stackable ~= nil and
            self:AcceptsStacks() then
            local old_skinname = active_item.skinname
            active_item.skinname = item.skinname --允许合并
            local leftovers = item.components.stackable:Put(active_item)
            active_item.skinname = old_skinname
            self:SetActiveItem(leftovers)
        end

        return OldAddAllOfActiveItemToSlot(self, slot, ...)
    end
end)
