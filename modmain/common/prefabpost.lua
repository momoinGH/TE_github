local Utils = require("tropical_utils/utils")



----------------------------------------------------------------------------------------------------

-- 太长的单独写一个文件了
modimport "modmain/common/components/locomotor"
modimport "modmain/common/components/birdspawner"
modimport "modmain/common/components/map"
modimport "modmain/common/components/playervision"
modimport "modmain/common/components/temperature"
modimport "modmain/common/components/inventory"
modimport "modmain/common/components/builder"
modimport "modmain/common/components/inventoryitem"
modimport "modmain/common/components/walkableplatformplayer"
modimport "modmain/common/components/playeractionpicker"

modimport "modmain/common/prefabs/oceanfishdef"
modimport "modmain/common/prefabs/allplayers"
modimport "modmain/common/prefabs/world"



----------------------------------------------------------------------------------------------------
local function ArmorCanResistBefore(self, attacker, weapon)
    if attacker and self.immunetags then
        for k, v in pairs(self.immunetags) do
            if attacker:HasTag(v) or (weapon ~= nil and weapon:HasTag(v)) then
                return { false }, true
            end
        end
    end
end

AddComponentPostInit("armor", function(self)
    self.immunetags = nil --不能抵抗标签，如果指定了标签，则对于含有该标签的攻击者伤害不抵抗，与tags不同，tags只能抵抗记录已有标签的攻击

    function self:SetImmuneTags(tags)
        self.immunetags = tags
    end

    Utils.FnDecorator(self, "CanResist", ArmorCanResistBefore)
end)

----------------------------------------------------------------------------------------------------
-- 用于控制熊大和巨鹿刷新条件，组件没有可以hook的方法，只好通过该方式来阻止生成
local function AreaAwareCurrentlyInTagBefore(self, tag)
    if tag == "nohasslers" and (
            self:CurrentlyInTag("tropical")
            or self:CurrentlyInTag("hamlet")
            or self:CurrentlyInTag("frost")
        )
    then
        return { true }, true
    end
end

AddComponentPostInit("areaaware", function(self)
    Utils.FnDecorator(self, "CurrentlyInTag", AreaAwareCurrentlyInTagBefore)
end)

----------------------------------------------------------------------------------------------------

local function IsSpecialTile(tile)
    local isCave = TheWorld:HasTag("cave")
    return tile == GROUND.UNDERWATER_SANDY
        or tile == GROUND.UNDERWATER_ROCKY
        or (isCave and (tile == GROUND.BEACH
            or tile == GROUND.MAGMAFIELD
            or tile == GROUND.PAINTED
            or tile == GROUND.BATTLEGROUND
            or tile == GROUND.PEBBLEBEACH
            or tile == GROUND.ANTFLOOR
            or tile == GROUND.WATER_MANGROVE
        ))
end

local function DeployableCanDeployBefore(self, pt)
    local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
    return { false }, IsSpecialTile(tile)
end

local function ForceDeploy(self, pt, deployer)
    if self.ondeploy ~= nil then
        self.ondeploy(self.inst, pt, deployer)
    end
    -- self.inst is removed during ondeploy
    deployer:PushEvent("deployitem", { prefab = self.inst.prefab })
    return true
end

AddComponentPostInit("deployable", function(self)
    self.ForceDeploy = ForceDeploy

    Utils.FnDecorator(self, "CanDeploy", DeployableCanDeployBefore)
end)


----------------------------------------------------------------------------------------------------
-- 不会落水
local function DrownableShouldDrownBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 30, { "interior_center" }) > 0 then
        return { false }, true
    end
end


AddComponentPostInit("drownable", function(self)
    Utils.FnDecorator(self, "ShouldDrown", DrownableShouldDrownBefore)
end)


----------------------------------------------------------------------------------------------------

local flotsam_prefabs
AddComponentPostInit("flotsamgenerator", function(self)
    if not flotsam_prefabs then
        flotsam_prefabs = Utils.ChainFindUpvalue(self.SpawnFlotsam, "PickFlotsam", "flotsam_prefabs")
        if flotsam_prefabs then
            flotsam_prefabs["waterygrave"] = 1
            flotsam_prefabs["redbarrel"] = 1
            flotsam_prefabs["luggagechest_spawner"] = 1
            flotsam_prefabs["messagebottle1"] = 1
        end
    end
end)


----------------------------------------------------------------------------------------------------

AddComponentPostInit("groundpounder", function(self)
    table.insert(self.noTags, "groundpoundimmune")
end)


