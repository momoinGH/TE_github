require "prefabs/roe_fish"
local assets =
{
    Asset("ANIM", "anim/roe.zip"),
}

local prefabs =
{

}

local SEEDS_GROW_TIME = 300 * 6

for k, v in pairs(ROE_FISH) do
    if v.createPrefab then
        table.insert(prefabs, k)
    end
end

local function pickproduct(inst)
    local tipo_de_eixe = math.random(1, 13)
    if tipo_de_eixe < 6 then
        return "fish2"
    end

    if tipo_de_eixe == 6 then
        return "fish3"
    end

    if tipo_de_eixe == 7 then
        return "fish3"
    end

    if tipo_de_eixe == 8 then
        return "fish4"
    end

    if tipo_de_eixe == 9 then
        return "fish4"
    end

    if tipo_de_eixe == 10 then
        return "fish5"
    end

    if tipo_de_eixe == 11 then
        return "fish5"
    end

    if tipo_de_eixe == 12 then
        return "coi"
    end

    if tipo_de_eixe == 13 then
        return "salmon"
    end

    return "fish2"
end

local function raw()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    --    MakeInventoryFloatable(inst, "idle_water", "idle")

    inst.AnimState:SetBank("roe")
    inst.AnimState:SetBuild("roe")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("roe")
    inst:AddTag("oceanfishing_lure")
    inst:AddTag("spawnnosharx")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 2

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "roe_cooked"

    inst:AddComponent("bait")
    inst:AddComponent("seedable")
    inst.components.seedable.growtime = SEEDS_GROW_TIME
    inst.components.seedable.product = pickproduct

    inst:AddComponent("oceanfishingtackle")
    inst.components.oceanfishingtackle:SetupLure({ build = "oceanfishing_lure_mis", symbol = "hook_seeds", single_use = true, lure_data = { charm = 0.3, reel_charm = -0.3, radius = 3.0, style = "rot", timeofday = { day = 1, dusk = 1, night = 1 }, dist_max = 2 } })

    return inst
end

local function cooked()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    --    MakeInventoryFloatable(inst, "cooked_water", "cooked")



    inst.AnimState:SetBank("roe")
    inst.AnimState:SetBuild("roe")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:PlayAnimation("cooked")

    inst:AddTag("spawnnosharx")
    inst:AddTag("oceanfishing_lure")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 0
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 2

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)

    inst:AddComponent("oceanfishingtackle")
    inst.components.oceanfishingtackle:SetupLure({ build = "oceanfishing_lure_mis", symbol = "hook_seeds", single_use = true, lure_data = { charm = 0.3, reel_charm = -0.3, radius = 3.0, style = "rot", timeofday = { day = 1, dusk = 1, night = 1 }, dist_max = 2 } })


    return inst
end

return Prefab("roe", raw, assets, prefabs),
    Prefab("roe_cooked", cooked, assets, prefabs)
