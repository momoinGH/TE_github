-- 让蘑菇农场能种植新东西，来自老版棱镜，感谢梧桐山大佬的无私分享！

table.insert(Assets, Asset("ANIM", "anim/mushroom_farm_cutlichen_build.zip"))
table.insert(Assets, Asset("ANIM", "anim/mushroom_farm_foliage1_build.zip"))
table.insert(Assets, Asset("ANIM", "anim/mushroom_farm_foliage2_build.zip"))
table.insert(Assets, Asset("ANIM", "anim/mushroom_farm_quagmire_mushrooms_build.zip"))
table.insert(Assets, Asset("ANIM", "anim/mushroom_farm_yellow_cap_build.zip"))


local mushroom_farm_seeds = {
    cutlichen = { product = "cutlichen", amount = 4 },
    foliage = { product = "foliage", amount = 6 },
    quagmire_mushrooms = { product = "quagmire_mushrooms", amount = 4 },
    yellow_cap = { product = "yellow_cap", amount = 4 },
}

local function DoMushroomOverrideSymbol(inst, productname)
    local build
    if productname == "foliage" then
        build = TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build"
    else
        build = "mushroom_farm_" .. productname .. "_build"
    end
    inst.AnimState:OverrideSymbol("swap_mushroom", build, "swap_mushroom")
end

-- 对原有函数的小修改，修改贴图和产物
local function StartGrowing(inst, giver, item)
    if inst.components.harvestable ~= nil then
        local grower_skilltreeupdater = giver.components.skilltreeupdater

        local data = mushroom_farm_seeds[item.prefab]
        local max_produce = data.amount
        local productname = data.product

        local grow_time_percent = 1.0

        if grower_skilltreeupdater ~= nil then
            if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
                grow_time_percent = TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
            elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
                grow_time_percent = TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
            end
        end

        local grow_time = grow_time_percent * TUNING.MUSHROOMFARM_FULL_GROW_TIME

        DoMushroomOverrideSymbol(inst, productname)

        inst.components.harvestable:SetProduct(productname, max_produce)
        inst.components.harvestable:SetGrowTime(grow_time / max_produce)
        inst.components.harvestable:Grow()

        TheWorld:PushEvent("itemplanted", { doer = giver, pos = inst:GetPosition() }) --this event is pushed in other places too
    end
end

AddPrefabPostInit("mushroom_farm", function(inst)
    if not TheWorld.ismastersim then return end

    local old_abletoaccepttest = inst.components.trader.abletoaccepttest
    inst.components.trader:SetAbleToAcceptTest(function(inst, item, ...)
        if not old_abletoaccepttest then return true end
        local able, reason = old_abletoaccepttest(inst, item, ...)
        if able then return true end

        if item == nil then return false end
        if inst.remainingharvests == 0 then return false end
        if mushroom_farm_seeds[item.prefab] then return true end --如果是指定的物品
        return able, reason
    end)

    local old_onaccept = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item, ...)
        if not mushroom_farm_seeds[item.prefab] then
            if old_onaccept then
                return old_onaccept(inst, giver, item, ...)
            end
        end
        StartGrowing(inst, giver, item)
    end

    local old_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data)
        old_OnLoad(inst, data)
        if data and not data.burnt and inst.components.harvestable.product then
            DoMushroomOverrideSymbol(inst, inst.components.harvestable.product)
        end
    end
end)
