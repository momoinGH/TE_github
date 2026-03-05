local RoomUtils = require("tropical_utils/room_utils")

local assets =
{
    Asset("SOUND", "sound/pig.fsb"),
    Asset("ANIM", "anim/pig_usher.zip"),
    Asset("ANIM", "anim/pig_mayor.zip"),
    Asset("ANIM", "anim/pig_miner.zip"),
    Asset("ANIM", "anim/pig_queen.zip"),
    Asset("ANIM", "anim/pig_farmer.zip"),
    Asset("ANIM", "anim/pig_hunter.zip"),
    Asset("ANIM", "anim/pig_banker.zip"),
    Asset("ANIM", "anim/pig_florist.zip"),
    Asset("ANIM", "anim/pig_erudite.zip"),
    Asset("ANIM", "anim/pig_hatmaker.zip"),
    Asset("ANIM", "anim/pig_mechanic.zip"),
    Asset("ANIM", "anim/pig_professor.zip"),
    Asset("ANIM", "anim/pig_collector.zip"),
    Asset("ANIM", "anim/townspig_basic.zip"),
    Asset("ANIM", "anim/pig_beautician.zip"),
    Asset("ANIM", "anim/pig_royalguard.zip"),
    Asset("ANIM", "anim/pig_storeowner.zip"),
    Asset("ANIM", "anim/townspig_attacks.zip"),
    Asset("ANIM", "anim/townspig_actions.zip"),
    Asset("ANIM", "anim/pig_royalguard_2.zip"),
    Asset("ANIM", "anim/townspig_shop_wip.zip"),
}

