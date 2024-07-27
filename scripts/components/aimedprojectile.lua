local AimedProjectile = Class(function(self, inst)
    self.inst = inst;
    self.hitdist = 1;
    self.range = 10;
    self.speed = 20;
    self.damage = nil;
    self.stimuli = nil;
    self.onthrown = nil;
    self.onhit = nil;
    self.onmiss = nil
end)
function AimedProjectile:SetHitDistance(c)
    self.hitdist = c
end;

function AimedProjectile:SetRange(d)
    self.range = d
end;

function AimedProjectile:SetSpeed(e)
    self.speed = e
end;

function AimedProjectile:SetDamage(f)
    self.damage = f
end;

function AimedProjectile:SetStimuli(g)
    self.stimuli = g
end;

function AimedProjectile:SetOnThrownFn(h)
    self.onthrown = h
end;

function AimedProjectile:SetOnHitFn(h)
    self.onhit = h
end;

function AimedProjectile:SetOnMissFn(h)
    self.onmiss = h
end;

function AimedProjectile:RotateToTarget(pos)
    local j = (pos - self.inst:GetPosition()):GetNormalized()
    local k = math.acos(j:Dot(Vector3(1, 0, 0))) / DEGREES;
    self.inst.Transform:SetRotation(k)
    self.inst:FacePoint(pos)
end;

function AimedProjectile:Throw(l, m, n)
    self.owner = l;
    self.attacker = m;
    self.start = l:GetPosition()
    self.dest = n;
    if m ~= nil and self.launchoffset ~= nil then
        local o, p, q = self.inst.Transform:GetWorldPosition()
        local r = m.Transform:GetRotation() * DEGREES;
        self.inst.Transform:SetPosition(o + self.launchoffset.x * math.cos(r), p + self.launchoffset.y,
            q - self.launchoffset.x * math.sin(r))
    end;
    self:RotateToTarget(self.dest)
    self.inst.Physics:SetMotorVel(self.speed, 0, 0)
    self.inst:StartUpdatingComponent(self)
    self.inst:PushEvent("onthrown", { thrower = m })
    if self.onthrown ~= nil then
        self.onthrown(self.inst, l, m, n)
    end
end;

function AimedProjectile:Stop()
    self.inst:StopUpdatingComponent(self)
    self.target = nil;
    self.attacker = nil;
    self.owner = nil
end;

function AimedProjectile:Miss()
    if self.onmiss ~= nil then
        self.onmiss(self.inst, self.owner, self.attacker)
    end;
    self:Stop()
end;

function AimedProjectile:Hit(s)
    self.inst.Physics:Stop()
    if self.attacker and self.owner and self.owner.components.weapon then
        self.owner.components.weapon:DoAltAttack(self.attacker, s, nil, self.stimuli)
    end;
    if self.onhit ~= nil then
        self.onhit(self.inst, self.owner, self.attacker, s)
    end;
    self:Stop()
end;

function AimedProjectile:OnUpdate(t)
    local pos = self.inst:GetPosition()
    if self.range ~= nil and distsq(self.start, pos) > self.range * self.range then
        self:Miss()
    else
        local ents = {}
        local s = nil;
        local x, y, z = pos:Get()
        for _, v in ipairs(TheSim:FindEntities(x, y, z, 3, nil, { "player", "companion" })) do
            if v.entity:IsVisible()
                and (v.components.health and not v.components.health:IsDead()
                    or self.inst.prefab == 'riledlucy' and v:HasTag("tree") and not v:HasTag("stump") and v.components.workable and v.components.workable:CanBeWorked() and v.components.workable:GetWorkAction()) then
                local range = v:GetPhysicsRadius(0) + self.hitdist;
                local disSq = distsq(pos, v:GetPosition())
                if range > disSq then
                    table.insert(ents, { target = v, hitrange = range, currentrange = disSq })
                end
            end
        end;
        for _, v in pairs(ents) do
            if s == nil or v.currentrange - v.hitrange < s.range then
                s = { ent = v.target, range = v.currentrange - v.hitrange }
            end
        end;
        if s ~= nil then
            self:Hit(s.ent)
        end
    end
end;

local function Init(b, self)
    self.delaytask = nil;
    b:Show()
end

function AimedProjectile:DelayVisibility(D)
    if self.delaytask ~= nil then
        self.delaytask:Cancel()
    end;
    self.inst:Hide()
    self.delaytask = self.inst:DoTaskInTime(D, Init, self)
end;

return AimedProjectile
