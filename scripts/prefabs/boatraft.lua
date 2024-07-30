local assets =
{
    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_build.zip"),
    Asset("ANIM", "anim/raft_log_build.zip"),
    Asset("ANIM", "anim/raft_rot.zip"),
}

local prefabs =
{
    "boat_water_fx",
    "boat_leak",
    "fx_boat_crackle",
    "boatfragment03",
    "boatfragment04",
    "boatfragment05",
    "fx_boat_pop",
    "walkingplank",
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

local BOATBUMPER_MUST_TAGS = { "boatbumper" }
local BOATCANNON_MUST_TAGS = { "boatcannon" }

local function OnLoadPostPass(inst)
    local boatring = inst.components.boatring
    if boatring == nil then
        return
    end

    -- If cannons and bumpers are on a boat, we need to rotate them to account for the boat's rotation
    local x, y, z = inst:GetPosition():Get()

    -- Bumpers
    local bumpers = TheSim:FindEntities(x, y, z, boatring:GetRadius(), BOATBUMPER_MUST_TAGS)
    for i, bumper in ipairs(bumpers) do
        -- Add to boat bumper list for future reference
        table.insert(boatring.boatbumpers, bumper)

        local bumperpos = bumper:GetPosition()
        local angle = GetAngleFromBoat(inst, bumperpos.x, bumperpos.z) / DEGREES

        -- Need to further rotate the bumpers to account for the boat's rotation
        bumper.Transform:SetRotation(-angle + 90)
    end

    -- Cannons
    --[[local cannons = TheSim:FindEntities(x, y, z, boatring:GetRadius(), BOATCANNON_MUST_TAGS)
    for i, cannon in ipairs(cannons) do
        local cannonpos = cannon:GetPosition()
        local angle = GetAngleFromBoat(inst, cannonpos.x, cannonpos.z) / DEGREES

        cannon.Transform:SetRotation(-angle)
    end]]
end

local function speed(inst)
    if not inst.startpos then
        inst.startpos = inst:GetPosition()
        inst.starttime = GetTime()
        inst.speedtask = inst:DoPeriodicTask(FRAMES, function()
            local pt = inst:GetPosition()
            local dif = distsq(pt.x, pt.z, inst.startpos.x, inst.startpos.z)
            print("DIST", dif, GetTime() - inst.starttime)
        end)
    else
        inst.startpos = nil
        inst.speedtask:Cancel()
        inst.speedtask = nil
        inst.starttime = nil
    end
end

local function OnRepaired(inst)
    --inst.SoundEmitter:PlaySound("dontstarve/creatures/together/fossil/repair")
end

local function BoatCam_IsEnabledFn()
    return Profile:IsBoatCameraEnabled()
end

local function BoatCam_ActiveFn(params, parent, best_dist_sq)
    local state = params.updater.state
    local tpos = params.target:GetPosition()
    state.last_platform_x, state.last_platform_z = tpos.x, tpos.z

    local pan_gain, heading_gain, distance_gain = TheCamera:GetGains()
    TheCamera:SetGains(1.5, heading_gain, distance_gain)
end

local function BoatCam_UpdateFn(dt, params, parent, best_dist_sq)
    local tpos = params.target:GetPosition()

    local state = params.updater.state
    local platform_x, platform_y, platform_z = tpos:Get()

    local velocity_x = dt == 0 and 0 or ((platform_x - state.last_platform_x) / dt)
    local velocity_z = dt == 0 and 0 or ((platform_z - state.last_platform_z) / dt)
    local velocity_normalized_x, velocity_normalized_z = 0, 0
    local velocity = 0
    local min_velocity = 0.4
    local velocity_sq = velocity_x * velocity_x + velocity_z * velocity_z

    if velocity_sq >= min_velocity * min_velocity then
        velocity = math.sqrt(velocity_sq)
        velocity_normalized_x = velocity_x / velocity
        velocity_normalized_z = velocity_z / velocity
        velocity = math.max(velocity - min_velocity, 0)
    end

    local look_ahead_max_dist = 5
    local look_ahead_max_velocity = 3
    local look_ahead_percentage = math.min(math.max(velocity / look_ahead_max_velocity, 0), 1)
    local look_ahead_amount = look_ahead_max_dist * look_ahead_percentage

    --Average target_camera_offset to get rid of some of the noise.
    state.target_camera_offset.x = (state.target_camera_offset.x + velocity_normalized_x * look_ahead_amount) / 2
    state.target_camera_offset.z = (state.target_camera_offset.z + velocity_normalized_z * look_ahead_amount) / 2

    state.last_platform_x, state.last_platform_z = platform_x, platform_z

    local camera_offset_lerp_speed = 0.25
    state.camera_offset.x, state.camera_offset.z = VecUtil_Lerp(state.camera_offset.x, state.camera_offset.z,
        state.target_camera_offset.x, state.target_camera_offset.z, dt * camera_offset_lerp_speed)

    TheCamera:SetOffset(state.camera_offset + (tpos - parent:GetPosition()))

    local pan_gain, heading_gain, distance_gain = TheCamera:GetGains()
    local pan_lerp_speed = 0.75
    pan_gain = Lerp(pan_gain, state.target_pan_gain, dt * pan_lerp_speed)

    TheCamera:SetGains(pan_gain, heading_gain, distance_gain)
end

local function StartBoatCamera(inst)
    local camera_settings =
    {
        state = {
            target_camera_offset = Vector3(0, 1.5, 0),
            camera_offset = Vector3(0, 1.5, 0),
            last_platform_x = 0,
            last_platform_z = 0,
            target_pan_gain = 4,
        },
        UpdateFn = BoatCam_UpdateFn,
        ActiveFn = BoatCam_ActiveFn,
        IsEnabled = BoatCam_IsEnabledFn,
    }

    TheFocalPoint.components.focalpoint:StartFocusSource(inst, nil, nil, math.huge, math.huge, -1, camera_settings)
end

local function OnObjGotOnPlatform(inst, obj)
    if obj == ThePlayer and inst.StartBoatCamera ~= nil then
        inst:StartBoatCamera()
    end
end

local function OnObjGotOffPlatform(inst, obj)
    if obj == ThePlayer then
        TheFocalPoint.components.focalpoint:StopFocusSource(inst)
    end
end

local function RemoveConstrainedPhysicsObj(physics_obj)
    if physics_obj:IsValid() then
        physics_obj.Physics:ConstrainTo(nil)
        physics_obj:Remove()
    end
end

local function AddConstrainedPhysicsObj(boat, physics_obj)
    physics_obj:ListenForEvent("onremove", function() RemoveConstrainedPhysicsObj(physics_obj) end, boat)

    physics_obj:DoTaskInTime(0, function()
        if boat:IsValid() then
            physics_obj.Transform:SetPosition(boat.Transform:GetWorldPosition())
            physics_obj.Physics:ConstrainTo(boat.entity)
        end
    end)
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

local function ReticuleTargetFn(inst)
    local range = 7
    local pos = inst:GetPosition()

    local dir = Vector3()
    dir.x = TheInput:GetAnalogControlValue(CONTROL_MOVE_RIGHT) - TheInput:GetAnalogControlValue(CONTROL_MOVE_LEFT)
    dir.y = 0
    dir.z = TheInput:GetAnalogControlValue(CONTROL_MOVE_UP) - TheInput:GetAnalogControlValue(CONTROL_MOVE_DOWN)
    local deadzone = .3

    if math.abs(dir.x) >= deadzone or math.abs(dir.z) >= deadzone then
        dir = dir:GetNormalized()
        inst.lastreticuleangle = dir
    else
        if inst.lastreticuleangle then
            dir = inst.lastreticuleangle
        else
            return nil
        end
    end

    local Camangle = TheCamera:GetHeading() / 180
    local theta = -PI * (0.5 - Camangle)

    local newx = dir.x * math.cos(theta) - dir.z * math.sin(theta)
    local newz = dir.x * math.sin(theta) + dir.z * math.cos(theta)

    pos.x = pos.x - (newx * range)
    pos.z = pos.z - (newz * range)

    return pos
end

local function SpawnFragment(lp, prefix, offset_x, offset_y, offset_z, ignite)
    local fragment = SpawnPrefab(prefix)
    fragment.Transform:SetPosition(lp.x + offset_x, lp.y + offset_y, lp.z + offset_z)

    if offset_y > 0 then
        local physics = fragment.Physics
        if physics ~= nil then
            physics:SetVel(0, -0.25, 0)
        end
    end

    if ignite then
        fragment.components.burnable:Ignite()
    end

    return fragment
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
    inst:sinkloot()
    if inst.postsinkfn then
        inst:postsinkfn()
    end
    inst:Remove()
end

local function GetSafePhysicsRadius(inst)
    return (inst.components.hull ~= nil and inst.components.hull:GetRadius() or TUNING.BOAT.RADIUS) +
        0.10 -- Add a small offset for item overhangs.
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

local function MakeBoat(name, radius)
    local stats_multiplier = (radius / 4) ^ 2
    local scale_multiplier = radius / 4

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        --inst.MiniMapEntity:SetIcon("boat.png")
        inst.entity:AddNetwork()

        inst:AddTag("ignorewalkableplatforms")
        inst:AddTag("antlion_sinkhole_blocker")
        if name == "boat_raft_rot" then
            inst:AddTag("boat")
        else
            inst:AddTag("swboat")
        end
        inst.sounds = sounds
        inst.walksound = "wood"

        inst.boat_crackle = "fx_boat_crackle"

        inst.sinkloot = function()
            local ignitefragments = inst.activefires > 0
            local locus_point = inst:GetPosition()
            local num_loot = 3
            for i = 1, num_loot do
                local r = math.sqrt(math.random()) * (TUNING.BOAT.RADIUS - 2) + 1.5
                local t = i * PI2 / num_loot + math.random() * (PI2 / (num_loot * .5))
                SpawnFragment(locus_point, "log", math.cos(t) * r, 0, math.sin(t) * r, ignitefragments)
            end
        end

        inst.postsinkfn = function()
            local fx_boat_crackle = SpawnPrefab("fx_boat_pop")
            fx_boat_crackle.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, { intensity = 1 })
            inst.SoundEmitter:PlaySoundWithParams(inst.sounds.sink)
        end

        local max_health = 150

        local phys = inst.entity:AddPhysics()
        phys:SetMass(TUNING.BOAT.MASS * stats_multiplier)

        phys:SetFriction(0)
        --		if name == "raft" then
        --        phys:SetFriction(0.011)
        --		end
        --		if name == "lograft" then
        --        phys:SetFriction(0.015)
        --		end		

        --		if name == "boat_raft_rot" then
        --        phys:SetFriction(0.010)
        --		end	

        phys:SetDamping(5)
        phys:SetCollisionGroup(COLLISION.OBSTACLES)
        phys:ClearCollisionMask()
        phys:CollidesWith(COLLISION.WORLD)
        phys:CollidesWith(COLLISION.OBSTACLES)
        phys:SetCylinder(radius, 3)
        --Boats currently need to not go to sleep because
        --constraints will cause a crash if either the target object or the source object is removed from the physics world
        phys:SetDontRemoveOnSleep(true)

        inst.AnimState:SetBank("raft")
        --		inst.AnimState:SetBuild("raft_log_build")
        --		inst.AnimState:SetBuild("raft_build")	

        inst.name = name
        inst.AnimState:PlayAnimation(inst.name, true)

        inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
        inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)

        inst:AddComponent("walkableplatform")
        inst.components.walkableplatform.radius = radius
        inst.components.walkableplatform.platform_radius = radius

        inst:AddComponent("healthsyncer")
        inst.components.healthsyncer.max_health = max_health

        AddConstrainedPhysicsObj(inst, SpawnPrefab("boat_item_collision_" .. name)) -- hack until physics constraints are networked

        inst:AddComponent("waterphysics")
        inst.components.waterphysics.restitution = 0.75 * stats_multiplier

        inst:AddComponent("reticule")
        inst.components.reticule.targetfn = ReticuleTargetFn
        inst.components.reticule.ispassableatallpoints = true
        inst.on_start_steering = on_start_steering
        inst.on_stop_steering = on_stop_steering

        inst.doplatformcamerazoom = net_bool(inst.GUID, "doplatformcamerazoom", "doplatformcamerazoomdirty")

        if not TheNet:IsDedicated() then
            -- dedicated server doesnt need to handle camera settings
            --            inst.StartBoatCamera = StartBoatCamera
            --            inst:ListenForEvent("obj_got_on_platform", OnObjGotOnPlatform)
            --            inst:ListenForEvent("obj_got_off_platform", OnObjGotOffPlatform)

            inst:ListenForEvent("endsteeringreticule",
                function(inst, data) if ThePlayer and ThePlayer == data.player then inst:on_stop_steering() end end)
            inst:ListenForEvent("starsteeringreticule",
                function(inst, data) if ThePlayer and ThePlayer == data.player then inst:on_start_steering() end end)

            inst:AddComponent("boattrail")
        end

        inst:AddComponent("boatringdata")
        inst.components.boatringdata:SetRadius(radius)
        inst.components.boatringdata:SetNumSegments(8)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("hull")
        inst.components.hull:SetRadius(radius)
        local boatlip = SpawnPrefab('boatlipinvisible')

        if name == "lograft" then
            inst.barco = SpawnPrefab('boatliplograft')
            inst.barco.entity:SetParent(inst.entity)
            inst.barco.Transform:SetPosition(0, 0, 0)
            inst.MiniMapEntity:SetIcon("lograft.png")
        end

        if name == "raft" then
            inst.barco = SpawnPrefab('boatlipraft')
            inst.barco.entity:SetParent(inst.entity)
            inst.barco.Transform:SetPosition(0, 0, 0)
            inst.MiniMapEntity:SetIcon("raft.png")
        end

        if name == "boat_raft_rot" then
            inst.barco2 = SpawnPrefab('boatlipraftrot')
            inst.barco2.entity:SetParent(inst.entity)
            inst.barco2.Transform:SetPosition(0, 0, 0)
            inst.MiniMapEntity:SetIcon("boat_raft.png")

            inst.barco3 = SpawnPrefab('boatlip')
            inst.barco3.AnimState:OverrideSymbol("boat_plants", "boat_test", "")
            inst.barco3.entity:SetParent(inst.entity)
            inst.barco3.Transform:SetPosition(0, 0, 0)
            inst.barco3.Transform:SetScale(0.88, 0.88, 0.88)
        end

        boatlip.AnimState:SetScale(scale_multiplier, scale_multiplier, scale_multiplier)
        inst.components.hull:SetBoatLip(boatlip)
        local playercollision = SpawnPrefab("boat_player_collision_" .. name)
        inst.components.hull:AttachEntityToBoat(playercollision, 0, 0)
        playercollision.collisionboat = inst

        inst:AddComponent("repairable")
        inst.components.repairable.repairmaterial = MATERIALS.WOOD
        inst.components.repairable.onrepaired = OnRepaired

        inst:AddComponent("hullhealth")
        inst.components.hullhealth.leak_radius = 2.5 * scale_multiplier
        inst.components.hullhealth.small_leak_dmg = 2
        inst.components.hullhealth.med_leak_dmg = 2

        inst:AddComponent("boatphysics")
        inst.components.boatphysics.sizespeedmultiplier = 1 / scale_multiplier
        inst.components.boatphysics.max_velocity = TUNING.BOAT.MAX_VELOCITY_MOD / scale_multiplier

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(max_health * 2.5)
        inst.components.health.nofadeout = true

        inst:AddComponent("boatring")

        inst.activefires = 0

        local burnable_locator = SpawnPrefab('burnable_locator_medium')
        burnable_locator.boat = inst
        inst.components.hull:AttachEntityToBoat(burnable_locator, 0, 0, true)

        burnable_locator = SpawnPrefab('burnable_locator_medium')
        burnable_locator.boat = inst
        inst.components.hull:AttachEntityToBoat(burnable_locator, 2.5 * scale_multiplier, 0, true)

        burnable_locator = SpawnPrefab('burnable_locator_medium')
        burnable_locator.boat = inst
        inst.components.hull:AttachEntityToBoat(burnable_locator, -2.5 * scale_multiplier, 0, true)

        burnable_locator = SpawnPrefab('burnable_locator_medium')
        burnable_locator.boat = inst
        inst.components.hull:AttachEntityToBoat(burnable_locator, 0, 2.5 * scale_multiplier, true)

        burnable_locator = SpawnPrefab('burnable_locator_medium')
        burnable_locator.boat = inst
        inst.components.hull:AttachEntityToBoat(burnable_locator, 0, -2.5 * scale_multiplier, true)

        inst:SetStateGraph("SGsurfboard")

        inst.speed = speed

        inst.InstantlyBreakBoat = InstantlyBreakBoat
        inst.GetSafePhysicsRadius = GetSafePhysicsRadius
        inst.IsBoatEdgeOverLand = IsBoatEdgeOverLand
        inst.OnLoadPostPass = OnLoadPostPass

        return inst
    end

    local function build_boat_collision_mesh(radius, height)
        local segment_count = 20
        local segment_span = math.pi * 2 / segment_count

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

    local PLAYER_COLLISION_MESH = build_boat_collision_mesh(radius + .1, 3)
    local ITEM_COLLISION_MESH = build_boat_collision_mesh(radius + .2, 3)

    local function boat_player_collision_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        local phys = inst.entity:AddPhysics()
        phys:SetMass(0)
        phys:SetFriction(0)
        phys:SetDamping(5)
        phys:SetCollisionGroup(COLLISION.BOAT_LIMITS)
        phys:ClearCollisionMask()
        phys:CollidesWith(COLLISION.CHARACTERS)
        phys:CollidesWith(COLLISION.WORLD)
        phys:SetTriangleMesh(PLAYER_COLLISION_MESH)

        inst:AddTag("NOBLOCK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end

    local function boat_item_collision_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        inst:AddTag("CLASSIFIED")

        local phys = inst.entity:AddPhysics()
        phys:SetMass(1000)
        phys:SetFriction(0)
        phys:SetDamping(5)
        phys:SetCollisionGroup(COLLISION.BOAT_LIMITS)
        phys:ClearCollisionMask()
        phys:CollidesWith(COLLISION.ITEMS)
        phys:CollidesWith(COLLISION.FLYERS)
        phys:CollidesWith(COLLISION.WORLD)
        phys:SetTriangleMesh(ITEM_COLLISION_MESH)
        --Boats currently need to not go to sleep because
        --constraints will cause a crash if either the target object or the source object is removed from the physics world
        phys:SetDontRemoveOnSleep(true)

        inst:AddTag("NOBLOCK")
        inst:AddTag("ignorewalkableplatforms")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end

    return { Prefab(name, fn, assets, prefabs),
        Prefab("boat_player_collision_" .. name, boat_player_collision_fn),
        Prefab("boat_item_collision_" .. name, boat_item_collision_fn) }
end

local FilePrefabs = {}
for i, v in ipairs(MakeBoat("lograft", 0.8)) do
    table.insert(FilePrefabs, v)
end

for i, v in ipairs(MakeBoat("raft", 0.8)) do
    table.insert(FilePrefabs, v)
end

for i, v in ipairs(MakeBoat("boat_raft_rot", 3.2)) do
    table.insert(FilePrefabs, v)
end

return unpack(FilePrefabs)