local prefabs =
{
    "meat",
    "poop",
    "tophat",
    "pigskin",
    "halberd",
    "strawhat",
    "monstermeat",
    "pigcrownhat",
    "pig_scepter",
    "pigman_shopkeeper_desk",
    "pedestal_key",
    "firecrackers",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function getSpeechType(inst, speech)
    local line = speech.DEFAULT

    if inst.talkertype and speech[inst.talkertype] then
        line = speech[inst.talkertype]
    end

    if type(line) == "table" then
        line = line[math.random(#line)]
    end

    return line
end

local function shopkeeper_speech(inst, speech)
    if not inst.components.combat.target and not inst:IsInLimbo() then
        inst.components.talker:Say(speech)
    end
end

local function spawndesk(inst, spawndesk)
    if spawndesk then
        local desk = SpawnPrefab("pigman_shopkeeper_desk")
        desk.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.components.entitytracker:TrackEntity("home", desk)
    else
        local desk = inst.components.entitytracker:GetEntity("home")
        if desk then
            inst.components.entitytracker:ForgetEntity("home")
            desk:Remove()
        end
    end
end

local function separatedesk(inst, separate)
    if separate then
        inst:RemoveTag("atdesk")
        inst.AnimState:Hide("desk")
        spawndesk(inst, true)
        ChangeToCharacterPhysics(inst)
        inst.Physics:SetMass(50)
    else
        ChangeToObstaclePhysics(inst)
        local desk = inst.components.entitytracker:GetEntity("home")
        if desk then
            local x, y, z = desk.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x, y, z)
        end
        spawndesk(inst, false)
        inst:AddTag("atdesk")
        inst.AnimState:Show("desk")
    end
end

local function ontalk(inst, script, mood)
    if inst:HasTag("guard") then
        if mood and mood == "alarmed" then
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/guard_alert")
        else
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd", "talk")
        end
    else
        if inst.female then
            if mood and mood == "alarmed" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream_female")
            else
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_female", "talk")
            end
        else
            if mood and mood == "alarmed" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream")
            else
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk", "talk")
            end
        end
    end
end


local function CalcSanityAura(inst, observer)
    if inst.components.werebeast
        and inst.components.werebeast:IsInWereState() then
        return -TUNING.SANITYAURA_LARGE
    end

    if inst.components.follower and inst.components.follower.leader == observer then
        return TUNING.SANITYAURA_SMALL
    end

    return 0
end

local function getstatus(inst)
    if inst:HasTag("guard") then
        return "GUARD"
    elseif inst.components.follower.leader ~= nil then
        return "FOLLOWER"
    end
end

local function special_action(inst)
    if inst.daily_gifting then
        inst.sg:GoToState("daily_gift")
    elseif inst.poop_tip then
        inst.sg:GoToState("poop_tip")
    elseif inst:HasTag("paytax") then
        inst.sg:GoToState("pay_tax")
    end
end

--- 当皇家守卫因脱离加载消失时减少老板重新召唤的冷却，防止玩家通过离开加载范围卡bug
local function vanishfn(inst)
    local owner = inst.components.entitytracker:GetEntity("owner")
    local left = owner and owner.components.timer:GetTimeLeft("guards_called")
    if left then
        owner.components.timer:StopTimer("guards_called")
        if left - 30 > 0 then
            owner.components.timer:StartTimer("guards_called", left - 60)
        end
    end
end

local function GuardSetTemp(inst)
    inst.temp_spawn = true
    inst:AddComponent("vanish_on_sleep")
    inst.components.vanish_on_sleep.vanishfn = vanishfn
end

local function OnSave(inst, data)
    data.children = {}

    if inst:HasTag("atdesk") then
        data.atdesk = true
    end

    data.temp_spawn = inst.temp_spawn

    if inst:HasTag("angry_at_player") then
        data.angryatplayer = true
    end

    if inst.equipped then
        data.equipped = true
    end

    if inst:HasTag("recieved_trinket") then
        data.recieved_trinket = true
    end

    if inst:HasTag("paytax") then
        data.paytax = true
    end

    if inst.daily_gift then
        data.daily_gift = inst.daily_gift
    end

    if data.children and #data.children > 0 then
        return data.children
    end
end

local function OnLoad(inst, data)
    if not data then return end

    if data.atdesk then
        inst.sg:GoToState("desk")
    end

    if data.temp_spawn then
        GuardSetTemp(inst)
    end

    if data.equipped then
        inst.equipped = true
    end

    if data.angryatplayer then
        inst:AddTag("angry_at_player")
    end

    if data.recieved_trinket then
        inst:AddTag("recieved_trinket")
    end

    if data.paytax then
        inst:AddTag("paytax")
    end

    if data.daily_gift then
        inst.daily_gift = data.daily_gift
    end
end

local function ShouldAcceptItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        return false
    end

    if item.components.unwrappable then
        return true
    end

    if inst.components.eater:CanEat(item) then
        if (item.components.edible.foodtype == FOODTYPE.MEAT or item.components.edible.foodtype == "HORRIBLE")
            and inst.components.follower.leader
            and inst.components.follower:GetLoyaltyPercent() > 0.9 then
            return false
        end

        if (item.components.edible.foodtype == FOODTYPE.VEGGIE or item.components.edible.foodtype == FOODTYPE.RAW) then
            local econ = TheWorld.components.economy
            local econprefab = inst.prefab
            if inst.econprefab then
                econprefab = inst.econprefab
            end
            local wanteditems = econ:GetTradeItems(econprefab)
            local wantitem = false
            for i, wanted in ipairs(wanteditems or {}) do
                if wanted == item.prefab then
                    wantitem = true
                    break
                end
            end

            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            if not wantitem and last_eat_time and last_eat_time < TUNING.PIG_MIN_POOP_PERIOD then
                return false
            end

            if inst.components.inventory:Has(item.prefab, 1) then
                return false
            end
        end
    end

    if item:HasTag("oinc") then
        return true
    end

    if not inst:HasTag("guard") then
        local city = 1
        if inst:HasTag("city2") then
            city = 2
        end
        local econ = TheWorld.components.economy

        local econprefab = inst.prefab
        if inst.econprefab then
            econprefab = inst.econprefab
        end

        local wanteditems = econ:GetTradeItems(econprefab)
        local desc = econ:GetTradeItemDesc(econprefab)
        --local wantednum =   econ:GetNumberWanted(econprefab,city)

        local wantitem = false
        for i, wanted in ipairs(wanteditems) do
            if wanted == item.prefab then
                wantitem = true
                break
            end
        end
        print(item.prefab, inst.prefab)
        if item.prefab == "purplegem" and (inst.prefab == "pigman_banker" or inst.prefab == "pigman_banker_shopkeep") then
            inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_PURPLEGEM))
            return false
        end

        if (item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3") and inst:HasTag("city1") and not inst:HasTag("recieved_trinket") then
            wantitem = true
        end

        if (item.prefab == "relic_4" or item.prefab == "relic_5") and not inst:HasTag("pigqueen") then
            wantitem = false
        end

        if wantitem then
            if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" then
                return true
            end

            local delay = econ:GetDelay(econprefab, city, inst)
            if delay > 0 then
                if delay == 1 then
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY_TOMORROW))
                else
                    inst.components.talker:Say(string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY), tostring(delay)))
                end
                return false
            else
                return true
            end
        else
            if item:HasTag("relic") then
                if item.prefab == "relic_4" or item.prefab == "relic_5" then
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_PRICELESS_GIFT))
                else
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_RELIC_GIFT))
                end
            else
                if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" and inst:HasTag("city1") then
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_TRINKET_GIFT))
                else
                    --HUGO
                    inst.components.talker:Say(string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT), desc))
                end
            end
            return false
        end
    end

    if inst:HasTag("guard") then
        if item:HasTag("securitycontract") then
            return true
        end
    end

    return false
