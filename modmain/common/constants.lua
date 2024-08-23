local Utils = require("tropical_utils/utils")

--渡渡鸟数量控制
_G.SEABEACH_AMOUNT = {
    doydoy = 0,
}

-- TODO 定义新的FUELTYPE最好给图鉴一个图片，用于图鉴wiki
-- FUELTYPE_SUBICON_LOOKUP
FUELTYPE.TAR = "TAR"
FUELTYPE.REPARODEBARCO = "REPARODEBARCO"
FUELTYPE.LIVINGARTIFACT = "LIVINGARTIFACT"
FUELTYPE.ANCIENT_REMNANT = "ANCIENT_REMNANT" -- Runar: 在modmain太炸裂了
FUELTYPE.CORK = "CORK"

MATERIALS.SANDBAG = "sandbag"
MATERIALS.LIMESTONE = "limestone"
MATERIALS.ENFORCEDLIMESTONE = "enforcedlimestone"

TOOLACTIONS["HACK"] = true
TOOLACTIONS["SHEAR"] = true
TOOLACTIONS["PAN"] = true

Utils.FnDecorator(GLOBAL, "PlayFootstep", function(inst)
    local boat = inst:GetCurrentPlatform()
    return nil, boat and boat:HasTag("shipwrecked_boat") --海难小船时不播放走路音效
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