----------------------------------------------------------------------------------------------------
AddComponentPostInit("plantregrowth", function(self)
    self.TimeMultipliers["mushtree_yelow"] = function()
        return TUNING.MUSHTREE_REGROWTH_TIME_MULT * ((not TheWorld.state.autumn and 0) or 1)
    end
end)

----------------------------------------------------------------------------------------------------
-- 地震组件quaker不好覆盖，这里判断如果是地震生成的物品就直接删除

local function CheckIsQUaker(inst)
    if not inst.persists and inst.shadow and inst.updatetask then --地震生成的，根据quaker组件的SpawnDebris函数进行判断
        local x, _, z = inst.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
        if IsSpecialTile(tile) then
            inst:Remove()
        end
    end
end

for _, v in ipairs({
    "rocks",
    "rabbit",
    "mole",
    "carrat",
    "flint",
    "goldnugget",
    "nitre",
    "redgem",
    "bluegem",
    "marble",
    "moonglass",
    "rock_avocado_fruit",
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:ListenForEvent("startfalling", CheckIsQUaker)
    end)
end

----------------------------------------------------------------------------------------------------

local FX_MAP
AddComponentPostInit("spooked", function(self)
    if not FX_MAP then
        FX_MAP = Utils.ChainFindUpvalue(self.Spook, "FX_MAP")
        if FX_MAP then
            FX_MAP["mushtree_yelow"] = "mushtree_yelow"
        end
    end
end)

----------------------------------------------------------------------------------------------------
local function DoSpringBefore(self)
    if self.target
        and self.target:IsValid()
        and not self.target:IsInLimbo()
        and not (self.target.components.health ~= nil and self.target.components.health:IsDead())
        and self.target.components.inventoryitem ~= nil
        and self.target.components.inventoryitem.trappable
    then
        local old = self.target.prefab
        self.target.prefab = old == "lobster" and "lobster_land"
            or old == "wobster_sheller" and "wobster_sheller_land"
            or old == "wobster_moonglass" and "wobster_moonglass_land"
    end
end

AddComponentPostInit("trap", function(self)
    Utils.FnDecorator(self, "DoSpring", DoSpringBefore)
end)

Utils.FnDecorator(GLOBAL, "GetTemperatureAtXZ", nil, function(retTab, x, z)
    local val = next(retTab)
    if val > TUNING.WILDFIRE_THRESHOLD then
        -- 防野火
        if #TheSim:FindEntities(x, 0, z, 20, { "interior_center" }) > 0 then
            return { TUNING.WILDFIRE_THRESHOLD }
        end

        local player = FindClosestPlayerInRangeSq(x, 0, z, 400)
        if player and player.components.areaaware and player.components.areaaware:CurrentlyInTag("frost") then
            return { TUNING.WILDFIRE_THRESHOLD }
        end
    end

    return retTab
end)




----------------------------------------------------------------------------------------------------




AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("economy")
    inst:AddComponent("shadowmanager")
    inst:AddComponent("tro_interiorspawner")

    if TUNING.tropical.sealnado then
        inst:AddComponent("twisterspawner")
    end

    if TUNING.tropical.only_hamlet or GetModConfigData("Hamlet") ~= 5 then
        inst:AddComponent("roottrunkinventory")
    end

    if not TUNING.tropical.only_shipwrecked
        and (TUNING.tropical.only_hamlet or GetModConfigData("Hamlet") ~= 5
            and TUNING.tropical.pigruins
            and TUNING.tropical.aporkalypse)
    then
        inst:AddComponent("aporkalypse")
    end

    if not TUNING.tropical.only_shipwrecked and GetModConfigData("Hamlet") ~= 5 then
        inst:AddComponent("tropicalgroundspawner")
    end

    if GetModConfigData("aquaticcreatures") and (
            TUNING.tropical.kindofworld == 15 or TUNING.tropical.only_shipwrecked or TUNING.tropical.only_sea)
    then
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
    end

    if TUNING.tropical.only_hamlet then
        inst:AddComponent("shadowmanager")
        inst:AddComponent("rocmanager")
    end

    if not TUNING.tropical.only_shipwrecked then
        inst:AddComponent("quaker_interior")
    end
end)

AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("roottrunkinventory")
    inst:AddComponent("quaker_interior")
    inst:AddComponent("economy")
    inst:AddComponent("tro_interiorspawner")
end)

----------------------------------------------------------------------------------------------------




