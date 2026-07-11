local assets =
{
    Asset("ANIM", "anim/flotsam_armoured_build.zip"),
    Asset("ANIM", "anim/flotsam_cargo_build.zip"),
    Asset("ANIM", "anim/flotsam_bamboo_build.zip"),
    Asset("ANIM", "anim/flotsam_debris_sw.zip"),
    Asset("ANIM", "anim/flotsam_lograft_build.zip"),
    Asset("ANIM", "anim/flotsam_rowboat_build.zip"),
    Asset("ANIM", "anim/flotsam_surfboard_build.zip"),
}

local prefabs =
{

}

local function onhammered(inst)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function MakeFlotsamDebris(name, build, loots)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        MakeObstaclePhysics(inst, 0.3)

        inst.AnimState:SetBank("flotsam_debris_sw")
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle", true)

        if not TheNet:IsDedicated() then
            local ondas = SpawnPrefab("float_fx_front")
            inst:AddChild(ondas)
            ondas.AnimState:PlayAnimation("idle_front_small", true)
            ondas.Transform:SetScale(0.8, 0.8, 0.8)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        MakeLargeBurnable(inst)
        MakeLargePropagator(inst)

        inst:AddComponent("hauntable")

        inst:AddComponent("inspectable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onhammered)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loots)

        return inst
    end
    return Prefab(name, fn, assets, prefabs)
end

-- 残骸
return MakeFlotsamDebris("flotsam_armoured_build", "flotsam_armoured_build", { "boards" }),
    MakeFlotsamDebris("flotsam_cargo_build", "flotsam_cargo_build", { "boards" }),
    MakeFlotsamDebris("flotsam_bamboo_build", "flotsam_bamboo_build", { "bamboo" }),
    MakeFlotsamDebris("flotsam_lograft_build", "flotsam_lograft_build", { "log" }),
    MakeFlotsamDebris("flotsam_rowboat_build", "flotsam_rowboat_build", { "boards" }),
    MakeFlotsamDebris("flotsam_surfboard_build", "flotsam_surfboard_build", { "log" }),
    MakeFlotsamDebris("flotsam_encrusted_build", "flotsam_cargo_build", { "limestone" })
