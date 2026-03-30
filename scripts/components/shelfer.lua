-- 一个货架的槽，主要和货架的container组件关联
local Shelfer = Class(function(self, inst)
    self.inst = inst

    self.shelf = nil
    self.slotindex = nil
    self.slot = nil
end)

function Shelfer:SetShelf(shelf, slot, slotindex)
    self.shelf = shelf
    self.slot = slot
    self.slotindex = slotindex
end

function Shelfer:GetGift()
    return self.shelf.components.container:GetItemInSlot(self.slotindex)
end

function Shelfer:GiveGift()
    return self.shelf.components.container:RemoveItemBySlot(self.slotindex)
end

function Shelfer:CanAccept(item, giver)
    local player_to_shop = not self.shelf:HasTag("playercrafted") and giver and giver:HasTag("player")
    return
        not self.shelf.components.container:GetItemInSlot(self.slotindex) --槽位当前空缺
        and item.components.inventoryitem                                 --物品
        and not player_to_shop                                            --非购买
end

function Shelfer:AcceptGift(giver, item)
    if not self:CanAccept(item, giver) then
        return false
    end
    if item.components.stackable and item.components.stackable.stacksize > 1 then
        item = item.components.stackable:Get()
    else
        item.components.inventoryitem:RemoveFromOwner()
    end
    return self.shelf.components.container:GiveItem(item, self.slotindex)
end

return Shelfer
