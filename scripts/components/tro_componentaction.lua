local pre = debug.getinfo(1, 'S').source:match("([^/]+)componentaction%.lua$") --当前文件前缀
local FNS = {}

--- 通用消耗品组件，主客机通用组件
--- 下面是不同类型的test，其中每个类型的其他函数去掉right就是了
--- SCENE：(inst, doer, right)
--- USEITEM：(inst, doer, target, right)
--- POINT：(inst, doer, pos, right)
--- UNARMED：(doer, pos, right) 无手持空手下对空地操作
--- EQUIPPED：(inst, doer, target, right)
--- INVENTORY：(inst, doer, right)
local ComponentAction = Class(function(self, inst)
    self.inst = inst

    self.actiontypes = {
        -- SCENE = {
        --     actiontype = nil,
        --     test = nil,               --
        --     state = "domediumaction", --
        --     str = nil,                --
        --     ---------------------------
        --     use = nil,                --
        --     extra_arrive_dist = nil,  --
        -- }
    }
end)

---初始化
---@param actiontype string
---@param test function|string
---@param state function|string|nil
---@param str function|string
---@param use function
---@param data table|nil {extra_arrive_dist,priority} 优先级priority需要在PRIORITIES表预设
function ComponentAction:Init(actiontype, test, state, str, use, data)
    data = data or {}

    assert(type(actiontype) == "string" and type(test) == "function" and (type(use) == "function" or type(use) == "string")
        , "这些值必须初始化 "
        .. tostring(type(actiontype) == "string") .. " "
        .. tostring(type(type(test) == "function")) .. " "
        .. tostring(type(use) == "function" or type(use) == "string"))

    local d = {}
    self.actiontypes[actiontype] = d --会覆盖掉重复的

    d.test = test
    d.state = state or "domediumaction"
    d.str = str
    d.extra_arrive_dist = data.extra_arrive_dist

    d.priority = data.priority or 0
    assert(ACTIONS["_" .. string.upper(pre) .. actiontype .. "_ACT" .. d.priority], actiontype .. "没有预设的优先级：" .. d.priority) --检查这个优先级的action有没有

    if not TheWorld.ismastersim then return end

    d.use = use
end

function ComponentAction:InitSCENE(test, state, str, use, data)
    self:Init("SCENE", test, state, str, use, data)
end

function ComponentAction:InitUSEITEM(test, state, str, use, data)
    self:Init("USEITEM", test, state, str, use, data)
end

function ComponentAction:InitPOINT(test, state, str, use, data)
    self:Init("POINT", test, state, str, use, data)
end

function ComponentAction:InitEQUIPPED(test, state, str, use, data)
    self:Init("EQUIPPED", test, state, str, use, data)
end

function ComponentAction:InitINVENTORY(test, state, str, use, data)
    self:Init("INVENTORY", test, state, str, use, data)
end

function ComponentAction:InitUNARMED(test, state, str, use, data)
    self:Init("UNARMED", test, state, str, use, data)
end

----------------------------------------------------------------------------------------------------

function ComponentAction:Test(actiontype, ...)
    return self.actiontypes[actiontype] and self.actiontypes[actiontype].test(self.inst, ...) or false
end

function ComponentAction:GetState(actiontype, ...)
    return self.actiontypes[actiontype] and FunctionOrValue(self.actiontypes[actiontype].state, self.inst, ...) or nil
end

function ComponentAction:GetStr(actiontype, ...)
    return self.actiontypes[actiontype] and FunctionOrValue(self.actiontypes[actiontype].str, self.inst, ...) or nil
end

function ComponentAction:Use(actiontype, ...)
    local d = self.actiontypes[actiontype]
    if not d then return false end

    if type(d.use) == "string" then
        return FNS[d.use] and FNS[d.use](self.inst, ...) or false
    else
        return d.use(self.inst, ...)
    end
end

function ComponentAction:GetExtraArriveDist(actiontype, ...)
    return self.actiontypes[actiontype] and FunctionOrValue(self.actiontypes[actiontype].extra_arrive_dist, self.inst, ...) or 0
end

----------------------------------------------------------------------------------------------------
-- 也许可以找个文件提前定义好，实现actions那样的代码复用。

function ComponentAction:AddFn(name, fn)
    FNS[name] = fn
end

function ComponentAction:GetFn(name)
    return FNS[name]
end

return ComponentAction
