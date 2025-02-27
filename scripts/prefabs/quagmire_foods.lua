local assets =
{
    Asset("ANIM", "anim/preparedfood_gorge.zip"),
}

local prefabs =
{
    "spoiled_food",
}

local function MakePreparedFood(data)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)
        local anim = "preparedfood_gorge"

        inst.AnimState:SetBank("preparedfood_gorge")
        inst.AnimState:SetBuild("preparedfood_gorge")
        inst.AnimState:PlayAnimation("idle", false)
        inst.AnimState:OverrideSymbol("bread", anim, data.oldname or data.name)
        inst.AnimState:OverrideSymbol("generic_plate", anim, "nothing")
        inst.AnimState:OverrideSymbol("generic_bowl", anim, "nothing")
        -- inst.AnimState:SetScale(2,2,2)

        if not data.ingredient then
            inst:AddTag("preparedfood")
        end

        if data.tags then
            for i, v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        inst:AddTag("replatable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        if data.oneat then
            inst.components.edible:SetOnEatenFn(data.oneat)
        end

        inst:AddComponent("inspectable")
        inst.wet_prefix = data.wet_prefix

        inst:AddComponent("inventoryitem")
        -- print(data.name)

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(data.perishtime or TUNING.PERISH_SLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("replatable")
        inst.components.replatable:SetUp(data.name, data.platetype and data.platetype or "plate", "generic")

        inst:AddComponent("snackrificable")
        inst.components.snackrificable:SetUp(
            data.worth or 1,
            data.cravings or { "bread" }
        )

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)
        AddHauntableCustomReaction(inst, function(inst, haunter)
            --#HAUNTFIX
            --if math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE then
            --if inst.components.burnable and not inst.components.burnable:IsBurning() then
            --inst.components.burnable:Ignite()
            --inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            --inst.components.hauntable.cooldown_on_successful_haunt = false
            --return true
            --end
            --end
            return false
        end, true, false, true)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        ------------------------------------------------

        return inst
    end

    local anim = data.anim and data.anim or (data.oldname or data.name)
    return Prefab(data.name, fn, assets, prefabs)
end

local prefs = {}

local foods = require("gorge_foods")
for k, v in pairs(foods) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)
