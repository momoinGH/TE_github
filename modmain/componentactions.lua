local function CheckConsumable(inst, doer, target, actions)
    local com = inst.components.tropical_consumable
    if com
        and inst:HasTag("tropical_consumable")
        and (not com.userCheckFn or com.userCheckFn(inst, doer, target))
        and (not com.targetCheckFn or com.targetCheckFn(inst, doer, target))
    then
        table.insert(actions, ACTIONS.TROPICAL_USE_ITEM)
    end
end

AddComponentAction("INVENTORY", "tropical_consumable", function(inst, doer, actions, right)
    CheckConsumable(inst, doer, doer, actions)
end)
AddComponentAction("USEITEM", "tropical_consumable", function(inst, doer, target, actions, right)
    CheckConsumable(inst, doer, target, actions)
end)
AddComponentAction("EQUIPPED", "tropical_consumable", function(inst, doer, target, actions, right)
    CheckConsumable(inst, doer, target, actions)
end)

----------------------------------------------------------------------------------------------------

AddComponentAction("POINT", "tropical_noequipactivator", function(inst, doer, pos, actions, right, target)
    local boat = doer:GetCurrentPlatform()
    if right
        and boat
        and boat:HasTag("shipwrecked_boat")
        and boat.replica.container
        and boat.replica.container:GetItemInSlot(2)
        and boat.replica.container:GetItemInSlot(2):HasTag("boatcannon") -- 船炮
        and not doer.replica.inventory:IsHeavyLifting()
    then
        -- 船炮开炮
        table.insert(actions, ACTIONS.BOATCANNON)
    end
end)
----------------------------------------------------------------------------------------------------

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if target:HasTag("cost_one_oinc") then
        if target:HasTag("playercrafted") and not target:HasTag("slot_one") then
            -- 物品放入柜中
            table.insert(actions, ACTIONS.GIVE_SHELF)
        end
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

AddComponentAction("SCENE", "melter", function(inst, doer, actions, right)
    if not inst:HasTag("burnt") then
        if right and not inst:HasTag("alloydone") and inst.replica.container and inst.replica.container:IsFull() then
            --冶炼炉冶炼
            table.insert(actions, ACTIONS.SMELT)
        elseif not right and inst:HasTag("alloydone") then
            --冶炼炉收获
            table.insert(actions, ACTIONS.HARVEST)
        end
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

AddComponentAction("USEITEM", "fueltar", function(inst, doer, target, actions)
    if not doer.replica.rider:IsRiding()
        or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
        if target:HasTag("seayard") or target:HasTag("tarlamp") or target:HasTag("tarsuit") then
            --焦油添加燃料
            table.insert(actions, ACTIONS.ADDFUEL)
        end
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


AddComponentAction("SCENE", "portablestructure", function(inst, doer, actions, right)
    if right
        and inst:HasTag("shipwrecked_boat")
        and not inst:HasTag("fire")
        and (not inst.replica.container or not inst.replica.container:IsOpenedBy(doer))
        and doer:GetCurrentPlatform() ~= inst
    then
        -- 可以收回小船
        table.insert(actions, ACTIONS.RETRIEVE)
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