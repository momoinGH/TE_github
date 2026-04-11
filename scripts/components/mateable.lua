local function OnPartnerRemove(inst, partner)
    inst.components.mateable:RemovePartner()
end

-- 每天早上都会检测附近有没有合适的繁殖对象
local nomatingtags = { "baby", "teen", "mating", "doydoynest", "insprungtrap", }
local function TryToSpawn(inst)
    if inst.partner then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 30, { "doydoy" }) > 20 then
        return --周围有很多就不生了
    end

    if inst:GetIsOnWater() then
        return --海上不繁殖
    end

    for _, v in ipairs(TheSim:FindEntities(x, y, z, 15, { "doydoy" }, nomatingtags)) do
        if v ~= inst and not v.components.inventoryitem:IsHeld() and not v:GetIsOnWater() then
            -- 随便分配个公母
            inst.components.mateable:SetPartner(v, true)
            v.components.mateable:SetPartner(inst, false)
        end
    end
end

-- 渡渡鸟的交配组件，一公一母
-- 只有要交配的时候才有partner，才有性别，交配完就不需要了
local Mateable = Class(function(self, inst)
    self.inst = inst

    self.onmate = nil

    self.partner = nil                            --伴侣实体
    self.spawn_period = TUNING.TOTAL_DAY_TIME * 2 --繁殖时间
    self.next_spawn_time = self.spawn_period

    self._on_partner_removed = function(partner) OnPartnerRemove(inst, partner) end

    inst:WatchWorldState("startday", function(inst)
        inst:DoTaskInTime(math.random(0, 20), TryToSpawn)
    end)
end)

-- 设置自己的伴侣
function Mateable:SetPartner(partner, partnerismommy)
    self:RemovePartner()

    self.partner = partner
    self.inst:ListenForEvent("onrmeve", self._on_partner_removed, partner)

    if partnerismommy then
        self.inst:AddTag("daddy")
    else
        self.inst:AddTag("mommy")
    end
    self.inst:AddTag("mating")
end

function Mateable:GetPartner()
    return self.partner
end

-- 繁殖后也不需要伴侣了
function Mateable:RemovePartner()
    if self.partner then
        self.inst:RemoveEventCallback("onremove", self._on_partner_removed, self.partner)
    end
    self.inst:RemoveTag("daddy")
    self.inst:RemoveTag("mommy")
    self.inst:RemoveTag("mating")
    if self.inst:HasTag("daddy") then
        local mommy = self.partner
        if mommy then
            mommy.components.mateable:RemovePartner()
        end
    end
    self.partner = nil
end

function Mateable:Mate()
    if self.onmate then
        self.onmate(self.inst, self.partner)
    end
    self:RemovePartner()

    self.next_spawn_time = TroGetTotalTime() + self.spawn_period
end

function Mateable:OnSave()
    local data, refs = {}, {}

    data.next_spawn_time = self.next_spawn_time

    if self.partner then
        data.partner = self.partner.GUID
        data.partnerismommy = self.partner:HasTag("mommy")
        table.insert(refs, self.partner.GUID)
    end
    return data, refs
end

function Mateable:LoadPostPass(newents, data)
    if not data then return end

    data.next_spawn_time = self.next_spawn_time
    if data.partner and newents[data.partner] then
        self:SetPartner(newents[data.partner].entity, data.partnerismommy)
    end
end

return Mateable
