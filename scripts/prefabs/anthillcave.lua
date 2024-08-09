local ANTMAN_MIN = 3
local ANTMAN_MAX = 4
local ANTMAN_REGEN_TIME = TUNING.SEG_TIME * 2
local ANTMAN_RELEASE_TIME = TUNING.SEG_TIME

local assets =
{
    Asset("ANIM", "anim/grotto_bug_house.zip"),
}

local prefabs =
{
    "antman",
}
local loot =
{
    "rocks", "rocks", "chitin",
}

local function onhammered(inst)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")

    inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("anthillcave.png")

    inst.Transform:SetScale(1, 1, 1)

    MakeObstaclePhysics(inst, 1.3)

    inst.AnimState:SetBank("grotto_bug_house")
    inst.AnimState:SetBuild("grotto_bug_house")
    local names = { "idle1", "idle2", "idle3" }
    inst.AnimState:PlayAnimation(names[math.random(#names)])

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "antman"
    inst.components.childspawner:SetRegenPeriod(ANTMAN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(ANTMAN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(ANTMAN_MIN, ANTMAN_MAX))
    inst.components.childspawner:StartSpawning()

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("anthillcave", fn, assets, prefabs)
