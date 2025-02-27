local assets =
{
    Asset("ANIM", "anim/bramble_bulb.zip"),
}

local prefabs =
{
    --  "acorn_cooked",
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("bramble_bulb")
    inst.AnimState:SetBuild("bramble_bulb")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("cattoy")
    inst:AddComponent("tradable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst:AddTag("show_spoilage")

    inst:AddComponent("edible")
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.foodtype = "SEEDS"
    inst.components.edible.foodstate = "RAW"

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")
    -- inst.components.inspectable.getstatus = describe

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    --    inst.components.burnable:MakeDragonflyBait(3)

    inst:AddComponent("inventoryitem")


    --    inst.OnSave = OnSave
    --    inst.OnLoad = OnLoad

    return inst
end

return Prefab("bramble_bulb", fn, assets, prefabs)
