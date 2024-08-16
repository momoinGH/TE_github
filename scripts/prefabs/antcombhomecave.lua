local GetPrefab = require("tropical_utils/getprefab")

local assets =
{
    Asset("ANIM", "anim/ant_house.zip"),
    Asset("SOUND", "sound/pig.fsb"),
    Asset("MINIMAP_IMAGE", "ant_house"),
}

local prefabs =
{
    "antman",
    "antlarva",
}

local loot = { "honey", "honey", "honey", "honeycomb" }

local function onhammered(inst, worker)
    inst.components.childspawner:ReleaseAllChildren(worker)
    inst.components.lootdropper:DropLoot()

    -- 生成几个虫卵
    for i = 1, math.random(1, 2) do
        GetPrefab.ReleaseChild(SpawnPrefab("antlarva"), inst)
    end

    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")

    inst.components.childspawner:ReleaseAllChildren(worker)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onaddchild(inst, count)
    if inst.components.childspawner.childreninside == inst.components.childspawner.maxchildren then
        inst.AnimState:PlayAnimation("hit", true)
        inst.SoundEmitter:PlaySound("dontstarve/cave/bat_cave_warning", "full")
    end
end

local function onspawnchild(inst, child)
    inst.AnimState:PlayAnimation("idle", true)
    inst.SoundEmitter:KillSound("full")
    inst.SoundEmitter:PlaySound("dontstarve/cave/bat_cave_bat_spawn")
end

-- 不会一下子全部出来
local function onnear(inst)
    if inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        local tries = 10
        while inst.components.childspawner:CanSpawn() and tries > 0 do
            inst.components.childspawner:SpawnChild()
            tries = tries - 1
        end
        inst.SoundEmitter:PlaySound("dontstarve/cave/bat_cave_explosion")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/taunt")
    end
end

local function common(childname)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("ant_house.png")

    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
    inst.Light:SetColour(185 / 255, 185 / 255, 20 / 255)
    inst.lightson = true

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("ant_house")
    inst.AnimState:SetBuild("ant_house")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(TUNING.BATCAVE_REGEN_PERIOD)
    inst.components.childspawner:SetSpawnPeriod(TUNING.BATCAVE_SPAWN_PERIOD)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner.childname = childname
    inst.components.childspawner:SetOnAddChildFn(onaddchild)
    inst.components.childspawner:SetSpawnedFn(onspawnchild)
    inst.components.childspawner.childreninside = 0 -- initialize with no children
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner:StartRegen()

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetDist(6, 40)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst, .01)
    MakeLargePropagator(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function fn1()
    return common("antman2")
end

local function fn2()
    return common("antman_warrior")
end

return Prefab("antcombhomecave", fn1, assets, prefabs),
    Prefab("antcombhomecavewarrior", fn2, assets, prefabs),
    MakePlacer("antcombhomecave_placer", "ant_house", "ant_house", "idle")
