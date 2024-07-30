local assets =
{
    Asset("ANIM", "anim/pollen.zip"),
}

local prefabs =
{
    "pollen_cooked",
}
--[[
local function oneaten(inst, eater)
    if eater.components.poisonable then
	eater.components.poisonable:SetPoison(-2, 3, 60)
    end
end
]]

local function TransformToRoyalJelly(inst, antchest)
    if inst.components.inventoryitem and inst.components.inventoryitem.owner == antchest then
        antchest.components.container:RemoveItem(inst)
        local numpollens = 1
        if inst.components.stackable and inst.components.stackable:IsStack() and inst.components.stackable:StackSize() >
            1 then
            numpollens = inst.components.stackable:StackSize() + 1
        end
        print("POLLEN", numpollens)
        inst:Remove()
        for index = 1, numpollens do
            local honey = SpawnPrefab("Royal_Jelly")
            local position = Vector3(antchest.Transform:GetWorldPosition())
            honey.Transform:SetPosition(position.x, position.y, position.z)
            antchest.components.container:GiveItem(honey, nil, inst:GetPosition())
        end
    end
end

local function OnPutInInventory(inst, owner)
    if owner.prefab == "antchest" or owner.prefab == "honeychest" then
        inst:DoTaskInTime(144, function() TransformToRoyalJelly(inst, owner) end)
    end
end

local function OnRemoved(inst, owner)
    inst.components.perishable:StartPerishing()
end

local function commonfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pollen")
    inst.AnimState:SetBuild("pollen")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)


    inst:AddTag("pollen")
    --inst:AddTag("poisonous")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    --inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 0

    --inst:AddComponent("appeasement")
    --inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_SMALL

    return inst
end

local function defaultfn()
    local inst = commonfn()
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    --inst:AddTag("poisonous")

    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL

    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"


    inst:AddComponent("cookable")
    inst.components.cookable.product = "pollen_cooked"

    return inst
end

local function cookedfn()
    local inst = commonfn("cooked")

    if not TheWorld.ismastersim then
        return inst
    end
    --inst:AddTag("poisonous")

    inst.AnimState:PlayAnimation("cooked")
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)

    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"


    return inst
end

return
    Prefab("pollen_item", defaultfn, assets, prefabs),
    Prefab("pollen_cooked", cookedfn, assets)
