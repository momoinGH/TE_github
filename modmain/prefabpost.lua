local Utils = require("tropical_utils/utils")

-- TODO 可以换个写法吗？
local function AoeSpellCastSpellBefore(self)
    if self.inst.components.reticule_spawner then
        if self.inst.components.recarregavel and self.inst.components.recarregavel.isready then
            self.inst.components.reticule_spawner:Spawn(pos)
        end
        self.inst.components.reticule_spawner:OnCastAoeSpelled()
    end
end

AddComponentPostInit("aoespell", function(self)
    Utils.FnDecorator(self, "CastSpell", AoeSpellCastSpellBefore)
end)


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
-- 控制鸟生成逻辑

local BIRD_TYPES, PickBird
local function SpawnBirdBefore(self, spawnpoint)
    local prefab = PickBird and PickBird(spawnpoint)
    if prefab and not GLOBAL.Prefabs[prefab] then
        return nil, true --有的鸟预制体不存在，可能没有定义，跳过旧方法防止报错
    end
end

AddComponentPostInit("birdspawner", function(self)
    if not BIRD_TYPES then
        PickBird = Utils.ChainFindUpvalue(self.SpawnBird, "PickBird")
        BIRD_TYPES = PickBird and Utils.ChainFindUpvalue(PickBird, "BIRD_TYPES")
        if BIRD_TYPES then
            BIRD_TYPES[WORLD_TILES.OCEAN_COASTAL] = { "puffin", "cormorant" }
            BIRD_TYPES[WORLD_TILES.OCEAN_COASTAL_SHORE] = { "puffin", "cormorant" }
            BIRD_TYPES[WORLD_TILES.OCEAN_SWELL] = { "puffin", "cormorant", "seagullwater" }
            BIRD_TYPES[WORLD_TILES.OCEAN_ROUGH] = { "puffin", "seagullwater", "cormorant" }
            BIRD_TYPES[WORLD_TILES.OCEAN_BRINEPOOL] = { "puffin", "seagullwater" }
            BIRD_TYPES[WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = { "puffin" }
            BIRD_TYPES[WORLD_TILES.OCEAN_HAZARDOUS] = { "puffin", "seagullwater" }

            BIRD_TYPES[WORLD_TILES.RAINFOREST] = { "toucan_hamlet", "kingfisher", "parrot_blue", "kingfisher_swarm",
                "toucan_hamlet_swarm", "parrot_blue_swarm" }
            BIRD_TYPES[WORLD_TILES.DEEPRAINFOREST] = { "toucan_hamlet", "parrot_blue", "kingfisher", "kingfisher_swarm",
                "toucan_hamlet_swarm", "parrot_blue_swarm" }
            BIRD_TYPES[WORLD_TILES.GASJUNGLE] = { "parrot_blue", "parrot_blue_swarm" }
            BIRD_TYPES[WORLD_TILES.FOUNDATION] = { "quagmire_pigeon", "crow", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.FIELDS] = { "robin", "crow" }
            BIRD_TYPES[WORLD_TILES.SUBURB] = { "robin", "crow", "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.PAINTED] = { "kingfisher", "crow", "kingfisher_swarm" }
            BIRD_TYPES[WORLD_TILES.PLAINS] = { "robin", "crow", "kingfisher", "kingfisher_swarm" }

            BIRD_TYPES[WORLD_TILES.TIDALMARSH] = { "toucan" }
            BIRD_TYPES[WORLD_TILES.MAGMAFIELD] = { "toucan" }
            BIRD_TYPES[WORLD_TILES.MEADOW] = { "parrot", "toucan", "parrot_pirate" }
            BIRD_TYPES[WORLD_TILES.BEACH] = { "toucan" }
            BIRD_TYPES[WORLD_TILES.JUNGLE] = { "parrot", "parrot_pirate" }
            BIRD_TYPES[WORLD_TILES.QUAGMIRE_PEATFOREST] = { "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKFIELD] = { "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKSTONE] = { "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.QUAGMIRE_GATEWAY] = { "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.QUAGMIRE_SOIL] = { "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.QUAGMIRE_CITYSTONE] = { "quagmire_pigeon", "pigeon_swarm" }
            BIRD_TYPES[WORLD_TILES.IMPASSABLE] = {} --不生成鸟
            BIRD_TYPES[WORLD_TILES.INVALID] = {}    --不生成鸟
            BIRD_TYPES[WORLD_TILES.WATER_MANGROVE] = { "robin_winter" }
            BIRD_TYPES[WORLD_TILES.ANTFLOOR] = { "robin_winter" }
            BIRD_TYPES[WORLD_TILES.WINDY] = { "goddess_bird" }

            if KnownModIndex:IsModEnabled("workshop-1289779251") then --樱花林
                BIRD_TYPES[WORLD_TILES.CHERRY] = { "catbird", "crow" }
                BIRD_TYPES[WORLD_TILES.CHERRY2] = { "chaffinch", "robin" }
                BIRD_TYPES[WORLD_TILES.CHERRY3] = { "catbird" }
                BIRD_TYPES[WORLD_TILES.CHERRY4] = { "chaffinch" }
            end
        end
    end

    Utils.FnDecorator(self, "SpawnBird", SpawnBirdBefore)
end)

----------------------------------------------------------------------------------------------------
local NOT_PASSABLE_TILES = {
    [WORLD_TILES.OCEAN_SWELL] = true,
    [WORLD_TILES.OCEAN_BRINEPOOL] = true,
    [WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = true,
    [WORLD_TILES.OCEAN_HAZARDOUS] = true,
    [WORLD_TILES.OCEAN_ROUGH] = true,
    [WORLD_TILES.OCEAN_COASTAL_SHORE] = true,
    [WORLD_TILES.OCEAN_WATERLOG] = true,
    [WORLD_TILES.OCEAN_COASTAL] = true
}

local function IsPassableAtPointBefore(self, x, y, z)
    return { false }, NOT_PASSABLE_TILES[TheWorld.Map:GetTileAtPoint(x, y, z)]
end

require "components/map"
Utils.FnDecorator(Map, "IsPassableAtPoint", IsPassableAtPointBefore)


----------------------------------------------------------------------------------------------------

local function DeployableCanDeployBefore(self, pt)
    local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
    local isCave = TheWorld:HasTag("cave")
    return { false }, tile == GROUND.UNDERWATER_SANDY
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

AddComponentPostInit("deployable", function(self)
    Utils.FnDecorator(self, "CanDeploy", DeployableCanDeployBefore)
end)


----------------------------------------------------------------------------------------------------
-- 不会落水
local function DrownableShouldDrownBefore(self)
    if self.inst.components.driver then
        return { false }, true
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 30, { "blows_air" }) > 0
        or #TheSim:FindEntities(x, y, z, 1, { "boat" }) > 0
    then
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
            print("获取到了吗")
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
