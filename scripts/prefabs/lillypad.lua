local assets =
{
    Asset("ANIM", "anim/lily_pad.zip"),
    Asset("ANIM", "anim/splash.zip"),
    Asset("MINIMAP_IMAGE", "lily_pad"),

}


local prefabs =
{
    "mast",
    "burnable_locator_medium",
    "steeringwheel",
    "rudder",
    "boatlip",
    "boat_water_fx",
    "boat_leak",
    "fx_boat_crackle",
    "boatfragment03",
    "boatfragment04",
    "boatfragment05",
    "fx_boat_pop",
    "boat_player_collision",
    "boat_item_collision",
    "walkingplank",
    "frog_poison",
    "mosquito",
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

local function groundtest(inst)
    local map = TheWorld.Map
    local ex, ey, ez = inst.Transform:GetWorldPosition()
    local posicao1 = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez + 5))
    local posicao2 = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez - 5))
    local posicao3 = map:GetTile(map:GetTileCoordsAtPoint(ex + 5, ey, ez))
    local posicao4 = map:GetTile(map:GetTileCoordsAtPoint(ex - 5, ey, ez))

    if posicao1 ~= (GROUND.OCEAN_SWELL) and posicao1 ~= (GROUND.OCEAN_WATERLOG) and posicao1 ~= (GROUND.OCEAN_BRINEPOOL) and posicao1 ~= (GROUND.OCEAN_BRINEPOOL_SHORE) and posicao1 ~= (GROUND.OCEAN_HAZARDOUS) and posicao1 ~= (GROUND.OCEAN_ROUGH) and posicao1 ~= (GROUND.OCEAN_COASTAL) and posicao1 ~= (GROUND.OCEAN_COASTAL_SHORE)
        or posicao2 ~= (GROUND.OCEAN_SWELL) and posicao2 ~= (GROUND.OCEAN_WATERLOG) and posicao2 ~= (GROUND.OCEAN_BRINEPOOL) and posicao2 ~= (GROUND.OCEAN_BRINEPOOL_SHORE) and posicao2 ~= (GROUND.OCEAN_HAZARDOUS) and posicao2 ~= (GROUND.OCEAN_ROUGH) and posicao2 ~= (GROUND.OCEAN_COASTAL) and posicao2 ~= (GROUND.OCEAN_COASTAL_SHORE)
        or posicao3 ~= (GROUND.OCEAN_SWELL) and posicao3 ~= (GROUND.OCEAN_WATERLOG) and posicao3 ~= (GROUND.OCEAN_BRINEPOOL) and posicao3 ~= (GROUND.OCEAN_BRINEPOOL_SHORE) and posicao3 ~= (GROUND.OCEAN_HAZARDOUS) and posicao3 ~= (GROUND.OCEAN_ROUGH) and posicao3 ~= (GROUND.OCEAN_COASTAL) and posicao3 ~= (GROUND.OCEAN_COASTAL_SHORE)
        or posicao4 ~= (GROUND.OCEAN_SWELL) and posicao4 ~= (GROUND.OCEAN_WATERLOG) and posicao4 ~= (GROUND.OCEAN_BRINEPOOL) and posicao4 ~= (GROUND.OCEAN_BRINEPOOL_SHORE) and posicao4 ~= (GROUND.OCEAN_HAZARDOUS) and posicao4 ~= (GROUND.OCEAN_ROUGH) and posicao4 ~= (GROUND.OCEAN_COASTAL) and posicao4 ~= (GROUND.OCEAN_COASTAL_SHORE) then
        inst:Remove()
    end
end


local function OnRepaired(inst)
    --inst.SoundEmitter:PlaySound("dontstarve/creatures/together/fossil/repair")
end

local function OnSpawnNewBoatLeak(inst, data)
    if data ~= nil and data.pt ~= nil then
        local leak = SpawnPrefab("boat_leak")
        leak.Transform:SetPosition(data.pt:Get())
        leak.components.boatleak.isdynamic = true
        leak.components.boatleak:SetBoat(inst)
        leak.components.boatleak:SetState(data.leak_size)

        table.insert(inst.components.hullhealth.leak_indicators_dynamic, leak)

        if inst.components.walkableplatform ~= nil then
            inst.components.walkableplatform:AddEntityToPlatform(leak)
            for k in pairs(inst.components.walkableplatform:GetPlayersOnPlatform()) do
                if k:IsValid() then
                    k:PushEvent("on_standing_on_new_leak")
                end
            end
        end

        if data.playsoundfx then
            inst.SoundEmitter:PlaySoundWithParams("turnoftides/common/together/boat/damage", { intensity = 0.8 })
        end
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

local function EnableBoatItemCollision(inst)
    if not inst.boat_item_collision then
        inst.boat_item_collision = SpawnPrefab("boat_item_collision")
        AddConstrainedPhysicsObj(inst, inst.boat_item_collision)
    end
end

local function DisableBoatItemCollision(inst)
    if inst.boat_item_collision then
        RemoveConstrainedPhysicsObj(inst.boat_item_collision) --also :Remove()s object
        inst.boat_item_collision = nil
    end
end

local function OnPhysicsWake(inst)
    EnableBoatItemCollision(inst)
    inst.components.walkableplatform:StartUpdating()
    inst.components.boatphysics:StartUpdating()
end

