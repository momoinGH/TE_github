AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if not right then
        if target:HasTag("shelfcanaccept") then --target.components.shelfer and target.components.shelfer:CanAccept(inst, doer ) then
            table.insert(actions, ACTIONS.GIVE2)
        end
    end
end)
AddComponentAction("SCENE", "hackable", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not right then
        if equipamento and equipamento:HasTag("machete") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then --and equipamento.components.hackable then --and inst.components.hackable.canbehacked then
            table.insert(actions, ACTIONS.HACK1)
        end
    end

    if right then
        if doer:HasTag("ironlord") then
            table.insert(actions, ACTIONS.HACK1)
        end
    end
end)

AddComponentAction("SCENE", "melter", function(inst, doer, actions, right)
    if right then
        if not inst:HasTag("burnt") then
            if inst:HasTag("alloydone") then
                table.insert(actions, ACTIONS.HARVEST1)
            elseif inst.replica.container ~= nil and
                inst.replica.container:IsFull() then
                table.insert(actions, ACTIONS.SMELT)
            end
        end
    end
end)



AddComponentAction("SCENE", "workable", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") then
        if inst:HasTag("tree") then
            table.insert(actions, ACTIONS.CHOP)
        end

        if inst:HasTag("bush_vine") or inst:HasTag("bambootree") then
            table.insert(actions, ACTIONS.HACK)
        end

        if inst:HasTag("boulder") then
            table.insert(actions, ACTIONS.MINE)
        end

        if inst:HasTag("structure") then
            table.insert(actions, ACTIONS.HAMMER)
        end
    end
end)

-------------------------------------------
AddComponentAction("SCENE", "dislodgeable", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
    if not right then
        if equipamento and equipamento:HasTag("ballpein_hammer") and inst:HasTag("dislodgeable") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
            table.insert(actions, ACTIONS.DISLODGE)
            return
        end
    end
end)


AddComponentAction("SCENE", "mystery", function(inst, doer, actions, right)
    if not right then
        local equipamento = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        if equipamento and equipamento:HasTag("magnifying_glass") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
            table.insert(actions, ACTIONS.INVESTIGATEGLASS)
        end
    end
end)


AddComponentAction("SCENE", "interactions", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
    --local rightrect = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
    --  and doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS).components.reticule ~= nil or nil
    if right then
        if equipamento and equipamento:HasTag("boatrepairkit") and doer:HasTag("aquatic") then
            table.insert(actions, GLOBAL.ACTIONS.BOATREPAIR)
            return
        end
    end

    if not right then
        ---------------------------------
        -- TODO 删掉
        if inst.prefab == "surfboard" and not inst:HasTag("ocupado") and not doer.replica.inventory:IsFull() then
            table.insert(actions, GLOBAL.ACTIONS.RETRIEVE)
            return
        end

        if inst.prefab == "fish_farm" then
            table.insert(actions, GLOBAL.ACTIONS.RETRIEVE)
            return
        end
        ---------------------------------

        if inst:HasTag("wallhousehamlet") and equipamento and equipamento:HasTag("hameletwallpaper") then
            table.insert(actions, GLOBAL.ACTIONS.PAINT)
            return
        end

        if inst:HasTag("pisohousehamlet") and equipamento and equipamento:HasTag("hameletfloor") then
            table.insert(actions, GLOBAL.ACTIONS.PAINT)
            return
        end
    end
end
)

AddComponentAction(
    "INVENTORY",
    "interactions",
    function(inst, doer, actions)
        if inst:HasTag("boatlight") and inst:HasTag("nonavio") and not inst:HasTag("ligado") then --and inst:HasTag("nonavio")
            table.insert(actions, ACTIONS.ACTIVATESAIL)
        end
        if inst:HasTag("boatlight") and inst:HasTag("ligado") then
            table.insert(actions, ACTIONS.DESACTIVATESAIL)
        end

        if inst:HasTag("boatrepairkit") then
            table.insert(actions, ACTIONS.BOATREPAIR)
        end

        if inst:HasTag("tunacan") then
            table.insert(actions, ACTIONS.OPENTUNA)
        end

        if inst:HasTag("pooptocompact") and doer:HasTag("wilbur") then
            table.insert(actions, ACTIONS.COMPACTPOOP)
        end
    end)