if TUNING.tropical.only_sea then
    for _, v in ipairs({
        "rocks",
        "nitre",
        "flint",
        "goldnugget",
        "moonrocknugget",
        "moonglass",
        "moonrockseed"
    }) do
        AddPrefabPostInit(v, function(inst)
            MakeInventoryFloatable(inst, "small", 0.15)

            if not TheWorld.ismastersim then return end

            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end)
    end
end






----------------------------------------------------------------------------------------------------

local function OnPoisonOverDirty(inst)
    if inst._parent and inst._parent.HUD then
        if inst.poisonover:value() then
            inst._parent.HUD.poisonover:Flash()
        end
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst.poisonover = net_bool(inst.GUID, "poison.poisonover", "poisonoverdirty") --中毒HUD

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("poisonoverdirty", OnPoisonOverDirty)
    end
end)
----------------------------------------------------------------------------------------------------

AddPrefabPostInit("ash", function(inst)
    if not TheWorld.ismastersim then return end

    AddComponentIfNot(inst, "fertilizer")
end)

----------------------------------------------------------------------------------------------------

-- 防止在季节/潮湿季节里雾的减速效果。
for _, v in ipairs({
    "bathat",
    "pithhat",
    "armor_weevole",
}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("velocidadenormal")
    end)
end

----------------------------------------------------------------------------------------------------
-- 浪花碰撞检测对象
for _, v in ipairs({
    "seastack",
    "wreck",
    "waterygrave",
    "octopusking",
    "ballphinhouse",
    "saltstackthen",
    "wall_enforcedlimestone",
    "sea_yard"
}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("quebraonda")
    end)
end

----------------------------------------------------------------------------------------------------


