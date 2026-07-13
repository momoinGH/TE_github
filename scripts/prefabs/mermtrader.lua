local assets =
{
    Asset("ANIM", "anim/merm_build.zip"),
    Asset("ANIM", "anim/merm_guard_build.zip"),
    Asset("ANIM", "anim/merm_guard_small_build.zip"),
    Asset("ANIM", "anim/merm_actions.zip"),
    Asset("ANIM", "anim/merm_guard_transformation.zip"),
    Asset("ANIM", "anim/ds_pig_boat_jump.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("ANIM", "anim/merm_fisherman_build.zip"),
    Asset("ANIM", "anim/merm_fishing.zip"),
    Asset("ANIM", "anim/merm_trader1_build.zip"),
    Asset("ANIM", "anim/merm_trader2_build.zip"),
    Asset("ANIM", "anim/mermpirate.zip"),
    Asset("SOUND", "sound/merm.fsb"),
}

local prefabs =
{
    "pondfish",
    "froglegs",
    "mermking",
    "merm_splash",
    "merm_spawn_fx",
}

local merm_loot =
{
    "pondfish",
    "froglegs",
}

local sounds = {
    attack = "dontstarve/creatures/merm/attack",
    hit = "dontstarve/creatures/merm/hurt",
    death = "dontstarve/creatures/merm/death",
    talk = "dontstarve/characters/wurt/merm/warrior/talk",
    buff = "dontstarve/characters/wurt/merm/warrior/yell",
    --debuff = "dontstarve/characters/wurt/merm/warrior/yell",
}

local deciduoustree_utils = require "tro_utils/deciduoustree_utils"

local function FindInvaderFn(guy, inst)
    local leader = inst.components.follower and inst.components.follower.leader

    local leader_guy = guy.components.follower and guy.components.follower.leader
    if leader_guy and leader_guy.components.inventoryitem then
        leader_guy = leader_guy.components.inventoryitem:GetGrandOwner()
    end

    return (guy:HasTag("character") and not (guy:HasTag("merm"))) and
        not ((TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKing())) and
        not (leader and leader:HasTag("player")) and
        not (leader_guy and (leader_guy:HasTag("merm")) and
            not guy:HasTag("pig"))
end

local function RetargetFn(inst)
    local defend_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_DEFEND_DIST or TUNING.MERM_DEFEND_DIST
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home

    if home and inst:GetDistanceSqToInst(home) < defend_dist * defend_dist then
        defenseTarget = home
    end

    return FindEntity(defenseTarget or inst, SpringCombatMod(TUNING.MERM_TARGET_DIST), FindInvaderFn)
end

local function KeepTargetFn(inst, target)
    local defend_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_DEFEND_DIST or TUNING.MERM_DEFEND_DIST
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    local follower = inst.components.follower and inst.components.follower.leader

    if home and not follower then
        return home:GetDistanceSqToInst(target) < defend_dist * defend_dist
            and home:GetDistanceSqToInst(inst) < defend_dist * defend_dist
    end

    return inst.components.combat:CanTarget(target)
end

local PIRATE_DIST = 4

local function RetargetpirateFn(inst)
    local defend_dist = inst:HasTag("mermguard") and PIRATE_DIST or PIRATE_DIST
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home

    if home and inst:GetDistanceSqToInst(home) < defend_dist * defend_dist then
        defenseTarget = home
    end

    return FindEntity(defenseTarget or inst, SpringCombatMod(PIRATE_DIST), FindInvaderFn)
end

local function KeepTargetpirateFn(inst, target)
    local defend_dist = inst:HasTag("mermguard") and PIRATE_DIST or PIRATE_DIST
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    local follower = inst.components.follower and inst.components.follower.leader

    if home and not follower then
        return home:GetDistanceSqToInst(target) < defend_dist * defend_dist
            and home:GetDistanceSqToInst(inst) < defend_dist * defend_dist
    end

    return inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if deciduoustree_utils.OnAttackedByDecidRoot(inst, attacker, { "merm" }) then
        return
    end

    if attacker and inst.components.combat:CanTarget(attacker) and attacker.prefab ~= "deciduous_root" then
        local share_target_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_SHARE_TARGET_DIST or
            TUNING.MERM_SHARE_TARGET_DIST
        local max_target_shares = inst:HasTag("mermguard") and TUNING.MERM_GUARD_MAX_TARGET_SHARES or
            TUNING.MERM_MAX_TARGET_SHARES

        inst.components.combat:SetTarget(attacker)

        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home

            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= share_target_dist * share_target_dist then
                max_target_shares = max_target_shares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end

            inst.components.combat:ShareTarget(attacker, share_target_dist, function(dude)
                return (dude.components.homeseeker and dude.components.homeseeker.home and dude.components.homeseeker.home == home) or
                    (dude:HasTag("merm") and not dude:HasTag("player") and not
                        (dude.components.follower and dude.components.follower.leader and dude.components.follower.leader:HasTag("player")))
            end, max_target_shares)
        end
    end
end

local function IsAbleToAccept(inst, item, giver)
    if inst.components.health ~= nil and inst.components.health:IsDead() then
        return false, "DEAD"
    elseif inst.sg ~= nil and inst.sg:HasStateTag("busy") then
        if inst.sg:HasStateTag("sleeping") then
            return true
        end
        return false, "BUSY"
    end
    return true
end

local function ShouldAcceptItem(inst, item, giver)
    if inst:HasTag("mermguard") and inst.king ~= nil then
        return false
    end

    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    return (giver:HasTag("merm") and not (inst:HasTag("mermguard") and giver:HasTag("mermdisguise"))) and
        ((item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD) or
            (item.components.edible and inst.components.eater:CanEat(item)) or
            (item:HasTag("fish") and not (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst))))
