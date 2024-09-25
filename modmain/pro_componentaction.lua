--[[
@author: 绯世行
欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！

使用方法：
1. 修改文件名，把前缀改成自己mod的，比如上面两个文件的前缀为wxw_
2. 在需要的预制件文件里主客机通用部分添加组件并初始化
3. 一个是初始化文件，一个是组件文件，初始化文件要放在modmain的最后再引入
4. str需要的文本在STRINGS.ACTIONS.GIVE里追加

]]

-- 可以调节的action优先级，默认只有一种优先级为0的action，但有时候多个action同时满足时你想覆盖别的action，在下面的表中填入预设可选优先级，要求数字
local PRIORITIES = { 0, 11 }

----------------------------------------------------------------------------------------------------

local pre = debug.getinfo(1, 'S').source:match("([^/]+)componentaction%.lua$") --当前文件前缀
local COMP_NAME = pre .. "componentaction"

local SCENE_ACT = "_" .. string.upper(pre) .. "SCENE_ACT"
local USEITEM_ACT = "_" .. string.upper(pre) .. "USEITEM_ACT"
local POINT_ACT = "_" .. string.upper(pre) .. "POINT_ACT"
local EQUIPPED_ACT = "_" .. string.upper(pre) .. "EQUIPPED_ACT"
local INVENTORY_ACT = "_" .. string.upper(pre) .. "INVENTORY_ACT"
local UNARMED_ACT = "_" .. string.upper(pre) .. "UNARMED_ACT"

----------------------------------------------------------------------------------------------------

local function CreateAction(key, fn, strfn, extra_arrive_dist, act_hander)
    for _, priority in ipairs(PRIORITIES) do -- 给每个优先级创建5个action
        local ACT = Action({ mount_valid = true, canforce = true, extra_arrive_dist = extra_arrive_dist, priority = priority })
        local id = key .. priority
        ACT.id = id
        ACT.fn = fn
        ACT.strfn = strfn
        AddAction(ACT)

        STRINGS.ACTIONS[id] = STRINGS.ACTIONS.GIVE
        STRINGS.CHARACTERS.GENERIC.ACTIONFAIL[id] = STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.GIVE

        AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[id], act_hander))
        AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[id], act_hander))
    end
end

CreateAction(SCENE_ACT, function(act)
    local c = act.target and act.target.components[COMP_NAME]
    return c and c:Use("SCENE", act.doer) or false
end, function(act)
    local c = act.target and act.target.components[COMP_NAME]
    return c and c:GetStr("SCENE", act.doer) or nil
end, function(inst, dest, act)
    act = act or inst:GetBufferedAction() or {} --我也不知道这个值有没有可能为nil o(￣ヘ￣o＃).
    local c = act and act.target and act.target.components[COMP_NAME]
    return c and c:GetExtraArriveDist("SCENE", inst) or 0
end, function(inst, act)
    local c = act.target and act.target.components[COMP_NAME]
    return c and c:GetState("SCENE", inst) or nil
end)

