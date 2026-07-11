local function copytable(tbl)
    local tblcopy = {}
    for k, v in pairs(tbl) do
        tblcopy[k] = v
    end
    return tblcopy
end

local function OnCheckCoinDropped(inst)
    local pt = Point(inst.Transform:GetWorldPosition())

    if pt.y < 2 then
        inst.fell = true
        inst.Physics:SetMotorVel(0, 0, 0)
    end

    if pt.y <= 0.2 then
        if inst.shadow then
            inst.shadow:Remove()
        end

        inst.Physics:SetDamping(0.9)

        if inst.updatetask then
            inst.updatetask:Cancel()
            inst.updatetask = nil
        end
    end

    inst.last_y = pt.y
end

local function OnCoinDrop(inst, doer, coin)
    local rad = 1 + math.random() * 2
    local theta = math.random() * TWOPI
    local vec = Vector3(math.cos(theta) - math.sin(theta), 0, math.cos(theta) + math.sin(theta))
    local offset = Vector3(vec.x * rad, 20, vec.z * rad)

    coin.Transform:SetPosition((inst:GetPosition() + offset):Get())
    coin.updatetask = coin:DoPeriodicTask(0.1, OnCheckCoinDropped, 0.05)
end

-- 给予硬币
local function GiveReward(inst, self, doer)
    if #self.reward == 0 then
        return
    end
    local coin_prefab = table.remove(self.reward, 1)
    OnCoinDrop(inst, doer, SpawnPrefab(coin_prefab))
    inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/gnaw/chomp")
    if #self.reward > 0 then
        inst:DoTaskInTime(0.4, GiveReward, self, doer)
    else
        self.inst:RemoveTag("giving_reward") --停止给予奖励
    end
end

local Snackrificer = Class(function(self, inst)
    self.inst = inst
    self.reward = {}
    self.onsnackrificefn = nil
end)

function Snackrificer:ComputeValue(item)
    local snackrificable = item.components.snackrificable
    if snackrificable == nil then
        return 0
    end
    local basevalue = snackrificable:GetValue()
    local cravingbonus = 0 -- adicionei
    local saltbonus = 0
    if item.components.saltable and item.components.saltable.saltlevel >= 0.75 then
        saltbonus = 1
    end
    local value = basevalue + cravingbonus + saltbonus
    local satisfaction = cravingbonus > 0 and 1 or -1
    return value, satisfaction
end

function Snackrificer:SubtractCravingViolation(reward)
    for k, v in pairs(reward) do
        if v > 0 then
            reward[k] = v - 1
        end
    end
end

local preparedFoods = require("gorge_foods")
function Snackrificer:ComputeReward(item, value, satisfaction)
    local rewardTable = preparedFoods[item.prefab].reward
    if rewardTable then
        local reward = rewardTable[item.components.replatable.material or "generic"]
        if reward then
            reward = copytable(reward)
            if item.components.saltable and item.components.saltable:IsSalted() then
                reward["coin1"] = reward["coin1"] + 1
            end
            self.reward = {}
            for coinprefab, amount in pairs(reward) do
                for i = 1, amount do
                    table.insert(self.reward, "quagmire_" .. coinprefab)
                end
            end
        end
    end
end

function Snackrificer:Snackrifice(doer, item)
    local value, satisfaction = self:ComputeValue(item)

    if item.components.stackable then
        item = item.components.stackable:Get(1)
    end
    item:Remove()

    if value > 0 then
        self.inst:AddTag("giving_reward") --给予奖励中
        self:ComputeReward(item, value, satisfaction)
        self.inst:DoTaskInTime(1, GiveReward, self, doer)
        if self.onsnackrificefn then
            self.onsnackrificefn(self.inst)
        end
    end
end

return Snackrificer
