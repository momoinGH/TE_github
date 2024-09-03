--[[
--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！

功能：
扩展标签数量上限、可用于FindEntities查找、装备和放置的标签限制

实现思路：
1. 定义一个标签表tags存储标签数据
2. hook标签相关方法
3. 在更新时发送rpc到客机同步标签数据
4. 实测rpc比net_string要快
]]

--key值，如果ONLY_MOD_TAGS为true则这个应该是拦截标签的前置
local KEY = "pro_"
--是否只拦截自己mod的标签，如果为false则拦截玩家绝大部分标签
local ONLY_MOD_TAGS = true
--拦截等级，默认只拦截EntityScripts相关方法，>=2表示拦截的标签也可用于FindEntities查找，>=3表示拦截的标签可用于装备和放置组件的标签限制
local HOOK_LEVEL = 2

--[[
- 建议 KEY 填写自己的mod前缀，而且mod标签最好也加上mod前缀，
- ONLY_MOD_TAGS 填写true，只处理自己mod的标签就好了
- HOOK_LEVEL 填写1或者2，不过如果确定不会查找自己mod标签就不用填2
]]


----------------------------------------------------------------------------------------------------

AddClientModRPCHandler("TagExtend", "UpdateTag", function(data)
    local d = ThePlayer and ThePlayer[KEY .. "tagData"]
    if d then --只处理客机
        for tag, enable in pairs(json.decode(data)) do
            d.tags[tag] = enable or nil
        end
    end
end)

--- 有些标签延迟一帧设置会有些问题，这里让经常更新的标签跳过拦截调用原方法
local EXCLUDE_TAGS = {
    notarget = true,
    spawnprotection = true,

    --state会添加的标签
    attack = true,
    autopredict = true,
    busy = true,
    dirt = true,
    doing = true,
    fishing = true,
    flight = true,
    hiding = true,
    idle = true,
    invisible = true,
    lure = true,
    moving = true,
    nibble = true,
    noattack = true,
    nopredict = true,
    pausepredict = true,
    sleeping = true,
    working = true,
    boathopping = true,
}

---函数装饰器，增强原有函数的时候可以使用
---@param beforeFn function|nil 先于fn执行，参数为fn参数，返回三个值：新返回值表、是否跳过旧函数执行，旧函数执行参数（要求是表，会用unpack解开）
---@param afterFn function|nil 晚于fn执行，第一个参数为前面执行后的返回值表，后续为fn的参数，返回值作为最终返回值（要求是表或nil，会用unpack解开）
---@param isUseBeforeReturn boolean|nil 在没有afterFn却有beforeFn的时候，是否采用beforeFn的返回值作为最终返回值，默认以原函数的返回值作为最终返回值
local function FnDecorator(obj, key, beforeFn, afterFn, isUseBeforeReturn)
    assert(type(obj) == "table")
    assert(beforeFn == nil or type(beforeFn) == "function", "beforeFn must be nil or a function")
    assert(afterFn == nil or type(afterFn) == "function", "afterFn must be nil or a function")

    local oldVal = obj[key]

    obj[key] = function(...)
        local retTab, isSkipOld, newParam, r
        if beforeFn then
            retTab, isSkipOld, newParam = beforeFn(...)
        end

        if type(oldVal) == "function" and not isSkipOld then
            if newParam ~= nil then
                r = { oldVal(unpack(newParam)) }
            else
                r = { oldVal(...) }
            end
            if not isUseBeforeReturn then
                retTab = r
            end
        end

        if afterFn then
            retTab = afterFn(retTab, ...)
        end

        if retTab == nil then
            return nil
        end
        return unpack(retTab)
    end
end



local function UpdateTag(inst)
    inst[KEY .. "tagUpdateTask"] = nil
    local data = inst[KEY .. "tagData"]
    if next(data.cache) then
        SendModRPCToClient(GetClientModRPC("TagExtend", "UpdateTag"), nil, json.encode(data.cache))

        data.cache = {}
    end
