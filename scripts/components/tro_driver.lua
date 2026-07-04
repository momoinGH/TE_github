local function ClearBoat(inst, data)
    inst.components.tro_driver:SetBoat(nil)
end

local function onboat(self, boat)
    self.inst.replica.tro_driver:SetBoat(boat)
end

--- 海难小船行驶组件
local Driver = Class(function(self, inst)
    self.inst = inst

    self.boat = nil
    self.hoptask = nil

    inst:ListenForEvent("death", ClearBoat)
end, nil, {
    boat = onboat
})

function Driver:GetBoat()
    return self.inst:TroGetSWBoat()
end

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
        if inst.components.playercontroller then --延迟补偿下玩家跳到船上了但会一直往岸上跑，调用这个解决
            inst.components.playercontroller:OnRemoteStopHopping()
        end
    end
end

local function SetWereDrowning(inst, isFly)
    if inst.components.drownable ~= nil then
        if isFly then
            if inst.components.drownable.enabled ~= false then
                inst.components.drownable.enabled = false
            end
        elseif inst.components.drownable.enabled == false then
            inst.components.drownable.enabled = true
        end
    end
end

-- 开始跳到船上
function Driver:StartHopBoat(boat)
    self:SetBoat(nil) --船跳船的情况

    if boat and not self.hoptask then
        SetWereDrowning(self.inst, true) --上船的时候得提前设置，等SetBoat里设置true还是会落水
        self.hoptask = self.inst:DoPeriodicTask(0, CheckFall, 0, self, boat)
    end
end

-- 小船抗伤
local function PlayerRedirectDamage(inst, attacker, damage, weapon, stimuli)
    local boat = inst.components.tro_driver.boat
    return boat
        and boat:IsValid()
        and not IsEntityDead(boat)
        and not (
            weapon and (
                weapon.components.projectile or
                weapon.components.complexprojectile or
                (weapon.components.weapon and weapon.components.weapon:CanRangedAttack())
            ) or
            (attacker and attacker:HasTag("pseudoprojectile"))
        )
        and stimuli ~= "electric"
        and stimuli ~= "darkness"
        and boat
        or nil
end

function Driver:SetBoat(boat)
    local oldboat = self.boat
    if oldboat == boat then return end

    self.inst.components.combat.redirectdamagefn = nil
    if oldboat and oldboat:IsValid() then
        self.inst:RemoveChild(oldboat)
        oldboat.Physics:Teleport(self.inst.Transform:GetWorldPosition()) --不能用Transform，延迟补偿下会坐标闪一下
        oldboat.components.shipwreckedboat:OnPlayerDismounted(self.inst)
    end

    self.boat = boat
    if boat then
        -- boat.Physics:SetCollides(false) --需要吗？
        boat.Physics:Teleport(0, -0.2, 0)
        self.inst:AddChild(boat)
        self.inst.components.combat.redirectdamagefn = PlayerRedirectDamage
        boat.components.shipwreckedboat:OnPlayerMounted(self.inst)
        self.inst:StartUpdatingComponent(self)
    else
        self.inst:StopUpdatingComponent(self)
    end
    SetWereDrowning(self.inst, boat ~= nil)
end

function Driver:Check()
    return self.boat and self.boat:IsValid()                                    --船还在
        and not self.inst:HasTag("playerghost")                                 --玩家没死
        and not (self.inst.sg and self.inst.sg:HasStateTag("jumping"))          --玩家不在跳跃
        and TheWorld.Map:IsOceanAtPoint(self.inst.Transform:GetWorldPosition()) --玩家在海上
        or false
end

function Driver:OnUpdate(dt)
    if not self:Check() then
        self:SetBoat(nil)
        return
    end
end

return Driver
