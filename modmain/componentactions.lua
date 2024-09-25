local function IsHold(doer, target)
    return target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)
end

local function IsRiding(doer)
    return doer.replica.rider:IsRiding()
end

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if target:HasTag("cost_one_oinc") and target:HasTag("playercrafted") and not target:HasTag("slot_one") then
        -- 物品放入柜中
        table.insert(actions, ACTIONS.GIVE_SHELF)
    end

    if inst.prefab == "tar"
        and (not IsRiding(doer) or IsHold(doer, target))
        and (target:HasTag("seayard") or target:HasTag("tarlamp") or target:HasTag("tarsuit"))
    then
        --焦油添加燃料
        table.insert(actions, ACTIONS.ADDFUEL)
    end
end)

AddComponentAction("SCENE", "shelfer", function(inst, doer, actions, right)
    if inst:HasTag("cost_one_oinc") and inst:HasTag("slot_one") then
        --从柜子中拿取
        table.insert(actions, ACTIONS.TAKE_SHELF)
    end
end)

AddComponentAction("SCENE", "shopped", function(inst, doer, actions, right)
    if inst:HasTag("slot_one") then
        --拿取货架物品
        table.insert(actions, ACTIONS.TAKE_SHELF)
    end
end)

local IRONLORD_WORKS = {
    CHOP = true,
    HAMMER = true,
    MINE = true,
}

AddComponentAction("SCENE", "workable", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") then
        -- 活性机甲
        for k, _ in ipairs(IRONLORD_WORKS) do
            if inst:HasTag(k .. "_workable") then
                table.insert(actions, ACTIONS[k])
            end
        end
    end
end)

AddComponentAction("SCENE", "hackable", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") and inst:HasTag("hackable") then
        -- 活性机甲
        table.insert(actions, ACTIONS.HACK)
    end
end)

-- bugrepellent
AddComponentAction("SCENE", "combat", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") and doer.replica.combat:CanTarget(inst) then
        --活性机甲发射
        table.insert(actions, ACTIONS.TIRO)
    end
end)

AddComponentAction("POINT", "gasser", function(inst, doer, pos, actions, right)
    if right and not doer.replica.rider:IsRiding() then
        --喷洒杀毒剂
        table.insert(actions, ACTIONS.GAS)
    end
end)

AddComponentAction("EQUIPPED", "gasser", function(inst, doer, target, actions, right)
    if right and not doer.replica.rider:IsRiding() then
        --喷洒杀毒剂
        table.insert(actions, ACTIONS.GAS)
    end
end)



AddComponentAction("SCENE", "sappy", function(inst, doer, actions, right)
    if inst:HasTag("sappy") and not inst:HasTag("stump") then
        -- 采集树液
        table.insert(actions, ACTIONS.COLLECTSAP)
    end
end)



AddComponentAction("USEITEM", "snackrificable", function(inst, doer, target, actions)
    if target:HasTag("gorge_altar") then
        table.insert(actions, ACTIONS.SNACKRIFICE)
    end
end
)

AddComponentAction("USEITEM", "installable", function(inst, doer, target, actions)
    if target:HasTag("installations") and not target:HasTag("installations_occupied") then
        table.insert(actions, ACTIONS.INSTALL)
    end
end
)

AddComponentAction("SCENE", "store", function(inst, doer, actions)
    table.insert(actions, ACTIONS.STOREOPEN)
end)


AddComponentAction("SCENE", "pro_portablestructure", function(inst, doer, actions, right)
    if right
        and not inst:HasTag("fire")
        and (not inst.candismantle or inst:candismantle(doer))
    then
        local container = inst.replica.container
        if (container == nil or (container:CanBeOpened() and not container:IsOpenedBy(doer))) then
            -- 收回
            table.insert(actions, ACTIONS.TRO_DISMANTLE)
        end
    end
end)

AddComponentAction("SCENE", "shipwreckedboat", function(inst, doer, actions, right)
    if inst:HasTag("shipwrecked_boat")
        and not inst:HasTag("fire")
        and inst.GetBoatPlayer and not inst:GetBoatPlayer()
    then
        -- 海难小船登船
        table.insert(actions, ACTIONS.BOATMOUNT)
    end
end)

AddComponentAction("SCENE", "inspectable", function(inst, doer, actions, right)
    if doer.components.pro_componentaction:Test("UNARMED", inst:GetPosition(), right) then
        -- 发射船炮
        table.insert(actions, ACTIONS.BOATCANNON)
    end
end)



local function UseTool(inst, doer, target, actions)
    if target:HasTag("INLIMBO") then return end

    if inst:HasTag("shear_tool") and target:HasTag("shearable") then
        -- 剪
        table.insert(actions, ACTIONS.SHEAR)
        return true
    elseif inst:HasTag("hack_tool") and target:HasTag("hackable") then
        --砍伐
        table.insert(actions, ACTIONS.HACK)
        return true
    end

    return false
end

AddComponentAction("USEITEM", "tool", function(inst, doer, target, actions)
    if UseTool(inst, doer, target, actions) then
        return
    end
end)

AddComponentAction("EQUIPPED", "tool", function(inst, doer, target, actions, right)
    if UseTool(inst, doer, target, actions) then
        return
    end
end)
