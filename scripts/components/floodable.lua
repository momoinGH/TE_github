local function onflooded(self, flooded)
    if flooded then
        self.inst:AddTag("flooded")
    else
        self.inst:RemoveTag("flooded")
    end
end

local function Init(inst, self)
    if not inst:HasTag("flooded") then
        if FindEntity(inst, 10, nil, { "mare" }) then
            self:StartFlooded()
        end
    end
end

--- 海难水坑组件，服务shipwrecked_flood预制件
local Floodable = Class(function(self, inst)
    self.inst = inst

    self.flooded = false

    self.onStartFlooded = nil
    self.onStopFlooded = nil

    self.fxTask = nil
    self.floodEffect = nil
    self.floodSound = nil
    self.timeToEffect = 0
    self.fxPeriod = 5

    inst:DoTaskInTime(0, Init, self)
end, nil, {
    flooded = onflooded
})

local function SpawnFx(inst, self)
    SpawnPrefab(self.floodEffect).Transform:SetPosition(inst.Transform:GetWorldPosition())
    if self.floodSound and self.inst.SoundEmitter then
        self.inst.SoundEmitter:PlaySound(self.floodSound)
    end
end

function Floodable:StartFlooded()
    self.flooded = true
    if self.onStartFlooded then
        self.onStartFlooded(self.inst)
    end
    if self.fxTask then
        self.fxTask:Cancel()
    end
    self.fxTask = self.inst:DoPeriodicTask(self.fxPeriod, SpawnFx, 0, self)
end

function Floodable:StopFlooded()
    self.flooded = false
    if self.onStopFlooded then
        self.onStopFlooded(self.inst)
    end
    if self.fxTask then
        self.fxTask:Cancel()
        self.fxTask = nil
    end
end

return Floodable
