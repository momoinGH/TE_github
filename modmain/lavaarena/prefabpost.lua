local Utils = require("tropical_utils/utils")

-- 对于熔炉、暴食里的一些预制件没有主机代码，但是有通用代码，其实只需要实现对应的主机代码就行了，没必要重新定义一个预制件
-- 该方法不够的地方再用AddPrefabPostInit补齐
local MyEventServerFiles = {}

Hooks.FnDecorator(GLOBAL, "requireeventfile", nil, function(retTab, fullpath)
    for k, v in pairs(MyEventServerFiles[fullpath] or {}) do
        retTab[1][k] = v --替换成我实现的初始化函数
    end

    return retTab
end)

---添加初始化函数
---@param eventname string
---@param path string
---@param data table
---@param assets table|nil 预制件需要的动画资源，最好加上，不知道为什么有的预制件明明可以生成，但是assets里的动画资源没加载
function add_event_server_data(eventname, path, data, assets)
    local fullpath = eventname .. "_event_server/" .. path
    MyEventServerFiles[fullpath] = data
    ConcatArrays(Assets, assets)
end

----------------------------------------------------------------------------------------------------

local ATTACK_MUST_TAGS = { "monster", "hostile" }
local ATTACK_ONEOF1_TAGS = { "_combat" }
local ATTACK_ONEOF2_TAGS = { "_combat", "CHOP_workable", "MINE_workable" }
local ATTACK_ONEOF3_TAGS = { "_combat", "CHOP_workable", "HAMMER_workable", "MINE_workable", "DIG_workable" }
local ATTACK_CANT_TAGS = { "player", "companion" }

---查找玩家可以攻击的目标
---@param attacker Entity 攻击者
---@param radius number 查找半径
---@param fn function|nil 额外的校验函数
---@param pos Vector3|nil 查找坐标，默认攻击者所在位置
---@param isforce boolean|nil 攻击目标是否包括中立单位，默认不攻击中立单位
---@param work_level number|boolean|nil 是否可以工作，工作等级，包括砍、挖、锤、凿
---@return table targets
function GetPlayerAttackTarget(attacker, radius, fn, pos, isforce, work_level)
    local targets = {}
    pos = pos or attacker:GetPosition()
    attacker.components.combat.ignorehitrange = true
    local oneof_tags = work_level == 2 and ATTACK_ONEOF3_TAGS
        or work_level and ATTACK_ONEOF2_TAGS
        or ATTACK_ONEOF1_TAGS
    for _, v in ipairs(TheSim:FindEntities(pos.x, pos.y, pos.z, radius, nil, ATTACK_CANT_TAGS, oneof_tags)) do
        if v.entity:IsVisible()
            and ((attacker.components.combat:CanTarget(v)
                    and (isforce
                        or v:HasOneOfTags(ATTACK_MUST_TAGS)
                        or (v.components.combat and v.components.combat.target and v.components.combat.target:HasOneOfTags(ATTACK_CANT_TAGS))))
                or (v.components.workable and v.components.workable:CanBeWorked()))
            and (not fn or fn(v, attacker))
        then
            table.insert(targets, v)
        end
    end
    attacker.components.combat.ignorehitrange = false
    return targets
end

----------------------------------------------------------------------------------------------------

--下面的文件根据源码调用add_event_server_data实现初始化函数就行了

--特效、建筑
modimport "modmain/lavaarena/event_server/firehits"
modimport "modmain/lavaarena/event_server/weaponsparks"
modimport "modmain/lavaarena/event_server/lavaarena_blooms"
modimport "modmain/lavaarena/event_server/fireball_projectile"
modimport "modmain/lavaarena/event_server/lavaarena_meteor"
modimport "modmain/lavaarena/event_server/damagenumber"
modimport "modmain/lavaarena/event_server/explosivehit"
modimport "modmain/lavaarena/event_server/lavaarena_battlestandard"
modimport "modmain/lavaarena/event_server/lavaarena_boarlord"
modimport "modmain/lavaarena/event_server/lavaarena_crowdstand"
modimport "modmain/lavaarena/event_server/lavaarena_groundlifts"
modimport "modmain/lavaarena/event_server/lavaarena_lootbeacon"
modimport "modmain/lavaarena/event_server/lavaarena_portal"
modimport "modmain/lavaarena/event_server/lavaarena_rhinobuff"
modimport "modmain/lavaarena/event_server/lavaarena_spawner"
modimport "modmain/lavaarena/event_server/sunderarmordebuff"
modimport "modmain/lavaarena/event_server/wathgrithr_bloodlustbuff"