for _, v in ipairs({
    "houndstooth",
    "gunpowder",
    "boards",
    "mosquitosack",
    "nightmarefuel",
    "stinger",
    "spear",
    "spear_wathgrithr"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        AddComponentIfNot(inst, "tradable")
    end)
end

----------------------------------------------------------------------------------------------------
-- 如果夏季考拉象在冰岛上生成则替换成冬季的
local function OnSpawnedForHunt(inst, data)
    local ground = TheWorld.Map:GetTileAtPoint(inst.Transform:GetWorldPosition())
    if ground == GROUND.WATER_MANGROVE or ground == GROUND.ANTFLOOR then
        ReplacePrefab(inst, "koalefant_winter")
    end
end

AddPrefabPostInit("koalefant_summer", function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("spawnedforhunt", OnSpawnedForHunt)
end)

----------------------------------------------------------------------------------------------------

AddPrefabPostInitAny(function(inst)
    -----mostra neve--------------
    if inst:HasTag("SnowCovered") then
        inst:DoTaskInTime(0.5, function(inst)
            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
            if ground == WORLD_TILES.WATER_MANGROVE or ground == WORLD_TILES.ANTFLOOR then
                inst:AddTag("mostraneve")
            end
        end)
    end

    if not TheWorld.ismastersim then return end

    if TheWorld.components.tro_tempentitytracker and TheWorld.components.tro_tempentitytracker:KeyExists(inst.prefab) then
        TheWorld.components.tro_tempentitytracker:OnEntSpawned(inst)
    end

    -- Only fightable mobs can be poisonable 中毒组件
    if inst.components.combat and inst.components.poisonable == nil then
        inst:AddComponent("poisonable")
    end

    -- 被毒死时生成的掉落物处理
    if inst.components.perishable then
        inst:ListenForEvent("on_loot_dropped", OnLootDropped)
    end
end)

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------------
local function ShelteredOnUpdateBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if not self.mounted
        and #TheSim:FindEntities(x, y, z, 40, { "interior_center" }) > 0
    then
        self:SetSheltered(true)
        return nil, true
    end
end

AddComponentPostInit("sheltered", function(self)
    Utils.FnDecorator(self, "OnUpdate", ShelteredOnUpdateBefore)
end)

----------------------------------------------------------------------------------------------------

AddSimPostInit(function()
    EmitterManager.old_updatefuncs = { snow = nil, rain = nil, pollen = nil }
    Utils.FnDecorator(EmitterManager, "PostUpdate", function(self, ...)
        for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
            if inst.prefab == "pollen" or inst.prefab == "snow" or inst.prefab == "rain" then
                if self.old_updatefuncs[inst.prefab] == nil then
                    self.old_updatefuncs[inst.prefab] = data.updateFunc
                end
                local x, y, z = inst.Transform:GetWorldPosition()
                if #TheSim:FindEntities(x, y, z, 40, { "interior_center" }) > 0 then
                    data.updateFunc = function() end -- empty function
                else
                    data.updateFunc = self.old_updatefuncs[inst.prefab] ~= nil and self.old_updatefuncs[inst.prefab] or
                        function() end -- the original one
                end
            end
        end
    end)
end)

----------------------------------------------------------------------------------------------------
if TUNING.tropical.only_hamlet then
    AddSimPostInit(function()
        if TheNet:IsDedicated() or not TheWorld or not TheWorld.WaveComponent then
            return
        end

        TheWorld.Map:SetUndergroundFadeHeight(0)
        TheWorld.Map:AlwaysDrawWaves(true)
        TheWorld.WaveComponent:SetWaveTexture(resolvefilepath("images/fog_cloud.tex"))
        local scale = 1
        local map_width, map_height = TheWorld.Map:GetSize()
        TheWorld.WaveComponent:SetWaveParams(13.5, 2.5, -1)
        TheWorld.WaveComponent:Init(map_width, map_height)
        TheWorld.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)
        TheWorld.WaveComponent:SetWaveMotion(0.3, 0.5, 0.35)

        local map = TheWorld.Map
        local tuning = TUNING.OCEAN_SHADER
        map:SetOceanEnabled(true)
        map:SetOceanTextureBlurParameters(tuning.TEXTURE_BLUR_PASS_SIZE, tuning.TEXTURE_BLUR_PASS_COUNT)
        map:SetOceanNoiseParameters0(tuning.NOISE[1].ANGLE, tuning.NOISE[1].SPEED, tuning.NOISE[1].SCALE,
            tuning.NOISE[1].FREQUENCY)
        map:SetOceanNoiseParameters1(tuning.NOISE[2].ANGLE, tuning.NOISE[2].SPEED, tuning.NOISE[2].SCALE,
            tuning.NOISE[2].FREQUENCY)
        map:SetOceanNoiseParameters2(tuning.NOISE[3].ANGLE, tuning.NOISE[3].SPEED, tuning.NOISE[3].SCALE,
            tuning.NOISE[3].FREQUENCY)

        local waterfall_tuning = TUNING.WATERFALL_SHADER.NOISE
        map:SetWaterfallFadeParameters(TUNING.WATERFALL_SHADER.FADE_COLOR[1] / 255,
            TUNING.WATERFALL_SHADER.FADE_COLOR[2] / 255, TUNING.WATERFALL_SHADER.FADE_COLOR[3] / 255,
            TUNING.WATERFALL_SHADER.FADE_START)
        map:SetWaterfallNoiseParameters0(waterfall_tuning[1].SCALE, waterfall_tuning[1].SPEED,
            waterfall_tuning[1].OPACITY, waterfall_tuning[1].FADE_START)
        map:SetWaterfallNoiseParameters1(waterfall_tuning[2].SCALE, waterfall_tuning[2].SPEED,
            waterfall_tuning[2].OPACITY, waterfall_tuning[2].FADE_START)

        local minimap_ocean_tuning = TUNING.OCEAN_MINIMAP_SHADER
        map:SetMinimapOceanEdgeColor0(minimap_ocean_tuning.EDGE_COLOR0[1] / 255,
            minimap_ocean_tuning.EDGE_COLOR0[2] / 255, minimap_ocean_tuning.EDGE_COLOR0[3] / 255)
        map:SetMinimapOceanEdgeParams0(minimap_ocean_tuning.EDGE_PARAMS0.THRESHOLD,
            minimap_ocean_tuning.EDGE_PARAMS0.HALF_THRESHOLD_RANGE)

        map:SetMinimapOceanEdgeColor1(minimap_ocean_tuning.EDGE_COLOR1[1] / 255,
            minimap_ocean_tuning.EDGE_COLOR1[2] / 255, minimap_ocean_tuning.EDGE_COLOR1[3] / 255)
        map:SetMinimapOceanEdgeParams1(minimap_ocean_tuning.EDGE_PARAMS1.THRESHOLD,
            minimap_ocean_tuning.EDGE_PARAMS1.HALF_THRESHOLD_RANGE)

        map:SetMinimapOceanEdgeShadowColor(minimap_ocean_tuning.EDGE_SHADOW_COLOR[1] / 255,
            minimap_ocean_tuning.EDGE_SHADOW_COLOR[2] / 255, minimap_ocean_tuning.EDGE_SHADOW_COLOR[3] / 255)
        map:SetMinimapOceanEdgeShadowParams(minimap_ocean_tuning.EDGE_SHADOW_PARAMS.THRESHOLD,
            minimap_ocean_tuning.EDGE_SHADOW_PARAMS.HALF_THRESHOLD_RANGE,
            minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_X, minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_Y)

        map:SetMinimapOceanEdgeFadeParams(minimap_ocean_tuning.EDGE_FADE_PARAMS.THRESHOLD,
            minimap_ocean_tuning.EDGE_FADE_PARAMS.HALF_THRESHOLD_RANGE,
            minimap_ocean_tuning.EDGE_FADE_PARAMS.MASK_INSET)

        map:SetMinimapOceanEdgeNoiseParams(minimap_ocean_tuning.EDGE_NOISE_PARAMS.UV_SCALE)

        map:SetMinimapOceanTextureBlurParameters(minimap_ocean_tuning.TEXTURE_BLUR_SIZE,
            minimap_ocean_tuning.TEXTURE_BLUR_PASS_COUNT, minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_SIZE,
            minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_PASS_COUNT)
        map:SetMinimapOceanMaskBlurParameters(minimap_ocean_tuning.MASK_BLUR_SIZE,
            minimap_ocean_tuning.MASK_BLUR_PASS_COUNT)

        if TheWorld.ismastersim then
            TheWorld:AddComponent("cloudpuffmanager")
        end
    end)
