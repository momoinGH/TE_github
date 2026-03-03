local function OnBoatStartMoving(inst)
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end
local function OnBoatStopMoving(inst)
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function OnEquipped(inst, data)
    local self = inst.components.shipwreckedboatparts
    inst:ListenForEvent("boat_startmoving", self.on_boat_startmoving_fn, data.owner)
    inst:ListenForEvent("boat_stopmoving", self.on_boat_stopmoving_fn, data.owner)
end

local function OnUnEquipped(inst, data)
    local self = inst.components.shipwreckedboatparts
    inst:RemoveEventCallback("boat_startmoving", self.on_boat_startmoving_fn, data.owner)
    inst:RemoveEventCallback("boat_stopmoving", self.on_boat_stopmoving_fn, data.owner)
end

--- 海难小船零件
--- 别忘了给零件添加shipwrecked_boat_head或者shipwrecked_boat_tail标签，前者对应船帆，后者对应船灯
local ShipwreckedBoatParts = Class(function(self, inst)
    self.inst = inst

    assert(inst:HasTag("shipwrecked_boat_head") or inst:HasTag("shipwrecked_boat_tail"),
        "小船配件需要添加shipwrecked_boat_head或者shipwrecked_boat_tail标签，用来决定对应小船容器那个槽位")

    self.speed_mult = 1
    self.move_sound = nil

    -- 可以监听boat_equipped和boat_unequipped事件来判断是否被装备到容器对应槽中
    -- 区别在于下面两个函数是玩家在船上和不在船上时调用，这两个事件只跟是否被船放入槽中有关系
    self.onplayermountedfn = nil    --(inst, boat, driver)玩家上船
    self.onplayerdismountedfn = nil --(inst, boat, driver)玩家下船

    self.on_boat_startmoving_fn = function(boat) OnBoatStartMoving(inst) end
    self.on_boat_stopmoving_fn = function(boat) OnBoatStopMoving(inst) end

    inst:ListenForEvent("boat_equipped", OnEquipped)
    inst:ListenForEvent("boat_unequipped", OnUnEquipped)
end)

-- 当零件被装备时返回小船
function ShipwreckedBoatParts:GetBoat()
    local owner = self.inst.components.inventoryitem.owner
    if owner and owner:HasTag("shipwrecked_boat") then
        local slot = owner.components.container and owner.components.container:GetItemSlot(self.inst)
        return (slot == 1 or slot == 2) and owner or nil
    end
end

function ShipwreckedBoatParts:GetDriver()
    local boat = self:GetBoat()
    return boat and boat.components.shipwreckedboat.driver or nil
end

function ShipwreckedBoatParts:SetSpeedMult(speed_mult)
    self.speed_mult = speed_mult

    local boat = self:GetBoat()
    if boat then
        boat.components.shipwreckedboat:UpdateSpeedMult()
    end
end

return ShipwreckedBoatParts