AddComponentAction("SCENE", "health", function(inst, doer, actions, right)
    local containedsail = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BARCO)
    if right and doer:HasTag("aquatic") and containedsail and containedsail.replica.container and containedsail.replica.container:GetItemInSlot(2) ~= nil and containedsail.replica.container:GetItemInSlot(2):HasTag("boatcannon") and
        not (doer.replica.rider:IsRiding() or doer.replica.inventory:IsHeavyLifting() or doer:HasTag("bonked") or doer:HasTag("deleidotiro")) then
        table.insert(actions, GLOBAL.ACTIONS.BOATCANNON)
    end



    if not right and doer:HasTag("ironlord") and
        inst.replica.health ~= nil and not inst.replica.health:IsDead() and
        inst.replica.combat ~= nil and inst.replica.combat:CanBeAttacked(doer) then
        table.insert(actions, GLOBAL.ACTIONS.ATTACK)
    end

    if GLOBAL.TheWorld.ismastersim then
        if right and doer:HasTag("ironlord") and not inst:HasTag("ironlord") and
            inst.replica.health ~= nil and not inst.replica.health:IsDead() and
            inst.replica.combat ~= nil and inst.replica.combat:CanBeAttacked(doer) then
            table.insert(actions, ACTIONS.TIRO)
        end
    end
end)

AddComponentAction("SCENE", "shopped", function(inst, doer, actions, right)
    if not right then
        if doer.components.shopper then --and inst.components.shopdispenser and inst.components.shopdispenser.item_served then
            table.insert(actions, ACTIONS.SHOP)
        end
    end
end)

AddComponentAction("POINT", "gasser", function(inst, doer, pos, actions, right)
    if right and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
        table.insert(actions, ACTIONS.GAS)
    end
end)

AddComponentAction("SCENE", "poisonable", function(inst, doer, actions, right)
    if right then
        local equipamento = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        if equipamento and equipamento:HasTag("bugrepellent") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
            table.insert(actions, ACTIONS.GAS)
        end
    end
end)

AddComponentAction("POINT", "equippable", function(inst, doer, pos, actions, right, target)
    local xjp, yjp, zjp = pos:Get()
    local xs, ys, zs = doer.Transform:GetWorldPosition()
    local dist = math.sqrt((xjp - xs) * (xjp - xs) + (zjp - zs) * (zjp - zs))
    local rightrect =
        doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BARCO) and
        doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BARCO).components.reticule ~= nil or
        nil
    local terraformer =
        doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BARCO) and
        doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BARCO).components.terraformer ~= nil or
        nil

    local containedsail = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BARCO)
    if right and doer:HasTag("aquatic") and containedsail and containedsail.replica.container and containedsail.replica.container:GetItemInSlot(2) ~= nil and containedsail.replica.container:GetItemInSlot(2):HasTag("boatcannon") and
        not (doer.replica.rider:IsRiding() or doer.replica.inventory:IsHeavyLifting() or doer:HasTag("bonked") or doer:HasTag("deleidotiro")) then
        return table.insert(actions, GLOBAL.ACTIONS.BOATCANNON)
    end

    if not right and rightrect == nil and terraformer == nil and doer:HasTag("aquatic") and
        GLOBAL.TheWorld.Map:IsPassableAtPoint(pos:Get()) and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked"))
    then
        table.insert(actions, GLOBAL.ACTIONS.BOATDISMOUNT)
    end


    if right and rightrect == nil and terraformer == nil and dist <= 20 then
        local doer_x, doer_y, doer_z = doer.Transform:GetWorldPosition()
        local planchadesurf = GLOBAL.TheWorld.Map:GetPlatformAtPoint(doer_x, doer_z)
        if planchadesurf and planchadesurf:HasTag("planchadesurf") then
            table.insert(actions, GLOBAL.ACTIONS.SURF)
        end
    end
