local Utils = require("tropical_utils/utils")

----------------------------------------------------------------------------------------------------

-- 太长的单独写一个文件了
modimport "modmain/common/natureskin_variants"
modimport "modmain/common/world_map"
modimport "modmain/common/entityscript"

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

modimport "modmain/common/poisonable"

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
            self:CurrentlyInTag("shipwrecked")
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
            or tile == GROUND.BATTLEGROUNDS
            or tile == GROUND.PEBBLEBEACH
            or tile == GROUND.ICELAND
            or tile == GROUND.SNOWLAND
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


local function ShouldX_InternalCheckAfter(retTab, self)
    if not retTab[1] then return retTab end

    -- 同设置drownable的enabled效果，没有直接改enabled是为了兼容
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetSWBoatAtPoint(x, y, z) then
        retTab[1] = false
    end

    return retTab
end

AddComponentPostInit("drownable", function(self)
    Utils.FnDecorator(self, "ShouldX_InternalCheck", nil, ShouldX_InternalCheckAfter)
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
            flotsam_prefabs["messagebottle_sw"] = 1
        end
    end
end)

----------------------------------------------------------------------------------------------------

AddComponentPostInit("groundpounder", function(self)
    table.insert(self.noTags, "groundpoundimmune")
end)


----------------------------------------------------------------------------------------------------
AddComponentPostInit("plantregrowth", function(self)
    self.TimeMultipliers["mushtree_yellow"] = function()
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
            FX_MAP["mushtree_yellow"] = "mushtree_yellow"
        end
    end
end)

----------------------------------------------------------------------------------------------------
for _, v in ipairs({"wobster_sheller", "wobster_moonglass"}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("lobster")
        if not TheWorld.ismastersim then return inst end

        local lootdropper = inst:AddComponent("lootdropper")
        lootdropper.trappable = true
        lootdropper:SetLoot({v .. "_land"})

    end)
end
----------------------------------------------------------------------------------------------------

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
    if ground == GROUND.SNOWLAND or ground == GROUND.ICELAND then
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
            if ground == WORLD_TILES.SNOWLAND or ground == WORLD_TILES.ICELAND then
                inst:AddTag("mostraneve")
            end
        end)
    end

    if not TheWorld.ismastersim then return end

    if TheWorld.components.tro_tempentitytracker and TheWorld.components.tro_tempentitytracker:KeyExists(inst.prefab) then
        TheWorld.components.tro_tempentitytracker:OnEntSpawned(inst)
    end
end)

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