end

local function OnGetItemFromPlayer(inst, giver, item)
    local loyalty_max = inst:HasTag("mermguard") and TUNING.MERM_GUARD_LOYALTY_MAXTIME or TUNING.MERM_LOYALTY_MAXTIME
    local loyalty_per_hunger = inst:HasTag("mermguard") and TUNING.MERM_GUARD_LOYALTY_PER_HUNGER or
        TUNING.MERM_LOYALTY_PER_HUNGER

    if item.components.edible ~= nil then
        if inst.components.combat:TargetIs(giver) then
            inst.components.combat:SetTarget(nil)
        elseif giver.components.leader ~= nil and not (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst)) then
            giver:PushEvent("makefriend")
            giver.components.leader:AddFollower(inst)

            inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * loyalty_per_hunger)
            inst.components.follower.maxfollowtime = loyalty_max
        end
    end

    -- I also wear hats
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

    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function SuggestTreeTarget(inst, data)
    local ba = inst:GetBufferedAction()
    if data ~= nil and data.tree ~= nil and (ba == nil or ba.action ~= ACTIONS.CHOP) then
        inst.tree_target = data.tree
    end
end

local function RoyalUpgrade(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH_KINGBONUS)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE_KINGBONUS)
    inst.Transform:SetScale(1.05, 1.05, 1.05)
end

local function RoyalDowngrade(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.Transform:SetScale(1, 1, 1)
end

local function ResolveMermChatter(inst, strid, strtbl)
    local stringtable = STRINGS[strtbl:value()]
    if stringtable then
        if stringtable[strid:value()] ~= nil then
            if ThePlayer and ThePlayer:HasTag("mermfluent") then
                return stringtable[strid:value()][1] -- First value is always the translated one
            else
                return stringtable[strid:value()][2]
            end
        end
    end
end

local function ShouldSleep(inst)
    return NocturnalSleepTest(inst)
        and ((inst.components.follower == nil or inst.components.follower.leader == nil) and
            not (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst)))
end

local function ShouldWakeUp(inst)
    return NocturnalWakeTest(inst) or
        (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst))
end

local function OnTimerDone(inst, data)
    if data.name == "facetime" then
        inst.components.timer:StartTimer("dontfacetime", 10)
    elseif data.name == "fish" then
        inst.CanFish = true
    end
end

local function battlecry(combatcmp, target)
    local strtbl =
        combatcmp.inst:HasTag("guard") and
        "MERM_BATTLECRY" or
        "MERM_BATTLECRY"
    return strtbl, math.random(#STRINGS[strtbl])
end

local function MakeMerm(name, common_postinit, master_postinit)
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
        inst.AnimState:Hide("hat")

        inst:AddTag("character")
        inst:AddTag("merm")
        inst:AddTag("wet")

        inst:AddComponent("talker")
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0, -400, 0)
        inst.components.talker.resolvechatterfn = ResolveMermChatter
        inst.components.talker:MakeChatter()


        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.sounds = sounds

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
        inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED
        -- boat hopping setup
        inst.components.locomotor:SetAllowPlatformHopping(true)
        inst:AddComponent("embarker")
        inst:AddComponent("drownable")

        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODGROUP.VEGETARIAN }, { FOODGROUP.VEGETARIAN })

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
        inst.components.combat.GetBattleCryString = battlecry
        inst.components.combat.hiteffectsymbol = "pig_torso"
        inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(merm_loot)

        inst:AddComponent("inventory")
        inst:AddComponent("inspectable")
        inst:AddComponent("knownlocations")
        inst:AddComponent("follower")
        inst.components.follower.maxfollowtime = TUNING.MERM_LOYALTY_MAXTIME

        inst:AddComponent("sleeper")
        inst.components.sleeper:SetNocturnal(true)
        inst.components.sleeper:SetSleepTest(ShouldSleep)
        inst.components.sleeper:SetWakeTest(ShouldWakeUp)

        inst:AddComponent("mermcandidate")

        inst:AddComponent("timer")

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader:SetAbleToAcceptTest(IsAbleToAccept)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem
        inst.components.trader.deleteitemonaccept = false

        MakeMediumBurnableCharacter(inst, "pig_torso")
        MakeMediumFreezableCharacter(inst, "pig_torso")
        MakeHauntablePanic(inst)

        inst:ListenForEvent("timerdone", OnTimerDone)
        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local SLIGHTDELAY = 1


