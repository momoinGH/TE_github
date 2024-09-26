local function ClearBoat(inst, data)
    inst.components.pro_driver:SetBoat(nil)
end

local function Init(inst, self)
    local boat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
        or FindClosestEntity(inst, 1, nil, { "shipwrecked_boat" }, { "INLIMBO" })
    if boat then
        self:SetBoat(nil) --先脱下来
        self:SetBoat(boat)
    end
end

--- 海难小船行驶组件
local Driver = Class(function(self, inst)
    self.inst = inst

    self.hoptask = nil

    inst:ListenForEvent("death", ClearBoat)
    inst:ListenForEvent("onhop", ClearBoat) --延迟补偿下主机检测不到，得刷帧才行

    inst:DoTaskInTime(0, Init, self)
end)

-- 检测玩家落地，玩家落地时将船挂在玩家身上
local function CheckFall(inst, self, boat)
    if not boat:IsValid() then
        self.hoptask:Cancel()
        self.hoptask = nil
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if y <= 0.2 and not inst.sg:HasStateTag("jumping") then
        --落地
        self:SetBoat(boat)

        self.hoptask:Cancel()
        self.hoptask = nil
    end
end

-- 开始跳到船上
function Driver:StartHopBoat(boat)
    self:SetBoat(nil) --船跳船的情况

    if boat and not self.hoptask then
        self.hoptask = self.inst:DoPeriodicTask(0, CheckFall, 0, self, boat)
    end
end

function Driver:SetBoat(boat)
    local oldboat = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
    if oldboat == boat then return end

    if oldboat then
        oldboat.components.equippable:SetPreventUnequipping(false)
        self.inst.components.inventory:Unequip(EQUIPSLOTS.SWBOAT)
        oldboat.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        oldboat.components.inventoryitem:OnDropped() --不加这一行船还是隐身状态
        oldboat.components.shipwreckedboat:OnPlayerDismounted(self.inst)
    end

    if boat then
        self.inst.components.inventory:Equip(boat)
        boat.components.equippable:SetPreventUnequipping(true)

        boat.components.shipwreckedboat:OnPlayerMounted(self.inst)

        self.inst:StartUpdatingComponent(self)
    else
        self.inst:StopUpdatingComponent(self)
    end
end

function Driver:Check()
    return not self.inst:HasTag("playerghost")
        and not (self.inst.sg and self.inst.sg:HasStateTag("jumping"))
        and TheWorld.Map:IsOceanAtPoint(self.inst.Transform:GetWorldPosition())
end

-- TODO 就算刷帧，延迟补偿下上岸还是有些问题，只能先这样了
function Driver:OnUpdate(dt)
    if not self:Check() then
        self:SetBoat(nil)
        return
    end
end

return Driver
