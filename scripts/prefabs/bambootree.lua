local assets =
{
    Asset("ANIM", "anim/bamboo.zip"),
    Asset("ANIM", "anim/bambootree.zip"),
    Asset("ANIM", "anim/bambootree_build.zip"),
}

local prefabs =
{
    "bamboo",
    "dug_bambootree",
}
local respawndays = 2 --tempo para renascer em dias

local function OnPicked(inst, is_load, loot_count)
    if is_load then
        inst.AnimState:PlayAnimation("picked")
    else
        inst.AnimState:PlayAnimation("picking")
        inst.AnimState:PushAnimation("picked")
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_drop")
        for i = 1, loot_count or inst.loot_count do
            inst.components.lootdropper:SpawnLootPrefab("bamboo")
        end
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if not TheWorld.Map:IsOceanAtPoint(x, y, z, true) then
        RemovePhysicsColliders(inst) --陆地上的可以通行，水里的不行
    end

    inst.components.hackable:SetWorkLeft(0)
    inst.components.shearable:SetWorkLeft(0)
    inst:RemoveTag("machetecut")
end

local function OnWork(inst, data)
    if data.workleft <= 0 then
        local loot_count = inst.loot_count + (data.is_shear and 1 or 0) --剪刀就多一个掉落物
        OnPicked(inst, false, loot_count)
    else
        local fx = SpawnPrefab("hacking_bamboo_fx")
        local x, y, z = inst.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x, y + math.random() * 2, z)
        inst.AnimState:PlayAnimation("chop")
        inst.AnimState:PushAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_hack")
    end
end

local function OnDig(inst, worker)
    if inst:HasTag("machetecut") then
        for i = 1, inst.loot_count do
            inst.components.lootdropper:SpawnLootPrefab("bamboo")
        end
    end
    inst.components.lootdropper:SpawnLootPrefab("dug_bambootree")
    inst:Remove()
end

local function OnRespawn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
    inst:AddTag("machetecut")
    inst.components.hackable:SetWorkLeft(inst.is_double and 9 or 6)
    inst.components.shearable:SetWorkLeft(1)
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

-- 种下去时
local function OnDeploy(inst)
    inst.components.timer:StartTimer("spawndelay", 60 * 8 * 2)
    OnPicked(inst, true, 0)
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

local function MakeBamboo(name, data, common_post, master_post)
    data = data or {}
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon("bambootree.png")

        inst.AnimState:SetRayTestOnBB(true)
        inst.AnimState:SetBank("bambootree")
        inst.AnimState:SetBuild("bambootree_build")
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * 2)

        -- MakeObstaclePhysics(inst, .35)
        --  inst:SetPhysicsRadiusOverride(1.8)
        MakeWaterObstaclePhysics(inst, 0.35, 2, 1.25)

        if data.is_double then
            inst.Transform:SetScale(1, 1.5, 1)
        end

        inst:AddTag("machetecut")
        inst:AddTag("bambootree")
        inst:AddTag("plant")
        inst:AddTag("ignorewalkableplatforms")

        MakeInventoryFloatable(inst, "med", 0, { 1.1, 0.9, 1.1 })
        inst.components.floater.bob_percent = 0

        local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0
        inst:DoTaskInTime(land_time, function(inst)
            inst.components.floater:OnLandedServer()
        end)

        if common_post then
            common_post(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.loot_count = data.is_double and 2 or 1

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")

        MakeHackablePlant(
            inst,
            data.is_double and 9 or 6, 1, 1, TUNING.TOTAL_DAY_TIME * respawndays,
            OnWork, OnDig, OnRespawn
        )

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableIgnite(inst)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
        inst.OnDeploy = OnDeploy

        if master_post then
            master_post(inst)
        end

        inst:ListenForEvent("on_collide", OnCollide)

        return inst
    end
    return Prefab(name, fn, assets, prefabs)
end

return MakeBamboo("bambootree"),
    MakeBamboo("bambootreebig", { is_double = true })
