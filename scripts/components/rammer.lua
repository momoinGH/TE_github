-- 为小船船头锤服务，刷帧检测，虽然我觉得用Physics:SetCollisionCallback(OnCollide)回更好
local Rammer = Class(function(self, inst)
    self.inst = inst

    self.minSpeed = 2.0
    self.cooldown = 0.0
    self.checkRadius = 3
    self.hitRadius = 1
    self.wasActive = false
    self.ramFilters = {}
    
    self.onActivate = nil --当启用时
    self.onDeactivate = nil --当禁用时
    self.onUpdate = nil --启用时更新
    self.onRamTarget = nil --当与目标相撞时

    self.inst:StartUpdatingComponent(self)
end)

function Rammer:StartCooldown()
    self.cooldown = 5 * FRAMES
end

local function isInHitCone(self, boat, item)
    if boat.Physics == nil or item.Physics == nil then
        return false
    end

    local origin = self.inst:GetPosition()
    local point = item:GetPosition()
    local d = (point - origin):GetNormalized()
    local maxDistance = self.hitRadius + boat.Physics:GetRadius() + item.Physics:GetRadius()

    if d:LengthSq() > (maxDistance * maxDistance) then
        return false
    else
        local v = Vector3(boat.Physics:GetVelocity()):GetNormalized()
        local dot = v:Dot(d)
        return dot > 0.75
    end
end

local RAMMER_NO_TAGS = { "falling", "FX", "NOCLICK", "DECOR", "INLIMBO", "unramable" }
function Rammer:CheckRamHit()
    if not self.onRamTarget then return end

    local boat = self.inst.components.shipwreckedboatparts:GetBoat()
    if not boat then return end --不应该

    local x, y, z = boat.Transform:GetWorldPosition()
    local driver = self.inst.components.shipwreckedboatparts:GetDriver()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, boat.Physics:GetRadius() + self.hitRadius * 2, nil, RAMMER_NO_TAGS)) do
        if v ~= driver
            and v ~= boat
            and not IsEntityDead(v)
            and (not v.components.inventoryitem or not v.components.inventoryitem:IsHeld())
        then
            if isInHitCone(self, boat, v) then
                self.onRamTarget(self.inst, v)
            end
        end
    end
end

function Rammer:OnUpdate(dt)
    local isActive = self:IsActive()

    -- toggle on/off callbacks
    if isActive and not self.wasActive then
        if self.onActivate then
            self.onActivate(self.inst)
        end
    elseif not isActive and self.wasActive then
        if self.onDeactivate then
            self.onDeactivate(self.inst)
        end
    end

    if isActive then
        self:CheckRamHit()

        if self.onUpdate ~= nil then
            self.onUpdate(self.inst, dt)
        end
    end

    self.cooldown = math.max(0, self.cooldown - dt)
    self.wasActive = isActive
end

function Rammer:IsActive()
    -- TODO: consider storing the driver whenever it changes to avoid the constant lookup
    local boat = self.inst.components.shipwreckedboatparts:GetBoat()

    if boat == nil then
        return false
    end

    local v = Vector3(boat.Physics:GetVelocity())
    local minSpeedSq = self.minSpeed * self.minSpeed

    return (v:LengthSq() >= minSpeedSq) and (self.cooldown <= 0.0)
end

function Rammer:DebugRender()
    if TheSim:GetDebugRenderEnabled() then
        if self.inst.draw then
            self.inst.draw:Flush()
            self.inst.draw:SetRenderLoop(true)
            self.inst.draw:SetZ(0.15)

            local dim = 2.0 * self.range
            local x, y, z = self.inst.Transform:GetWorldPosition()

            self.inst.draw:Box(x - self.range, z - self.range, dim, dim, 0, 1, 0, 1)
        else
            --TheSim:SetDebugRenderEnabled(true)
            self.inst.draw = self.inst.entity:AddDebugRender()
        end
    end
end

return Rammer
