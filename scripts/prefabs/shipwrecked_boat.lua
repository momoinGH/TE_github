local assets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_armored_build.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_row.zip"),
    Asset("ANIM", "anim/corkboat.zip"),
    Asset("ANIM", "anim/coracle_boat_build.zip"),
    Asset("ANIM", "anim/rowboat_cargo_build.zip"),
    Asset("ANIM", "anim/boat_hud_cargo.zip"),
    Asset("ANIM", "anim/rowboat_encrusted_build.zip"),
    Asset("ANIM", "anim/boat_hud_encrusted.zip"),
    Asset("ANIM", "anim/rowboat_build.zip"),
    Asset("ANIM", "anim/pirate_boat_build.zip"),
    Asset("ANIM", "anim/pirate_boat_placer.zip"),

    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_build.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
}

local sounds = {
    place = "turnoftides/common/together/boat/place",
    creak = "turnoftides/common/together/boat/creak",
    damage = "turnoftides/common/together/boat/damage",
    sink = "turnoftides/common/together/boat/sink",
    hit = "turnoftides/common/together/boat/hit",
    thunk = "turnoftides/common/together/boat/thunk",
    movement = "turnoftides/common/together/boat/movement",
}

local BOAT_COLLISION_SEGMENT_COUNT = 20

--上船前的半径，太大会导致很容易拉着海带跑来跑去玩家还够不着，太小会导致玩家跳不上去
--2这个值可以跳上船，但是下不来,需要覆盖locomotor的CheckEdge方法
--0.2这个值可以跳下船，但是上不去，可以使用componentaction来实现上船，并且因为半径小，所以碰撞范围也小，而且保证不会有第二个玩家上船，是合适的选择
local RADIUS = 0.2

