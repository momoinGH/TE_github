local FN = {}

local _source = debug.getinfo(1, 'S').source
local KEY = "_" .. _source:match(".*scripts[/\\](.*)%.lua"):gsub("[/\\]", "_") .. "_"

local Utils = require(_source:match(".*scripts[/\\](.*[/\\])") .. "utils")
local Hooks = require("tro_utils/hooks")


---攻击对象检测，会攻击monster标签生物和当前仇恨对象，不会误伤其他单位
---攻击示例代码：
---inst.components.combat:DoAreaAttack(inst, 3, nil, function(ent, ins)
---    return Utils.TargetTest(ins, ent) and (not data.target or data.target ~= ent)
---end, nil, { "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" })
---要求data.target ~= ent是因为这段代码一般写在onattackother监听事件中的
---@return boolean
function FN.TargetTest(inst, target)
    if target.components.health and target.components.health:IsDead() then
        return false
    end
    -- or target:IsInLimbo() --比如乌龟缩壳

    if not inst.components.combat or inst.components.combat:IsAlly(target) then
        return false
    end

    local ismonster = target:HasTag("monster") or target:HasTag("hostile")
    if ismonster and not TheNet:GetPVPEnabled() and
        ((target.components.follower and target.components.follower.leader ~= nil and
            target.components.follower.leader:HasTag("player")) or target.bedazzled) then
        return false
    end

    return ismonster
end

----------------------------------------------------------------------------------------------------

--- 获取指定位置耕地地皮的湿度
local _overlaygrid, _moisturegrid
function FN.FarmingManagerGetMoisture(x, y, z)
    if not TheWorld.components.farming_manager then
        return 0
    end
    if not _overlaygrid then
        _overlaygrid = Hooks.GetUpValue(TheWorld.components.farming_manager.GetDebugString, "_overlaygrid")
        _moisturegrid = Hooks.GetUpValue(TheWorld.components.farming_manager.GetDebugString, "_moisturegrid")
    end
    -- 这里我不会判断是否读取到了，如果失败说明该更新代码了

    local index = _overlaygrid:GetIndex(TheWorld.Map:GetTileCoordsAtPoint(x, y, z))
    local nutrients_overlay = _overlaygrid:GetDataAtIndex(index) --if the tile is not used for farming then there is no need to track the moisture

    return nutrients_overlay and _moisturegrid:GetDataAtIndex(index) or 0
end

--- 获取指定位置耕地地皮的营养值
function FN.FarmingManagerGetNutrients(x, y, z)
    if not TheWorld.components.farming_manager then
        return 0, 0, 0
    end

    local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    return TheWorld.components.farming_manager:GetTileNutrients(tile_x, tile_z)
end

----------------------------------------------------------------------------------------------------
local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

---模拟父单位生成子的单位，设置子单位的坐标，来自猪人房生成猪人的逻辑
function FN.ReleaseChild(child, parent, data)
    local overridespawnlocation = Utils.GetVal(data, "overridespawnlocation")
    local spawnInWater = Utils.GetVal(data, "spawnInWater", false)
    local spawnOnBoats = Utils.GetVal(data, "spawnOnBoats", false)

    local x, y, z = parent.Transform:GetWorldPosition()
    y = 0

    if overridespawnlocation then
        x, y, z = overridespawnlocation(parent)
    else
        local rad = .5 + parent:GetPhysicsRadius(0) + child:GetPhysicsRadius(0)
        local start_angle = math.random() * TWOPI

        local offset = FindWalkableOffset(Vector3(x, 0, z), start_angle, rad, 8, false, true, NoHoles, spawnInWater,
            spawnOnBoats)
        if offset == nil then
            -- well it's gotta go somewhere!
            x = x + rad * math.cos(start_angle)
            z = z - rad * math.sin(start_angle)
        else
            x = x + offset.x
            z = z + offset.z
        end
    end
    if child.Physics ~= nil then
        child.Physics:Teleport(x, y, z)
    else
        child.Transform:SetPosition(x, y, z)
    end
end

----------------------------------------------------------------------------------------------------

--- 提高血量上限，血量百分比不变
function FN.SetMaxHealth(inst, maxHealth)
    local health = inst.components.health
    local per = health:GetPercent()
    health.maxhealth = maxHealth
    if health.currenthealth > 0 then --玩家有可能死亡
        health.currenthealth = per * maxHealth
    end
    health:ForceUpdateHUD(true) --handles capping health at max with penalty
end

--- 在原版函数基础上加一个可以判断的函数checkFn
function FN.FindClosestPlayerInRangeSq(x, y, z, rangesq, isalive, checkFn)
    local closestPlayer = nil
    for i, v in ipairs(AllPlayers) do
        if (isalive == nil or isalive ~= IsEntityDeadOrGhost(v))
            and (checkFn == nil or checkFn(v))
            and v.entity:IsVisible() then
            local distsq = v:GetDistanceSqToPoint(x, y, z)
            if distsq < rangesq then
                rangesq = distsq
                closestPlayer = v
            end
        end
    end
    return closestPlayer, closestPlayer ~= nil and rangesq or nil