end

---Runar: 打包交易,TE未测试
local Trinkets = { "kabobs", "pumpkincookie", "taffy", "oinc", "butterflymuffin", "powcake" }
local function OnAccept(inst, doer, item)
    --- Trade items init
    local Items = {}
    local RewardList = {}
    if item.components.unwrappable == nil then
        Items[item] = true
    else
        if item.prefab == "bundle" then
            RewardList["waxpaper"] = 1
        end
        for _, v in ipairs(item.components.unwrappable.itemdata) do
            local tradeitem = SpawnPrefab(v.prefab, v.skinname, v.skin_id)
            tradeitem:SetPersistData(v.data)
            Items[tradeitem] = true
        end
    end

    --- Sp trade actions
    if inst:HasTag("guard") then
        for item in pairs(Items) do
            if item:HasTag("securitycontract") then
                inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
                doer.components.leader:AddFollower(inst)
                inst.components.follower:AddLoyaltyTime(TUNING.PIG_LOYALTY_MAXTIME)
                Items[item] = false
                break
            end
        end
    elseif inst:HasTag("pigqueen") then
        local behappy = false
        for item in pairs(Items) do
            if item.prefab == "pigcrownhat" or item.prefab == "pig_scepter" then
                inst.components.inventory:Equip(SpawnPrefab(item.prefab))
                behappy = true
            elseif item.prefab == "relic_4" or item.prefab == "relic_5" then
                behappy = true
            end
        end
        if behappy then
            inst:PushEvent("behappy")
        end
    end

    --- Handle trade
    if not inst:HasTag("guard") then
        local city = inst:HasTag("city2") and 2 or 1
        local economy = TheWorld.components.economy
        local econprefab = inst.econprefab or inst.prefab

        local TradeItems = economy:GetTradeItems(econprefab)
        local desc = economy:GetTradeItemDesc(econprefab)

        for item in pairs(Items) do
            if not inst:HasTag("pigqueen") and (item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" and inst:HasTag("city1")) then
                inst:AddTag("recieved_trinket")
                inst:sayline(getSpeechType(inst, STRINGS.CITY_PIG_TALK_GIVE_TRINKET_REWARD))
                local reward = Trinkets[math.random(1, #Trinkets)]
                RewardList[reward] = (RewardList[reward] or 0) + 1
                Items[item] = false
            else
                for _, tradeitem in ipairs(TradeItems or {}) do
                    if tradeitem == item.prefab then
                        local reward, quanty = economy:MakeTrade(econprefab, city, inst, item.prefab)
                        if reward then
                            inst:AddTag("troqueihoje")
                            inst:sayline(string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_GIVE_REWARD),
                                tostring(1), desc))
                            if item.components.stackable then
                                quanty = quanty * item.components.stackable.stacksize
                            end
                            RewardList[reward] = (RewardList[reward] or 0) + quanty
                            Items[item] = false
                        end
                        break
                    end
                end
            end
        end
    end

    --- Give rewards
    for item, give in pairs(Items) do
        if give then
            doer.components.inventory:GiveItem(item, nil,
                inst:GetPosition())
        else
            item:Remove()
        end
    end
    RewardList["oinc100"] = (RewardList["oinc100"] or 0) + math.floor((RewardList["oinc10"] or 0) / 10) + math.floor((RewardList["oinc"] or 0) / 100)
    RewardList["oinc10"] = (RewardList["oinc10"] or 0) % 10 + math.floor((RewardList["oinc"] or 0) % 100 / 10)
    RewardList["oinc"] = (RewardList["oinc"] or 0) % 10
    for reward, amount in pairs(RewardList) do
        while amount > 0 do
            local p = SpawnPrefab(reward)
            if p.components.stackable then
                local sz = math.clamp(amount, 1, p.components.stackable.maxsize)
                p.components.stackable:SetStackSize(sz)
                amount = amount - sz
            else
                amount = amount - 1
            end
            doer.components.inventory:GiveItem(p, nil, inst:GetPosition())
        end
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnEat(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT
        and inst.components.werebeast
        and not inst.components.werebeast:IsInWereState() then
        if food.components.edible:GetHealth() < 0 then
            inst.components.werebeast:TriggerDelta(1)
        end
    end

    if food.components.edible.foodtype == FOODTYPE.VEGGIE then --or food.components.edible.foodtype == FOODTYPE.SEEDS) then
        SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end

local function OnAttackedByDecidRoot(inst, attacker)
    local fn = function(dude) return dude:HasTag("pig") and not dude:HasTag("werepig") and not dude:HasTag("guard") end

    local x, y, z = inst.Transform:GetWorldPosition()
    local radius = TheWorld.state.isspring and ((SHARE_TARGET_DIST * TUNING.SPRING_COMBAT_MOD) / 2) or (SHARE_TARGET_DIST / 2)
    local num_helpers = 0
    for k, v in pairs(TheSim:FindEntities(x, y, z, radius)) do
        if v ~= inst and v.components.combat and not (v.components.health and v.components.health:IsDead()) and fn(v) then
            if v:PushEvent("suggest_tree_target", { tree = attacker }) then
                num_helpers = num_helpers + 1
            end
        end
        if num_helpers >= MAX_TARGET_SHARES then
            break
        end
    end
end

local function callGuards(inst, attacker, id)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, RoomUtils.RADIUS, { "interior_door" })
    if #ents > 0 then
        local guardprefab = inst:HasTag("city2") and "pigman_royalguard_2" or "pigman_royalguard"
        local guard = SpawnPrefab(guardprefab)
        local door = ents[math.random(#ents)]
        guard.Transform:SetPosition(door.Transform:GetWorldPosition())
        guard:PushEvent("attacked", { attacker = attacker, damage = 0 })
        guard:SetTemp() --临时的

        door.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
        inst.components.entitytracker:TrackEntity("guard" .. id, guard)
        guard.components.entitytracker:TrackEntity("owner", inst)
    end
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    if not attacker then return end
    inst:ClearBufferedAction()

    if attacker.prefab == "deciduous_root" and attacker.owner then
        OnAttackedByDecidRoot(inst, attacker.owner)
    elseif attacker.prefab ~= "deciduous_root" then
        inst.components.combat:SetTarget(attacker)

        if inst:HasTag("guard") then
            if attacker:HasTag("player") then
                inst:AddTag("angry_at_player")
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("pig") and (dude:HasTag("guard") or not attacker:HasTag("pig")) end,
                MAX_TARGET_SHARES)
        else
            if not (attacker:HasTag("pig") and attacker:HasTag("guard")) then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("pig") end, MAX_TARGET_SHARES)
            end
        end
    end

    if (inst:HasTag("shopkeep") or inst:HasTag("pigqueen"))
        and not inst.components.timer:TimerExists("guards_called")
        and not inst.components.entitytracker:GetEntity("guard1")
        and not inst.components.entitytracker:GetEntity("guard2")
    then
        inst:DoTaskInTime(math.random(1) + 1, function()
            callGuards(inst, attacker, 1)
        end)
        inst:DoTaskInTime(math.random(1) + 1.5, function()
            callGuards(inst, attacker, 2)
            inst.components.timer:StartTimer("guards_called", 120)
        end)
    end
