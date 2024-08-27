local Utils = require("tropical_utils/utils")

local function OrderByPriority(l, r)
    return (l.action and l.action.priority or 0) > (r.action and r.action.priority or 0)
end

local MOD_COMPONENT_ACTIONS, MOD_ACTION_COMPONENT_NAMES

--我不想判断所有的POINT，这里把CollectActions的部分代码抄写过来
local function CollectNoEquipActions(self, actiontype, ...)
    if not MOD_COMPONENT_ACTIONS or not MOD_ACTION_COMPONENT_NAMES then
        -- 求上值要多次获取，多次判断，防止因为其他mod覆盖获得不到而崩溃
        MOD_COMPONENT_ACTIONS = Utils.ChainFindUpvalue(GLOBAL.AddComponentAction, "MOD_COMPONENT_ACTIONS")
            or Utils.ChainFindUpvalue(EntityScript.CollectActions, "CheckModComponentActions", "MOD_COMPONENT_ACTIONS")
            or Utils.ChainFindUpvalue(EntityScript.IsActionValid, "CheckModComponentActions", "MOD_COMPONENT_ACTIONS")
        MOD_ACTION_COMPONENT_NAMES = Utils.ChainFindUpvalue(GLOBAL.AddComponentAction, "MOD_ACTION_COMPONENT_NAMES")
            or Utils.ChainFindUpvalue(EntityScript.CollectActions, "CheckModComponentNames", "MOD_ACTION_COMPONENT_NAMES")
            or Utils.ChainFindUpvalue(EntityScript.IsActionValid, "CheckModComponentNames", "MOD_ACTION_COMPONENT_NAMES")
    end
    if self.modactioncomponents ~= nil and MOD_COMPONENT_ACTIONS and MOD_ACTION_COMPONENT_NAMES then
        for modname, cmplist in pairs(self.modactioncomponents) do
            local t = MOD_COMPONENT_ACTIONS[modname]
            t = t and t[actiontype] or nil
            if t ~= nil then
                local namemap = MOD_ACTION_COMPONENT_NAMES[modname] --组件名
                for i, id in ipairs(cmplist) do
                    local componentname = namemap[id]
                    if componentname == "tro_noequipactivator" then
                        -- 只判断tro_noequipactivator组件的componentaction
                        local collector = t[componentname]
                        if collector ~= nil then
                            collector(self, ...)
                        end
                    end
                end
            end
        end
    end
end

--- GetPointActions稍微修改
local function GetNoEquipPointActions(self, pos, useitem, right, target)
    local actions = {}

    -- 筛选满足条件的actions
    -- useitem:CollectActions("POINT", self.inst, pos, actions, right, target)
    CollectNoEquipActions(useitem, "POINT", self.inst, pos, actions, right, target)

    local sorted_acts = self:SortActionList(actions, pos, useitem)

    if not self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_STACK) then
        for i, v in ipairs(sorted_acts) do
            if v.action == ACTIONS.DROP then
                v.options.wholestack = true
                break
            end
        end
    end

    return sorted_acts
end

-- 如果在海难船上的时候，POINT类型的action不需要手持什么东西
local function NoEquipActivator(retTab, self, position, right)
    local acts = retTab[1]

    --追加的bufferedaction，这里第三个参数用于componentaction的inst参数，这里可以加判断修改第三个参数，
    --比如给船加个tro_noequipactivator组件，这里再替换成船，addcomponentaction里就可以添加船的判断，inst也是船体本身
    local acts2 = GetNoEquipPointActions(self, position, self.inst, right)
    for _, buf in ipairs(acts2) do
        table.insert(acts, buf)
    end
    table.sort(acts, OrderByPriority) --顺便和原来的一起排个序

    return retTab
end

local function GetLeftClickActionsAfter(retTab, self, position)
    return NoEquipActivator(retTab, self, position)
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

local function GetRightClickActionsAfter(retTab, self, position)
    return NoEquipActivator(retTab, self, position, true)
end

AddComponentPostInit("playeractionpicker", function(self)
    self.current_boat = nil --鼠标悬停的海难小船
    self.unregisterBoatTask = nil

    Utils.FnDecorator(self, "GetLeftClickActions", nil, GetLeftClickActionsAfter)
    Utils.FnDecorator(self, "GetRightClickActions", GetRightClickActionsBefore, GetRightClickActionsAfter)
end)
