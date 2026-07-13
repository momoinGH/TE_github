local brain = require "brains/spiderbrain"

local SPIDER_ASSETS = {
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/ds_spider_snow.zip"),
    Asset("ANIM", "anim/ds_spidersnow2.zip"),
    Asset("SOUND", "sound/spider.fsb"),
    Asset("ANIM", "anim/spider_frost.zip"),
}

local SPIDER_PREFABS = {
    "spidergland",
    "monstermeat",
    "silk",
    "spider_web_spit",
    "snowspider_spike",
    "snowspider_spike2",
}

local function ShouldAcceptItem(inst, item, giver)
    local in_inventory = inst.components.inventoryitem.owner ~= nil
    if in_inventory and not inst.components.eater:CanEat(item) then
        return false, "SPIDERNOHAT"
    end

    return (giver:HasTag("spiderwhisperer") and inst.components.eater:CanEat(item)) or
        (item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD)
end

local SPIDER_TAGS = { "spider" }
local SPIDER_IGNORE_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function GetOtherSpiders(inst, radius, tags)
    tags = tags or SPIDER_TAGS
    local x, y, z = inst.Transform:GetWorldPosition()
    local spiders = TheSim:FindEntities(x, y, z, radius, nil, SPIDER_IGNORE_TAGS, tags)
    local valid_spiders = {}
    for _, spider in ipairs(spiders) do
        if spider:IsValid() and not spider.components.health:IsDead() and not spider:HasTag("playerghost") then
            table.insert(valid_spiders, spider)
        end
    end
    return valid_spiders
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.eater:CanEat(item) then
        inst.components.eater:Eat(item)

        if inst.components.inventoryitem.owner ~= nil then
            inst.sg:GoToState("idle")
        else
            inst.sg:GoToState("eat", true)
        end

        local playedfriendsfx = false
        if inst.components.combat.target == giver then
            inst.components.combat:SetTarget(nil)
        elseif giver.components.leader ~= nil and
            inst.components.follower ~= nil then
            if giver.components.minigame_participator == nil then
                giver:PushEvent("makefriend")
                giver.components.leader:AddFollower(inst)
                playedfriendsfx = true
            end
        end

        if giver.components.leader ~= nil then
            local spiders = GetOtherSpiders(inst, 15)
            local maxSpiders = TUNING.SPIDER_FOLLOWER_COUNT

            for i, v in ipairs(spiders) do
                if v ~= inst then
                    if maxSpiders <= 0 then
                        break
                    end

                    local effectdone = true

                    if v.components.combat.target == giver then
                        v.components.combat:SetTarget(nil)
                    elseif giver.components.leader ~= nil and
                        v.components.follower ~= nil and
                        v.components.follower.leader == nil then
                        if not playedfriendsfx then
                            giver:PushEvent("makefriend")
                            playedfriendsfx = true
                        end
                        giver.components.leader:AddFollower(v)
                    else
                        effectdone = false
                    end

                    if effectdone then
                        maxSpiders = maxSpiders - 1

                        if v.components.sleeper:IsAsleep() then
                            v.components.sleeper:WakeUp()
                        end
                    end
                end
            end
        end
    elseif item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("taunt")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function HasFriendlyLeader(inst, target)
    local leader = inst.components.follower.leader
    local target_leader = (target.components.follower ~= nil) and target.components.follower.leader or nil

    if leader ~= nil and target_leader ~= nil then
        if target_leader.components.inventoryitem then
            target_leader = target_leader.components.inventoryitem:GetGrandOwner()
            if target_leader == nil then
                return true
            end
        end

        local PVP_enabled = TheNet:GetPVPEnabled()
        return leader == target or (target_leader ~= nil
                and (target_leader == leader or (target_leader:HasTag("player")
                    and not PVP_enabled))) or
            (target.components.domesticatable and target.components.domesticatable:IsDomesticated()
                and not PVP_enabled) or
            (target.components.saltlicker and target.components.saltlicker.salted
                and not PVP_enabled)
    elseif target_leader ~= nil and target_leader.components.inventoryitem then
        target_leader = target_leader.components.inventoryitem:GetGrandOwner()
        return target_leader ~= nil and target_leader:HasTag("spiderwhisperer")
    end

    return false
end

