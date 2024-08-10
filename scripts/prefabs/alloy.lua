local assets =
{
    Asset("ANIM", "anim/alloy.zip"),
    Asset("ANIM", "anim/alloygold.zip"),
    Asset("ANIM", "anim/alloystone.zip"),
}

--common to all gold prefabs below
local function shine(inst)
    inst.shinetask = nil
    if not inst.AnimState:IsCurrentAnimation("sparkle") then
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:PushAnimation("idle", false)
    end
    if not inst:IsAsleep() then
        inst.shinetask = inst:DoTaskInTime(4 + math.random() * 5, shine)
    end
end

--common to all gold prefabs below
local function OnEntityWake(inst)
    if inst.shinetask == nil then
        inst.shinetask = inst:DoTaskInTime(4 + math.random() * 5, shine)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.pickupsound = "metal"

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("alloy")
    inst.AnimState:SetBuild("alloy")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("molebait")
    inst:AddTag("scarerbait")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 2

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"

    inst:AddComponent("bait")

    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.LIVINGARTIFACT
    inst.components.fuel.fuelvalue = 20

    shine(inst)
    inst.OnEntityWake = OnEntityWake

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("alloy")
    inst.AnimState:SetBuild("alloygold")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 2

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

    inst:AddComponent("bait")

    inst:AddTag("molebait")
    inst:AddTag("scarerbait")

    shine(inst)
    inst.OnEntityWake = OnEntityWake

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("alloy")
    inst.AnimState:SetBuild("alloystone")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 2

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

    inst:AddComponent("bait")

    inst:AddTag("molebait")
    inst:AddTag("scarerbait")

    shine(inst)
    inst.OnEntityWake = OnEntityWake

    return inst
end

return Prefab("alloy", fn, assets),
    Prefab("goldenbar", fn2, assets),
    Prefab("stonebar", fn3, assets)
