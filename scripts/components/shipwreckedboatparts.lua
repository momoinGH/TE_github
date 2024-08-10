--- 海难小船零件
--- 别忘了给零件添加shipwrecked_boat_head或者shipwrecked_boat_tail标签，前者对应船帆，后者对应船灯
local ShipwreckedBoatParts = Class(function(self, inst)
    self.inst = inst

    self.speed_mult = 1
    self.move_sound = nil

    -- 可以监听boat_equipped和boat_unequipped事件来判断是否被装备到容器对应槽中
    -- 区别在于下面两个函数是玩家在船上和不在船上时调用，这两个事件只跟是否被船放入槽中有关系
    self.onplayermountedfn = nil    --玩家上船
    self.onplayerdismountedfn = nil --玩家下船
end)

function ShipwreckedBoatParts:GetBoat()
    local owner = self.inst.components.inventoryitem.owner
    if owner and owner:HasTag("shipwrecked_boat") and owner.components.container then
        local slot = owner.components.container:GetItemSlot(self.inst)
        return (slot == 1 or slot == 2) and owner or nil
    end
end

function ShipwreckedBoatParts:GetDriver()
    local boat = self:GetBoat()
    return boat and boat.components.shipwreckedboat:GetDriver()
end

function ShipwreckedBoatParts:SetSpeedMult(speed_mult)
    self.speed_mult = speed_mult

    local owner = self.inst.components.inventoryitem.owner
    local shipwreckedboat = owner and owner.components.shipwreckedboat
    if shipwreckedboat then
        shipwreckedboat.speedmultiplier:RemoveModifier(self.inst)
        shipwreckedboat.speedmultiplier:SetModifier(self.inst, speed_mult)
    end
end

return ShipwreckedBoatParts