local function OnPhysicsSleep(inst)
    DisableBoatItemCollision(inst)
    inst.components.walkableplatform:StopUpdating()
    inst.components.boatphysics:StopUpdating()
end

local function StopBoatPhysics(inst)
    --Boats currently need to not go to sleep because
    --constraints will cause a crash if either the target object or the source object is removed from the physics world
    inst.Physics:SetDontRemoveOnSleep(false)
end

local function StartBoatPhysics(inst)
    inst.Physics:SetDontRemoveOnSleep(true)
end

local function ReturnChildren(inst)
    inst:DoTaskInTime(math.random() * 10, function(inst)
        for k, child in pairs(inst.components.childspawner.childrenoutside) do
            if child.components.homeseeker ~= nil then
                child.components.homeseeker:GoHome()
            end
            child:PushEvent("gohome")
        end
    end)
end


local function DoReleaseAllChildren(inst)
    if math.random() < 0.5 then
        inst.components.childspawner.childname = "mosquito"
    else
        inst.components.childspawner.childname = "frog_poison"
    end

    inst:DoTaskInTime(math.random() * 30, function(inst)
        inst.components.childspawner:ReleaseAllChildren()
    end)
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("lily_pad.png")
    inst.entity:AddNetwork()

    inst:AddTag("ignorewalkableplatforms")

    inst:AddTag("boat")
    inst.sounds = sounds
    inst.walksound = "marsh" --"tallgrass"
    inst.second_walk_sound = "tallgrass"

    inst:ListenForEvent("spawnnewboatleak", OnSpawnNewBoatLeak)
    inst.boat_crackle = "fx_boat_crackle"

    inst.sinkloot = function()
        local ignitefragments = inst.activefires > 0
        local locus_point = inst:GetPosition()
        local num_loot = 3
        for i = 1, num_loot do
            local r = math.sqrt(math.random()) * (TUNING.BOAT.RADIUS - 2) + 1.5
            local t = i * PI2 / num_loot + math.random() * (PI2 / (num_loot * .5))
            SpawnFragment(locus_point, "boards", math.cos(t) * r, 0, math.sin(t) * r, ignitefragments)
        end
    end

    inst.postsinkfn = function()
        local fx_boat_crackle = SpawnPrefab("fx_boat_pop")
        fx_boat_crackle.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, { intensity = 1 })
        inst.SoundEmitter:PlaySoundWithParams(inst.sounds.sink)
    end


    local radius = 4
    local max_health = TUNING.BOAT.HEALTH + 1000

    local phys = inst.entity:AddPhysics()
    phys:SetMass(TUNING.BOAT.MASS * 4)
    phys:SetFriction(10)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.OBSTACLES)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:SetCylinder(radius, 3)

    inst.AnimState:SetBank("lily_pad")
    inst.AnimState:SetBuild("lily_pad")
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst:AddComponent("walkableplatform")
    inst.components.walkableplatform.radius = radius
    inst.components.walkableplatform.player_collision_prefab = "boat_player_collision"

    --    inst:AddComponent("healthsyncer")
    --    inst.components.healthsyncer.max_health = max_health

    inst:AddComponent("waterphysics")
    inst.components.waterphysics.restitution = 0.75

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ispassableatallpoints = true
    inst.on_start_steering = on_start_steering
    inst.on_stop_steering = on_stop_steering

    inst.doplatformcamerazoom = net_bool(inst.GUID, "doplatformcamerazoom", "doplatformcamerazoomdirty")


    if not TheNet:IsDedicated() then
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

    inst.Physics:SetDontRemoveOnSleep(true)
    EnableBoatItemCollision(inst)

    inst.entity:AddPhysicsWaker() --server only component
    inst.PhysicsWaker:SetTimeBetweenWakeTests(TUNING.BOAT.WAKE_TEST_TIME)

    inst:AddComponent("hull")
    inst.components.hull:SetRadius(radius)
    --    inst.components.hull:SetBoatLip(SpawnPrefab('boatlip'))
    inst:AddComponent("boatring")

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(150)
    inst.components.childspawner:SetSpawnPeriod(TUNING.COOKIECUTTER_SPAWNER.RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()
    inst.components.childspawner.spawnradius = { min = 0, max = 0 }
    inst.components.childspawner.childname = "frog_poison"
    inst.components.childspawner.wateronly = true
    inst.components.childspawner:StartSpawning()

    --    local walking_plank = SpawnPrefab("walkingplank")
    --    local edge_offset = -0.05
    --    inst.components.hull:AttachEntityToBoat(walking_plank, 0, radius + edge_offset, true)
    --    inst.components.hull:SetPlank(walking_plank)

    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = MATERIALS.WOOD
    inst.components.repairable.onrepaired = OnRepaired

    --    inst:AddComponent("hullhealth")
    inst:AddComponent("boatphysics")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(-1)
    inst.components.health.nofadeout = true

    inst.activefires = 0

    inst:SetStateGraph("SGlilypad")

    inst.StopBoatPhysics = StopBoatPhysics
    inst.StartBoatPhysics = StartBoatPhysics

    inst.OnPhysicsWake = OnPhysicsWake
    inst.OnPhysicsSleep = OnPhysicsSleep

    inst:WatchWorldState("startday", DoReleaseAllChildren)
    inst:WatchWorldState("stopday", ReturnChildren)

    inst:DoTaskInTime(0, groundtest)

    inst.speed = speed

    inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("lilypad", fn, assets, prefabs)