end

local function OnGoToSleep(inst)
    inst:AddTag("sleeping") --我需要在客机检查老板是否睡着
end

local function OnWakeUp(inst)
    inst:RemoveTag("sleeping")
end

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.CITY_PIG_GUARD_TARGET_DIST,
        function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                if guy and guy:HasTag("player") and inst:HasTag("angry_at_player") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not (inst.components.combat.target and inst.components.combat.target:HasTag("player")) then
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
                    --inst.components.talker:Say( getSpeechType(inst,STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER) )
                end

                return (guy:HasTag("monster") or (guy:HasTag("player") and inst:HasTag("angry_at_player"))) and guy.components.health and not guy.components.health:IsDead() and
                    inst.components.combat:CanTarget(guy) and not
                    (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
            end
        end)
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
        and (not target.LightWatcher or target.LightWatcher:IsInLight())
        and not (target.sg and target.sg:HasStateTag("transform"))
end

local function NormalShouldSleep(inst)
    if inst.components.follower and inst.components.follower.leader then
        local fire = FindEntity(inst, 6, function(ent)
            return ent.components.burnable
                and ent.components.burnable:IsBurning()
        end, { "campfire" })
        return DefaultSleepTest(inst) and fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
    else
        return DefaultSleepTest(inst)
    end
