local assets =
{
    Asset("ANIM", "anim/bottle_green.zip"),
    Asset("IMAGE", "images/inventoryimages/empty_bottle_green.tex"),
    Asset("ATLAS", "images/inventoryimages/empty_bottle_green.xml")
}

local function TargetCheck(inst, doer, target)
    return target:HasTag("goddess_fountain") or target:HasTag("milkable")
end

local function OnUse(inst, doer, target)
    local extrafilleditem = SpawnPrefab(target:HasTag("goddess_fountain") and "full_bottle_green" or "full_bottle_green_milk")
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem:GetGrandOwner() or nil
    if owner ~= nil then
        local container = owner.components.inventory or owner.components.container
        local item = container:RemoveItem(inst, false) or inst
        item:Remove()
        container:GiveItem(extrafilleditem, nil, owner:GetPosition())
    else
        extrafilleditem.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.components.stackable:Get():Remove()
    end
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("tro_consumable")
    inst.components.tro_consumable.targetCheckFn = TargetCheck
    inst.components.tro_consumable.state = "dolongaction"
    inst.components.tro_consumable.str = "FILL"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.tro_consumable.onUseFn = OnUse

    inst:AddTag("glassbottle")

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/empty_bottle_green.xml"

    inst:AddComponent("stackable")

    return inst
end

return Prefab("empty_bottle_green", fn, assets)
