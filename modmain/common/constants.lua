local Utils = require("tropical_utils/utils")

EQUIPSLOTS.SWBOAT = "swboat" --海难小船的装备槽


--渡渡鸟数量控制
_G.SEABEACH_AMOUNT = {
    doydoy = 0,
}

-- TODO 定义新的FUELTYPE最好给图鉴一个图片，用于图鉴wiki
-- FUELTYPE_SUBICON_LOOKUP
FUELTYPE.TAR = "TAR"                         -- tar.tex
FUELTYPE.REPARODEBARCO = "REPARODEBARCO"
FUELTYPE.LIVINGARTIFACT = "LIVINGARTIFACT"   -- living_artifact.tex
FUELTYPE.ANCIENT_REMNANT = "ANCIENT_REMNANT" -- ancient_remnant.tex
FUELTYPE.CORK = "CORK"                       -- cork.tex

MATERIALS.SANDBAG = "sandbag"
MATERIALS.LIMESTONE = "limestone"
MATERIALS.ENFORCEDLIMESTONE = "enforcedlimestone"

TOOLACTIONS["HACK"] = true
TOOLACTIONS["SHEAR"] = true
TOOLACTIONS["PAN"] = true

GLOBAL.ANTCHEST_PRESERVATION = {
    honey = true,
    royal_jelly = true,
    nectar_pod = true,
    pollen_item = true,
}

GLOBAL.SWP_WAVEBREAK_EFFICIENCY = { -- 破浪效率：var * 100%
    BUMPER = {
        kelp = .6,                  -- prefab = "boat_bumper_" .. k
        shell = .8,
        yotd = .8,
        crabking = 1,
    },
    BOAT = {
        boat = .3, -- prefab = k
        boat_pirate = .3,
        boat_ancient = .4,
        boatmetal = .9,
    }
}

Utils.FnDecorator(GLOBAL, "PlayFootstep", function(inst)
    return nil, inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT) --海难小船时不播放走路音效
end)

--- 掉落一个物品，ReplacePrefab的强化
GLOBAL.TropicalDropItem = function(inst, item, isremove)
    local product
    if isremove then
        product = ReplacePrefab(inst, item)
    else
        product = SpawnPrefab(item)
        product.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    if product.components.inventoryitem then
        product.components.inventoryitem:OnDropped()
    end
end


GLOBAL.AddComponentIfNot = function(inst, name)
    if not inst.components[name] then
        inst:AddComponent(name)
    end
end

----------------------------------------------------------------------------------------------------
-- 淘气值表

NAUGHTY_VALUE["lightflier"] = 1
NAUGHTY_VALUE["dustmoth"] = 4
NAUGHTY_VALUE["friendlyfruitfly"] = 20
NAUGHTY_VALUE["ballphin"] = 2
NAUGHTY_VALUE["toucan"] = 1
NAUGHTY_VALUE["parrot"] = 2
NAUGHTY_VALUE["parrot_pirate"] = 6
NAUGHTY_VALUE["seagull"] = 1
NAUGHTY_VALUE["crab"] = 1
NAUGHTY_VALUE["solofish"] = 2
NAUGHTY_VALUE["swordfish"] = 4
NAUGHTY_VALUE["whale_white"] = 6
NAUGHTY_VALUE["whale_blue"] = 7
NAUGHTY_VALUE["jellyfish_planted"] = 1
NAUGHTY_VALUE["rainbowjellyfish_planted"] = 1
NAUGHTY_VALUE["ox"] = 4
NAUGHTY_VALUE["lobster_land"] = 2
NAUGHTY_VALUE["primeape"] = 2
NAUGHTY_VALUE["doydoy"] = 8
NAUGHTY_VALUE["twister_seal"] = 50
NAUGHTY_VALUE["glowfly"] = 1
NAUGHTY_VALUE["pog"] = 2
NAUGHTY_VALUE["pangolden"] = 4
NAUGHTY_VALUE["kingfisher"] = 2
NAUGHTY_VALUE["quagmire_pigeon"] = 1
NAUGHTY_VALUE["dungbeetle"] = 3
NAUGHTY_VALUE["piko"] = 1
NAUGHTY_VALUE["piko_orange"] = 2
NAUGHTY_VALUE["hippopotamoose"] = 4
NAUGHTY_VALUE["mandrakeman"] = 3
NAUGHTY_VALUE["peagawk"] = 3
NAUGHTY_VALUE["zeb"] = 2
NAUGHTY_VALUE["chicken"] = 3

--猪人商店老板
NAUGHTY_VALUE["pigman_beautician"] = 6
NAUGHTY_VALUE["pigman_florist"] = 6
NAUGHTY_VALUE["pigman_erudite"] = 6
NAUGHTY_VALUE["pigman_hatmaker"] = 6
NAUGHTY_VALUE["pigman_storeowner"] = 6
NAUGHTY_VALUE["pigman_banker"] = 6
NAUGHTY_VALUE["pigman_collector"] = 6
NAUGHTY_VALUE["pigman_hunter"] = 6
NAUGHTY_VALUE["pigman_mayor"] = 6
NAUGHTY_VALUE["pigman_mechanic"] = 6
NAUGHTY_VALUE["pigman_professor"] = 6
NAUGHTY_VALUE["pigman_usher"] = 6
NAUGHTY_VALUE["pigman_royalguard"] = 6
NAUGHTY_VALUE["pigman_royalguard_2"] = 6
NAUGHTY_VALUE["pigman_farmer"] = 6
NAUGHTY_VALUE["pigman_miner"] = 6
NAUGHTY_VALUE["pigman_queen"] = 6
NAUGHTY_VALUE["pigman_beautician_shopkeep"] = 6
NAUGHTY_VALUE["pigman_florist_shopkeep"] = 6
NAUGHTY_VALUE["pigman_erudite_shopkeep"] = 6
NAUGHTY_VALUE["pigman_hatmaker_shopkeep"] = 6
NAUGHTY_VALUE["pigman_storeowner_shopkeep"] = 6
NAUGHTY_VALUE["pigman_banker_shopkeep"] = 6
NAUGHTY_VALUE["pigman_shopkeep"] = 6
NAUGHTY_VALUE["pigman_hunter_shopkeep"] = 6
NAUGHTY_VALUE["pigman_mayor_shopkeep"] = 6
NAUGHTY_VALUE["pigman_farmer_shopkeep"] = 6
NAUGHTY_VALUE["pigman_miner_shopkeep"] = 6
NAUGHTY_VALUE["pigman_collector_shopkeep"] = 6
NAUGHTY_VALUE["pigman_professor_shopkeep"] = 6
NAUGHTY_VALUE["pigman_mechanic_shopkeep"] = 6


----------------------------------------------------------------------------------------------------

-- 对于熔炉、暴食里的一些预制件没有主机代码，但是有通用代码，其实只需要实现对应的主机代码就行了，没必要重新定义一个预制件
-- 该方法不够的地方再用AddPrefabPostInit补齐
local MyEventServerFiles = {}

Utils.FnDecorator(GLOBAL, "requireeventfile", nil, function(retTab, fullpath)
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
