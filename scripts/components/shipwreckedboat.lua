local function OnItemGet(inst, data)
    local item = data and data.item
    local part = item and item.components.shipwreckedboatparts
    if not part or (data.slot ~= 1 and data.slot ~= 2) then
        return
    end

    local self = inst.components.shipwreckedboat
    self:UpdateSpeedMult()

    local driver = inst.components.inventoryitem.owner
    if driver then
        if part.onplayermountedfn then
            part.onplayermountedfn(item, inst, driver)
        end
    end

    item:PushEvent("boat_equipped", { owner = inst })
end

local function OnItemLose(inst, data)
    local item = data and data.prev_item
    local part = item and item.components.shipwreckedboatparts
    if not part or (data.slot ~= 1 and data.slot ~= 2) then
        return
    end

    local self = inst.components.shipwreckedboat
    self:UpdateSpeedMult()

    local driver = inst.components.inventoryitem.owner
    if driver then
        if part.onplayerdismountedfn then
            part.onplayerdismountedfn(item, inst, driver)
        end
    end
    item:PushEvent("boat_unequipped", { owner = inst })
end

local BOAT_HEALTH_CONSUME_STEP = 125 / TUNING.TOTAL_DAY_TIME
local function ConsumeBoatHealth(inst)
    if inst.components.health then
        inst.components.health:DoDelta(-BOAT_HEALTH_CONSUME_STEP)
    end
end

local function OnBoatStartMoving(inst, data)
    if not inst.consume_task then
        inst.consume_task = inst:DoPeriodicTask(1, ConsumeBoatHealth)
    end
end
local function OnBoatStopMoving(inst, data)
    if inst.consume_task then
        inst.consume_task:Cancel()
        inst.consume_task = nil
    end
end

--- 海难小船
local Boat = Class(function(self, inst)
    self.inst = inst

    inst:AddTag("shipwrecked_boat")

    inst.consume_task = nil

    inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("itemlose", OnItemLose)
    inst:ListenForEvent("boat_startmoving", OnBoatStartMoving)
    inst:ListenForEvent("boat_stopmoving", OnBoatStopMoving)
end)

-- 获取可见的小船，如果被装备了就获取复制体，否则获取真实的船
function Boat:GetVisibleBoat()
    return self.inst
end

--重新计算移速倍率
function Boat:UpdateSpeedMult()
    local driver = self.inst.components.inventoryitem.owner
    if not driver or not driver.components.locomotor then return end

    local c = self.inst.components.container
    if not c then return end

    local speed_mult = 1
    for i = 1, c.numslots do
        local item = c.slots[i]
        if item ~= nil then
            speed_mult = speed_mult * item.components.shipwreckedboatparts.speed_mult
        end
    end

    driver.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "swboat")
    driver.components.locomotor:SetExternalSpeedMultiplier(self.inst, "swboat", speed_mult)
end

--- 玩家上船（或者说被装备的时候）
function Boat:OnPlayerMounted(player)
    if self.inst.components.container then
        self.inst.components.container:Open(player)

        for i = 1, 2 do
            local item = self.inst.components.container:GetItemInSlot(i)
            local fn = item and item.components.shipwreckedboatparts.onplayermountedfn
            if fn then
                fn(item, self.inst, player)
            end
        end
    end

    self:UpdateSpeedMult()
end

--- 玩家下船
function Boat:OnPlayerDismounted(player)
    if self.inst.components.container then
        self.inst.components.container:Close(player)

        for i = 1, 2 do
            local item = self.inst.components.container:GetItemInSlot(i)
            local fn = item and item.components.shipwreckedboatparts.onplayerdismountedfn
            if fn then
                fn(item, self.inst, player)
            end
        end
    end

    if player.components.locomotor then
        player.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "swboat")
    end
end

return Boat
