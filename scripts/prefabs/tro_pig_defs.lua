-- 换皮猪人太多了，这里提供一个统一预制件，为猪人、鱼人提供简便函数

local deciduoustree_utils = require "tro_utils/deciduoustree_utils"



local function ShouldAcceptItem(inst, item)
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    elseif inst.components.eater:CanEat(item) then
        local foodtype = item.components.edible.foodtype
        if foodtype == FOODTYPE.MEAT or foodtype == FOODTYPE.HORRIBLE then
            return inst.components.follower:GetLeader() == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
        elseif foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.RAW then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            return (last_eat_time == nil or
                    last_eat_time >= TUNING.PIG_MIN_POOP_PERIOD)
                and (inst.components.inventory == nil or
                    not inst.components.inventory:Has(item.prefab, 1))
        end
        return true
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    --I eat food
    if item.components.edible ~= nil then
        --meat makes us friends (unless I'm a guard)
        if (item.components.edible.foodtype == FOODTYPE.MEAT or
                item.components.edible.foodtype == FOODTYPE.HORRIBLE
            ) and
            item.components.inventoryitem ~= nil and
            ( --make sure it didn't drop due to pockets full
                item.components.inventoryitem:GetGrandOwner() == inst or
                --could be merged into a stack
                (not item:IsValid() and
                    inst.components.inventory:FindItem(function(obj)
                        return obj.prefab == item.prefab
                            and obj.components.stackable ~= nil
                            and obj.components.stackable:IsStack()
                    end) ~= nil)
            ) then
            if inst.components.combat:TargetIs(giver) then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader ~= nil and not (inst:HasTag("guard") or giver:HasTag("monster") or giver:HasTag("merm")) then
                if giver.components.minigame_participator == nil then
                    giver:PushEvent("makefriend")
                    giver.components.leader:AddFollower(inst)
                end
                inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
                inst.components.follower.maxfollowtime =
                    giver:HasTag("polite")
                    and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                    or TUNING.PIG_LOYALTY_MAXTIME
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end

    --I wear hats
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

----------------------------------------------------------------------------------------------------

local function OnEat(inst, food)
    if food.components.edible ~= nil then
        if food.components.edible.foodtype == FOODTYPE.VEGGIE then
            SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
end

local function NormalShouldSleep(inst)
    return DefaultSleepTest(inst)
        and (inst.components.follower == nil or inst.components.follower.leader == nil
            or (FindEntity(inst, 6, nil, { "campfire", "fire" }) ~= nil and
                (inst.LightWatcher == nil or inst.LightWatcher:IsInLight())))
end

----------------------------------------------------------------------------------------------------
local RETARGET_MUST_TAGS = { "_combat" }
local function NormalRetargetFn(inst)
    if inst:HasTag("NPC_contestant") then
        return nil
    end

    local exclude_tags = { "playerghost", "INLIMBO", "NPC_contestant" }
    if inst.components.follower:GetLeader() ~= nil then
        table.insert(exclude_tags, "abigail")
    end
    if inst.components.minigame_spectator ~= nil then
        table.insert(exclude_tags, "player") -- prevent spectators from auto-targeting webber
    end

    local oneof_tags = { "monster", "wonkey", "pirate" }
    if not inst:HasTag("merm") then
        table.insert(oneof_tags, "merm")
    end

    return not inst:IsInLimbo()
        and FindEntity(
            inst,
            TUNING.PIG_TARGET_DIST,
            function(guy)
                return guy:IsInLight() and inst.components.combat:CanTarget(guy)
            end,
            RETARGET_MUST_TAGS, -- see entityreplica.lua
            exclude_tags,
            oneof_tags
        )
        or nil
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target) and target:IsInLight()
        and not (target.sg ~= nil and target.sg:HasStateTag("transform"))
end

----------------------------------------------------------------------------------------------------

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function IsPig(dude)
    return dude:HasTag("pig")
end

local function IsWerePig(dude)
    return dude:HasTag("werepig")
end

local function IsNonWerePig(dude)
    return dude:HasTag("pig") and not dude:HasTag("werepig")
end

local function IsGuardPig(dude)
    return dude:HasTag("guard") and dude:HasTag("pig")
end

local function IsHost(dude)
    return dude:HasTag("shadowthrall_parasite_hosted")
end

