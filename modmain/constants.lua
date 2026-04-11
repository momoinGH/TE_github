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

function _G.AddComponentIfNot(inst, name)
    if not inst.components[name] then
        inst:AddComponent(name)
    end
end



-- 关闭物理碰撞
function _G.ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

-- 开启物理碰撞
function _G.ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

-- 拿到装备的东西
function _G.TroGetEquippedItem(inst, eslot)
    if inst.components.inventory then
        return inst.components.inventory:GetEquippedItem(eslot)
    end
    return inst.replilca.inventory and inst.replilca.inventory:GetEquippedItem(eslot) or nil
end

-- 是否在哈姆雷特雾气中
function _G.TroInHamletFogImple(inst)
    return TheWorld.state.israining                                           --下雨
        and TheWorld.state.moisture > 500                                     --潮湿度，雨越下越小，这个值要看着效果调整
        and TheWorld.state.issummer                                           --夏天当潮湿季用
        and inst:IsInHamletArea()                                             --在哈姆雷特区域
        and not TheWorld.Map:TroIsWorldOut(inst.Transform:GetWorldPosition()) --不在虚空小房子里或虚空洞穴里
end

-- 是否可以抵抗哈姆雷特雾气
function _G.TroCanResistHamletFog(player)
    if player:HasTag("playerghost") then
        return true
    end
    if player.components.inventory then
        return player.components.inventory:EquipHasTag("clearfog")
    elseif player.replica.inventory then
        return player.replica.inventory:EquipHasTag("clearfog")
    end
end


-- 伤害类型
DAMAGETYPES = { PHYSICAL = 1, MAGIC = 2 }



---生成一个掉落物
---@param inst Entity 谁生成的，在inst脚下生成
---@param item string
---@param count int 数量
---@param target Entity 目标，如果有值，物品会飞向目标
function _G.TroSpawnDropItem(inst, item, count, target)
    count = count or 1
    for i = 1, count do
        local product = SpawnPrefab(item)
        if product then
            product.Transform:SetPosition(inst.Transform:GetWorldPosition())
            if target then
                LaunchAt(product, inst, target, 1, 4, .5)
            else
                if product.components.inventoryitem then
                    product.components.inventoryitem:OnDropped(true)
                end
            end
        end
    end
end

---简易的坐标附近生成实体的函数，经常用于在玩家附近生成一些怪物
---不能保证数量一定足够，没有找到合适的位置就会少生成
---@param prefab string 要生成的实体名，可以是一个数组
---@param pt Vector3
---@param count number
---@param radius number 生成半径
---@param offset_y number
---@param find_offset_fn function 查找偏移量的函数，一般是FindWalkableOffset、FindSwimmableOffset，默认是一个尝试12次查找陆地的函数
---@return table
function _G.TroSpawnRandomEntsInRange(prefab, pt, count, radius, offset_y, find_offset_fn)
    local ents = {}
    offset_y = offset_y or 0
    local function getrandomoffset()
        local theta = math.random() * 2 * PI
        local offset = find_offset_fn and find_offset_fn(pt) or FindWalkableOffset(pt, theta, radius, 12, true)
        if offset then
            return pt + offset
        end
    end

    for i = 1, count do
        local spawn_pt = getrandomoffset()
        if spawn_pt then
            spawn_pt.y = spawn_pt.y + offset_y

            local ent = nil
            if type(prefab) == "table" then
                ent = SpawnPrefab(prefab[math.random(1, #prefab)])
            else
                ent = SpawnPrefab(prefab)
            end
            if ent then
                if ent.Physics then
                    ent.Physics:Teleport(spawn_pt:Get())
                else
                    ent.Transform:SetPosition(spawn_pt.x, spawn_pt.y, spawn_pt.z)
                end
                table.insert(ents, ent)
            end
        end
    end
    return ents
end

--- 通过userid在AllPlayers中查找玩家
function _G.TroGetPlayerById(userid)
    for _, player in ipairs(AllPlayers) do
        if player.userid == userid then
            return player
        end
    end
end

-- 世界经过的总时间
function _G.TroGetTotalTime()
    return (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME
end