end

--- 在原版函数的基础上，支持inst为一个Vector3类型，并且不排除死亡对象，返回找到的对象，距离
---@param inst Entity|Vector3
---@param radius number
---@param ignoreheight boolean|nil
---@param musttags table|nil
---@param canttags table|nil
---@param mustoneoftags table|nil
---@param fn function|nil
function FN.FindClosestEntity(inst, radius, ignoreheight, musttags, canttags, mustoneoftags, fn)
    local isEntity = inst and not inst.IsVector3
    if not inst or (isEntity and not inst:IsValid()) then
        return
    end

    local x, y, z
    if isEntity then
        x, y, z = inst.Transform:GetWorldPosition()
    else
        x, y, z = inst:Get()
    end

    local ents = TheSim:FindEntities(x, ignoreheight and 0 or y, z, radius, musttags, canttags, mustoneoftags)
    local closestEntity = nil
    local rangesq = radius * radius
    for i, v in ipairs(ents) do
        if (not isEntity or v ~= inst)
            -- and (not IsEntityDeadOrGhost(v))
            and v.entity:IsVisible()
            and (not fn or fn(v, inst)) then
            local distsq = v:GetDistanceSqToPoint(x, y, z)
            if distsq < rangesq then
                rangesq = distsq
                closestEntity = v
            end
        end
    end
    return closestEntity, closestEntity ~= nil and rangesq or nil
end

--- 判断单位是否死亡或正在死亡
--- 好像比IsEntityDeadOrGhost更好点，用IsEntityDeadOrGhost判断有时候还是会有"Left death state."的崩溃，我怀疑是有mod在玩家在death的
--- 状态下给玩家回血导致health:IsDead返回了false，判断玩家没有死，后来就调用了GoToState
function FN.IsEntityDeadOrGhost(player)
    return IsEntityDeadOrGhost(player)
        or (player.sg and player.sg:HasStateTag("dead"))
end

--- 获取rpc内的执行函数
function FN.GetModRPCFn(namespace, name)
    local id = MOD_RPC[namespace] and MOD_RPC[namespace][name]
    id = id and id.id
    return id and MOD_RPC_HANDLERS[namespace][id] or nil
end

local FIND_CLOSEST_KEY = KEY .. "tempDisSq"
local function SortByDis(a, b)
    return a[FIND_CLOSEST_KEY] < b[FIND_CLOSEST_KEY]
end

---按照离所给坐标的距离从小到大进行排序
function FN.SortEntsByDis(ents, centterPos)
    for _, v in ipairs(ents) do
        v[FIND_CLOSEST_KEY] = distsq(v:GetPosition(), centterPos)
    end

    table.sort(ents, SortByDis)

    for _, v in ipairs(ents) do
        v[FIND_CLOSEST_KEY] = nil
    end

    return ents
end

---FindEntities的增强，在此基础上按照离所给坐标的距离从小到大进行排序
function FN.FindClosestEntities(x, y, z, radius, musttags, canttags, mustoneoftags, centterPos)
    local ents = TheSim:FindEntities(x, y, z, radius, musttags, canttags, mustoneoftags)
    if #ents <= 1 then return ents end

    centterPos = centterPos or Vector3(x, y, z)
    return FN.SortEntsByDis(ents, centterPos)
end

---在一个对象表中查找里所给坐标最近的对象
---@param ents table 对象表
---@param pos Vector3 要查找的点
---@return Entity|nil ent 离所给点最近的对象
---@return number|nil rangesq 距离的平方
function FN.FindClosestEnt(ents, pos)
    local closestEnt = nil
    local rangesq = math.huge
    for i, v in ipairs(ents) do
        local distsq = distsq(v:GetPosition(), pos)
        if distsq < rangesq then
            rangesq = distsq
            closestEnt = v
        end
    end
    return closestEnt, closestEnt ~= nil and rangesq or nil
end

----------------------------------------------------------------------------------------------------
local function CanRemoveEnt(ent)
    if ent.prefab
        and not ent.widget
        and not ent.isplayer
        and not ent.entity:GetParent()
        and ent.Network
        and not ent:HasTag("CLASSIFIED")
        and not ent:HasTag("INLIMBO")
        and not ent:HasTag("irreplaceable")
    then
        return true
    end
end

-- 清除周围不重要的东西
function FN.ClearNearbyPrefabs(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, radius, nil, { "FX" })) do
        if v.prefab and v.prefab ~= inst.prefab and CanRemoveEnt(v) then
            v:Remove()
        end
    end
end

return FN
