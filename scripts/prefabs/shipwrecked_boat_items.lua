local assets =
{
    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_surfboard_build.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
    Asset("ANIM", "anim/surfboard.zip"),
    Asset("ANIM", "anim/corkboat.zip"),
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_build.zip"),
    Asset("ANIM", "anim/raft_build.zip"),
    Asset("ANIM", "anim/rowboat_cargo_build.zip"),
    Asset("ANIM", "anim/rowboat_armored_build.zip"),
    Asset("ANIM", "anim/rowboat_encrusted_build.zip"),
    Asset("ANIM", "anim/raft_log_build.zip"),
    Asset("ANIM", "anim/pirate_boat_build.zip"),
    Asset("ANIM", "anim/coracle_boat_build.zip"),
    Asset("ANIM", "anim/seafarer_boatsw.zip"),
    Asset("ANIM", "anim/waxwell_shadowboat_build.zip"),
}

local prefabs =
{

}

local function ondeploycorkboat(inst, pt, deployer)
    local boat = SpawnPrefab(inst.boat)
    if boat ~= nil then
        boat.Physics:SetCollides(false)
        boat.Physics:Teleport(pt.x, 0, pt.z)
        boat.Physics:SetCollides(true)
        if inst.components.finiteuses and boat.components.finiteuses then
            boat.components.finiteuses.current = inst.components.finiteuses.current
        end

        inst:Remove()
    end
end

local function ondeploywoodlegsboat(inst, pt, deployer)
    local boat = SpawnPrefab(inst.boat)
    if boat ~= nil then
        local velaw = SpawnPrefab("woodlegssail")
        local canhao = SpawnPrefab("boatcannon")
        boat.components.container:GiveItem(velaw, 1)
        boat.components.container:GiveItem(canhao, 2)
        boat.Physics:SetCollides(false)
        boat.Physics:Teleport(pt.x, 0, pt.z)
        boat.Physics:SetCollides(true)

        inst:Remove()
    end
end

local function DefaultOnDeploy(inst, pt, deployer)
    local boat = SpawnPrefab(inst.boat)
    if boat ~= nil then
        boat.Physics:SetCollides(false)
        boat.Physics:Teleport(pt.x, 0, pt.z)
        boat.Physics:SetCollides(true)
        inst:Remove()
    end
end

local function MakeBoatItem(name, data, common_post_fn, master_post_fn)
    data = data or {}
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank(data.bank or "seafarer_boatsw")
        inst.AnimState:SetBuild(data.build or "seafarer_boatsw")
        inst.AnimState:PlayAnimation(data.anim or "idle")

        inst:AddTag("boatbuilder")

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst, "med", 0.25, 0.83)

        inst.boat = data.boat
        inst.overridedeployplacername = data.boat .. "_placer" --placer在小船预制件里定义

        --Deployable needs to be client side because of the custom deploy range
        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = DefaultOnDeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

        if common_post_fn then
            common_post_fn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        MakeLargeBurnable(inst)
        MakeLargePropagator(inst)

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeHauntableLaunch(inst)

        if master_post_fn then
            master_post_fn(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeBoatItem("porto_raft", { anim = "bambo", boat = "raft" }),
    MakeBoatItem("porto_lograft", { anim = "log", boat = "lograft" }),
    MakeBoatItem("porto_rowboat", { anim = "row", boat = "rowboat" }),
    MakeBoatItem("porto_cargoboat", { anim = "cargo", boat = "cargoboat" }),
    MakeBoatItem("porto_armouredboat", { anim = "seashell", boat = "armouredboat" }),
    MakeBoatItem("porto_encrustedboat", { anim = "limestone", boat = "encrustedboat" }),
    MakeBoatItem("surfboard_item", { anim = "idle", boat = "surfboard", bank = "surfboard", build = "surfboard" }),
    MakeBoatItem("porto_woodlegsboat", { anim = "pirate", boat = "woodlegsboat" }, function(inst)
        inst.components.deployable.ondeploy = ondeploywoodlegsboat
    end),
    MakeBoatItem("corkboatitem", {
        anim = "idle", bank = "corkboat", build = "corkboat", boat = "corkboat"
    }, function(inst)
        inst:AddTag("aquatic")
        inst.components.deployable.ondeploy = ondeploycorkboat
    end, function(inst)
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(80)
        inst.components.finiteuses:SetUses(80)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    end),
    MakeBoatItem("porto_shadowboat", { anim = "shadow", boat = "shadowboat" })