end

local brain = require "brains/citypigbrain"

local function SetNormalPig(inst)
    inst:RemoveTag("werepig")
    inst:RemoveTag("guard")

    inst:SetBrain(brain)
    inst:SetStateGraph("SGpig_city")

    inst.components.sleeper:SetResistance(2)

    inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)

    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED

    inst.components.sleeper:SetSleepTest(NormalShouldSleep)
    inst.components.sleeper:SetWakeTest(DefaultWakeTest)

    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat", 3)
    inst.components.lootdropper:AddRandomLoot("pigskin", 1)
    inst.components.lootdropper.numrandomloot = 1

    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)

    inst:ListenForEvent("suggest_tree_target", function(inst, data)
        if data and data.tree and inst:GetBufferedAction() ~= ACTIONS.CHOP then
            inst.tree_target = data.tree
        end
    end)

    -- 给予猪币取消仇恨
    inst:ListenForEvent("itemget",
        function(inst, data)
            if data.item:HasTag("oinc") and inst:HasTag("angry_at_player") then
                inst.bribe_count = (inst.bribe_count or 0) + data.item:GetOincAllValue()
                local bribe_threshold = inst:HasTag("guard") and 10 or 1
                if inst.bribe_count >= bribe_threshold then
                    inst:RemoveTag("angry_at_player")
                    if inst.components.combat and inst.components.combat.target and inst.components.combat.target:HasTag("player") then
                        inst.components.combat:GiveUp()
                    end

                    inst.bribe_count = nil
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_FORGIVE_PLAYER))
                else
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_NOT_ENOUGH))
                end
            end
        end)

    inst.components.trader:Enable()
    inst.components.talker:StopIgnoringAll()
end

local function NormalGuardWeapon(item)
    if item.components.fueled then
        item.components.fueled.rate = 1
    elseif item.components.finiteuses then
        item.components.finiteuses.onfinished = nil
    end
end

