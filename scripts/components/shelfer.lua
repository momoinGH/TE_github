local Shelfer = Class(function(self, inst)
    self.inst = inst

    self.shelf = nil
    self.slotindex = nil
    self.slot = nil
end)

function Shelfer:IsTryingToTradeWithMe(inst)
    local act = inst:GetBufferedAction()
    if act then
        return act.target == self.inst and act.action == ACTIONS.GIVE
    end
end

function Shelfer:SetShelf(shelf, slot, slotindex)
    self.shelf = shelf
    self.slot = slot
    self.slotindex = slotindex
end

function Shelfer:GetGift()
    return self.shelf.components.container:GetItemInSlot(self.slotindex)
end

function Shelfer:OnItemLose()
    self.inst:RemoveTag("slot_one")
end

function Shelfer:GiveGift()
    self.shelf:SetImageFromName(nil, self.slot)
    return self.shelf.components.container:RemoveItemBySlot(self.slotindex)
end

function Shelfer:CanAccept(item, giver)
    local frozen = self.inst.components.freezable and self.inst.components.freezable:IsFrozen()
    local inventortyitem = item.components.inventoryitem ~= nil
    local item = self.shelf.components.container:GetItemInSlot(self.slotindex)
    local player_to_shop = not self.shelf:HasTag("playercrafted") and giver and giver:HasTag("player")

    return inventortyitem      --物品
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

function Shelfer:AcceptGift(giver, item)
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
    if self.shelf and self.slot then
        self.inst:AddTag("slot_one")
        self:SetArt()
    end
end

return Shelfer
