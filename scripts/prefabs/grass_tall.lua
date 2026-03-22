local assets =
{
    Asset("ANIM", "anim/grass_tall.zip"),
    Asset("SOUND", "sound/common.fsb"),
    Asset("MINIMAP_IMAGE", "grass"),
}

local prefabs =
{
    "weevole",
    "cutgrass",
    "dug_grass",
    "hacking_tall_grass_fx",
}

local WEEVOLEDEN_MAX_WEEVOLES = 3

local function spawnweevole(inst, target)
    local weevole = inst.components.childspawner:SpawnChild()
    if weevole then
        local spawnpos = inst:GetPosition()
        spawnpos = spawnpos + TheCamera:GetDownVec()
        weevole.Transform:SetPosition(spawnpos:Get())
        if weevole and target and weevole.components.combat then
            weevole.components.combat:SetTarget(target)
        end
    end
end

local function startspawning(inst)
    if inst.components.childspawner and inst.components.workable and inst.components.workable.workable == true then
        local frozen = (inst.components.freezable and inst.components.freezable:IsFrozen())
        if not frozen and not TheWorld.state.isday then
            inst.components.childspawner:StartSpawning()
        end
    end
end

local function stopspawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
    end
end

local function removeweevoleden(inst)
    inst:RemoveTag("weevole_infested")
    inst:StopWatchingWorldState("isday", stopspawning)
    inst:StopWatchingWorldState("isdusk", startspawning)
end

local function makeweevoleden(inst)
    inst:AddTag("weevole_infested")
    inst:WatchWorldState("isday", stopspawning)
    inst:WatchWorldState("isdusk", startspawning)
end


local function onsave(inst, data)
    data.weevole_infested = inst:HasTag("weevole_infested") --染病
end

local function onload(inst, data)
    if not data then return end

    if data.weevole_infested then
        makeweevoleden(inst)
    end
end

local function onspawnweevole(inst)
    if inst:IsValid() then
        if inst.components.workable and inst.components.workable.workable == true then
            inst.AnimState:PlayAnimation("rustle", false)
            inst.AnimState:PushAnimation("idle", true)
        end
    end
end

local function weevolenesttest(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 12, { "grass_tall" })
    local weevoleents = TheSim:FindEntities(pt.x, pt.y, pt.z, 12, { "weevole_infested" })

    if #weevoleents < 1 and math.random() < #ents / 100 then
        local ent = ents[math.random(#ents)]
        makeweevoleden(ent)
    end
end

local function OnDig(inst)
    if inst.components.pickable.canbepicked then
        TroSpawnDropItem(inst, "cutgrass")
    end
    TroSpawnDropItem(inst, "dug_grass")
    inst:Remove()
end

local function OnNear(inst)
    if inst.components.workable and inst.components.workable.workleft > 1 then
        inst.AnimState:PlayAnimation("rustle")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function OnShearFinished(inst, data)
    inst.components.pickable:Pick(data.worker)
end

local function OnHacked(inst, data)
    local fx = SpawnPrefab("hacking_tall_grass_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random() * 2, z)
    if data.workleft <= 0 then
        inst.components.pickable:Pick(data.worker)
    else
        inst.AnimState:PushAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/grabbing_vine/drop")
    end
end

local function OnPicked(inst, picker)
    inst.AnimState:PlayAnimation("fall")
    inst.AnimState:PushAnimation("picked", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/grabbing_vine/drop")

    inst.components.hackable:SetWorkLeft(0)
    inst.components.shearable:SetWorkLeft(0)

    if inst:HasTag("weevole_infested") then
        spawnweevole(inst, picker)
    end
end

local function MakeEmpty(inst)
    inst.AnimState:PlayAnimation("picked")
    inst.components.hackable:SetWorkLeft(0)
    inst.components.shearable:SetWorkLeft(0)
end

local function OnRegen(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
    weevolenesttest(inst)
end

local function MakeFull(inst)
    inst.components.hackable:SetWorkLeft(2.5)
    inst.components.shearable:SetWorkLeft(1)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("grass_tall.png")

    inst.AnimState:SetBank("grass_tall")
    inst.AnimState:SetBuild("grass_tall")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetTime(math.random() * 2)
    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddTag("gustable")
    inst:AddTag("grass_tall")
    inst:AddTag("plant")
    inst:AddTag("grasstall")
    inst:AddTag("ignorewalkableplatforms")

    MakeInventoryFloatable(inst, "med", 0, { 1.1, 0.9, 1.1 })
    inst.components.floater.bob_percent = 0
    local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(OnNear)
    inst.components.playerprox:SetDist(0.75, 1)

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(OnDig)
    inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("shearable")
    inst.components.shearable:SetWorkLeft(1)
    inst:ListenForEvent("onshearfinished", OnShearFinished)

    inst:AddComponent("hackable")
    inst.components.hackable:SetWorkLeft(2.5)
    inst:ListenForEvent("onhacked", OnHacked)

    inst:AddComponent("pickable")
    inst.components.pickable:SetUp("cutgrass", 2)
    inst.components.pickable:SetOnPickedFn(OnPicked)
    inst.components.pickable:SetOnRegenFn(OnRegen)
    inst.components.pickable.caninteractwith = false --不能直接采集，得用工具
    inst.components.pickable.makefullfn = MakeFull
    inst.components.pickable:SetMakeEmptyFn(MakeEmpty)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    ---------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "weevole"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetSpawnedFn(onspawnweevole)
    inst.components.childspawner:SetMaxChildren(WEEVOLEDEN_MAX_WEEVOLES)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("grass_tall", fn, assets, prefabs)