-- 根据地皮判断不太好，能不能给草添加特殊标签
local CANT_PICK_TILES = {
    [GROUND.MOSS] = true,
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

local function shardDMGRedirect(self, attacker, damage, weapon, ...)          -- 碎裂武器伤害重定向
    if weapon then
        if weapon.prefab == "shard_sword" and self.inst:HasTag("shadow") then -- 碎裂剑对梦魇生物
            local health = self.inst.components.health
            if health then
                if health.currenthealth <= damage * TUNING.SWP_SHARD_DMG.SHADOW_MODIFIER_MAXIMUM then
                    return nil, false,
                        { self, attacker,
                            math.max(damage * TUNING.SWP_SHARD_DMG.SHADOW_MODIFIER_MINIMUM, health.currenthealth - 1),
                            weapon, ... }
                else
                    if attacker and attacker.components.combat then
                        attacker:DoTaskInTime(0, function()
                            attacker.components.combat:GetAttacked(weapon, math.random(1, 5))
                            attacker:PushEvent("thorns")
                        end)
                    end
                    return nil, false,
                        { self, attacker, damage * TUNING.SWP_SHARD_DMG.SHADOW_MODIFIER_MAXIMUM, weapon, ... }
                end
            end
        elseif weapon.prefab == "shard_beak" and -- 碎裂喙对建筑和巢
            (self.inst:HasTag("wall") or self.inst:HasTag("structure") or self.inst.components.childspawner) then
            return nil, false, { self, attacker, damage * TUNING.SWP_SHARD_DMG.STRUCTURE_MODIFIER, weapon, ... }
        end
    end
end

AddComponentPostInit("combat", function(self, inst) Utils.FnDecorator(self, "GetAttacked", shardDMGRedirect) end)

----------------------------------------------------------------------------------------------------

AddComponentPostInit("boatphysics", function(self, inst) -- 给船和保险杠增加破浪能力
    Utils.FnDecorator(self, "ApplyForce", function(self, dir_x, dir_z, force)
        if SWP_WAVEBREAK_EFFICIENCY.BOAT[self.inst.prefab] then
            force = force * math.max(1 - SWP_WAVEBREAK_EFFICIENCY.BOAT[self.inst.prefab], 0)
        end
        if self.inst.components.boatring then
            local bumper = self.inst.components.boatring:GetBumperAtPoint(dir_x, dir_z)
            if bumper and SWP_WAVEBREAK_EFFICIENCY.BUMPER["boat_bumper_" .. bumper.prefab] then
                force = force * math.max(1 - SWP_WAVEBREAK_EFFICIENCY.BUMPER["boat_bumper_" .. bumper.prefab], 0)
            end
        end
        return nil, false, { self, dir_x, dir_z, force }
    end)
end)

----------------------------------------------------------------------------------------------------

-- 让原版坟墓也能挖出海难玩具
local trinkets_sw = { "trinket_sw_23" }
AddPrefabPostInit("trinket_1", function() -- 定义在prefab里面，延迟修改
    local PickRandomTrinket = GLOBAL.PickRandomTrinket
    GLOBAL.PickRandomTrinket = function()
        if math.random() < #trinkets_sw / (#trinkets_sw + GLOBAL.NUM_TRINKETS) then
            return trinkets_sw[math.random(1, #trinkets_sw)]
        else
            return PickRandomTrinket()
        end
    end
end)

----------------------------------------------------------------------------------------------------

AddPrefabPostInit("warningshadow", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("sizetweener")
    inst:AddComponent("colourtweener")
    inst.shrink = function(inst, times, startsize, endsize)
        inst.AnimState:SetMultColour(1, 1, 1, .33)
        inst.Transform:SetScale(startsize, startsize, startsize)
        inst.components.colourtweener:StartTween({ 1, 1, 1, .75 }, times)
        inst.components.sizetweener:StartTween(.5, times, inst.Remove)
    end
end)

----------------------------------------------------------------------------------------------------

-- scripts/widgets/image
AddClassPostConstruct("widgets/image", function(self)
    Utils.FnDecorator(self, "SetTexture", function(atlas, tex, default_tex)
        return nil, false, { atlas or tex and GetInventoryItemAtlas(tex) or
        default_tex and GetInventoryItemAtlas(default_tex),
            tex, default_tex }
    end)
end)

----------------------------------------------------------------------------------------------------
--晾肉架悬挂物品，以后可晾物品只用在fn里添加dryable组件并SetProduct和DryTime，Symbol写在这里就行了
local tro_buildfile = "meat_rack_food_tro"
local meatrack_items = { --前面是prefab名，后面是bulid里面的Symbol
    coi = "coi",
    dogfish_dead = "dogfish",
    jellyjerky = "jellyjerky",
    seaweed_dried = "seaweed_dried",
    fish2 = "fish2",
    fish3 = "fish3",
    fish4 = "fish4",
    fish5 = "fish5",
    froglegs_poison = "froglegs_poison",
    jellyfish_dead = "jellyfish_dead",
    quagmire_crabmeat = "quagmire_crabmeat",
    quagmire_smallmeat = "quagmire_smallmeat",
    rainbowjellyfish_dead = "rainbowjellyfish_dead",
    salmon = "salmon",
    seaweed = "seaweed",
    swordfish_dead = "dead_swordfish",
    venus_stalk = "venus_stalk",
    walkingstick = "walkingstick"

}

AddPrefabPostInit("meatrack", function(inst)
    if not TheWorld.ismastersim then return end

    local _OnStartDrying = inst.components.dryer.onstartdrying --开始晾的时候，即可晾物品
    local function OnStartDrying(inst, ingredient, buildfile)
        if meatrack_items[ingredient] then
            ingredient = meatrack_items[ingredient]
            buildfile = tro_buildfile
        end
        _OnStartDrying(inst, ingredient, buildfile)
    end

    inst.components.dryer:SetStartDryingFn(OnStartDrying)

    local _ondonedrying = inst.components.dryer.ondonedrying --晾完的时候，即产物
    local function OnDoneDrying(inst, product, buildfile)
        if meatrack_items[product] then
            product = meatrack_items[product]
            buildfile = tro_buildfile
        end
        _ondonedrying(inst, product, buildfile)
    end

    inst.components.dryer:SetDoneDryingFn(OnDoneDrying)
    --[[
    local _StartDrying = inst.components.dryer.StartDrying
    local function StartDrying(self, dryable, ...)
        if inst:GetIsInInterior() then
            inst.components.dryer.protectedfromrain = true
        else
            inst.components.dryer.protectedfromrain = nil
        end
        return _StartDrying(self, dryable, ...)
    end

    inst.components.dryer.StartDrying = StartDrying]]
end)

AddPrefabPostInit("mosquitosack", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.BLOOD --新燃料值：血，可以用蚊子血嚢给蝙蝠帽回耐久
    inst.components.fuel.fuelvalue = TUNING.TOTAL_DAY_TIME * .5
end)

AddComponentPostInit("combat", function(self)
    function self:GetWeapon()
        if self.inst.components.inventory ~= nil then
            local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or
            self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            return item ~= nil
                and item.components.weapon ~= nil
                and (item.components.projectile ~= nil or
                    not (self.inst.components.rider ~= nil and
                        self.inst.components.rider:IsRiding()) or
                    item:HasTag("rangedweapon"))
                and item
                or nil
        end
    end
end)

AddClassPostConstruct("components/combat_replica", function(self)
    function self:GetWeapon()
        if self.inst.components.combat ~= nil then
            return self.inst.components.combat:GetWeapon()
        elseif self.inst.replica.inventory ~= nil then
            local item = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or
            self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if item ~= nil and item:HasTag("weapon") then
                if item:HasTag("projectile") or item:HasTag("rangedweapon") then
                    return item
                end
                local rider = self.inst.replica.rider
                return not (rider ~= nil and rider:IsRiding()) and item or nil
            end
        end
    end
end)

local require = GLOBAL.require
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local resolvefilepath = GLOBAL.resolvefilepath

AddClassPostConstruct("widgets/controls", function(self)
    if self.owner == nil then return end
    local VisorOver = require "widgets/visorover"
    self.visorover = self:AddChild(VisorOver(self.owner))
    self.visorover:MoveToBack()
end)

AddClassPostConstruct("screens/playerhud", function(self)
    local BatSonar = require "widgets/batsonar"
    local TrapMarker = require "widgets/trapmarker"

    local old_CreateOverlays = self.CreateOverlays
    function self:CreateOverlays(owner)
        old_CreateOverlays(self, owner)
        self.batview = self.overlayroot:AddChild(BatSonar(owner))
        self.trapmarker = self.overlayroot:AddChild(TrapMarker(owner))
    end

    local shootview = false
    local old_OnUpdate = self.OnUpdate
    function self:OnUpdate(dt)
        old_OnUpdate(self, dt)

        if self.batview and self.trapmarker and shootview ~= nil and self.owner then
            if not (self.batview.shown or self.trapmarker.shown or shootview) and
                self.owner.replica.inventory:EquipHasTag("invisiblegoggles") then
                self.gogglesover.bg:SetTint(1, 1, 1, 0)
            elseif (self.batview.shown or self.trapmarker.shown or shootview) and
                not self.owner.replica.inventory:EquipHasTag("invisiblegoggles") then
                self.gogglesover.bg:SetTint(1, 1, 1, 1)
            end

            if not self.batview.shown and self.owner.replica.inventory:EquipHasTag("batvision") then
                self.batview:StartSonar()
            elseif self.batview.shown and not self.owner.replica.inventory:EquipHasTag("batvision") then
                self.batview:StopSonar()
            end

            if not self.trapmarker.shown and self.owner.replica.inventory:EquipHasTag("dangervision") then
                self.trapmarker:ShowMarker()
            elseif self.trapmarker.shown and not self.owner.replica.inventory:EquipHasTag("dangervision") then
                self.trapmarker:HideMarker()
            end

            if not shootview and self.owner.replica.inventory:EquipHasTag("shootvision") then
                shootview = true
            elseif shootview and not self.owner.replica.inventory:EquipHasTag("shootvision") then
                shootview = false
            end
        end
    end
end)

AddPrefabPostInit("world", function(inst)
    inst:AddComponent("globalcolourmodifier")
end)

AddPlayerPostInit(function(inst)
    local function fn(ent)
        if ent == GLOBAL.TheWorld then --[[
	        local tuning = TUNING.GOGGLES_HEAT.GROUND
			 ent.Map:SetMultColour(unpack(tuning.MULT_COLOUR))
			 ent.Map:SetAddColour(unpack(tuning.ADD_COLOUR))

			 local tuning = TUNING.GOGGLES_HEAT.WAVES
			 local waves = ent.WaveComponent or ent.CloudComponent
			 if waves then
			 	waves:SetMultColour(unpack(tuning.MULT_COLOUR))
			 	waves:SetAddColour(unpack(tuning.ADD_COLOUR))
			 end]]
            return
        end
        if ent.AnimState then
            local tuning
            if not ent:HasTag("shadow") and (ent:HasTag("monster") or ent:HasTag("animal") or ent:HasTag("character") or ent:HasTag("smallcreature") or ent:HasTag("seacreature") or ent:HasTag("oceanfish")) then
                tuning = TUNING.GOGGLES_HEAT.HOT
            else
                tuning = TUNING.GOGGLES_HEAT.COLD
            end
            if tuning.BLOOM then
                ent.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            end
            ent.AnimState:SetMultColour(GLOBAL.unpack(tuning.MULT_COLOUR))
            ent.AnimState:SetAddColour(GLOBAL.unpack(tuning.ADD_COLOUR))
            -- ent.AnimState:SetSaturation(1 - tuning.DESATURATION)
        end
    end

    local function OnPlayerActivated(inst)
        GLOBAL.TheWorld:ListenForEvent("ccoverrides", function()
            inst:DoTaskInTime(0, function()
                if inst.components.playervision.heatvision then
                    if GLOBAL.TheWorld.components.globalcolourmodifier then
                        GLOBAL.TheWorld.components.globalcolourmodifier:SetModifyColourFn(fn)
                    end
                elseif inst.components.playervision.heatvision == false then
                    if GLOBAL.TheWorld.components.globalcolourmodifier then
                        GLOBAL.TheWorld.components.globalcolourmodifier:Reset()
                    end
                end
            end)
        end, inst)
    end

    if not GLOBAL.TheNet:IsDedicated() then
        inst:ListenForEvent("playeractivated", OnPlayerActivated)
    end
end)

AddComponentPostInit("playervision", function(self)
    local BAT_COLOURCUBE = resolvefilepath "images/colour_cubes/bat_vision_on_cc.tex"
    local BAT_COLOURCUBES =
    {
        day = BAT_COLOURCUBE,
        dusk = BAT_COLOURCUBE,
        night = BAT_COLOURCUBE,
        full_moon = BAT_COLOURCUBE,
    }
    local HEATVISION_COLOURCUBE = resolvefilepath("images/colour_cubes/heat_vision_cc.tex")
    local HEATVISION_COLOURCUBES =
    {
        day = HEATVISION_COLOURCUBE,
        dusk = HEATVISION_COLOURCUBE,
        night = HEATVISION_COLOURCUBE,
        full_moon = HEATVISION_COLOURCUBE,
    }
    local SHOOT_COLOURCUBE = resolvefilepath "images/colour_cubes/shooting_goggles_cc.tex"
    local SHOOT_COLOURCUBES =
    {
        day = SHOOT_COLOURCUBE,
        dusk = SHOOT_COLOURCUBE,
        night = SHOOT_COLOURCUBE,
        full_moon = SHOOT_COLOURCUBE,
    }

    local function OnEquipChanged(inst)
        local self = inst.components.playervision
        if self.batvision == not inst.replica.inventory:EquipHasTag("batvision") then
            self.batvision = not self.batvision
            self:UpdateCCTable()
        end
        if self.heatvision == not inst.replica.inventory:EquipHasTag("heatvision") then
            self.heatvision = not self.heatvision
            self:UpdateCCTable()
        end
        if self.shootvision == not inst.replica.inventory:EquipHasTag("shootvision") then
            self.shootvision = not self.shootvision
            self:UpdateCCTable()
        end
    end

    local function OnInit(inst, self)
        inst:ListenForEvent("equip", OnEquipChanged)
        inst:ListenForEvent("unequip", OnEquipChanged)
        if not GLOBAL.TheWorld.ismastersim then
            inst:ListenForEvent("inventoryclosed", OnEquipChanged)
            if inst.replica.inventory == nil then return end
        end
        OnEquipChanged(inst)
    end

    self.batvision = false
    self.heatvision = false
    self.shootvision = false

    self.inst:DoTaskInTime(0, OnInit, self)

    local old_UpdateCCTable = self.UpdateCCTable
    function self:UpdateCCTable(...)
        if self.inst.replica.inventory and (self.inst.replica.inventory:EquipHasTag("heatvision")) then
            --old_UpdateCCTable(self)
            local cctable = (self.batvision and BAT_COLOURCUBES)
                or (self.heatvision and HEATVISION_COLOURCUBES)
                or (self.shootvision and SHOOT_COLOURCUBES)
                or nil
            if cctable ~= self.currentcctable and cctable ~= nil then
                self.currentcctable = cctable
                self.inst:PushEvent("ccoverrides", cctable)
            end
        else
            old_UpdateCCTable(self, ...)
        end
    end
end)

--------------------------------------------------------------------------
--[[ 让蘑菇农场能种植新东西 ]]--来自老版棱镜，感谢梧桐山大佬的无私分享！
--------------------------------------------------------------------------

local mushroom_farm_seeds = {
    cutlichen = { product = "cutlichen", produce = 4 },
    foliage = { product = "foliage", produce = 6 },
    quagmire_mushrooms = { product = "quagmire_mushrooms", produce = 4 },
    yellow_cap = { product = "yellow_cap", produce = 4 },
}
AddPrefabPostInit("mushroom_farm", function(inst)
    local AbleToAcceptTest_old = inst.components.trader.abletoaccepttest
    inst.components.trader:SetAbleToAcceptTest(function(farm, item, ...)
        if item ~= nil then
            if farm.remainingharvests == 0 then
                if item.prefab == "shyerrylog" then
                    return true
                end
            elseif mushroom_farm_seeds[item.prefab] ~= nil then
                return true
            end
        end
        return AbleToAcceptTest_old(farm, item, ...)
    end)

    local OnAccept_old = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(farm, giver, item, ...)
        if farm.remainingharvests ~= 0 and mushroom_farm_seeds[item.prefab] ~= nil then
            if farm.components.harvestable ~= nil then
                local data = mushroom_farm_seeds[item.prefab]
                local max_produce = data.produce
                local grow_time = TUNING.MUSHROOMFARM_FULL_GROW_TIME
                local grower_skilltreeupdater = giver.components.skilltreeupdater
                if grower_skilltreeupdater ~= nil then
                    if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_upgrade") then
                        max_produce = 6
                    end
                    if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
                        grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
                    elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
                        grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
                    end
                end

                if item.prefab == "foliage" then
                    farm.AnimState:OverrideSymbol(
                        "swap_mushroom",
                        TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                        "swap_mushroom"
                    )
                else
                    farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                end
                farm.components.harvestable:SetProduct(data.product, max_produce)
                farm.components.harvestable:SetGrowTime(grow_time/max_produce)
                farm.components.harvestable:Grow()

                TheWorld:PushEvent("itemplanted", { doer = giver, pos = farm:GetPosition() }) --this event is pushed in other places too
            end
        else
            OnAccept_old(farm, giver, item, ...)
        end
    end

    local OnLoad_old = inst.OnLoad
    inst.OnLoad = function(farm, data)
        OnLoad_old(farm, data)
        if data ~= nil and not data.burnt and data.product ~= nil then
            for k,v in pairs(mushroom_farm_seeds) do
                if v.product == data.product then
                    if data.product == "foliage" then
                        farm.AnimState:OverrideSymbol(
                            "swap_mushroom",
                            TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                            "swap_mushroom"
                        )
                    else
                        farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                    end
                    break
                end
            end
        end
    end
end)