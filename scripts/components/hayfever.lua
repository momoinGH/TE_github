local function Check(inst)
    if TheWorld.state.isspring and inst:IsInHamletArea() then
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

--- 哈姆雷特花粉症
local Hayfever = Class(function(self, inst)
    self.inst          = inst

    self.enabled       = false
    self.sneezed       = false
    self.wantstosneeze = false
    self.nextsneeze    = self:GetNextSneezTimeInitial() --下一次打喷嚏时间
    self.level         = 0                              --一共四个等级

    self.update_task   = nil

    inst:WatchWorldState("isspring", Check)
    inst:ListenForEvent("changearea", Check)
    inst:DoTaskInTime(0, Check)
end, nil, {
    nextsneeze = onnextsneeze,
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
    if not self.inst:IsInHamletArea() then
        return false
    end
    if self.inst.replica.inventory ~= nil and self.inst.replica.inventory:EquipHasTag("gasmask") then
        return false
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    return #TheSim:FindEntities(x, y, z, 30, { "prevents_hayfever" }) <= 0 --工作的摆动风扇旁边
end

local function Update(inst, self, dt)
    if self:CanSneeze() then
        if self.nextsneeze <= 0 then
            if not self.wantstosneeze then
                -- large chance to sneeze twice in a row
                if self.sneezed or math.random() > 0.7 then
                    self.sneezed = false
                    self.nextsneeze = self:GetNextSneezTime()
                else
                    self.sneezed = true
                    self.nextsneeze = 2
                end

                self.wantstosneeze = true
            end

            if self.wantstosneeze then
                self.inst:PushEvent("sneeze") --不把这个喷嚏打了就一直推送！
            end
        else
            self.wantstosneeze = false
            self.nextsneeze = self.nextsneeze - dt
        end
    else
        if self.nextsneeze < 120 then
            self.nextsneeze = self.nextsneeze + (dt * 0.9)
        end
    end

    self.inst:TroSetPlayerClassifiedNetVar("tro_sneezetime", self.nextsneeze)
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

function Hayfever:Enable()
    if self.inst:HasTag("plantkin") or self.inst:HasTag("beaver") then
        return --植物人、海狸伍迪免疫
    end

    if self.enabled then
        return
    end

    self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_HAYFEVER"))
    self.enabled = true
    self.update_task = self.inst:DoPeriodicTask(0.2, Update, 0.2, self, 0.2)
end

function Hayfever:Disable()
    if self.enabled then
        self.inst:TroSetPlayerClassifiedNetVar("tro_sneezetime", -1)
        self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_HAYFEVER_OFF"))

        self:SetNextSneezeTime(self:GetNextSneezTimeInitial())
    end

    self.enabled = false
    if self.update_task then
        self.update_task:Cancel()
        self.update_task = nil
    end
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
            if #findItems > 0 then
                local itemnum = math.random(1, #findItems)
                local item = findItems[itemnum]

                table.remove(findItems, itemnum)

                if item then
                    local direction = Vector3(math.random() * 2 - 1, 0, math.random() * 2 - 1)
                    self.inst.components.inventory:DropItem(item, false, direction:GetNormalized())
                end
            end
        end
    end
end

return Hayfever