-- 装备
modimport "modmain/lavaarena/event_server/blowdart_lava"
modimport "modmain/lavaarena/event_server/blowdart_lava2"
modimport "modmain/lavaarena/event_server/lavaarena_firebomb"
modimport "modmain/lavaarena/event_server/hammer_mjolnir"
modimport "modmain/lavaarena/event_server/spear_gungnir"
modimport "modmain/lavaarena/event_server/spear_lance"
modimport "modmain/lavaarena/event_server/lavaarena_heavyblade"
modimport "modmain/lavaarena/event_server/lavaarena_lucy"
modimport "modmain/lavaarena/event_server/healingstaff"
modimport "modmain/lavaarena/event_server/fireballstaff"
modimport "modmain/lavaarena/event_server/books_lavaarena"
modimport "modmain/lavaarena/event_server/armor_lavaarena"
modimport "modmain/lavaarena/event_server/hats_lavaarena"

-- 生物
modimport "modmain/lavaarena/event_server/lavaarena_beetletaur"
modimport "modmain/lavaarena/event_server/lavaarena_boaron"
modimport "modmain/lavaarena/event_server/lavaarena_boarrior"
modimport "modmain/lavaarena/event_server/lavaarena_elemental"
modimport "modmain/lavaarena/event_server/lavaarena_rhinodrill"
modimport "modmain/lavaarena/event_server/lavaarena_snapper"
modimport "modmain/lavaarena/event_server/lavaarena_trails"
modimport "modmain/lavaarena/event_server/lavaarena_turtillus"
modimport "modmain/lavaarena/event_server/lavaarena_peghook"


----------------------------------------------------------------------------------------------------

--- 根据装备计算增伤，必须要传入weapon才会计算
local function GetAttackedBefore(self, attacker, damage, weapon, ...)
    local damagetype = weapon and weapon.components.lavaarena_equip and weapon.components.lavaarena_equip.damagetype
    if damagetype and attacker and attacker.components.inventory then
        local mult = 1

        local item = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        local attack_mult = item and item.components.lavaarena_equip and item.components.lavaarena_equip.attack_mult
        mult = mult * (attack_mult and attack_mult[damagetype] or 1)

        item = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        attack_mult = item and item.components.lavaarena_equip and item.components.lavaarena_equip.attack_mult
        mult = mult * (attack_mult and attack_mult[damagetype] or 1)

        damage = damage * mult
        return nil, false, { self, attacker, damage, weapon, ... }
    end
end

AddComponentPostInit("combat", function(self, inst)
    Hooks.FnDecorator(self, "GetAttacked", GetAttackedBefore)
end)

----------------------------------------------------------------------------------------------------
AddPrefabPostInit("world", function(inst)
    inst:AddComponent("lavaarenamobtracker") --熔炉单位对象记录

    if not TheWorld.ismastersim then return end

    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_portal")                 --熔炉传送门
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_center")                 --角斗容器
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_battlestandard_damager") --战旗
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_battlestandard_shield")
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_battlestandard_heal")
end)

----------------------------------------------------------------------------------------------------
--根据战旗添加buff
local function StartTrackingBefore(self, ent)
    self.count = self.count + 1

    if TheWorld.ismastersim then
        for _, v in ipairs({
            "lavaarena_battlestandard_damager",
            "lavaarena_battlestandard_shield",
            "lavaarena_battlestandard_heal"
        }) do
            local flag = TheWorld.components.tro_tempentitytracker:GetEnts(v)[1]
            if flag then
                ent:AddDebuff(flag.debuffprefab, flag.debuffprefab)
            end
        end
    end
end

local function StopTrackingBefore(self)
    self.count = self.count - 1
end

AddComponentPostInit("lavaarenamobtracker", function(self)
    Hooks.FnDecorator(self, "StartTracking", StartTrackingBefore)
    Hooks.FnDecorator(self, "StopTracking", StopTrackingBefore)
end)