end

local function OnTagDirty(inst)
    local data = inst[KEY .. "tagData"]
    local tags = json.decode(data.tag_dirty:value())
    -- print("处理", GetTime(), inst, data.tag_dirty:value())
    for tag, enable in pairs(tags) do
        data.tags[tag] = enable or nil
    end
end

local function TagNeedUpdate(inst)
    if TheWorld.ismastersim then
        --如果该单位在休眠，则本地不会立刻调用监听回调，只会在进入加载范围后才进行，不过正常玩家用不到这一步，只有直接生成的玩家的对象才需要
        if inst:IsAsleep() then
            inst.entity:SetCanSleep(false)
        end

        local k = KEY .. "tagUpdateTask"
        if not inst[k] then
            --本来写成0，但是加载时前后两帧推送的数据在客机还是只收最后一次的，这里延长推送时间，希望解决这个问题
            inst[k] = inst:DoTaskInTime(FRAMES * 2, UpdateTag)
        end
    end
end

local function AddTagBefore(inst, tag)
    tag = string.lower(tag)
    if EXCLUDE_TAGS[tag]                                  --不应该延迟
        or string.find(tag, "_") == 1                     --不处理组件副件
        or (ONLY_MOD_TAGS and string.find(tag, KEY) ~= 1) --只处理mod标签
    then
        return
    end

    local data = inst[KEY .. "tagData"]
    if not data.tags[tag] then --没有时才更新
        data.tags[tag] = true
        data.cache[tag] = true --缓存
        TagNeedUpdate(inst)
    end
    return nil, true
end

local function RemoveTagBefore(inst, tag)
    tag = string.lower(tag)
    local data = inst[KEY .. "tagData"]
    if data.tags[tag] then
        data.tags[tag] = nil
        data.cache[tag] = false
        TagNeedUpdate(inst)
    end
end

local function AddOrRemoveTag(inst, tag, condition)
    if condition then
        inst:AddTag(tag)
    else
        inst:RemoveTag(tag)
    end
end

local function HasTagBefore(inst, tag)
    return { true }, inst[KEY .. "tagData"].tags[tag]
end

local function HasTagsBefore(inst, ...)
    local tags = select(1, ...)
    local t = {}
    for _, v in ipairs(type(tags) == "table" and tags or { ... }) do
        if not inst:HasTag(v) then
            table.insert(t, v)
        end
    end

    if #t <= 0 then
        return { true }, true
    end

    return nil, false, { inst, t }
end

local function HasOneOfTagsBefore(inst, ...)
    local tags = select(1, ...)
    for _, v in ipairs(type(tags) == "table" and tags or { ... }) do
        if inst:HasTag(v) then --如果是表里套表，保持崩溃，因为原版也会崩溃
            return { true }, true
        end
    end
end

AddPlayerPostInit(function(inst)
    inst[KEY .. "tagData"] = {
        tags = {},  --自己记录的标签
        cache = {}, --缓存，存储需要同步的数据
    }

    if not TheNet:IsDedicated() then
        inst:ListenForEvent(KEY .. "tag_dirty", OnTagDirty) --只有客机需要监听
    end

    FnDecorator(inst, "AddTag", AddTagBefore)
    FnDecorator(inst, "RemoveTag", RemoveTagBefore)
    inst.AddOrRemoveTag = AddOrRemoveTag
    FnDecorator(inst, "HasTag", HasTagBefore)
    FnDecorator(inst, "HasTags", HasTagsBefore)
    inst.HasAllTags = inst.HasTags
    FnDecorator(inst, "HasOneOfTags", HasOneOfTagsBefore)
    inst.HasAnyTag = inst.HasOneOfTags
end)

if HOOK_LEVEL < 2 then return end
-- 不再执行

