local Utils = require("tropical_utils/utils")

-- 太长的单独写一个文件了
modimport "modmain/components/locomotor"
modimport "modmain/components/birdspawner"
modimport "modmain/components/map"
modimport "modmain/components/playervision"
modimport "modmain/components/temperature"
modimport "modmain/components/inventory"
modimport "modmain/components/builder"

modimport "modmain/prefabs/oceanfishdef"

local function AddComponent(inst, name)
    if not inst.components[name] then
        inst:AddComponent(name)
    end
end

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


AddPrefabPostInit("saltrock", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("mealable")
    inst.components.mealable:SetType("salt")
end)

AddPrefabPostInit("spice_salt", function(inst)
    inst:AddTag("salty")
end)

----------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    AddComponent(inst, "bigfooter")
end)

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("parrotspawner")
    inst:AddComponent("economy")
    inst:AddComponent("shadowmanager")
    inst:AddComponent("contador")

    if TUNING.tropical.sealnado then
        inst:AddComponent("twisterspawner")
    end

    if GetModConfigData("kindofworld") == 5 or GetModConfigData("Hamlet") ~= 5 then
        inst:AddComponent("roottrunkinventory")
    end

    if GetModConfigData("kindofworld") ~= 10
        and (GetModConfigData("kindofworld") == 5 or GetModConfigData("Hamlet") ~= 5
            and GetModConfigData("pigruins") ~= 0
            and GetModConfigData("aporkalypse") == true)
    then
        inst:AddComponent("aporkalypse")
    end

    if GetModConfigData("kindofworld") ~= 10 and GetModConfigData("Hamlet") ~= 5 then
        inst:AddComponent("tropicalgroundspawner")
    end

    if GetModConfigData("aquaticcreatures") and (GetModConfigData("kindofworld") == 15
            or GetModConfigData("kindofworld") == 10
            or GetModConfigData("kindofworld") == 20)
    then
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
    end

    if GetModConfigData("kindofworld") == 5 then
        inst:AddComponent("shadowmanager")
        inst:AddComponent("rocmanager")
    end

    if GetModConfigData("kindofworld") ~= 10 then
        inst:AddComponent("quaker_interior")
    end

    -- if TUNING.tropical.springflood or TUNING.tropical.kindofworld == 10 then
    --     inst:AddComponent("floodspawner")
    -- end
end)

AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("roottrunkinventory")
    inst:AddComponent("quaker_interior")
    inst:AddComponent("economy")
    inst:AddComponent("contador")
end)

----------------------------------------------------------------------------------------------------

-- 这部分代码看起来是设置和缩放制作栏的什么东西，但是注释掉好像也没什么变化
-- AddClassPostConstruct("widgets/crafttabs", function(self)
--     local numtabs = 0

--     for i, v in ipairs(self.tabs.tabs) do
--         if not v.collapsed then
--             numtabs = numtabs + 1
--         end
--     end

--     if numtabs > 11 then
--         self.tabs.spacing = 67

--         local scalar = self.tabs.spacing * (1 - numtabs) * .5
--         local offset = self.tabs.offset * scalar

--         for i, v in ipairs(self.tabs.tabs) do
--             if i > 1 and not v.collapsed then
--                 offset = offset + self.tabs.offset * self.tabs.spacing
--             end
--             v:SetPosition(offset)
--             self.tabs.base_pos[v] = Vector3(offset:Get())
--         end

--         local scale = 67 * numtabs / 750.0
--         self.bg:SetScale(1, scale, 1)
--         self.bg_cover:SetScale(1, scale, 1)
--     end
-- end)

-- 中毒时血条显示下降箭头
local function HealthBadgeOnUpdateAfter(retTab, self)
    if not TheNet:IsServerPaused()
        and self.arrowdir == "neutral" --不扣血也不加血
        and self.owner.components.poisonable and self.owner.components.poisonable.dmg < 0
    then
        local anim = "arrow_loop_decrease"
        if self.arrowdir ~= anim then
            self.arrowdir = anim
            self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
        end
    end