CreateAction(USEITEM_ACT, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:Use("USEITEM", act.doer, act.target) or false
end, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetStr("USEITEM", act.doer, act.target) or nil
end, function(inst, dest, act)
    act = act or inst:GetBufferedAction() or {}
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetExtraArriveDist("USEITEM", inst, act.target) or 0
end, function(inst, act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetState("USEITEM", inst, act.target) or nil
end)

CreateAction(POINT_ACT, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:Use("POINT", act.doer, act:GetActionPoint()) or false
end, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetStr("POINT", act.doer, act:GetActionPoint()) or nil
end, function(inst, dest, act)
    act = act or inst:GetBufferedAction() or {}
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetExtraArriveDist("POINT", inst, act:GetActionPoint()) or 0
end, function(inst, act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetState("POINT", inst, act:GetActionPoint()) or nil
end)

CreateAction(EQUIPPED_ACT, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:Use("EQUIPPED", act.doer, act.target) or false
end, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetStr("EQUIPPED", act.doer, act.target) or nil
end, function(inst, dest, act)
    act = act or inst:GetBufferedAction() or {}
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetExtraArriveDist("EQUIPPED", inst, act.target) or 0
end, function(inst, act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetState("EQUIPPED", inst, act.target) or nil
end)

CreateAction(INVENTORY_ACT, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:Use("INVENTORY", act.doer) or false
end, function(act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetStr("INVENTORY", act.doer) or nil
end, function(inst, dest, act)
    act = act or inst:GetBufferedAction() or {}
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetExtraArriveDist("INVENTORY", inst) or 0
end, function(inst, act)
    local c = act.invobject and act.invobject.components[COMP_NAME]
    return c and c:GetState("INVENTORY", inst) or nil
end)

CreateAction(UNARMED_ACT, function(act)
    local c = act.doer.components[COMP_NAME]
    return c and c:Use("UNARMED", act:GetActionPoint()) or false
end, function(act)
    local c = act.doer.components[COMP_NAME]
    return c and c:GetStr("UNARMED", act:GetActionPoint()) or nil
end, function(inst, dest, act)
    act = act or inst:GetBufferedAction() or {}
    local c = act.doer.components[COMP_NAME]
    return c and c:GetExtraArriveDist("UNARMED", act:GetActionPoint()) or 0
end, function(inst, act)
    local c = act.doer.components[COMP_NAME]
    return c and c:GetState("UNARMED", act:GetActionPoint()) or nil
end)

--------------------------------------------------------------------------------------------------
-- 如果c不存在，可能是组件只在主机添加了，应当注意

AddComponentAction("SCENE", COMP_NAME, function(inst, doer, actions, right)
    local c = inst.components[COMP_NAME]
    if c:Test("SCENE", doer, right) then
        table.insert(actions, ACTIONS[SCENE_ACT .. c.actiontypes["SCENE"].priority])
    end
end)

AddComponentAction("USEITEM", COMP_NAME, function(inst, doer, target, actions, right)
    local c = inst.components[COMP_NAME]
    if c:Test("USEITEM", doer, target, right) then
        table.insert(actions, ACTIONS[USEITEM_ACT .. c.actiontypes["USEITEM"].priority])
    end
end)

AddComponentAction("POINT", COMP_NAME, function(inst, doer, pos, actions, right)
    local c = inst.components[COMP_NAME]
    if c:Test("POINT", doer, pos, right) then
        table.insert(actions, ACTIONS[POINT_ACT .. c.actiontypes["POINT"].priority])
    end
end)

AddComponentAction("EQUIPPED", COMP_NAME, function(inst, doer, target, actions, right)
    local c = inst.components[COMP_NAME]
    if c:Test("EQUIPPED", doer, target, right) then
        table.insert(actions, ACTIONS[EQUIPPED_ACT .. c.actiontypes["EQUIPPED"].priority])
    end
end)

AddComponentAction("INVENTORY", COMP_NAME, function(inst, doer, actions, right)
    local c = inst.components[COMP_NAME]
    if c:Test("INVENTORY", doer, right) then
        table.insert(actions, ACTIONS[INVENTORY_ACT .. c.actiontypes["INVENTORY"].priority])
    end
end)

----------------------------------------------------------------------------------------------------
local function OrderByPriority(l, r)
    return (l.action and l.action.priority or 0) > (r.action and r.action.priority or 0)
end

-- 这个使用GetPointSpecialActions来实现，但是不允许右键海上
-- AddComponentPostInit("playeractionpicker", function(self)
--     local OldGetPointSpecialActions = self.GetPointSpecialActions
--     self.GetPointSpecialActions = function(self, pos, useitem, right, usereticulepos, ...)
--         local bufs = OldGetPointSpecialActions(self, pos, useitem, right, usereticulepos, ...)
--         local c = self.inst.components[COMP_NAME]
--         if not useitem
--             and not (self.inst.replica.inventory and self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
--             and c
--             and c:Test("UNARMED", pos, right)
--         then
--             --需要我自己手动封装action和排序，需要注意角色如果有pointspecialactionsfn并且返回的action优先级高于这个，就不会执行了
--             table.insert(bufs, BufferedAction(self.inst, nil, ACTIONS[UNARMED_ACT .. c.actiontypes["UNARMED"].priority], nil, pos))
--             table.sort(bufs, OrderByPriority)
--         end
--         return bufs
--     end
-- end)

local function NoEquipActivator(bufs, self, pos, target, right)
    local c = self.inst.components[COMP_NAME]
    if not target                                                             --鼠标位置无目标
        and not self.inst.replica.inventory:GetActiveItem()                   --鼠标无选中物品
        and not self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) --无手持
        and c and c:Test("UNARMED", pos, right)
    then
        local actions = { ACTIONS[UNARMED_ACT .. c.actiontypes["UNARMED"].priority] }

        for _, buf in ipairs(self:SortActionList(actions, pos, useitem)) do
            table.insert(bufs, buf)
        end
        table.sort(bufs, OrderByPriority) --顺便和原来的一起排个序
    end
end

AddComponentPostInit("playeractionpicker", function(self)
    local OldGetLeftClickActions = self.GetLeftClickActions
    self.GetLeftClickActions = function(self, position, target, ...)
        local bufs = OldGetLeftClickActions(self, position, target, ...)
        NoEquipActivator(bufs, self, position, target, false)
        return bufs
    end

    local OldGetRightClickActions = self.GetRightClickActions
    self.GetRightClickActions = function(self, position, target, ...)
        local bufs = OldGetRightClickActions(self, position, target, ...)
        NoEquipActivator(bufs, self, position, target, true)
        return bufs
    end
end)