local function throwcrackers(inst)
    local cracker = SpawnPrefab("firecrackers")
    inst.components.inventory:GiveItem(cracker)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local start_angle = inst.Transform:GetRotation()
    local radius = 5
    local attempts = 12

    local test_fn = function(offset)
        local ents = TheSim:FindEntities(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z, 2, nil, { "INLIMBO" })

        if #ents == 0 then
            return true
        end
    end
    local pt, new_angle = FindValidPositionByFan(start_angle, radius, attempts, test_fn)

    if new_angle then
        inst.Transform:SetRotation(new_angle / DEGREES)
    end

    local rot = inst.Transform:GetRotation() * DEGREES

    local tossdir = Vector3(0, 0, 0)
    tossdir.x = math.cos(rot)
    tossdir.z = -math.sin(rot)

    inst.components.inventory:DropItem(cracker, nil, nil, nil, nil, tossdir)
    cracker.components.fuse:StartFuse()
end


local function common(name, build, fixer, tags, sex, econprefab)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("townspig")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("desk")
    inst.AnimState:Hide("ARM_carry")

    inst.DynamicShadow:SetSize(1.5, .75)

    inst.Transform:SetFourFaced()

    inst.getSpeechType = getSpeechType
    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -600, 0)
    inst.talkertype = name

    MakeCharacterPhysics(inst, 50, .5)

    inst:AddTag("character")
    inst:AddTag("pig")
    inst:AddTag("civilized")
    inst:AddTag("scarytoprey")
    inst:AddTag("firecrackerdance")
    inst:AddTag("city_pig")
    if tags then
        for i, tag in ipairs(tags) do
            inst:AddTag(tag)
        end
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")                              -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED   --5
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED --3

    inst:AddComponent("eater")
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"

    MakeMediumBurnableCharacter(inst, "pig_torso")

    inst:AddComponent("named")
    local names = {}
    for i, v in ipairs(STRINGS.CITYPIGNAMES["UNISEX"]) do
        table.insert(names, v)
    end
    if sex then
        inst.female = sex ~= "MALE"
        for i, v in ipairs(STRINGS.CITYPIGNAMES[sex]) do
            table.insert(names, v)
        end
    end
    inst.components.named.possiblenames = names
    inst.components.named:PickNewName()

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME

    inst:AddComponent("health")
    inst:AddComponent("sleeper")
    inst:AddComponent("inventory")
    inst:AddComponent("lootdropper")
    inst:AddComponent("timer")
    inst:AddComponent("entitytracker")

    inst:AddComponent("trader")
    inst.components.trader.deleteitemonaccept = false
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnAccept
    inst.components.trader.onrefuse = OnRefuseItem

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "pig_torso")
    --------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    if econprefab then
        inst.econprefab = econprefab
        inst.components.inspectable.nameoverride = econprefab
    end

    if fixer then
        inst:AddComponent("fixer")
    end

    inst.special_action = special_action
    inst.throwcrackers = throwcrackers
    SetNormalPig(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

local function FullFiniteUses(inst)
    inst.components.finiteuses:SetPercent(1)
end

-- 生成守卫初始装备
local function SpawnInitEquip(inst)
    if inst.equipped then return end

    inst.equipped = true

    local torch = SpawnPrefab("torch")
    inst.components.inventory:GiveItem(torch)
    torch.components.fueled.rate = 0

    local axe = SpawnPrefab("halberd")
    inst.components.inventory:GiveItem(axe)
    inst.components.inventory:Equip(axe)
    axe.components.finiteuses.onfinished = FullFiniteUses

    local armour = SpawnPrefab("armorwood")
    inst.components.inventory:GiveItem(armour)
    inst.components.inventory:Equip(armour)
end

local function OnIsDay(inst, isday)
    if isday then

    else
        if TheWorld.state.isdusk then
            inst.components.talker:Say(STRINGS.CITY_PIG_GUARD_LIGHT_TORCH.DEFAULT[math.random(#STRINGS.CITY_PIG_GUARD_LIGHT_TORCH.DEFAULT)])
        end
        local axe = inst.components.inventory:FindItem(function(item) return item.prefab == "halberd" end)
        if axe then
            inst.components.inventory:Equip(axe)
        end
    end
end

local function OnGuardDropItem(inst, data)
    if data.item.prefab == "torch" or data.item.prefab == "halberd" then
        NormalGuardWeapon(data.item)
    end
end

local function OnGuardDeath(inst)
    local torch = inst.components.inventory:FindItem(function(item) return item.prefab == "torch" end)
    if torch then
        NormalGuardWeapon(torch)
    end

    local axe = inst.components.inventory:FindItem(function(item) return item.prefab == "halberd" end)
    if axe then
        NormalGuardWeapon(axe)
    end
end

local function getguardstatus(inst)
    if inst.components.sleeper:IsAsleep() then
        return "SLEEPING"
    end
end

local guard_brain = require "brains/royalpigguardbrain"

----------------------------------------------------------------------------------------------------

local function OnShopkeeperEnterRoom(inst)
    shopkeeper_speech(inst, getSpeechType(inst, STRINGS.CITY_PIG_SHOPKEEPER_GREETING))
end

local function OnShopkeeperNight(inst)
    if not inst:IsAsleep() and not inst.components.combat.target and not inst:IsInLimbo() then
        inst.sg:GoToState("idle")
        shopkeeper_speech(inst, STRINGS.CITY_PIG_SHOPKEEPER_CLOSING[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_CLOSING)])
    end
end

local function ShopkeeperSpecialAction(inst)
    inst.sg:GoToState("desk")
end

local function IniMechanic(inst)
    if not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local tool = SpawnPrefab("hammer")
        inst.components.inventory:Equip(tool)
    end
end


local function makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab)
    local function make_pig_guard()
        local inst = common(name, build, fixer, tags, sex, econprefab)

        inst:AddTag("emote_nocurtsy")
        inst:AddTag("guard")
        inst:AddTag("extinguisher")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.temp_spawn = nil
        inst.SetTemp = GuardSetTemp

        inst.components.burnable:SetBurnTime(2)

        inst:DoTaskInTime(0, SpawnInitEquip)

        inst.components.inspectable.getstatus = getguardstatus

        inst:SetBrain(guard_brain)

        inst:WatchWorldState("isday", OnIsDay)
        inst:ListenForEvent("dropitem", OnGuardDropItem)
        inst:ListenForEvent("death", OnGuardDeath)

        return inst
    end

    local function make_shopkeeper()
        local inst = common(name, build, fixer, tags, sex, econprefab)

        inst.AnimState:AddOverrideBuild("townspig_shop_wip")

        inst:AddTag("shopkeep") --有该标签才能补货

        if not TheWorld.ismastersim then
            return inst
        end

        inst.separatedesk = separatedesk
        inst.shopkeeper_speech = shopkeeper_speech

        inst.special_action = ShopkeeperSpecialAction

        inst:ListenForEvent("enterroom", OnShopkeeperEnterRoom)
        inst:WatchWorldState("isnight", OnShopkeeperNight)
        inst:ListenForEvent("gotosleep", OnGoToSleep)
        inst:ListenForEvent("onwakeup", OnWakeUp)

        return inst
    end

    local function make_mechanic()
        local inst = common(name, build, fixer, tags, sex, econprefab)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(0, IniMechanic)

        return inst
    end

    local function make_queen()
        local inst = common(name, build, fixer, tags, sex, econprefab)

        MakeCharacterPhysics(inst, 50, 0.75)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.named.possiblenames = STRINGS.QUEENPIGNAMES
        inst.components.named:PickNewName()

        return inst
    end

    local function make_mayor()
        local inst = common(name, build, fixer, tags, sex, econprefab)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.named:SetName(STRINGS.NAMES.PIGMAN_MAYOR)

        return inst
    end

    local function make_mayor_shopkeeper()
        local inst = make_shopkeeper()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.named:SetName(STRINGS.NAMES.PIGMAN_MAYOR)

        return inst
    end

    --------------------------------------------------------------------------
    local function make_common()
        return common(name, build, fixer, tags, sex, econprefab)
    end

    if name == "pigman_queen" then
        return make_queen
    elseif name == "pigman_mayor" then
        return make_mayor
    elseif name == "pigman_mayor_shopkeep" then
        return make_mayor_shopkeeper
    elseif name == "pigman_mechanic" then
        return make_mechanic
    elseif shopkeeper or name == "pigman_shopkeep" then
        return make_shopkeeper
    elseif guard_pig then
        return make_pig_guard
    else
        return make_common
    end
end

local function makepigman(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab)
    return Prefab(name, makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab), assets, prefabs)
end

--                      name                        build         fixer  guard shop tags               sex
return makepigman("pigman_beautician", "pig_beautician", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_florist", "pig_florist", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_erudite", "pig_erudite", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_hatmaker", "pig_hatmaker", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_storeowner", "pig_storeowner", nil, nil, nil, { "emote_nohat" }, "FEMALE"),
    makepigman("pigman_banker", "pig_banker", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_collector", "pig_collector", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_hunter", "pig_hunter", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_mayor", "pig_mayor", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_mechanic", "pig_mechanic", true, nil, nil, nil, "MALE"),
    makepigman("pigman_professor", "pig_professor", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_usher", "pig_usher", nil, nil, nil, nil, "MALE"),

    makepigman("pigman_royalguard", "pig_royalguard", nil, true, nil, nil, "MALE"),
    makepigman("pigman_royalguard_2", "pig_royalguard_2", nil, true, nil, nil, "MALE"),
    makepigman("pigman_farmer", "pig_farmer", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_miner", "pig_miner", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_queen", "pig_queen", nil, nil, nil, { "pigqueen", "emote_nohat" }),
    makepigman("pigman_beautician_shopkeep", "pig_beautician", nil, nil, true, nil, "FEMALE", "pigman_beautician"),
    makepigman("pigman_florist_shopkeep", "pig_florist", nil, nil, true, nil, "FEMALE", "pigman_florist"),
    makepigman("pigman_erudite_shopkeep", "pig_erudite", nil, nil, true, nil, "FEMALE", "pigman_erudite"),
    makepigman("pigman_hatmaker_shopkeep", "pig_hatmaker", nil, nil, true, nil, "FEMALE", "pigman_hatmaker"),
    makepigman("pigman_storeowner_shopkeep", "pig_storeowner", nil, nil, true, { "emote_nohat" }, "FEMALE", "pigman_storeowner"),
    makepigman("pigman_banker_shopkeep", "pig_banker", nil, nil, true, { "emote_nohat" }, "MALE", "pigman_banker"),
    makepigman("pigman_shopkeep", "pig_banker", nil, nil, true, nil, "MALE", "pigman_banker"), -- default
    makepigman("pigman_hunter_shopkeep", "pig_hunter", nil, nil, true, nil, "MALE", "pigman_hunter"),
    makepigman("pigman_mayor_shopkeep", "pig_mayor", nil, nil, true, nil, "MALE", "pigman_mayor"),
    makepigman("pigman_farmer_shopkeep", "pig_farmer", nil, nil, true, nil, "MALE", "pigman_farmer"),
    makepigman("pigman_miner_shopkeep", "pig_miner", nil, nil, true, nil, "MALE", "pigman_miner"),
    makepigman("pigman_collector_shopkeep", "pig_collector", nil, nil, true, nil, "MALE", "pigman_collector"),
    makepigman("pigman_professor_shopkeep", "pig_professor", nil, nil, true, nil, "MALE", "pigman_professor"),
    makepigman("pigman_mechanic_shopkeep", "pig_mechanic", nil, nil, true, nil, "MALE", "pigman_mechanic"),

    -- 新增
    makepigman("pigman_eskimo_shopkeep", "pig_eskimo", nil, nil, true, nil, "MALE", "pig_eskimo"),
    makepigman("pig_shopkeeper", "pig_shopkeeper", nil, nil, nil, nil, "MALE"),
    makepigman("pig_royalguard_rich", "pig_royalguard_rich", nil, true, nil, nil, "MALE"),
    makepigman("pig_royalguard_rich_2", "pig_royalguard_rich_2", nil, true, nil, nil, "MALE"),
    makepigman("pigman_royalguard_3", "pig_royalguard_3", nil, true, nil, nil, "MALE"),
    makepigman("pig_eskimo", "pig_eskimo", nil, true, nil, nil, "MALE")
