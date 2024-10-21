local assets =
{
    Asset("ANIM", "anim/goddess_statue.zip"),
}

local function ondeploy(inst, pt)
    local goddess_figure = SpawnPrefab("goddess_statue")
    if goddess_figure then
        goddess_figure.Transform:SetPosition(pt.x, pt.y, pt.z)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    local s = 0.5
    inst.Transform:SetScale(s, s, s)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("goddess_statue")
    inst.AnimState:SetBuild("goddess_statue")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_figure", fn, assets),
    MakePlacer("goddess_figure_placer", "goddess_statue", "goddess_statue", "idle")
