local Utils = require("tropical_utils/utils")

modimport "modmain/common/stategraphs/SGwilson"
modimport "modmain/common/stategraphs/SGwilson_client"

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MEAL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MEAL, "doshortaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.COLLECTSAP, function(inst, action)
    return inst:HasTag("fastpicker") and "doshortaction" or inst:HasTag("quagmire_fasthands") and "domediumaction" or
        "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.COLLECTSAP, function(inst, action)
    return inst:HasTag("fastpicker") and "doshortaction" or inst:HasTag("quagmire_fasthands") and "domediumaction" or
        "dolongaction"
end))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SNACKRIFICE, "give"))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SNACKRIFICE, "give"))

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.STOREOPEN, "doshortaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.STOREOPEN, "doshortaction"))


AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PLAY, function(inst, action)
    if action.invobject ~= nil then
        return (action.invobject:HasTag("flute") and "play_flute")
            or (action.invobject:HasTag("horn") and "play_horn")
            or (action.invobject:HasTag("horn2") and "play_horn2")
            or (action.invobject:HasTag("horn3") and "play_horn3")
            or (action.invobject:HasTag("bell") and "play_bell")
            or (action.invobject:HasTag("whistle") and "play_whistle")
            or (action.invobject:HasTag("flutesw") and "play_flutesw")
            or (action.invobject:HasTag("goddess_bell") and "play_goddess_bell")
            or (action.invobject:HasTag("goddess_flute") and "play_goddess_flute")
            or nil
    end
end
))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PLAY, function(inst, action)
    if action.invobject ~= nil then
        return (action.invobject:HasTag("flute") and "play_flute")
            or (action.invobject:HasTag("horn") and "play_horn")
            or (action.invobject:HasTag("horn2") and "play_horn2")
            or (action.invobject:HasTag("horn3") and "play_horn3")
            or (action.invobject:HasTag("bell") and "play_bell")
            or (action.invobject:HasTag("whistle") and "play_whistle")
            or (action.invobject:HasTag("flutesw") and "play_flutesw")
            or nil
    end
end
))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BLINK, function(inst, action)
    --		if inst:HasTag("aquatic") and inst:HasTag("soulstealer") then return false end
    local interior = GetClosestInstWithTag("interior_center", inst, 30)
    if interior then return false end
    if TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL_SHORE and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_SWELL and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_ROUGH and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL_SHORE and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_WATERLOG and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_HAZARDOUS then
        return action.invobject == nil and inst:HasTag("soulstealer") and "portal_jumpin_pre" or "quicktele"
    end
end
))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BLINK, function(inst, action)
    --		if inst:HasTag("aquatic") and inst:HasTag("soulstealer") then return false end
    local interior = GetClosestInstWithTag("interior_center", inst, 30)
    if interior then return false end
    if TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL_SHORE and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_SWELL and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_ROUGH and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL_SHORE and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_WATERLOG and
        TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_HAZARDOUS then
        return action.invobject == nil and inst:HasTag("soulstealer") and "portal_jumpin_pre" or "quicktele"
    end
end
))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.COMPACTPOOP, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.COMPACTPOOP, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.DESACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.DESACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.OPENTUNA, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.OPENTUNA, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATCANNON, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOATCANNON, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TRO_DISMANTLE, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TRO_DISMANTLE, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SMELT, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SMELT, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE_SHELF, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GIVE_SHELF, "give"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TAKE_SHELF, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TAKE_SHELF, "give"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PAINT, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PAINT, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GAS, "crop_dust"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GAS, "crop_dust"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.HACK, function(inst)
    if inst:HasTag("beaver") then
        return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
    end

    local equipamento = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if equipamento and equipamento.prefab == "shears" then
        if not inst.sg:HasStateTag("preshear") then
            if inst.sg:HasStateTag("shearing") then
                return "shear"
            else
                return "shear_start"
            end
        end
    end


    return not inst.sg:HasStateTag("prechop") and (inst.sg:HasStateTag("chopping") and "chop" or "chop_start") or
        nil
end
))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.HACK, function(inst)
    if inst:HasTag("beaver") then
        return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
    end

    return not inst.sg:HasStateTag("prechop") and "chop_start" or nil
end
))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PAN, function(inst)
    if not inst.sg:HasStateTag("panning") then
        return "pan"
    end
end
))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PAN, function(inst)
    if not inst.sg:HasStateTag("panning") then
        return "pan"
    end