end

AddClassPostConstruct("widgets/healthbadge", function(self)
    Utils.FnDecorator(self, "OnUpdate", nil, HealthBadgeOnUpdateAfter)
end)

if GetModConfigData("kindofworld") == 20 then
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

local boat_health =
{
    cargoboat = 300,
    encrustedboat = 800,
    rowboat = 250,
    armouredboat = 500,
    raft_old = 150,
    lograft_old = 150,
    woodlegsboat = 500,
    surfboard = 100,
}

AddClassPostConstruct("widgets/containerwidget", function(self)
    local BoatBadge = require("widgets/boatbadge")
    self.boatbadge = self:AddChild(BoatBadge(self.owner))
    self.boatbadge:SetPosition(0, 45, 0)
    self.boatbadge:Hide()

    local function BoatState(inst, data)
        self.boatbadge:SetPercent(data.percent, boat_health[inst.prefab] or 150)

        if self.boathealth then
            if data.percent > self.boathealth then
                self.boatbadge:PulseGreen()
            elseif data.percent < self.boathealth - 0.015 then
                self.boatbadge:PulseRed()
            end
        end

        self.boathealth = data.percent

        if data.percent <= .25 then
            self.boatbadge:StartWarning()
        else
            self.boatbadge:StopWarning()
        end
    end


    local OldOpen = self.Open
    function self:Open(container, doer)
        OldOpen(self, container, doer)
        local widget = container.replica.container:GetWidget()
        if widget and widget.slotbg and type(widget.slotbg) == "table" and widget.isboat then
            for i, v in ipairs(widget.slotbg) do
                if self.inv[i] then
                    self.inv[i].bgimage:SetTexture(v.atlas, v.texture)
                end
            end
        end
        if widget and widget.isboat then
            self.isboat = true
            self.boatbadge:Show()
            self.inst:ListenForEvent("percentusedchange", BoatState, container)
            if TheWorld.ismastersim then
                container:PushEvent("percentusedchange",
                    { percent = container.replica.inventoryitem.classified.percentused:value() / 100 })
            else
                container.replica.inventoryitem:DeserializeUsage()
            end
        end
    end

    local OldClose = self.Close
    function self:Close()
        OldClose(self)
        if self.isboat then
            self.inst:RemoveEventCallback("percentusedchange", BoatState, self.contanier)
        end
    end
end)

----------------------------------------------------------------------------------------------------

AddClassPostConstruct("widgets/controls", function(self)
    local Widget = require("widgets/widget")
    local c = self:AddChild(Widget(""))
    c:SetHAnchor(ANCHOR_MIDDLE)
    c:SetVAnchor(ANCHOR_BOTTOM)
    c:SetScaleMode(SCALEMODE_PROPORTIONAL)
    c:SetMaxPropUpscale(MAX_HUD_SCALE)
    c:MoveToBack()

    self.containerroot_bottom = c:AddChild(Widget("contaierroot_bottom"))
    local scale = TheFrontEnd:GetHUDScale()
    self.containerroot_bottom:SetScale(scale, scale, scale)
    self.containerroot_bottom:Hide()


    Utils.FnDecorator(self, "SetHUDSize", nil, function()
        local scale = TheFrontEnd:GetHUDScale()
        self.containerroot_bottom:SetScale(scale, scale, scale)
    end)


    Utils.FnDecorator(self, "ShowCraftingAndInventory", nil, function()
        self.containerroot_bottom:Show()
    end)

    Utils.FnDecorator(self, "HideCraftingAndInventory", nil, function()
        self.containerroot_bottom:Hide()
    end)
end)