local function OnEat(inst, data)
    if TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst) then
        if data.food and data.food.components.edible then
            inst.components.mermcandidate:AddCalories(data.food)
        end
    end
end

local function master_post(inst)
    inst:SetStateGraph("SGmermtrader")
    local merm_brain = require "brains/mermbrain"
    inst:SetBrain(merm_brain)

    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    -- 国王升级系统
    inst:ListenForEvent("onmermkingcreated", function()
        inst:DoTaskInTime(math.random() * SLIGHTDELAY, function()
            RoyalUpgrade(inst)
            inst:PushEvent("onmermkingcreated")
        end)
    end, TheWorld)
    inst:ListenForEvent("onmermkingdestroyed", function()
        inst:DoTaskInTime(math.random() * SLIGHTDELAY, function()
            RoyalDowngrade(inst)
            inst:PushEvent("onmermkingdestroyed")
        end)
    end, TheWorld)

    inst:ListenForEvent("oneat", OnEat)

    if TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKing() then
        RoyalUpgrade(inst)
    end
end



local function oncollect(inst)
    inst.CanFish = false

    if inst.components.timer:TimerExists("fish") then
        inst.components.timer:StopTimer("fish")
    end

    inst.components.timer:StartTimer("fish", TUNING.SEG_TIME * 2)
end

local function master_post2(inst)
    inst:SetStateGraph("SGmermfisher")
    local brain = require "brains/mermfisherbrain"
    inst:SetBrain(brain)

    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    -- 钓鱼系统
    inst:AddComponent("fishingrod")
    inst.components.fishingrod:SetWaitTimes(4, 40)
    inst.components.fishingrod:SetStrainTimes(0, 5)

    inst:AddComponent("finiteuses")

    inst:ListenForEvent("fishingcollect", oncollect)

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.MERMNAMES
    inst.components.named:PickNewName()

    inst.CanFish = true
end

local function oneatfish(inst, data)
    if inst.components.sleeper then
        inst.components.sleeper:GoToSleep()
    end
end

local function master_post_pirate(inst)
    inst:SetStateGraph("SGmermfisher")
    local brain = require "brains/mermpiratebrain"
    inst:SetBrain(brain)

    inst.components.combat:SetRetargetFunction(1, RetargetpirateFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetpirateFn)

    -- 覆盖血量
    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH + 100)

    -- 钓鱼系统
    inst:AddComponent("fishingrod")
    inst.components.fishingrod:SetWaitTimes(4, 40)
    inst.components.fishingrod:SetStrainTimes(0, 5)

    inst:AddComponent("finiteuses")

    inst:ListenForEvent("fishingcollect", oncollect)
    inst:ListenForEvent("oneat", oneatfish)

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.MERMNAMES
    inst.components.named:PickNewName()

    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })

    inst.CanFish = true
end


local function common_common(inst)
    inst.AnimState:SetBuild("merm_trader1_build")
    inst.build = "merm_trader1_build"
end

local function common_common2(inst)
    inst.AnimState:SetBuild("merm_trader2_build")
    inst.build = "merm_trader2_build"
end

local function common_common3(inst)
    inst.AnimState:SetBuild("merm_fisherman_build")
    inst.build = "merm_fisherman_build"
end

local function common_pirate(inst)
    inst.AnimState:SetBuild("merm_fisherman_build")
    inst.build = "merm_fisherman_build"
    inst.AnimState:OverrideSymbol("pig_torso", "mermpirate", "pig_torso")
    inst.AnimState:OverrideSymbol("pig_arm", "mermpirate", "pig_arm")
    inst.AnimState:OverrideSymbol("pig_cheeks", "mermpirate", "pig_cheeks")
    inst.AnimState:OverrideSymbol("pig_head", "mermpirate", "pig_head")
    inst.AnimState:OverrideSymbol("pig_leg", "mermpirate", "pig_leg")
    inst.AnimState:OverrideSymbol("pig_ear", "mermpirate", "pig_ear")
end

return MakeMerm("merm1", common_common, master_post),
    MakeMerm("merm2", common_common2, master_post),
    MakeMerm("mermfisher", common_common3, master_post2),
    MakeMerm("mermfisherpirate", common_pirate, master_post_pirate)