end

----------------------------------------------------------------------------------------------------
----- sai pulando automaticamente do barco cliente outra parte dentro de locomotor ----------------
-- 直接让玩家跳到海难小船中心位置，天才！
local function GetEmbarkPositionBefore(self)
    local boat = self.embarkable
    if boat ~= nil and boat:IsValid() and boat:HasTag("shipwrecked_boat") then
        local x, _, z = self.inst.Transform:GetWorldPosition()
        local embarkable_radius = 0.1
        local embarkable_x, embarkable_y, embarkable_z = boat.Transform:GetWorldPosition()
        local embark_x, embark_z = VecUtil_Normalize(x - embarkable_x, z - embarkable_z)
        return { embarkable_x + embark_x * embarkable_radius, embarkable_z + embark_z * embarkable_radius }, true
    end
end

AddComponentPostInit("embarker", function(self)
    Utils.FnDecorator(self, "GetEmbarkPosition", GetEmbarkPositionBefore)
end)

----------------------------------------------------------------------------------------------------

-- TODO 根据地皮判断不太好，能不能给草添加特殊标签
local CANT_PICK_TILES = {
    [GROUND.SUBURB] = true,
    [GROUND.FOUNDATION] = true,
    [GROUND.COBBLEROAD] = true,
    [GROUND.FIELDS] = true
}

-- 当玩家采集哈姆雷特的草时，附近守卫攻击玩家
local GUARD_MUST_TAGS = { "_combat", "_health", "guard" }
local function OnPlayerPick(inst, worker)
    if worker and worker:HasTag("player") and not worker:HasTag("sneaky") then
        local x, y, z = inst.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
        if CANT_PICK_TILES[tile] then
            for _, v in ipairs(TheSim:FindEntities(x, y, z, 40, GUARD_MUST_TAGS)) do
                if v.components.combat:CanTarget(worker) then
                    v.components.combat:SuggestTarget(worker)
                end
            end
        end
    end
end

local function OnTransplantfnAfter(retTab, inst)
    -- checks to turn into Tall Grass if on the right terrain
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    local tiletype = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

    if tiletype == GROUND.PLAINS
        or tiletype == GROUND.RAINFOREST
        or tiletype == GROUND.DEEPRAINFOREST then
        local newgrass = SpawnPrefab("grass_tall")
        newgrass.Transform:SetPosition(x, y, z)
        if newgrass:HasTag("machetecut") then
            inst:RemoveTag("machetecut")
        end
        newgrass.components.workable:SetWorkAction(ACTIONS.DIG)
        newgrass.components.workable:SetWorkLeft(1)
        newgrass.components.timer:StartTimer("spawndelay", 60 * 8 * 4)
        newgrass.AnimState:PlayAnimation("picked", true)
        inst:Remove()
    end
end

for _, v in ipairs({
    "grass",
    "grassnova"
}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("grasss") --用于海难刮大风用的

        if not TheWorld.ismastersim then return end

        if inst.components.workable then
            Utils.FnDecorator(inst.components.workable, "onfinish", OnPlayerPick)
        end

        if inst.components.pickable then
            Utils.FnDecorator(inst.components.pickable, "onpickedfn", OnPlayerPick)
            Utils.FnDecorator(inst.components.pickable, "ontransplantfn", nil, OnTransplantfnAfter)
        end
    end)
