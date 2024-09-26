local Utils = require("tropical_utils/utils")

local function OrderByPriority(l, r)
    return (l.action and l.action.priority or 0) > (r.action and r.action.priority or 0)
end

-- 如果在海难船上的时候，POINT类型的action不需要手持什么东西
local function PickActions(retTab, self, position, target, right)
    local bufs = retTab[1]

    local actions = {}
    local boat = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
    if boat then
        if right then
            if boat.replica.container
                and boat.replica.container:GetItemInSlot(2)
                and boat.replica.container:GetItemInSlot(2):HasTag("boatcannon") -- 船炮
                and not self.inst.replica.inventory:IsHeavyLifting() then
                -- 发射船炮
                table.insert(actions, ACTIONS.BOATCANNON)
            end
        else
            if not target
                and not TheWorld.Map:GetSWBoatAtPoint(position:Get())
                and TheWorld.Map:IsPassableAtPoint(position:Get()) then
                -- 上岸
                table.insert(actions, ACTIONS.BOATDISMOUNT)
            end
        end
    end

    if #actions > 0 then
        for _, buf in ipairs(self:SortActionList(actions, target or position)) do
            table.insert(bufs, buf)
        end
        table.sort(bufs, OrderByPriority) --顺便和原来的一起排个序
    end

    return retTab
end

local function GetLeftClickActionsAfter(retTab, self, position, target)
    return PickActions(retTab, self, position, target)
end

local function RemoveBoat(inst, self)
    if self.current_boat and self.current_boat:IsValid() then
        self:UnregisterContainer(self.current_boat)
    end

    self.unregisterBoatTask = nil
    self.current_boat = nil
end

local function GetRightClickActionsBefore(self, position, target)
    -- 这部分代码主要是让玩家可以对海难船检查SCENE类型的componentaction，玩家可以收回船
    -- 因为含有walkableplatform标签的目标不会调用GetSceneActions(target, true)
    if target
        and target:HasTag("walkableplatform")
        and target:HasTag("shipwrecked_boat")
    then
        if self.unregisterBoatTask then
            self.unregisterBoatTask:Cancel()
            if self.current_boat and self.current_boat:IsValid() then
                RemoveBoat(self.inst, self)
            end
        end

        self.current_boat = target
        self:RegisterContainer(target)
        self.unregisterBoatTask = self.inst:DoTaskInTime(3, RemoveBoat, self)
    end
end

local function GetRightClickActionsAfter(retTab, self, position, target)
    return PickActions(retTab, self, position, target, true)
end

AddComponentPostInit("playeractionpicker", function(self)
    self.current_boat = nil --鼠标悬停的海难小船
    self.unregisterBoatTask = nil

    Utils.FnDecorator(self, "GetLeftClickActions", nil, GetLeftClickActionsAfter)
    Utils.FnDecorator(self, "GetRightClickActions", GetRightClickActionsBefore, GetRightClickActionsAfter)
end)
