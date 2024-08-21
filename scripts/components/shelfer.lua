local Shelfer = Class(function(self, inst)
    self.inst = inst
    self.enabled = true
end)

function Shelfer:OnSave()
    local data = {}
    local references = {}
    data.enabled = self.enabled
    data.slot = self.slot
    data.slotindex = self.slotindex
    if self.shelf then
        data.shelf = self.shelf.GUID
        table.insert(references, self.shelf.GUID)
    end
    return data, references
end

function Shelfer:OnLoad(data)
    self.enabled = data.enabled
    if data.slot then
        self.slot = data.slot
    end
    if not data.slotindex then
        if data.slot == "SWAP_SIGN" then
            self.slotindex = 1
        else
            local slot = data.slot
            local prefix = slot:sub(1, 8)
            assert(prefix == "SWAP_img")
            self.slotindex = tonumber(slot:sub(9))
        end
    else
        self.slotindex = data.slotindex
    end
end

function Shelfer:LoadPostPass(newents, data)
    if data.shelf and newents[data.shelf] then
        self.shelf = newents[data.shelf].entity
        self:SetArt()
    end
end

function Shelfer:IsTryingToTradeWithMe(inst)
    local act = inst:GetBufferedAction()
    if act then
        return act.target == self.inst and act.action == ACTIONS.GIVE
    end
end

function Shelfer:Enable()
    self.enabled = true
    -- do I have an underlying item?

    self.inst:AddTag("slot_one")
end

function Shelfer:Disable()
    self.enabled = false
    self.inst:RemoveTag("slot_one")
end

function Shelfer:SetShelf(shelf, slot)
    self.shelf = shelf
    self.slot = slot
end

function Shelfer:GetGift()
    return self.shelf.components.container:GetItemInSlot(self.slotindex)
end

function Shelfer:GiveGift()
    self.inst:RemoveTag("slot_one")
    self.shelf.SetImageFromName(self.shelf, nil, self.slot)
    local item = self.shelf.components.container:RemoveItemBySlot(self.slotindex)
    return self:ReturnGift(item)
end

function Shelfer:CanAccept(item, giver)
    local frozen = self.inst.components.freezable and self.inst.components.freezable:IsFrozen()
    local inventortyitem = item.components.inventoryitem ~= nil
    local item = self.shelf.components.container:GetItemInSlot(self.slotindex)
    local player_to_shop = not self.shelf:HasTag("playercrafted") and giver and giver:HasTag("player")

    return self.enabled
        and inventortyitem     --物品
        and not frozen         --没有冻结
        and not item           --槽位当前空缺
        and not player_to_shop --非购买
end

function Shelfer:SetArt()
    local item = self.shelf.components.container:GetItemInSlot(self.slotindex)

    if item then
        self.shelf:SetImage(item, self.slot)
        -- self.inst:SetPrefabNameOverride(item.components.inspectable.nameoverride or item.prefab) -- 不开洞穴会显示名字，但是开启洞穴后不行
        self.inst.components.named:SetName(STRINGS.NAMES
            [string.upper(item.components.inspectable.nameoverride or item.prefab)])
    else
        self.inst:RemoveTag("slot_one")
    end
end

function Shelfer:ReturnGift(item)
    if item then
        item.onshelf = nil
        return item
    end
end

function Shelfer:AcceptGift(giver, item)
    if not self.enabled then return false end

    if self:CanAccept(item, giver) then
        if item.components.stackable and item.components.stackable.stacksize > 1 then
            item = item.components.stackable:Get()
        else
            item.components.inventoryitem:RemoveFromOwner()
        end

        self.shelf.components.container:GiveItem(item, self.slotindex)
        self:UpdateGift(item)

        self.inst:PushEvent("trade", { giver = giver, item = item })

        return true
    end

    local frozen = self.inst.components.freezable and self.inst.components.freezable:IsFrozen() or false

    if self.onrefuse and not frozen then
        self.onrefuse(self.inst, giver, item)
    end
end

function Shelfer:UpdateGift(item)
    item.onshelf = self.inst

    if self.shelf and self.slot then
        self.inst:AddTag("slot_one")
        self:SetArt()
    end
end

return Shelfer
