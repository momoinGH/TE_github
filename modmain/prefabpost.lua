local Utils = require("tropical_utils/utils")

-- 太长的单独写一个文件了
modimport "modmain/components/locomotor"
modimport "modmain/components/birdspawner"
modimport "modmain/components/map"
modimport "modmain/components/playervision"
modimport "modmain/components/temperature"

modimport "modmain/prefabs/oceanfishdef"

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
        if #TheSim:FindEntities(x, 0, z, 20, { "blows_air" }) > 0 then
            return { TUNING.WILDFIRE_THRESHOLD }
        end

        local player = FindClosestPlayerInRangeSq(x, 0, z, 400)
        if player and player.components.areaaware and player.components.areaaware:CurrentlyInTag("frost") then
            return { TUNING.WILDFIRE_THRESHOLD }
        end
    end

    return retTab
end)
