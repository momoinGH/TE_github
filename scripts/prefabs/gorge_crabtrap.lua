local assets =
{
    Asset("ANIM", "anim/quagmire_crab_trap.zip"),
    Asset("SCRIPT", "scripts/prefabs/wortox_soul_common.lua"),
}

local prefabs =
{
    -- everything it can "produce" and might need symbol swaps from
    "crab",
    "quagmire_pebblecrab",
    "quagmire_crabmeat",

    --"canary",
    --"bird_mutant",
    --"bird_mutant_spitter",
}

local sounds =
{
    close = "dontstarve/common/trap_close",
    rustle = "dontstarve/common/trap_rustle",
}

local function onharvested(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function on_float(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function on_not_float(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function on_usedup(inst)
    -- NOTES(JBK): There is a case where traps can reach here while in a container and cause issues later. This is a temporary fix until the source of that is found.
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:RemoveFromOwner()
    end
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("rabbittrap.png")

    inst.AnimState:SetBank("quagmire_crab_trap")
    inst.AnimState:SetBuild("quagmire_crab_trap")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("trap")

    MakeInventoryFloatable(inst, "med", 0.05, { 0.8, 0.5, 0.8 })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages2.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.TRAP_USES)
    inst.components.finiteuses:SetUses(TUNING.TRAP_USES)
    inst.components.finiteuses:SetOnFinished(on_usedup)

    inst:AddComponent("trap")
    inst.components.trap.targettag = "canbetrapped"
    inst.components.trap:SetOnHarvestFn(onharvested)
    inst.components.trap.baitsortorder = 1

    inst:ListenForEvent("floater_startfloating", on_float)
    inst:ListenForEvent("floater_stopfloating", on_not_float)

    MakeHauntableLaunch(inst)

    inst:SetStateGraph("SGtrap")

    return inst
end

return Prefab("quagmire_crabtrap", fn, assets)
