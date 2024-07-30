local prefabs =
{
    "collapse_small"
}

local assets =
{
    Asset("ANIM", "anim/grotto_bug_lamp.zip"),
}

local loot = { "log", "log", "lightbulb", "honey" }

local function OnWorked(inst, worker, workleft)
    if workleft <= 0 then
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
        inst.components.lootdropper:DropLoot(inst:GetPosition())
        inst:Remove()
    else
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetRadius(2.5)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:Enable(true)

    inst.MiniMapEntity:SetIcon("anthill_cavelamp.png")

    inst.AnimState:SetBank("grotto_bug_lamp")
    inst.AnimState:SetBuild("grotto_bug_lamp")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    ---------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(6)

    inst.components.workable:SetOnWorkCallback(OnWorked)

    return inst
end

return Prefab("anthill/items/anthill_cavelamp", fn, assets, prefabs)