----------------------------------------------------------------------------------------------------
-- 检查一下参数，有些mod不规范，比如永不妥协，表里套表或者单纯一个字符串什么的
local function CheckTagTable(tags)
    if not tags then return end

    local res = {}
    if type(tags) == "table" then
        for _, v in ipairs(tags) do
            if type(v) == "string" then
                table.insert(res, v)
            end
        end
        return res
    elseif type(tags) == "string" then
        table.insert(res, tags)
        return res
    end
end

--全部查找并且自己标签判断，可能有点儿效率问题，感觉加了游戏会变卡，但又不得不覆盖
local oldFindEntities = getmetatable(TheSim).__index["FindEntities"]
getmetatable(TheSim).__index["FindEntities"] = function(self, x, y, z, radius, mustTags, cantTags, oneOfTags)
    local res = oldFindEntities(self, x, y, z, radius)
    if #res <= 0 then return res end

    mustTags = CheckTagTable(mustTags)
    cantTags = CheckTagTable(cantTags)
    oneOfTags = CheckTagTable(oneOfTags)

    local ents = {}
    for _, v in ipairs(res) do
        if (not mustTags or v:HasTags(mustTags))
            and (not cantTags or not v:HasOneOfTags(cantTags))
            and (not oneOfTags or v:HasOneOfTags(oneOfTags))
        then
            table.insert(ents, v)
        end
    end

    return ents
end

if HOOK_LEVEL < 3 then return end
----------------------------------------------------------------------------------------------------

AddPrefabPostInit("inventoryitem_classified", function(inst)
    --新增一个网络变量来记录标签的字符串值
    inst[KEY .. "equiprestrictedtag"] = net_string(inst.GUID, "equippable. " .. KEY .. "restrictedtag")
    inst[KEY .. "deployrestrictedtag"] = net_string(inst.GUID, "deployable." .. KEY .. "restrictedtag")
end)

AddClassPostConstruct("components/inventoryitem_replica", function(self)
    FnDecorator(self, "SetEquipRestrictedTag", function(self, restrictedtag)
        self.classified[KEY .. "equiprestrictedtag"]:set_local(restrictedtag or "")
        self.classified[KEY .. "equiprestrictedtag"]:set(restrictedtag or "")
    end)

    FnDecorator(self, "SetEquipRestrictedTag", function(self, restrictedtag)
        self.classified[KEY .. "deployrestrictedtag"]:set_local(restrictedtag or "")
        self.classified[KEY .. "deployrestrictedtag"]:set(restrictedtag or "")
    end)


    --- 把原来的散列值替换成字符串，不知道有没有什么问题
    function self:GetEquipRestrictedTag()
        if self.inst.components.equippable ~= nil then
            return self.inst.components.equippable:GetRestrictedTag() --话说这个方法已经不存在了，留着是个bug
        end
        -- ###
        return self.classified ~= nil
            and self.classified[KEY .. "equiprestrictedtag"]:value() ~= ""
            and self.classified[KEY .. "equiprestrictedtag"]:value()
            or nil
    end

    function self:IsDeployable(deployer)
        if self.inst.components.deployable ~= nil then
            return self.inst.components.deployable:IsDeployable(deployer)
        elseif self.classified == nil or self.classified.deploymode:value() == DEPLOYMODE.NONE then
            return false
        end
        -- ###
        -- local restrictedtag = self.classified.deployrestrictedtag:value()
        -- if restrictedtag and restrictedtag ~= 0 and not (deployer and deployer:HasTag(restrictedtag)) then
        --     return false
        -- end
        local restrictedtag = self.classified[KEY .. "deployrestrictedtag"]:value()
        if restrictedtag and restrictedtag ~= "" and not (deployer and deployer:HasTag(restrictedtag)) then
            return false
        end
        local rider = deployer and deployer.replica.rider or nil
        if rider and rider:IsRiding() then
            --can only deploy tossables while mounted
            return self.inst:HasTag("projectile")
        end
        return true
    end
end)