end)

AddComponentAction("USEITEM", "sapbucket", function(inst, doer, target, actions, right)
    if target:HasTag("tappable") and not target:HasTag("tapped") and not target:HasTag("stump") then
        table.insert(actions, ACTIONS.TAPSUGARTREE)
    end
end)

AddComponentAction("SCENE", "sappy", function(inst, doer, actions, right)
    if inst:HasTag("sappy") and not inst:HasTag("stump") then
        table.insert(actions, ACTIONS.COLLECTSAP)
    end
end)

AddComponentAction("USEITEM", "fueltar", function(inst, doer, target, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
        if target:HasTag("seayard") then
            table.insert(actions, ACTIONS.ADDFUEL)
        end

        if target:HasTag("tarlamp") then
            table.insert(actions, ACTIONS.ADDFUEL)
        end

        if target:HasTag("tarsuit") then
            table.insert(actions, ACTIONS.ADDFUEL)
        end
    end
end)

AddComponentAction("USEITEM", "setupable", function(inst, doer, target, actions, right)
    if inst:HasTag("honeyed") and target:HasTag("honeyproducer") then
        table.insert(actions, ACTIONS.SETUPITEM)
    elseif inst:HasTag("salty") and target:HasTag("saltwater") then
        table.insert(actions, ACTIONS.SETUPITEM)
    end
end)

AddComponentAction("USEITEM", "slaughtertool", function(inst, doer, target, actions, right)
    if target:HasTag("canbeslaughtered") then
        table.insert(actions, ACTIONS.KILLSOFTLY)
    end
end)

AddComponentAction("USEITEM", "snackrificable", function(inst, doer, target, actions)
    if target:HasTag("gorge_altar") then
        table.insert(actions, ACTIONS.SNACKRIFICE)
    end
end
)

AddComponentAction("USEITEM", "replater", function(inst, doer, target, actions)
    if target:HasTag("replatable") then
        table.insert(actions, ACTIONS.REPLATE)
    end
end
)

AddComponentAction("USEITEM", "installable", function(inst, doer, target, actions)
    if target:HasTag("installations") and not target:HasTag("installations_occupied") then
        table.insert(actions, ACTIONS.INSTALL)
    end
end
)

AddComponentAction("USEITEM", "specialstewer_dish", function(inst, doer, target, actions)
    if inst:HasTag("quagmire_casseroledish") and target:HasTag("oven") and target:HasTag("specialstewer_dishtaker") then
        table.insert(actions, ACTIONS.GIVE_DISH)
    end


    if inst:HasTag("quagmire_pot") and target:HasTag("pot_hanger") and target:HasTag("specialstewer_dishtaker") then
        table.insert(actions, ACTIONS.GIVE_DISH)
    end
end)

AddComponentAction("USEITEM", "milker", function(inst, doer, target, actions)
    if target:HasTag("goddess_deer") and target:HasTag("windy4") then
        table.insert(actions, ACTIONS.MILK)
    end
end)


AddComponentAction("SCENE", "store", function(inst, doer, actions)
    table.insert(actions, ACTIONS.STOREOPEN)
end)

-- 可以收回小船
AddComponentAction("SCENE", "portablestructure",
    function(inst, doer, actions, right)                                              --TODO right不能用，一直为nil，是哪里覆盖把right弄丢了吗
        if not inst:HasTag("fire")
            and inst:HasTag("boat")
            and (not inst.replica.container or not inst.replica.container:IsOpenedBy(doer))
            and doer:GetCurrentPlatform() ~= inst
        then
            table.insert(actions, ACTIONS.RETRIEVE)
        end
    end)