local function sinkloot(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot(inst:GetPosition())
    end
end

local function ReticuleTargetFn(inst)
    local dir = Vector3(
        TheInput:GetAnalogControlValue(CONTROL_MOVE_RIGHT) - TheInput:GetAnalogControlValue(CONTROL_MOVE_LEFT),
        0,
        TheInput:GetAnalogControlValue(CONTROL_MOVE_UP) - TheInput:GetAnalogControlValue(CONTROL_MOVE_DOWN)
    )
    local deadzone = TUNING.CONTROLLER_DEADZONE_RADIUS

    if math.abs(dir.x) >= deadzone or math.abs(dir.z) >= deadzone then
        dir = dir:GetNormalized()

        inst.lastreticuleangle = dir
    elseif inst.lastreticuleangle ~= nil then
        dir = inst.lastreticuleangle
    else
        return nil
    end

    local Camangle = TheCamera:GetHeading() / 180
    local theta = -PI * (0.5 - Camangle)
    local sintheta, costheta = math.sin(theta), math.cos(theta)

    local newx = dir.x * costheta - dir.z * sintheta
    local newz = dir.x * sintheta + dir.z * costheta

    local range = 7
    local pos = inst:GetPosition()
    pos.x = pos.x - (newx * range)
    pos.z = pos.z - (newz * range)

    return pos
end


local function on_start_steering(inst)
    if ThePlayer and ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller.isclientcontrollerattached then
        inst.components.reticule:CreateReticule()
    end
end

local function on_stop_steering(inst)
    if ThePlayer and ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller.isclientcontrollerattached then
        inst.lastreticuleangle = nil
        inst.components.reticule:DestroyReticule()
    end
end

--- 用于客机判断，船上是否有玩家，虽然主机也能用
local function GetBoatPlayer(inst)
    for _, v in ipairs(AllPlayers) do
        if math.sqrt(v:GetDistanceSqToInst(inst)) <= RADIUS and v:GetCurrentPlatform() == inst then
            return v
        end
    end
end

local function OnEntityReplicated(inst)
    --Use this setting because we can rotate, and we are not billboarded with discreet anim facings
    --NOTE: this setting can only be applied after entity replicated
    inst.Transform:SetInterpolateRotation(true)
end

local function StopBoatPhysics(inst)
    --Boats currently need to not go to sleep because
    --constraints will cause a crash if either the target object or the source object is removed from the physics world
    inst.Physics:SetDontRemoveOnSleep(false)
end

local function StartBoatPhysics(inst)
    inst.Physics:SetDontRemoveOnSleep(true)
end

local function OnPhysicsWake(inst)
    if inst.stopupdatingtask then
        inst.stopupdatingtask:Cancel()
        inst.stopupdatingtask = nil
    else
        inst.components.walkableplatform:StartUpdating()
    end
    inst.components.boatphysics:StartUpdating()
end

local function physicssleep_stopupdating(inst)
    inst.components.walkableplatform:StopUpdating()
    inst.stopupdatingtask = nil
end

local function OnPhysicsSleep(inst)
    inst.stopupdatingtask = inst:DoTaskInTime(1, physicssleep_stopupdating)
    inst.components.boatphysics:StopUpdating()
end

local function InstantlyBreakBoat(inst)
    -- This is not for SGboat but is for safety on physics.
    if inst.components.boatphysics then
        inst.components.boatphysics:SetHalting(true)
    end
    --Keep this in sync with SGboat.
    for entity_on_platform in pairs(inst.components.walkableplatform:GetEntitiesOnPlatform()) do
        entity_on_platform:PushEvent("abandon_ship")
    end
    for player_on_platform in pairs(inst.components.walkableplatform:GetPlayersOnPlatform()) do
        player_on_platform:PushEvent("onpresink")
    end

    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:sinkloot()
    inst:Remove()
end

local function GetSafePhysicsRadius(inst)
    return RADIUS + 0.18 -- Add a small offset for item overhangs.
end

local function SpawnFragment(lp, prefix, offset_x, offset_y, offset_z, ignite)
    local fragment = SpawnPrefab(prefix)
    fragment.Transform:SetPosition(lp.x + offset_x, lp.y + offset_y, lp.z + offset_z)

    if offset_y > 0 and fragment.Physics then
        fragment.Physics:SetVel(0, -0.25, 0)
    end

    if ignite and fragment.components.burnable then
        fragment.components.burnable:Ignite()
    end

    return fragment
end

local function IsBoatEdgeOverLand(inst, override_position_pt)
    local map = TheWorld.Map
    local radius = inst:GetSafePhysicsRadius()
    local segment_count = BOAT_COLLISION_SEGMENT_COUNT * 2
    local segment_span = TWOPI / segment_count
    local x, y, z
    if override_position_pt then
        x, y, z = override_position_pt:Get()
    else
        x, y, z = inst.Transform:GetWorldPosition()
    end
    for segement_idx = 0, segment_count do
        local angle = segement_idx * segment_span

        local angle0 = angle - segment_span / 2
        local x0 = math.cos(angle0) * radius
        local z0 = math.sin(angle0) * radius
        if not map:IsOceanTileAtPoint(x + x0, 0, z + z0) or map:IsVisualGroundAtPoint(x + x0, 0, z + z0) then
            return true
        end

        local angle1 = angle + segment_span / 2
        local x1 = math.cos(angle1) * radius
        local z1 = math.sin(angle1) * radius
        if not map:IsOceanTileAtPoint(x + x1, 0, z + z1) or map:IsVisualGroundAtPoint(x + x1, 0, z + z1) then
            return true
        end
    end

    return false
end

local BOATBUMPER_MUST_TAGS = { "boatbumper" }
local function OnLoadPostPass(inst)
    local boatring = inst.components.boatring
    if not boatring then
        return
    end

    -- If cannons and bumpers are on a boat, we need to rotate them to account for the boat's rotation
    local x, y, z = inst.Transform:GetWorldPosition()

    -- Bumpers
    local bumpers = TheSim:FindEntities(x, y, z, boatring:GetRadius(), BOATBUMPER_MUST_TAGS)
    for _, bumper in ipairs(bumpers) do
        -- Add to boat bumper list for future reference
        table.insert(boatring.boatbumpers, bumper)

        local bumperpos = bumper:GetPosition()
        local angle = GetAngleFromBoat(inst, bumperpos.x, bumperpos.z) / DEGREES

        -- Need to further rotate the bumpers to account for the boat's rotation
        bumper.Transform:SetRotation(-angle + 90)
    end
end

local function OnDismantle(inst, doer)
    if inst.components.health and not inst.components.health:IsDead() then
        local items = inst.components.container and inst.components.container:RemoveAllItems() or {}
        table.insert(items, SpawnPrefab(inst.dismantlePrefab))
        local x, y, z = inst.Transform:GetWorldPosition()
        for _, v in ipairs(items) do
            if not doer.components.inventory or not doer.components.inventory:GiveItem(v) then
                v.Transform:SetPosition(x, y, z)
                v.components.inventoryitem:OnDropped()
            end
        end
        -- inst.SoundEmitter:PlaySound("meta4/winona_catapult/collapse")
        inst:Remove()
    end
end

local function GetSpecificSlotForItemBefore(self, item)
    print("获取槽")
end

---fn
---@param minimap string|nil
---@param bank string
---@param build string
---@param loots table
---@param data table health:血量；dismantlePrefab:收回后的预制体；container：容器；
local function common(minimap, bank, build, loots, data)
    data = data or {}

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    if minimap then
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("armouredboat.png")
        inst.MiniMapEntity:SetPriority(-1)
    end
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst:AddTag("shipwrecked_boat")
    inst:AddTag("ignorewalkableplatforms")

    inst:AddTag("boat")
    inst:AddTag("wood")

    local phys = inst.entity:AddPhysics()
    phys:SetMass(TUNING.BOAT.MASS)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.OBSTACLES)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    -- phys:CollidesWith(COLLISION.OBSTACLES)
    phys:SetCylinder(0.5, 3)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
    inst.AnimState:SetFinalOffset(1)
    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst:AddComponent("walkableplatform")
    inst.components.walkableplatform.platform_radius = RADIUS
    --生成一圈碰撞墙，防止玩家上船的时候跳过头直接跳海里了
    -- inst.components.walkableplatform.player_collision_prefab = "shipwrecked_boat_player_collision"

    inst:AddComponent("healthsyncer")
    inst.components.healthsyncer.max_health = data.health or TUNING.BOAT.HEALTH

    inst:AddComponent("waterphysics")
    inst.components.waterphysics.restitution = 0.75

    local reticule = inst:AddComponent("reticule")
    reticule.targetfn = ReticuleTargetFn
    reticule.ispassableatallpoints = true

    local boatringdata = inst:AddComponent("boatringdata")
    boatringdata:SetRadius(RADIUS)
    boatringdata:SetNumSegments(RADIUS * 2)

    inst.on_start_steering = on_start_steering
    inst.on_stop_steering = on_stop_steering

    inst.walksound = "wood"
    inst.doplatformcamerazoom = net_bool(inst.GUID, "doplatformcamerazoom", "doplatformcamerazoomdirty")

    inst.GetBoatPlayer = GetBoatPlayer

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("endsteeringreticule", function(inst2, event_data)
            if ThePlayer and ThePlayer == event_data.player then
                inst2:on_stop_steering()
            end
        end)
        inst:ListenForEvent("starsteeringreticule", function(inst2, event_data)
            if ThePlayer and ThePlayer == event_data.player then
                inst2:on_start_steering()
            end
        end)

        inst:AddComponent("boattrail")
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated
        return inst
    end

    inst.Physics:SetDontRemoveOnSleep(true)
    -- inst.item_collision_prefab = "boat_item_collision" --船是跟随玩家的，不需要墙

    inst.entity:AddPhysicsWaker() --server only component
    inst.PhysicsWaker:SetTimeBetweenWakeTests(TUNING.BOAT.WAKE_TEST_TIME)

    local repairable = inst:AddComponent("repairable")
    repairable.repairmaterial = MATERIALS.WOOD

    inst:AddComponent("inspectable")
    inst:AddComponent("boatring") --旋转
    inst:AddComponent("hullhealth")
    inst.components.hullhealth.leakproof = true
    inst:AddComponent("boatphysics")
    inst:AddComponent("boatdrifter")
    inst:AddComponent("savedrotation")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(data.health or TUNING.BOAT.HEALTH)
    inst.components.health.nofadeout = true

    --TODO 死亡时生成残骸 flotsam_debris_sw.lua

    if loots then
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loots)
    end

    if data.dismantlePrefab then --表示可收回
        inst.dismantlePrefab = data.dismantlePrefab
        inst:AddComponent("portablestructure")
        inst.components.portablestructure:SetOnDismantleFn(OnDismantle)
    end

    if data.container then
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(data.container)
        inst.components.container.canbeopened = false
    end

    inst:AddComponent("shipwreckedboat")

    -- inst:SetStateGraph(data.stategraph or "SGboat")

    inst.StopBoatPhysics = StopBoatPhysics
    inst.StartBoatPhysics = StartBoatPhysics

    inst.OnPhysicsWake = OnPhysicsWake
    inst.OnPhysicsSleep = OnPhysicsSleep

    inst.InstantlyBreakBoat = InstantlyBreakBoat
    inst.GetSafePhysicsRadius = GetSafePhysicsRadius
    inst.IsBoatEdgeOverLand = IsBoatEdgeOverLand

    inst.sounds = sounds

    inst.sinkloot = sinkloot
    inst.OnLoadPostPass = OnLoadPostPass

    inst:ListenForEvent("death", InstantlyBreakBoat)

    return inst