local ContainerWidget = require("widgets/containerwidget")
local function OpenContainerBefore(self, container, side)
    if container.replica.container and container.replica.container:GetWidget() and container.replica.container:GetWidget().isboat then
        local containerwidget = ContainerWidget(self.owner)
        self.controls.containerroot_bottom:AddChild(containerwidget)
        containerwidget:Open(container, self.owner)
        self.controls.containers[container] = containerwidget
        return nil, true
    end
end

local PoisonOver = require("widgets/poisonover")
AddClassPostConstruct("screens/playerhud", function(self)
    Utils.FnDecorator(self, "OpenContainer", OpenContainerBefore)

    -- 中毒
    Utils.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner)
        self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
    end)
end)



----------------------------------------------------------------------------------------------------

if GetModConfigData("kindofworld") == 10 then
    AddPlayerPostInit(function(inst)
        inst:AddComponent("mapwrapper")
    end)
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

    AddComponent(inst, "fertilizer")
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
-- 修船
AddPrefabPostInit("sewing_tape", function(inst)
    inst:AddTag("boatrepairkit")

    if not TheWorld.ismastersim then return end

    inst:AddComponent("interactions")
end)

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

        AddComponent(inst, "tradable")
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
AddPlayerPostInit(function(inst)
    inst._isopening = GLOBAL.net_bool(inst.GUID, "IsOpening", "Store_IsOpening")

    if inst.components.shopper == nil then
        inst:AddComponent("shopper")
    end

    if inst.components.infestable == nil then
        inst:AddComponent("infestable")
    end

    if TheNet:GetIsServer() then
        inst.findpigruinstask = inst:DoPeriodicTask(2, function()
            local x, y, z = inst.Transform:GetWorldPosition()
            if inst.LightWatcher ~= nil and #TheSim:FindEntities(x, y, z, 40, { "pisodaruina" }) > 0 then
                local thresh = TheSim:GetLightAtPoint(10000, 10000, 10000)
                inst.LightWatcher:SetLightThresh(0.075 + thresh)
                inst.LightWatcher:SetDarkThresh(0.05 + thresh)
            else
                inst.LightWatcher:SetLightThresh(0.075)
                inst.LightWatcher:SetDarkThresh(0.05)
            end
        end)
    end
end)

----------------------------------------------------------------------------------------------------

