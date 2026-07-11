local assets =
{
    Asset("ANIM", "anim/swap_quackeringram.zip"),
}

local prefabs =
{
    "quackering_wave"
}

local function onfinished(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()

    if boat then
        boat.AnimState:ClearOverrideSymbol("swap_lantern")
        if boat.wakeTask then
            boat.wakeTask:Cancel()
            boat.wakeTask = nil
        end
    end

    if inst.windFX then
        inst.windFX:Remove()
    end

    inst:Remove()
end

local function spawnWake(boat)
    local wake = SpawnPrefab("quackering_wake")
    wake.entity:AddFollower()
    if boat and boat.wakeLeft == true then
        wake.idleanimation = "idle"
        boat.wakeLeft = false
    else
        wake.idleanimation = "idle_2"
        boat.wakeLeft = true
    end
    if wake.Follower then
        wake.Follower:FollowSymbol(boat.GUID, "torso", 0, 0, 0)
    end
    wake.Transform:SetRotation(boat.Transform:GetRotation())
    boat.wakeTask = boat:DoTaskInTime(5 * FRAMES, function(boat) spawnWake(boat) end)
end

local function performRamFX(inst, target)
    for i = 1, 5 do
        local fx = SpawnPrefab("boat_hit_fx_quackeringram")
        local dx = math.random(-3, 3)
        local dz = math.random(-3, 3)
        local x, y, z = target.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x + dx, y, z + dz)
    end

    local boat = inst.components.shipwreckedboatparts:GetBoat()
    local driver = inst.components.shipwreckedboatparts:GetDriver()
    if boat then
        local currentSpeed = driver.Physics:GetMotorSpeed()
        local boost = 25

        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quackering_ram/impact")
        driver.Physics:SetMotorVel(currentSpeed + boost, 0, 0)
        boat.wakeLeft = true
        spawnWake(boat)
        boat:DoTaskInTime(40 * FRAMES, function()
            if boat and boat.wakeTask then
                boat.wakeTask:Cancel()
                boat.wakeTask = nil
            end
        end)
    end
end

local function onPotentialRamHit(inst, target)
    local hitTarget = false
    if target.components.combat then
        hitTarget = true
        local driver = inst.components.shipwreckedboatparts:GetDriver()
        if driver then
            target.components.combat:GetAttacked(driver, 100, inst)
        end
    elseif target.components.workable then
        hitTarget = true
        target.components.workable:Destroy(inst)
    end
    if hitTarget then
        -- show fx
        performRamFX(inst, target)
        -- use up a charge
        inst.components.finiteuses:Use()
        -- cooldown, avoid double hits
        inst.cooldown = 0.5
    end
end

local function GetBoatFacing(inst)
    local driver = inst.components.shipwreckedboatparts:GetDriver()
    return driver and driver.AnimState:GetCurrentFacing() or 0 --GetCurrentFacing好像不是很准
end

local function GetBoatVelocity(inst)
    local driver = inst.components.shipwreckedboatparts:GetDriver()
    return driver and Vector3(driver.Physics:GetVelocity()) or Vector3(0, 0, 0)
end

local function updateWindFX(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()
    local sortOrder = -1
    if boat ~= nil then
        local facing = GetBoatFacing(inst)
        inst.windFX:ChangeDirection(facing)

        -- when facing up, let the wind effect be behind the boat
        if facing == 1 then
            sortOrder = 3
        end
    end

    inst.windFX.AnimState:SetSortOrder(sortOrder)

    -- keep attached to ram
    local p = inst:GetPosition()
    inst.windFX.Transform:SetPosition(p.x, p.y, p.z)
end


local function OnRammerActive(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if not boat then return end

    local facing = GetBoatFacing(inst)
    inst.windFX:ShowEffect(facing)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quackering_ram/impact")
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quackering_ram/ram_LP", "ram_LP")
end

local function OnRammerDeactivate(inst)
    inst.windFX:HideEffect()
    inst.SoundEmitter:KillSound("ram_LP")
end

local function isInHitCone(inst, boat, item)
    if boat.Physics == nil or item.Physics == nil then
        return false
    end

    local origin = inst:GetPosition()
    local point = item:GetPosition()
    local d = (point - origin):GetNormalized()
    local maxDistance = 1 + boat.Physics:GetRadius() + item.Physics:GetRadius()

    if d:LengthSq() > (maxDistance * maxDistance) then
        return false
    else
        local v = GetBoatVelocity(inst):GetNormalized()
        local dot = v:Dot(d)
        return dot > 0.75
    end
end

local RAMMER_NO_TAGS = { "falling", "FX", "NOCLICK", "DECOR", "INLIMBO", "unramable", "player", "companion", "shipwrecked_boat" }
local function CheckRamHit(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if not boat then return end --不应该

    local x, y, z = boat.Transform:GetWorldPosition()
    local driver = inst.components.shipwreckedboatparts:GetDriver()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, boat.Physics:GetRadius() + 2, nil, RAMMER_NO_TAGS)) do
        if v ~= driver
            and v ~= boat
            and not IsEntityDead(v)
            and (not v.components.inventoryitem or not v.components.inventoryitem:IsHeld())
            and isInHitCone(inst, boat, v)
        then
            onPotentialRamHit(inst, v)
        end
    end
end

local minSpeedSq = 2.5 * 2.5
local function IsActive(inst)
    local driver = inst.components.shipwreckedboatparts:GetDriver()
    if not driver or not driver.Physics then
        return false
    end
    local v = GetBoatVelocity(inst)
    return (v:LengthSq() >= minSpeedSq) and (inst.cooldown <= 0.0)
end

local function Update(inst, dt)
    local isActive = IsActive(inst)

    -- toggle on/off callbacks
    if isActive and not inst.wasActive then
        OnRammerActive(inst)
    elseif not isActive and inst.wasActive then
        OnRammerDeactivate(inst)
    end

    if isActive then
        CheckRamHit(inst)
        updateWindFX(inst)
    end

    inst.cooldown = math.max(0, inst.cooldown - dt)
    inst.wasActive = isActive
end

local function OnEntitySleep(inst)
    inst.components.updatelooper:RemoveOnUpdateFn(Update)
end

local function OnEntityWake(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if boat then
        inst.components.updatelooper:RemoveOnUpdateFn(Update)
        inst.components.updatelooper:AddOnUpdateFn(Update)
    end
end

local function OnBoatEquipped(inst, data)
    local boat = data.owner
    boat.AnimState:OverrideSymbol("swap_lantern", "swap_quackeringram", "swap_quackeringram")

    OnEntityWake(inst)
end

local function OnBoatUnquipped(inst, data)
    local boat = data.owner
    boat.AnimState:ClearOverrideSymbol("swap_lantern")

    OnEntitySleep(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBuild("swap_quackeringram")
    inst.AnimState:SetBank("quackeringram")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("shipwrecked_boat_head")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.cooldown = 0
    inst.wasActive = false

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(25)
    inst.components.finiteuses:SetUses(25)
    inst.components.finiteuses:SetOnFinished(onfinished)

    -- wind fx
    inst.windFX = SpawnPrefab("quackering_wave")
    inst.windFX:HideEffect()

    inst:AddComponent("updatelooper")
    inst:AddComponent("shipwreckedboatparts")

    inst:ListenForEvent("boat_equipped", OnBoatEquipped)
    inst:ListenForEvent("boat_unequipped", OnBoatUnquipped)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

return Prefab("quackeringram", fn, assets, prefabs)
