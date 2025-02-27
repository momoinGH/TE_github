local function Check(inst)
    if TheWorld.state.issummer and (TUNING.tropical.hayfever == 20 or inst.components.areaaware:CurrentlyInTag("hamlet")) then
        inst.components.hayfever:Enable()
    else
        inst.components.hayfever:Disable()
    end
end

local function onnextsneeze(self, nextsneeze)
    self.level = not self.enabled and 0
        or nextsneeze >= 30 and 1
        or nextsneeze >= 20 and 2
        or nextsneeze >= 10 and 3
        or 4
end

local function onlevel(self, level)
    self.inst.replica.hayfever:SetLevel(level)
end

--- 哈姆雷特花粉症
local Hayfever = Class(function(self, inst)
    self.inst          = inst

    self.enabled       = false
    self.sneezed       = false
    self.wantstosneeze = false
    self.nextsneeze    = self:GetNextSneezTimeInitial() --下一次打喷嚏时间
    self.level         = 0                              --一共四个等级

    inst:WatchWorldState("issummer", Check)
    inst:ListenForEvent("changearea", Check)
    inst:DoTaskInTime(0, Check)
end, nil, {
    nextsneeze = onnextsneeze,
    level = onlevel
})

function Hayfever:GetNextSneezTime()
    return math.random(10, 40)
end

function Hayfever:GetNextSneezTimeInitial()
    return math.random(60, 80)
end

function Hayfever:SetNextSneezeTime(newtime)
    if self.nextsneeze < newtime then
        self.nextsneeze = newtime
    end
end

function Hayfever:CanSneeze()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    return self.inst:HasTag("has_gasmask")
        and not self.inst:HasTag("has_hayfeverhat")
        and #TheSim:FindEntities(x, y, z, 30, { "prevents_hayfever" }) <= 0 --工作的摆动风扇旁边
end

function Hayfever:OnUpdate(dt)
    if self:CanSneeze() then
        if self.nextsneeze <= 0 then
            if not self.wantstosneeze then
                -- large chance to sneeze twice in a row
                if self.sneezed or math.random() > 0.7 then
                    self.sneezed = false
                    self.nextsneeze = self:GetNextSneezTime()
                else
                    self.sneezed = true
                    self.nextsneeze = 1
                end

                self.wantstosneeze = true
                self.inst:PushEvent("sneeze")
            end
        else
            self.nextsneeze = self.nextsneeze - dt
        end
    else
        if self.nextsneeze < 120 then
            self.nextsneeze = self.nextsneeze + (dt * 0.9)
        end
    end
    self.inst:PushEvent("updatepollen", { sneezetime = self.nextsneeze })
end

function Hayfever:OnSave()
    local data = {}
    local references = {}

    data.sneezed = self.sneezed
    data.nextsneeze = self.nextsneeze

    return data, references
end

function Hayfever:OnLoad(data, newents)
    if data then
        if data.sneezed then
            self.sneezed = data.sneezed
        end
        if data.nextsneeze then
            self.nextsneeze = data.nextsneeze
        end
    end
end

function Hayfever:OnProgress()
    if self.enabled then
        self.inst:PushEvent("updatepollen", { sneezetime = nil })
        self:SetNextSneezeTime(self:GetNextSneezTimeInitial())
    end

    self.enabled = false
    self.inst:StopUpdatingComponent(self)
end

function Hayfever:Enable()
    if not self.hayfeverimune then
        if not self.enabled then
            self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_HAYFEVER"))
        end

        self.enabled = true

        self.inst:StartUpdatingComponent(self)
    end
end

function Hayfever:Disable()
    if self.enabled then
        self.inst:PushEvent("updatepollen", { sneezetime = nil })
        self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_HAYFEVER_OFF"))

        self:SetNextSneezeTime(self:GetNextSneezTimeInitial())
    end

    self.enabled = false
    self.inst:StopUpdatingComponent(self)
end

function Hayfever:GetDebugString()
    return "nextsneeze" .. self.nextsneeze
end

function Hayfever:DoSneezeEffects()
    self.inst.components.sanity:DoDelta(-TUNING.SANITY_SUPERTINY * 3)

    -- cause player to drop stuff here.
    local itemstodrop = 0

    if math.random() < 0.6 then
        itemstodrop = itemstodrop + 1
    end

    if math.random() < 0.1 then
        itemstodrop = itemstodrop + 1
    end

    if itemstodrop > 0 then
        local findItems = self.inst.components.inventory:FindItems(function(item) return not item:HasTag("nosteal") end)
        for i = 1, itemstodrop do
            for i = 1, itemstodrop do
                if #findItems > 0 then
                    local itemnum = math.random(1, #findItems)
                    local item = findItems[itemnum]

                    table.remove(findItems, itemnum)

                    if item then
                        local direction = Vector3(math.random(1) - 2, 0, math.random(1) - 2)
                        self.inst.components.inventory:DropItem(item, false, direction:GetNormalized())
                    end
                end
            end
        end
    end
end

return Hayfever