end

local function build_boat_collision_mesh(radius, height)
    local segment_count = BOAT_COLLISION_SEGMENT_COUNT
    local segment_span = TWOPI / segment_count

    local triangles = {}
    local y0 = 0
    local y1 = height

    for segement_idx = 0, segment_count do
        local angle = segement_idx * segment_span
        local angle0 = angle - segment_span / 2
        local angle1 = angle + segment_span / 2

        local x0 = math.cos(angle0) * radius
        local z0 = math.sin(angle0) * radius

        local x1 = math.cos(angle1) * radius
        local z1 = math.sin(angle1) * radius

        table.insert(triangles, x0)
        table.insert(triangles, y0)
        table.insert(triangles, z0)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y1)
        table.insert(triangles, z1)
    end

    return triangles
end

local function boat_player_collision_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    inst:AddTag("CLASSIFIED")

    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetRestitution(0)
    phys:SetCollisionGroup(COLLISION.BOAT_LIMITS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.WORLD)
    phys:SetTriangleMesh(build_boat_collision_mesh(RADIUS + 0.1, 3)) --大了碰撞体积就大，小了跳船时容易掉海里
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

----------------------------------------------------------------------------------------------------
local armouredboat_loots = {
    "boards", "boards", "boards", "rope", "seashell", "seashell", "seashell", "seashell", "seashell",
}
local armouredboat_prefabs = {
    "shipwrecked_boat_player_collision", "boards", "rope", "seashell"
}
local function armouredboat_fn()
    return common("armouredboat.png", "rowboat", "rowboat_armored_build", armouredboat_loots,
        { health = 150, dismantlePrefab = "porto_armouredboat", container = "armouredboat" })
