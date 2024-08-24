--- 熔炉竞技场战旗buff相关
local BattleStandard = Class(function(self, inst)
    self.inst = inst

    self.flags = {}   --所有战斗旗帜
    self.targets = {} --当前有战旗buff的敌方单位
end)

local TARGET_MUST_TAGS = { "monster", "hostile", "_combat", "_health" }
local function AddBuff(flag, self)
    local x, y, z = flag.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, 0, z, 100, TARGET_MUST_TAGS)) do --TOOD 熔炉竞技场的半径是多少？
        v:AddDebuff(flag.debuffprefab, flag.debuffprefab)
        table.insert(self.targets, v)
    end
end

local function OnFlagRemove(inst)
    local self = TheWorld.components.lavaarena_battlestandard
    self.flags[inst.debuffprefab][inst] = nil

    if not next(self.flags[inst.debuffprefab]) then --该类型的战旗一个也没有了
        local newTargets = {}
        for _, v in ipairs(self.targets) do
            if v:IsValid() then
                if v:HasDebuff(inst.debuffprefab) then
                    v:RemoveDebuff(inst.debuffprefab)
                else
                    table.insert(newTargets, v) --buff一直存在，没有这个类型的buff说明肯定有其他类型的buff
                end
            end
        end
        self.targets = newTargets
    end
end

function BattleStandard:OnFlagSpawned(flag)
    self.flags[flag.debuffprefab] = self.flags[flag.debuffprefab] or {}
    self.flags[flag.debuffprefab][flag] = true

    flag:ListenForEvent("onremove", OnFlagRemove)
    flag:DoTaskInTime(0, AddBuff, self)
end

--- 根据场上的旗帜给所有敌方单位提供buff
local function InitEnt(ent, self)
    if ent.components.combat
        and ent.components.health
        and (ent:HasTag("monster") or ent:HasTag("hostile"))
    -- TODO 判断是否在熔炉竞技场的范围
    then
        self:AddBuffs(ent)
    end
end

function BattleStandard:OnEntSpawned(ent)
    ent:DoTaskInTime(0, InitEnt, self)
end

function BattleStandard:AddBuffs(target)
    for buffprefab, ents in pairs(self.flags) do
        if next(ents) then --表示有存在的旗帜
            target:AddDebuff(buffprefab, buffprefab)
        end
    end
    table.insert(self.targets, target)
end

return BattleStandard
