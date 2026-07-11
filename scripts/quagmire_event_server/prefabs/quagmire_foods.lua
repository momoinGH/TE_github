local cooking = require "gorge_cooking"
local preparedfoods = require "gorge_preparedfoods"

local function GetDescription(inst, viewer)
    if viewer:HasTag("quagmire_foodie") then
        local quagmirecraving = TheWorld.components.quagmire:GetCraving()
        if table.contains(inst.cravings, quagmirecraving) then
            if table.contains(inst.cravings, "snack") and quagmirecraving ~= "snack" then
                return "MATCH_BUT_SNACK"
            end
            return "MATCH"
        end
        return "MISMATCH"
    end
    return nil
end

return {
    master_postinit = function(inst, name, DISH_NAMES, DISH_IDS, LoadKeys, OnDishDirty)
        local dish = cooking.GetDishByRecipe(name)
        local food_data = preparedfoods[name]

        inst.cravings = cooking.GetCravingsByRecipe(name)

        -- 使用 preparedfood_gorge 作为基础动画
        inst.AnimState:SetBank("preparedfood_gorge")
        inst.AnimState:SetBuild("preparedfood_gorge")
        inst.AnimState:PlayAnimation("idle", false)

        -- 用 OverrideSymbol 替换成食物自己的动画
        local overrideSymbol = (food_data and food_data.override_symbol) or name
        inst.AnimState:OverrideSymbol("bread", "preparedfood_gorge", overrideSymbol)

        -- 根据盘子类型隐藏不需要的符号
        if dish == "bowl" then
            inst.AnimState:OverrideSymbol("generic_plate", "preparedfood_gorge", "nothing")
        else
            inst.AnimState:OverrideSymbol("generic_bowl", "preparedfood_gorge", "nothing")
        end

        inst:AddTag("show_spoilage")

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = "quagmire_food"
        inst.components.inspectable.getstatus = GetDescription

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/quagmire_food_inv_images_" .. name .. ".xml"

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(500)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = food_data.health or 0
        inst.components.edible.hungervalue = food_data.hunger or 0
        inst.components.edible.sanityvalue = food_data.sanity or 0
        inst.components.edible.foodtype = food_data.foodtype or FOODTYPE.GENERIC
        -- inst.components.edible.temperaturedelta = food_data.temperature or 0
        -- inst.components.edible.temperatureduration = food_data.temperatureduration or 0
        -- if food_data.oneat then
        --     inst.components.edible:SetOnEatenFn(food_data.oneat)
        -- end

        inst:AddComponent("quagmire_saltable")
        inst:AddComponent("quagmire_stewable")

        if dish ~= nil then
            inst:AddComponent("quagmire_replatable")
            inst.components.quagmire_replatable.basedish = dish

            inst.basedishid:set(DISH_IDS[dish])

            OnDishDirty(inst)
        end
    end,
}