end))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ATTACK, function(inst, action)
    inst.sg.mem.localchainattack = not action.forced or nil
    local playercontroller = inst.components.playercontroller
    local attack_tag =
        playercontroller ~= nil and
        playercontroller.remote_authority and
        playercontroller.remote_predicting and
        "abouttoattack" or
        "attack"
    if not (inst.sg:HasStateTag(attack_tag) and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
        local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
        ---------umcompromissing mode compatibility---------	
        if weapon and weapon:HasTag("beegun") then
            if inst.sg.laststate.name == "beegun" or inst.sg.laststate.name == "beegun_short" then
                return
                "beegun_short"
            else
                return "beegun"
            end
        end
        if weapon and not ((weapon:HasTag("blowdart") or weapon:HasTag("thrown"))) and inst:HasTag("wathom") and not inst.sg:HasStateTag("attack") and (inst.components.rider ~= nil and not inst.components.rider:IsRiding()) then return ("wathomleap") end

        return (weapon == nil and "attack")
            or (weapon:HasTag("blowdart") and "blowdart")
            or (weapon:HasTag("slingshot") and "slingshot_shoot")
            or (weapon:HasTag("thrown") and "throw")
            or (weapon:HasTag("pillow") and "attack_pillow_pre")
            or (weapon:HasTag("propweapon") and "attack_prop_pre")
            or (weapon:HasTag("multithruster") and "multithrust_pre")
            or (weapon:HasTag("helmsplitter") and "helmsplitter_pre")
            or (weapon:HasTag("speargun") and "speargun")
            or (weapon:HasTag("blunderbuss") and "speargun")
            or "attack"
    end
end
))


AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ATTACK, function(inst, action)
    if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.replica.health:IsDead()) then
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equip == nil then
            return "attack"
        end
        local inventoryitem = equip.replica.inventoryitem

        ---------umcompromissing mode compatibility---------	
        if equip and equip:HasTag("beegun") then
            if inst.sg.laststate.name == "beegun" or inst.sg.laststate.name == "beegun_short" then
                return
                "beegun_short"
            else
                return "beegun"
            end
        end
        if equip and not ((equip:HasTag("blowdart") or equip:HasTag("thrown"))) and inst:HasTag("wathom") and not inst.sg:HasStateTag("attack") and (inst.components.rider ~= nil and not inst.components.rider:IsRiding()) then return ("wathomleap") end


        return (not (inventoryitem ~= nil and inventoryitem:IsWeapon()) and "attack")
            or (equip:HasTag("blowdart") and "blowdart")
            or (equip:HasTag("slingshot") and "slingshot_shoot")
            or (equip:HasTag("thrown") and "throw")
            or (equip:HasTag("pillow") and "attack_pillow_pre")
            or (equip:HasTag("propweapon") and "attack_prop_pre")
            or (equip:HasTag("speargun") and "speargun")
            or (equip:HasTag("blunderbuss") and "speargun")
            or "attack"
    end
end
))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SLEEPIN, function(inst, action)
    if action.invobject ~= nil then
        if action.invobject.onuse ~= nil then
            action.invobject:onuse(inst)
        end
        return "bedroll"
    elseif action.target:HasTag("bed") then
        local x, y, z = action.target.Transform:GetWorldPosition()
        action.doer.Transform:SetPosition(x + 0.02, y, z + 0.02)
        return "bedroll"
    else
        return "tent"
    end
end
))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SLEEPIN, function(inst, buf)
    if buf and buf.target and buf.target:HasTag("bed") then
        local x, y, z = buf.target.Transform:GetWorldPosition()
        buf.doer.Transform:SetPosition(x + 0.02, y, z + 0.02)
    end
    return buf.invobject ~= nil and "bedroll" or buf.target:HasTag("bed") and "bedroll" or "tent"
end
))



AddStategraphEvent("wilson", EventHandler("sanity_stun", function(inst, data)
    if not inst.components.inventory:IsItemNameEquipped("earmuffshat") then
        inst.sg:GoToState("sanity_stun", data.duration)
        inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
    end
end))

AddStategraphEvent("wilson_client", EventHandler("sanity_stun", function(inst, data)
    if not inst.replica.inventory:IsItemNameEquipped("earmuffshat") then
        inst.sg:GoToState("sanity_stun", data.duration)
    end
end))



AddStategraphEvent("wilson", EventHandler("sneeze", function(inst, data)
    if not inst.components.health:IsDead() and not inst.components.health.invincible then
        if inst.sg:HasStateTag("busy") and inst.sg.currentstate.name ~= "emote" then
            inst.components.hayfever.wantstosneeze = true
        else
            inst.sg:GoToState("sneeze")
        end
    end
end))


AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(ACTIONS.STOREOPEN, "doshortaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(ACTIONS.STOREOPEN, "doshortaction"))
