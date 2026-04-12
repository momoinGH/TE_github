-- 给草用的刮风交互组件
local BlowInWindGust = Class(function(self, inst)
    self.inst = inst
    self.startfn = nil          --风速超过阈值，开始被吹时
    self.endfn = nil            --风速降到阈值以下，停止被吹时
    self.destroyfn = nil        --被风直接摧毁时
    self.state = 0              --0=平静，1=正在被吹
    self.windspeedthreshold = 0 --触发吹袭的风速阈值
    self.destroychance = 0.01   --每次检查时被直接摧毁的概率
    self.task = nil
end)

function BlowInWindGust:OnRemoveEntity()
    self:Stop()
end

function BlowInWindGust:OnRemoveFromEntity()
    self:Stop()
end

local function UpdateTask(inst, dt)
    if not inst or not inst:IsValid() then
        return
    end

    local self = inst.components.blowinwindgust
    local sm = TheWorld.components.tro_hurricane
    local windspeed = sm and sm:GetHurricaneWindSpeed() or 0 --当前飓风风速
    if self.state == 0 then
        if windspeed > self.windspeedthreshold then
            if math.random() < self.destroychance and FindClosestPlayerToInst(self.inst, 15) then --附近有玩家
                self:CallDestroyFn()                                                              --直接摧毁
                self:Stop()
                return
            end
            self:CallGustStartFn(windspeed)
            self.state = 1
        end
    elseif self.state == 1 then
        if windspeed < self.windspeedthreshold then
            self:CallGustEndFn(windspeed)
            self.state = 0
        end
    end
    self:Stop()
    self:Start()
end

function BlowInWindGust:Start()
    if self.task == nil then
        local dt = math.random() * 0.5 + 1.0
        self.task = self.inst:DoTaskInTime(dt, UpdateTask, dt)
    end
end

function BlowInWindGust:Stop()
    if self.task then
        self.task:Cancel()
    end
    self.task = nil
end

function BlowInWindGust:OnEntitySleep()
    if self.state == 1 then
        self:CallGustEndFn(0)
    end
    self.state = 0
    self:Stop()
end

function BlowInWindGust:OnEntityWake()
    self.state = 0
    self:Start()
end

function BlowInWindGust:SetWindSpeedThreshold(windspeed)
    self.windspeedthreshold = windspeed
end

function BlowInWindGust:SetDestroyChance(chance)
    self.destroychance = chance
end

function BlowInWindGust:IsGusting()
    return self.state == 1
end

function BlowInWindGust:SetGustStartFn(fn)
    self.startfn = fn
end

function BlowInWindGust:CallGustStartFn(windspeed)
    if self.startfn then
        self.startfn(self.inst, windspeed)
    end
end

function BlowInWindGust:SetGustEndFn(fn)
    self.endfn = fn
end

function BlowInWindGust:CallGustEndFn(windspeed)
    if self.endfn then
        self.endfn(self.inst, windspeed)
    end
end

function BlowInWindGust:SetDestroyFn(fn)
    self.destroyfn = fn
end

function BlowInWindGust:CallDestroyFn()
    if self.destroyfn then
        self.destroyfn(self.inst)
    end
end

return BlowInWindGust