end

local corkboat_loots = {
    "cork"
}
local corkboat_prefabs = {
    "shipwrecked_boat_player_collision", "cork"
}
local function corkboat_fn()
    return common("coracle_boat.png", "rowboat", "coracle_boat_build", corkboat_loots,
        { health = 80, dismantlePrefab = "corkboatitem", container = "corkboat" })
end


local cargoboat_loots = {
    "boards", "boards", "boards", "rope"
}
local cargoboat_prefabs = {
    "shipwrecked_boat_player_collision", "boards", "rope"
}
local function cargoboat_fn()
    return common("cargo.png", "rowboat", "rowboat_cargo_build", cargoboat_loots,
        { health = 300, dismantlePrefab = "porto_cargoboat", container = "cargoboat" })
end

local encrustedboat_loots = {
    "limestone", "limestone", "boards", "boards", "boards"
}
local encrustedboat_prefabs = {
    "shipwrecked_boat_player_collision", "limestone", "boards"
}
local function encrustedboat_fn()
    return common("encrustedboat.png", "rowboat", "rowboat_encrusted_build", encrustedboat_loots,
        { health = 800, dismantlePrefab = "porto_encrustedboat", container = "encrustedboat" })
end

local rowboat_loots = {
    "boards", "vine", "vine"
}
local rowboat_prefabs = {
    "shipwrecked_boat_player_collision", "boards", "vine",
}
local function rowboat_fn()
    return common("rowboat.png", "rowboat", "rowboat_build", rowboat_loots,
        { health = 250, dismantlePrefab = "porto_rowboat", container = "rowboat" })
