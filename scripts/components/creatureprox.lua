local nothave = { "INTERIOR_LIMBO", "snake", "scorpion", "shadowcreature" }

local function DoTest(inst)
    local self = inst.components.creatureprox
    local x, y, z = inst.Transform:GetWorldPosition()

    local range = nil
    if self.isclose then
        range = self.far
    else
        range = self.near
    end

    local ents
    if self.all then
        ents = TheSim:FindEntities(x, y, z, range, nil)
    else
        local oneof_tags = { "animal", "character" }
        if self.inventorytrigger then
            oneof_tags = { "_inventoryitem", "monster", "animal", "character", "meat" }
        end
        ents = TheSim:FindEntities(x, y, z, range, nil, nothave, oneof_tags)
    end

    for i = #ents, 1, -1 do
        if ents[i] == inst or (self.testfn and not self.testfn(ents[i])) then
            table.remove(ents, i)
        end
    end

    local close = nil
    if #ents > 0 then
        close = true
        if self.inproxfn then
            for i, ent in ipairs(ents) do
                self.inproxfn(inst, ent)
            end
        end
    end
    if self.isclose ~= close then
        self.isclose = close
        if self.isclose and self.onnear then
            self.onnear(inst, ents)
        end
        if not self.isclose and self.onfar then
            self.onfar(inst)
        end
    end
end

local function SetTaskEnable(self, enable)
    if enable and not self.task then
        self.task = self.inst:DoPeriodicTask(self.period, DoTest)
    elseif not enable and self.task then
        self.task:Cancel()
        self.task = nil
    end
end

local function UpdateTaskEnable(self)
    local can_check = not self.inst:IsAsleep() and self.enabled
    SetTaskEnable(self, can_check)
end

local function onperiod(self)
    SetTaskEnable(self, false)
    UpdateTaskEnable(self)
end

-- 附近单位检测，主要用于遗迹的机关
local CreatureProx = Class(function(self, inst)
    self.inst = inst

    self.near = 2               --激活距离
    self.far = 3                --休眠距离
    self.period = .333          --检测间隔
    self.enabled = true
    self.isclose = nil          --附近是否已经有单位了
    self.all = nil              --是否检查所有单位
    self.inventorytrigger = nil --物品触发
    self.task = nil

    self.testfn = nil
    self.inproxfn = nil
    self.onnear = nil
    self.onfar = nil

    UpdateTaskEnable(self)
end, nil, {
    enabled = UpdateTaskEnable,
    period = onperiod
})

function CreatureProx:GetDebugString()
    return self.isclose and "NEAR" or "FAR"
end

function CreatureProx:SetOnNear(fn)
    self.onnear = fn
end

function CreatureProx:SetOnFar(fn)
    self.onfar = fn
end

function CreatureProx:SetEnabled(enabled)
    self.enabled = enabled
end

function CreatureProx:IsPlayerClose()
    return self.isclose
end

function CreatureProx:SetDist(near, far)
    self.near = near
    self.far = far
end

function CreatureProx:SetTestfn(testfn)
    self.testfn = testfn
end

function CreatureProx:ForceTest()
    DoTest(self.inst)
end

function CreatureProx:OnEntitySleep()
    UpdateTaskEnable(self)
end

function CreatureProx:OnEntityWake()
    UpdateTaskEnable(self)
end

function CreatureProx:OnRemoveEntity()
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

return CreatureProx
