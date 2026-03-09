local function IsHold(doer, target)
    return target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)
end

local function IsRiding(doer)
    return doer.replica.rider:IsRiding()
end

TRO_AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if inst.prefab == "tar"
        and (not IsRiding(doer) or IsHold(doer, target))
        and (target:HasTag("seayard") or target:HasTag("tarlamp") or target:HasTag("tarsuit"))
    then
        --焦油添加燃料
        table.insert(actions, ACTIONS.ADDFUEL)
    end
end)



local IRONLORD_WORKS = {
    CHOP = true,
    HAMMER = true,
    MINE = true,
}
--[[
TRO_AddComponentAction("SCENE", "workable", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") then
        -- 活性机甲
        for k, _ in ipairs(IRONLORD_WORKS) do
            if inst:HasTag(k .. "_workable") then
                table.insert(actions, ACTIONS[k])
            end
        end
    end
end)

TRO_AddComponentAction("SCENE", "hackable", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") and inst:HasTag("hackable") then
        -- 活性机甲
        table.insert(actions, ACTIONS.HACK)
    end
end)

-- bugrepellent
TRO_AddComponentAction("SCENE", "combat", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") and doer.replica.combat:CanTarget(inst) then
        --活性机甲发射
        table.insert(actions, ACTIONS.TIRO)
    end
end)]]

local ARTIFACT_FORBIDDEN = { "beaver", "weremoose", "weregoose", "wonkey" }

TRO_AddComponentAction("INVENTORY", "ironmachine", function(inst, doer, actions)
    if (doer.replica.rider and doer.replica.rider:IsRiding()) or
        not (inst.replica.inventoryitem and inst.replica.inventoryitem:IsHeldBy(doer)) then
        return
    end

    for _, v in pairs(ARTIFACT_FORBIDDEN) do
        if doer:HasTag(v) then return end
    end

    if inst:HasTag("ironmachineon") then
        table.insert(actions, ACTIONS.IRONTURNOFF)
    elseif not doer:HasTag("ironlord") then
        table.insert(actions, ACTIONS.IRONTURNON)
    end
end)

TRO_AddComponentAction("USEITEM", "installable", function(inst, doer, target, actions)
    if target:HasTag("installations") and not target:HasTag("installations_occupied") then
        table.insert(actions, ACTIONS.INSTALL)
    end
end
)

TRO_AddComponentAction("SCENE", "store", function(inst, doer, actions)
    table.insert(actions, ACTIONS.STOREOPEN)
end)


TRO_AddComponentAction("SCENE", "pro_portablestructure", function(inst, doer, actions, right)
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

local function UseTool(inst, doer, target, actions)
    if inst:HasTag("hack_tool") and target:HasTag("hackable") then
        --砍伐
        table.insert(actions, ACTIONS.HACK)
        return true
    end

    return false
end

TRO_AddComponentAction("USEITEM", "tool", function(inst, doer, target, actions)
    if UseTool(inst, doer, target, actions) then
        return
    end
end)

TRO_AddComponentAction("EQUIPPED", "tool", function(inst, doer, target, actions, right)
    if UseTool(inst, doer, target, actions) then
        return
    end
end)
