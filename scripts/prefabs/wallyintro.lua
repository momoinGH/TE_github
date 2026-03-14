local assets =
{
    Asset("ANIM", "anim/parrot_pirate_intro.zip"),
    Asset("ANIM", "anim/parrot_pirate.zip"),
}
local function onhammered(inst)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function MakeDebris(name, data)
    assert(data.anim)

    local function fn()
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, 0.1)
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        inst.AnimState:SetBank("parrot_pirate_intro")
        inst.AnimState:SetBuild("parrot_pirate_intro")
        inst.AnimState:PlayAnimation(data.anim)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(onhammered)

        inst:AddComponent("lootdropper")
        if data.loot then
            inst.components.lootdropper:SetLoot(data.loot)
        end

        inst:AddComponent("inspectable")

        return inst
    end
    return Prefab(name, fn, assets)
end

return MakeDebris("debris_1", { anim = "debris_1", loot = { "boards" } }),
    MakeDebris("debris_2", { anim = "debris_2", loot = { "log", "log", "log" } }),
    MakeDebris("debris_3", { anim = "debris_3", loot = { "boards", "boatrepairkit" } }),
    MakeDebris("debris_4", { anim = "debris_4", loot = { "log", "log", "log", "boatrepairkit" } })