-- TODO 可能会卡视角，需要修复
local function OnDirtyEventCameraStuff(inst) -- this is called on client, if the server does inst.mynetvarCameraMode:set(...)
    local val = inst.mynetvarCameraMode:value()

    if val == 1 then -- for jumping(OnActive) function
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 20 + GetModConfigData("housewallajust")
        TheCamera.targetoffset = Vector3(-2.3, 1.7, 0)
    elseif val == 2 then
        TheCamera:SetDistance(12)
    elseif val == 3 then
        TheCamera:SetDefault()
        TheCamera:SetTarget(TheFocalPoint)
    elseif val == 4 then --for player prox
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
        TheCamera:SetTarget(GetClosestInstWithTag("shopinterior", inst, 30))
        TheCamera.targetoffset = Vector3(2, 1.5, 0)
        TheWorld:PushEvent("underwatercave", "night")
        if not GetClosestInstWithTag("casadojogador", inst, 30) then
            TheFocalPoint.SoundEmitter:PlaySound("dontstarve_DLC003/amb/inside/store", "storemusic")
        end
    elseif val == 5 then --for player prox
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        local alvodacamera = GetClosestInstWithTag("caveinterior", inst, 30)
        if alvodacamera then
            TheCamera:SetTarget(alvodacamera)
        end
        if alvodacamera and alvodacamera:HasTag("pisodaruina") then
            TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
            TheCamera.targetoffset = Vector3(6, 1.5, 0)
            TheWorld:PushEvent("underwatercave", "night")
            TheFocalPoint.SoundEmitter:PlaySound("dontstarve_DLC003/amb/inside/ruins", "storemusic")
        elseif alvodacamera and alvodacamera:HasTag("pisogalleryinteriorpalace") then
            TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
            TheCamera.targetoffset = Vector3(3, 1.5, 0)
        elseif alvodacamera and alvodacamera:HasTag("pisoanthill") then
            TheCamera.distancetarget = 27 + GetModConfigData("housewallajust")
            TheCamera.targetoffset = Vector3(5, 1.5, 0)
            TheWorld:PushEvent("underwatercave", "night")
        else
            TheCamera.distancetarget = 27 + GetModConfigData("housewallajust")
            TheCamera.targetoffset = Vector3(5, 1.5, 0)
            TheWorld:PushEvent("underwatercave", "night")
        end
    elseif val == 6 then --for player prox
        TheCamera:SetDefault()
        TheCamera:SetTarget(TheFocalPoint)

        local fasedodia = "night"
        if TheWorld.state.isday then fasedodia = "day" end
        if TheWorld.state.isdusk then fasedodia = "dusk" end
        if TheWorld.state.isnight then fasedodia = "night" end
        TheWorld:PushEvent("underwatercaveexit", fasedodia)
        TheFocalPoint.SoundEmitter:KillSound("storemusic")
    elseif val == 7 then --for player prox
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 28 + GetModConfigData("housewallajust")
        TheCamera:SetTarget(GetClosestInstWithTag("pisointeriorpalace", inst, 30))
        TheCamera.targetoffset = Vector3(5, 1.5, 0)
    elseif val == 8 then --for player prox
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
        TheCamera:SetTarget(GetClosestInstWithTag("pisointerioruins", inst, 30)) --inst = ThePlayer
        TheCamera.targetoffset = Vector3(6, 1.5, 0)
    end
    -- Use val and do client related stuff
end

local function RegisterListenersCameraStuff(inst)
    -- check that the entity is the playing player
    if inst.HUD ~= nil then
        inst:ListenForEvent("DirtyEventCameraStuff", OnDirtyEventCameraStuff)
    end
end

AddPlayerPostInit(function(inst)
    inst.mynetvarCameraMode = net_tinybyte(inst.GUID, "BakuStuffNetStuff", "DirtyEventCameraStuff")
    inst.mynetvarCameraMode:set(0)
    inst:DoTaskInTime(0, RegisterListenersCameraStuff)

    inst:DoTaskInTime(0.5, function(inst)
        if GetClosestInstWithTag("shopinterior", inst, 30) then
            inst.mynetvarCameraMode:set(4)
        elseif GetClosestInstWithTag("caveinterior", inst, 30) then
            inst.mynetvarCameraMode:set(5)
        elseif GetClosestInstWithTag("pisointeriorpalace", inst, 30) then
            inst.mynetvarCameraMode:set(7)
        else
            inst.mynetvarCameraMode:set(6)
        end
    end)
end)

----------------------------------------------------------------------------------------------------
local function ShelteredOnUpdateBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if not self.mounted
        and #TheSim:FindEntities(x, y, z, 40, { "blows_air" }) > 0
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
                if #TheSim:FindEntities(x, y, z, 40, { "blows_air" }) > 0 then
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

local luavermelha = require "widgets/bloodmoon"
if GetModConfigData("aporkalypse") == true then
    AddClassPostConstruct("widgets/uiclock", function(self)
        self.luadesangue = self:AddChild(luavermelha(self.owner))
    end)
end



local iconedevelocidade = require "widgets/speedicon"
AddClassPostConstruct("widgets/statusdisplays", function(self)
    self.velocidadeativa = self:AddChild(iconedevelocidade(self.owner))
    self.owner.velocidadeativa = self.velocidadeativa
    if KnownModIndex:IsModEnabled("workshop-376333686") then --适配Combined Status模组
        self.velocidadeativa:SetPosition(-85, 6, 0)
    else
        self.velocidadeativa:SetPosition(-65.5, -9.5, 0)
    end
end)
