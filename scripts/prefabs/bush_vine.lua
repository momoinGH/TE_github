local assets =
{
    Asset("ANIM", "anim/bush_vine.zip"),
}

local prefabs =
{
    "vine",
    "dug_bush_vine",
    "hacking_fx",
}

local respawndays = 2 --tempo para renascer em dias

local function OnPicked(inst, is_load, loot_count)
    if is_load then
        inst.AnimState:PlayAnimation("hacked_idle")
    else
        loot_count = loot_count or 1
        for i = 1, loot_count do
            inst.components.lootdropper:SpawnLootPrefab("vine")
        end
        inst.AnimState:PlayAnimation("disappear")
        inst.AnimState:PushAnimation("hacked_idle")
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_drop")
    end
    inst:RemoveTag("machetecut")
    local x, y, z = inst.Transform:GetWorldPosition()
    if not TheWorld.Map:IsOceanAtPoint(x, y, z, true) then
        RemovePhysicsColliders(inst) --陆地上的可以通行，水里的不行
    end
    inst.components.hackable:SetWorkLeft(0)
    inst.components.shearable:SetWorkLeft(0)
end

local function OnWork(inst, data)
    local fx = SpawnPrefab("hacking_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random() * 2, z)

    if data.workleft <= 0 then
        local loot_count = data.is_shear and 2 or 1 --剪刀就多一个掉落物
        OnPicked(inst, false, loot_count)
    else
        inst.AnimState:PlayAnimation("chop")
        inst.AnimState:PushAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
    end
end

local function OnDig(inst)
    if inst:HasTag("machetecut") then
        inst.components.lootdropper:SpawnLootPrefab("vine")
    end
    inst.components.lootdropper:SpawnLootPrefab("dug_bush_vine")
    inst:Remove()
end

local function OnRespawn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
    inst:AddTag("machetecut")
    inst.components.workable:SetWorkLeft(6)
    inst.components.workable:SetWorkAction(ACTIONS.HACK)
    MakeWaterObstaclePhysics(inst, 0.35, 2, 1.25)
end

local function OnSave(inst, data)
    if not inst:HasTag("machetecut") then
        data.tag = 1
    end
end

local function OnLoad(inst, data)
    if data and data.tag == 1 then
        OnPicked(inst, true)
    end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE /
            boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("bushVine.png")

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("bush_vine")
    inst.AnimState:SetBuild("bush_vine")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetTime(math.random() * 2)

    -- MakeSmallObstaclePhysics(inst, .1)
    -- inst:SetPhysicsRadiusOverride(1.8)
    MakeWaterObstaclePhysics(inst, 0.35, 2, 1.25)

    MakeInventoryFloatable(inst, "med", 0, { 1.1, 0.6, 1.1 })
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst:AddTag("machetecut")
    inst:AddTag("plant")
    inst:AddTag("bush_vine")
    inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    MakeHackablePlant(
        inst,
        6, 1, 1, respawndays * TUNING.TOTAL_DAY_TIME,
        OnWork, OnDig, OnRespawn
    )
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("on_collide", OnCollide)

    return inst
end

return Prefab("bush_vine", fn, assets, prefabs)