local TARGET_MUST_TAGS = { "_combat", "character" }
local TARGET_CANT_TAGS = { "spiderwhisperer", "spiderdisguise", "INLIMBO" }

local function FindTarget(inst, radius)
    if not inst.no_targeting then
        return FindEntity(
            inst,
            SpringCombatMod(radius),
            function(guy)
                return (not inst.bedazzled and (not guy:HasTag("monster") or guy:HasTag("player")))
                    and inst.components.combat:CanTarget(guy)
                    and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
                    and not HasFriendlyLeader(inst, guy)
                    and not (inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("player")
                        and guy:HasTag("player") and not TheNet:GetPVPEnabled())
            end,
            TARGET_MUST_TAGS,
            TARGET_CANT_TAGS
        )
    end
end

local function NormalRetarget(inst)
    return FindTarget(inst,
        inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or
        TUNING.SPIDER_TARGET_DIST)
end

local function WarriorRetarget(inst)
    return FindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
end

local function keeptargetfn(inst, target)
    return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and not (inst.components.follower ~= nil and
            (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

local function BasicWakeCheck(inst)
    return inst.components.combat:HasTarget()
        or (inst.components.homeseeker ~= nil and inst.components.homeseeker:HasHome())
        or inst.components.burnable:IsBurning()
        or inst.components.freezable:IsFrozen()
        or inst.components.health.takingfiredamage
        or inst.components.follower:GetLeader() ~= nil
        or inst.summoned
end

local function ShouldSleep(inst)
    return TheWorld.state.iscaveday and not BasicWakeCheck(inst)
end

local function ShouldWake(inst)
    return not TheWorld.state.iscaveday
        or BasicWakeCheck(inst)
        or (inst:HasTag("spider_warrior") and
            FindTarget(inst, TUNING.SPIDER_WARRIOR_WAKE_RADIUS) ~= nil)
end

local function DoReturn(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home ~= nil and
        home.components.childspawner ~= nil and
        not (inst.components.follower ~= nil and
            inst.components.follower.leader ~= nil) then
        home.components.childspawner:GoHome(inst)
    end
end

local function OnIsCaveDay(inst, iscaveday)
    if not iscaveday then
        inst.components.sleeper:WakeUp()
    elseif inst:IsAsleep() then
        DoReturn(inst)
    end
end

local function OnEntitySleep(inst)
    if TheWorld.state.iscaveday then
        DoReturn(inst)
    end
end

local SPIDERDEN_TAGS = { "spiderden" }
local function SummonFriends(inst, attacker)
    local radius = (inst.prefab == "spider" or inst.prefab == "spider_warrior") and
        SpringCombatMod(TUNING.SPIDER_SUMMON_WARRIORS_RADIUS) or
        TUNING.SPIDER_SUMMON_WARRIORS_RADIUS

    local den = GetClosestInstWithTag(SPIDERDEN_TAGS, inst, radius)

    if den ~= nil and den.components.combat ~= nil and den.components.combat.onhitfn ~= nil then
        den.components.combat.onhitfn(den, attacker)
    end
end

local function OnAttacked(inst, data)
    if inst.no_targeting then
        return
    end

    inst.defensive = false
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        local should_share = dude:HasTag("spider")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            and dude.components.follower.leader == inst.components.follower.leader

        if should_share and dude.defensive and not dude.no_targeting then
            dude.defensive = false
        end

        return should_share
    end, 10)
end

local function OnTrapped(inst, data)
    inst.components.inventory:DropEverything()
end

local function OnEat(inst, data)
    if data.food.components.spidermutator and data.food.components.spidermutator:CanMutate(inst) then
        data.food.components.spidermutator:Mutate(inst)
    end
end

local function OnGoToSleep(inst)
    inst.components.inventoryitem.canbepickedup = true
end

local function OnWakeUp(inst)
    if inst.components.follower.leader == nil then
        inst.components.inventoryitem.canbepickedup = false
    end
end

local function OnDropped(inst, data)
    if ShouldWake(inst) then
        inst.sg:GoToState("idle")
    elseif ShouldSleep(inst) then
        inst.sg:GoToState("sleep")
    end
end

local function CalcSanityAura(inst, observer)
    if observer:HasTag("spiderwhisperer") or inst.bedazzled or
        (inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("spiderwhisperer")) then
        return 0
    end
    return inst.components.sanityaura.aura
end

local function SoundPath(inst, event)
    local creature = "spider"
    if inst:HasTag("spider_healer") then
        return "webber1/creatures/spider_cannonfodder/" .. event
    elseif inst:HasTag("spider_moon") then
        return "turnoftides/creatures/together/spider_moon/" .. event
    elseif inst:HasTag("spider_warrior") then
        creature = "spiderwarrior"
    elseif inst:HasTag("spider_hider") or inst:HasTag("spider_spitter") then
        creature = "cavespider"
    else
        creature = "spider"
    end
    return "dontstarve/creatures/" .. creature .. "/" .. event
end

local variations = { 1, 2, 3, 4, 5 }

local function DoSpikeAttack(inst, pt)
    local x, y, z = pt:Get()
    local inital_r = 1
    x = GetRandomWithVariance(x, inital_r)
    z = GetRandomWithVariance(z, inital_r)

    shuffleArray(variations)

    local num = math.random(2, 4)
    local dtheta = PI * 2 / num
    local thetaoffset = math.random() * PI * 2
    local delaytoggle = 0
    for i = 1, num do
        local r = 1.1 + math.random() * 1.75
        local theta = i * dtheta + math.random() * dtheta * 0.8 + dtheta * 0.2
        local x1 = x + r * math.cos(theta)
        local z1 = z + r * math.sin(theta)
        if TheWorld.Map:IsVisualGroundAtPoint(x1, 0, z1) and not TheWorld.Map:IsPointNearHole(Vector3(x1, 0, z1)) then
            local spike = SpawnPrefab(inst.spike_prefab)
            spike.Transform:SetPosition(x1, 0, z1)
            spike:SetOwner(inst)
            if variations[i + 1] ~= 1 then
                spike.AnimState:OverrideSymbol("spike01", inst.spike_symbol_build, "spike0" .. tostring(variations[i + 1]))
            end
        end
    end
end

---创建雪蜘蛛
---data参数：
---build 动画build名
---spike_prefab 尖刺prefab名
---spike_symbol_build 尖刺动画符号build
---spider_moon_init 月蜘蛛初始化函数（可选）
local function MakeSpiderSnow(name, data)
    data = data or {}

    local function SetHappyFace(inst, is_happy)
        if is_happy then
            inst.AnimState:OverrideSymbol("face", inst.build, "happy_face")
        else
            inst.AnimState:ClearOverrideSymbol("face")
        end
    end

    local function OnStartLeashing(inst, data_event)
        inst:SetHappyFace(true)
        if inst.recipe then
            local leader = inst.components.follower.leader
            if leader.components.builder and not leader.components.builder:KnowsRecipe(inst.recipe) and leader.components.builder:CanLearn(inst.recipe) then
                leader.components.builder:UnlockRecipe(inst.recipe)
            end
        end
    end

    local function OnStopLeashing(inst, data_event)
        inst.defensive = false
        inst.no_targeting = false
        if not inst.bedazzled then
            inst:SetHappyFace(false)
        end
    end

    local function create_common(bank, tag, common_init)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        MakeCharacterPhysics(inst, 10, .5)

        inst.DynamicShadow:SetSize(1.5, .5)
        inst.Transform:SetFourFaced()

        inst:AddTag("cavedweller")
        inst:AddTag("monster")
        inst:AddTag("hostile")
        inst:AddTag("scarytoprey")
        inst:AddTag("canbetrapped")
        inst:AddTag("smallcreature")
        inst:AddTag("spider")
        inst:AddTag("drop_inventory_pickup")
        inst:AddTag("drop_inventory_murder")
        inst:AddTag("walrus")
        inst:AddTag("houndfriend")

        if tag ~= nil then
            inst:AddTag(tag)
        end

        inst:AddTag("trader")

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("idle")

        if common_init ~= nil then
            common_init(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -- 存储实例级配置
        inst.build = data.build
        inst.spike_prefab = data.spike_prefab
        inst.spike_symbol_build = data.spike_symbol_build
        inst.SetHappyFace = SetHappyFace

        inst.OnEntitySleep = OnEntitySleep

        inst:AddComponent("locomotor")
        inst.components.locomotor:SetSlowMultiplier(1)
        inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor.pathcaps = { ignorecreep = true }
        inst.components.locomotor:SetAllowPlatformHopping(true)

        inst:AddComponent("embarker")
        inst:AddComponent("drownable")

        inst:SetStateGraph("SGspider")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddRandomLoot("monstermeat", 1)
        inst.components.lootdropper:AddRandomLoot("silk", .5)
        inst.components.lootdropper:AddRandomLoot("spidergland", .5)
        inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
        inst.components.lootdropper.numrandomloot = 1

        MakeMediumBurnableCharacter(inst, "body")
        MakeMediumFreezableCharacter(inst, "body")
        inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY

        inst:AddComponent("health")
        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "body"
        inst.components.combat:SetKeepTargetFunction(keeptargetfn)
        inst.components.combat:SetOnHit(SummonFriends)
        inst.components.combat:SetHurtSound("dontstarve/creatures/cavespider/hit_response")
        inst:AddComponent("follower")

        inst:AddComponent("sleeper")
        inst.components.sleeper.watchlight = true
        inst.components.sleeper:SetResistance(2)
        inst.components.sleeper:SetSleepTest(ShouldSleep)
        inst.components.sleeper:SetWakeTest(ShouldWake)

        inst:AddComponent("knownlocations")

        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
        inst.components.eater:SetCanEatHorrible()
        inst.components.eater:SetStrongStomach(true)

        inst:AddComponent("inspectable")

        inst:AddComponent("inventory")
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader:SetAbleToAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem
        inst.components.trader.deleteitemonaccept = false

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.nobounce = true
        inst.components.inventoryitem.canbepickedup = false
        inst.components.inventoryitem.canbepickedupalive = true

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aurafn = CalcSanityAura

        inst:AddComponent("debuffable")

        MakeFeedableSmallLivestock(inst, TUNING.SPIDER_PERISH_TIME)
        MakeHauntablePanic(inst)

        inst:SetBrain(brain)

        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("startleashing", OnStartLeashing)
        inst:ListenForEvent("stopleashing", OnStopLeashing)
        inst:ListenForEvent("ontrapped", OnTrapped)
        inst:ListenForEvent("oneat", OnEat)
        inst:ListenForEvent("gotosleep", OnGoToSleep)
        inst:ListenForEvent("onwakeup", OnWakeUp)
        inst:ListenForEvent("ondropped", OnDropped)

        inst:WatchWorldState("iscaveday", OnIsCaveDay)
        OnIsCaveDay(inst, TheWorld.state.iscaveday)

        inst.SoundPath = SoundPath
        inst.incineratesound = SoundPath(inst, "die")

        return inst
    end

    local function spider_moon_common_init(inst)
        inst.Transform:SetScale(1.25, 1.25, 1.25)
    end

    local function create_moon()
        local inst = create_common("spider_moon", "spider_moon", data.spider_moon_init or spider_moon_common_init)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.DoSpikeAttack = DoSpikeAttack

        inst.components.health:SetMaxHealth(TUNING.SPIDER_MOON_HEALTH)
        inst.components.combat:SetDefaultDamage(TUNING.SPIDER_MOON_DAMAGE)
        inst.components.combat:SetAttackPeriod(TUNING.SPIDER_MOON_ATTACK_PERIOD)
        inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE, TUNING.SPIDER_WARRIOR_HIT_RANGE)
        inst.components.combat:SetRetargetFunction(1, WarriorRetarget)
        inst.components.combat:SetHurtSound("turnoftides/creatures/together/spider_moon/hit_response")

        inst.components.locomotor.walkspeed = TUNING.SPIDER_HIDER_WALK_SPEED
        inst.components.locomotor.runspeed = TUNING.SPIDER_HIDER_RUN_SPEED

        inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
        return inst
    end

    return Prefab(name, create_moon, SPIDER_ASSETS, SPIDER_PREFABS)
end

return MakeSpiderSnow("spider_snow", {
        build = "ds_spider_snow",
        spike_prefab = "snowspider_spike",
        spike_symbol_build = "spider_frost",
    }),
    MakeSpiderSnow("spider_snow2", {
        build = "ds_spidersnow2",
        spike_prefab = "snowspider_spike2",
        spike_symbol_build = "spiderfrost2",
    })