local function SuggestTreeTarget(inst, data)
    if data ~= nil and data.tree ~= nil and inst:GetBufferedAction() ~= ACTIONS.CHOP then
        inst.tree_target = data.tree
    end
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    inst:ClearBufferedAction()

    if attacker ~= nil then
        if attacker.prefab == "deciduous_root" and attacker.owner ~= nil then
            deciduoustree_utils.OnAttackedByDecidRoot(inst, attacker.owner, inst.friend_must_tags)
        elseif attacker.prefab ~= "deciduous_root" and not attacker:HasTag("pigelite") then
            inst.components.combat:SetTarget(attacker)

            if inst:HasTag("shadowthrall_parasite_hosted") then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsHost, MAX_TARGET_SHARES)
            elseif inst:HasTag("werepig") then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsWerePig, MAX_TARGET_SHARES)
            elseif inst:HasTag("guard") then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, attacker:HasTag("pig") and IsGuardPig or IsPig, MAX_TARGET_SHARES)
            elseif not (attacker:HasTag("pig") and attacker:HasTag("guard")) then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsNonWerePig, MAX_TARGET_SHARES)
            end
        end
    end
end

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/wild_boar/grunt")
end

local function MakePig(name, data, common_post, master_post)
    if data.is_pig then
        data.pig_tag = true
        if not data.effectsymbol then
            data.effectsymbol = "pig_torso"
        end
        data.pig_eater = true
        data.pig_combat = true
        data.pig_name = true
        data.pig_trader = true
        data.pig_sleeper = true
        data.pig_attacked = true
    end



    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        MakeCharacterPhysics(inst, 50, .5)

        inst.DynamicShadow:SetSize(1.5, .75)
        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("pigman")

        inst:AddTag("_named")
        if data.pig_tag then
            inst:AddTag("character")
            inst:AddTag("pig")
            inst:AddTag("scarytoprey") --分泌
        end

        inst:AddComponent("talker")
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
        inst.components.talker.offset = Vector3(0, -400, 0)
        inst.components.talker:MakeChatter()

        if common_post then
            common_post(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.friend_must_tags = data.friend_must_tags

        inst:RemoveTag("_named")

        if data.is_pig then
            inst.components.talker.ontalk = ontalk
        end

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = 5
        inst.components.locomotor.walkspeed = 3
        inst.components.locomotor:SetAllowPlatformHopping(true)

        inst:AddComponent("bloomer")
        inst:AddComponent("embarker")
        inst:AddComponent("drownable")

        if data.pig_eater then
            inst:AddComponent("eater")
            inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
            inst.components.eater:SetCanEatHorrible()
            inst.components.eater:SetCanEatRaw()
            inst.components.eater:SetStrongStomach(true) -- can eat monster meat!
            inst.components.eater:SetOnEatFn(OnEat)
        end

        inst:AddComponent("health")
        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = data.effectsymbol
        if data.pig_combat then
            inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
            inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
            inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
            inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
        end

        MakeMediumBurnableCharacter(inst, data.effectsymbol)
        MakeMediumFreezableCharacter(inst, data.effectsymbol)
        MakeHauntablePanic(inst)

        inst:AddComponent("named")
        if data.pig_name then
            inst.components.named.possiblenames = STRINGS.PIGNAMES
            inst.components.named:PickNewName()
        end

        if data.pig_trader then
            inst:AddComponent("trader")
            inst.components.trader:SetAcceptTest(ShouldAcceptItem)
            inst.components.trader.onaccept = OnGetItemFromPlayer
            inst.components.trader.onrefuse = OnRefuseItem
            inst.components.trader.deleteitemonaccept = false
        end

        if data.pig_sleeper then
            inst:AddComponent("sleeper")
            inst.components.sleeper:SetResistance(2)
            inst.components.sleeper:SetSleepTest(NormalShouldSleep)
            inst.components.sleeper:SetWakeTest(DefaultWakeTest)
        end

        inst:AddComponent("follower")
        inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME

        inst:AddComponent("inventory")
        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        inst:AddComponent("knownlocations")

        if data.pig_attacked then
            inst:ListenForEvent("attacked", OnAttacked)
            inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)
        end

        if master_post then
            master_post(inst)
        end

        return inst
    end

    return Prefab(name, fn, data.assets, data.prefabs)
end

return {
    MakePig = MakePig
}
