-- TODO 定义新的FUELTYPE最好给图鉴一个图片，用于图鉴wiki
FUELTYPE.TAR = "TAR"                         -- tar.tex
FUELTYPE.REPARODEBARCO = "REPARODEBARCO"
FUELTYPE.LIVINGARTIFACT = "LIVINGARTIFACT"   -- living_artifact.tex
FUELTYPE.ANCIENT_REMNANT = "ANCIENT_REMNANT" -- ancient_remnant.tex
FUELTYPE.CORK = "CORK"                       -- cork.tex
FUELTYPE.BLOOD = "BLOOD"                     --新增一个燃料值：血，可以用蚊子血嚢给蝙蝠帽回耐久

MATERIALS.SANDBAG = "sandbag"
MATERIALS.LIMESTONE = "limestone"
MATERIALS.ENFORCEDLIMESTONE = "enforcedlimestone"

TOOLACTIONS["HACK"] = true
TOOLACTIONS["SHEAR"] = true
TOOLACTIONS["PAN"] = true




----------------------------------------------------------------------------------------------------

------ 淘气值表-----------------------------------

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
NAUGHTY_VALUE["pigeon"] = 1
NAUGHTY_VALUE["dungbeetle"] = 3
NAUGHTY_VALUE["piko"] = 1
NAUGHTY_VALUE["piko_orange"] = 2
NAUGHTY_VALUE["hippopotamoose"] = 4
NAUGHTY_VALUE["mandrakeman"] = 3
NAUGHTY_VALUE["peagawk"] = 3
NAUGHTY_VALUE["zeb"] = 2
NAUGHTY_VALUE["chicken"] = 3

--猪镇猪人
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

function AddComponentIfNot(inst, name)
    if not inst.components[name] then
        inst:AddComponent(name)
    end
end

GLOBAL.AddComponentIfNot = AddComponentIfNot


-- 关闭物理碰撞
function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

GLOBAL.ToggleOffPhysics = ToggleOffPhysics

-- 开启物理碰撞
function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

GLOBAL.ToggleOnPhysics = ToggleOnPhysics

-- 拿到装备的东西
function TroGetEquippedItem(inst, eslot)
    if inst.components.inventory then
        return inst.components.inventory:GetEquippedItem(eslot)
    end
    return inst.replilca.inventory and inst.replilca.inventory:GetEquippedItem(eslot) or nil
end

GLOBAL.TroGetEquippedItem = TroGetEquippedItem


--渡渡鸟数量控制
SEABEACH_AMOUNT = {
    doydoy = 0,
}



-- 是否在哈姆雷特雾气中
function TroInHamlteFogImple(inst)
    return TheWorld.state.israining                                           --下雨
        and TheWorld.state.moisture > 500                                     --潮湿度，雨越下越小，这个值要看着效果调整
        and TheWorld.state.issummer                                           --夏天当潮湿季用
        and inst:IsInHamletArea()                                             --在哈姆雷特区域
        and not TheWorld.Map:TroIsWorldOut(inst.Transform:GetWorldPosition()) --不在虚空小房子里或虚空洞穴里
end

GLOBAL.TroInHamlteFogImple = TroInHamlteFogImple

-- 是否可以抵抗哈姆雷特雾气
function TroCanResistHamletFog(player)
    if player:HasTag("playerghost") then
        return true
    end
    if player.components.inventory then
        return player.components.inventory:EquipHasTag("clearfog")
    elseif player.replica.inventory then
        return player.replica.inventory:EquipHasTag("clearfog")
    end
end

GLOBAL.TroCanResistHamletFog = TroCanResistHamletFog