end


local surfboard_loots = {
    "seashell"
}
local surfboard_prefabs = {
    "shipwrecked_boat_player_collision", "seashell"
}

local function surfboard_fn()
    return common("surfboard.png", "raft", "raft_surfboard_build", surfboard_loots,
        { health = 100, dismantlePrefab = "porto_surfboard" })
end

local woodlegsboat_loots = {
    "boards", "boards", "dubloon", "dubloon"
}
local woodlegsboat_prefabs = {
    "shipwrecked_boat_player_collision", "boards", "dubloon"
}

local function woodlegsboat_fn()
    return common("woodlegsboat.png", "rowboat", "pirate_boat_build", woodlegsboat_loots,
        { health = 500, dismantlePrefab = "porto_woodlegsboat", container = "woodlegsboat" })
end


local shadowwaxwellboat_loots = {
    "papyrus", "nightmarefuel", "nightmarefuel"
}
local shadowwaxwellboat_prefabs = {
    "shipwrecked_boat_player_collision", "papyrus", "nightmarefuel"
}

local function shadowwaxwellboat_fn()
    local inst = common("shadowboat.png", "rowboat", "waxwell_shadowboat_build", shadowwaxwellboat_loots,
        { health = 150, dismantlePrefab = "porto_shadowboat", container = "shadowwaxwellboat" })
    inst.AnimState:SetMultColour(0, 0, 0, .4)
    return inst
end

local raft_old_loots = {
    "vine", "bamboo", "bamboo"
}
local raft_old_prefabs = {
    "shipwrecked_boat_player_collision", "vine", "bamboo"
}

local function raft_old_fn()
    return common("raft.png", "raft", "raft_build", raft_old_loots, { health = 150 })
end

local lograft_old_loots = {
    "log", "log", "log", "cutgrass", "cutgrass"
}

local lograft_old_prefabs = {
    "shipwrecked_boat_player_collision", "log", "cutgrass"
}

local function lograft_old_fn()
    return common("lograft.png", "raft", "raft_log_build", lograft_old_loots, { health = 150 })
end

local woodlegsboatamigo_loots = {
    "log"
}

local woodlegsboatamigo_prefabs = {
    "shipwrecked_boat_player_collision", "log"
}

local function woodlegsboatamigo_fn()
    local inst = common("woodlegsboat.png", "rowboat", "pirate_boat_build", woodlegsboatamigo_loots,
        { health = 150, container = "woodlegsboatamigo" })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.health:SetInvincible(true)

    return inst
end

return Prefab("shipwrecked_boat_player_collision", boat_player_collision_fn),
    Prefab("armouredboat", armouredboat_fn, assets, armouredboat_prefabs),
    Prefab("corkboat", corkboat_fn, assets, corkboat_prefabs),
    Prefab("cargoboat", cargoboat_fn, assets, cargoboat_prefabs),
    Prefab("encrustedboat", encrustedboat_fn, assets, encrustedboat_prefabs),
    Prefab("rowboat", rowboat_fn, assets, rowboat_prefabs),
    Prefab("surfboard", surfboard_fn, assets, surfboard_prefabs),
    Prefab("woodlegsboat", woodlegsboat_fn, assets, woodlegsboat_prefabs),
    Prefab("shadowwaxwellboat", shadowwaxwellboat_fn, assets, shadowwaxwellboat_prefabs),
    Prefab("raft_old", raft_old_fn, assets, raft_old_prefabs),
    Prefab("lograft_old", lograft_old_fn, assets, lograft_old_prefabs),
    Prefab("woodlegsboatamigo", woodlegsboatamigo_fn, assets, woodlegsboatamigo_prefabs)