end

----------------------------------------------------------------------------------------------------

-- 还原科雷想做没做的 茶在冰箱里腐烂会转化为冰茶
local function changeonperishreplacement(inst)
    local owner = inst.components.inventoryitem:GetContainer()
    inst.components.perishable.onperishreplacement = owner and owner.inst.prefab == "icebox" and "iced" .. inst.prefab or
        "spoiled_food"
end

AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if inst.food_basename and inst.food_basename == "tea" then
        inst.components.inventoryitem:SetOnPutInInventoryFn(changeonperishreplacement)
        inst.components.inventoryitem:SetOnDroppedFn(changeonperishreplacement)
    end
end)


----------------------------------------------------------------------------------------------------
local function CheckHorn(inst)
    local boat = inst:GetCurrentPlatform()
    if not boat then
        inst.components.health:Kill()
    end
end

--- 海难的船太小，一角鲸的角可能扎不到，获取不到boat，就会报错
AddPrefabPostInit("gnarwail_attack_horn", function(inst)
    if not TheWorld.ismastersim then return end

    inst:DoTaskInTime(TUNING.GNARWAIL.HORN_RETREAT_TIME - 0.1, CheckHorn)
end)


----------------------------------------------------------------------------------------------------
-- 海难特色料理转化
for _, v in ipairs({ "butterflymuffin_sw", "lobsterbisque_sw", "lobsterdinner_sw", }) do
    AddPrefabPostInit(v, function(inst)
        if inst.prefab == v then
            inst._old_prefab = inst.prefab
            inst.prefab = inst.prefab:sub(1, -4)
        end
        if not TheWorld.ismastersim then
            return inst
        end
        local old_oneat = inst.components.edible.oneaten
        inst.components.edible:SetOnEatenFn(function(inst, eater, ...)
            eater:PushEvent("learncookbookstats", inst._old_prefab or inst.prefab)
            inst._old_prefab = nil
            if old_oneat then
                old_oneat(inst, eater, ...)
            end
        end)
    end)
end


----------------------------------------------------------------------------------------------------
-- 屏蔽随机种子中种出三合一作物
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local WEIGHTED_SEED_TABLE = require("prefabs/weed_defs").weighted_seed_table

local NOTINCLUDE = { wheat = true, } -- 先禁小麦

local function pickfarmplant()
    if math.random() < TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE then
        return weighted_random_choice(WEIGHTED_SEED_TABLE)
    else
        local season = TheWorld.state.season
        local weights = {}
        local season_mod = TUNING.SEED_WEIGHT_SEASON_MOD

        for k, v in pairs(VEGGIES) do
            weights[k] = v.seed_weight * ((PLANT_DEFS[k] and PLANT_DEFS[k].good_seasons[season]) and season_mod or 1)
        end

        for k, _ in ipairs(NOTINCLUDE) do
            weights[k] = 0
        end

        return "farm_plant_" .. weighted_random_choice(weights)
    end
    return "weed_forgetmelots"
end

AddPrefabPostInit("farm_plant_randomseed", function(inst)
    if not TheWorld.ismastersim then return end
    inst:ListenForEvent("on_planted", function(inst, data)
        local old_changefn = inst.components.growable.stages[2].fn
        inst.components.growable.stages[2].fn = function(inst, stage)
            inst._identified_plant_type = old_changefn and old_changefn(inst, stage)
            if not inst._identified_plant_type or NOTINCLUDE[inst._identified_plant_type] then
                inst._identified_plant_type = pickfarmplant()
            end
        end
    end)
end)

----------------------------------------------------------------------------------------------------
AddComponentPostInit("oar", function(self, inst)
    inst:AddTag("oar") --科雷真抠门，桨连个自己的标签也没有
end)

----------------------------------------------------------------------------------------------------

local function DoVanish(inst, self)
    self:vanish()
end

local function OnEntitySleep(self)
    if self.vanish_task == nil then
        self.vanish_task = self.inst:DoTaskInTime(self.duration, DoVanish, self)
    end
end

AddComponentPostInit("vanish_on_sleep", function(self)
    self.duration = 10 --支持设置休眠后多少秒移除
    self.OnEntitySleep = OnEntitySleep
end)


----------------------------------------------------------------------------------------------------
