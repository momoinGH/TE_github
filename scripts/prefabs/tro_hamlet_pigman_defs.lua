-- 给哈姆雷特猪人写的预制件创建函数，有时间再整理pigman_city.lua

local brain = require "brains/citypigbrain"

----------------------------------------------------------------------------------------------------

trader_check = {}
-- item_test：初步检查，不通过会继续检查
-- want_test：第二次检查，如果不通过会直接拒绝
-- onaccept：接受物品时执行的函数
local function AddTradeCheck(item_test, want_test, onaccept)
    table.insert(trader_check, { item_test = item_test, want_test = want_test, onaccept = onaccept })
end

-- 银行家不要紫宝石
AddTradeCheck(function(inst, item, giver)
    return item.prefab == "purplegem" and (inst.prefab == "pigman_banker" or inst.prefab == "pigman_banker_shopkeep")
end, function(inst, item, giver)
    return false, STRINGS.CITY_PIG_TALK_REFUSE_PURPLEGEM
end)

-- 贿赂仇视玩家的猪
AddTradeCheck(function(inst, item, giver)
    return item:HasTag("oinc") and item.GetOincAllValue
end, nil, function(inst, item, giver)
    if not inst:HasTag("angry_at_player") then
        return
    end

    inst.bribe_count = (inst.bribe_count or 0) + item:GetOincAllValue()
    local bribe_threshold = inst:HasTag("guard") and 10 or 1
    if inst.bribe_count >= bribe_threshold then
        inst:RemoveTag("angry_at_player")

        if inst.components.combat and inst.components.combat:IsTarget(giver) then
            inst.components.combat:GiveUp()
        end

        inst.bribe_count = 0
        inst:sayline(inst:getSpeechType(STRINGS.CITY_PIG_TALK_FORGIVE_PLAYER))
    else
        inst:sayline(inst:getSpeechType(STRINGS.CITY_PIG_TALK_NOT_ENOUGH))
    end
end)

-- 雇佣守卫
AddTradeCheck(function(inst, item, giver)
    return inst:HasTag("guard") and item:HasTag("securitycontract")
end, nil, function(inst, item, giver)
    inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
    if giver.components.leader then
        giver.components.leader:AddFollower(inst)
    end
    inst.components.follower:AddLoyaltyTime(TUNING.PIG_LOYALTY_MAXTIME)
end)

-- 珠宝
local trinket_reward = { "kabobs", "pumpkincookie", "taffy", "oinc", "butterflymuffin", "powcake" }
AddTradeCheck(function(inst, item, giver)
    return item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3"
end, function(inst, item, giver)
    if inst:HasTag("recieved_trinket") then
        return false, STRINGS.CITY_PIG_TALK_REFUSE_TRINKET_GIFT
    end
    return true
end, function(inst, item, giver)
    inst:AddTag("recieved_trinket")
    inst:sayline(inst:getSpeechType(STRINGS.CITY_PIG_TALK_GIVE_TRINKET_REWARD))
    if giver.components.inventory then
        local rewarditem = SpawnPrefab(trinket_reward[math.random(1, #trinket_reward)])
        giver.components.inventory:GiveItem(rewarditem, nil, inst:GetPosition())
    end
end)

-- 女王
AddTradeCheck(function(inst, item, giver)
    if item.prefab == "relic_4" or item.prefab == "relic_5" then
        return true
    end
    if item.prefab == "pigcrownhat" then
        return true
    end
    if item.prefab == "pig_scepter" then
        return true
    end
end, function(inst, item, giver)
    if inst:HasTag("pigqueen") then
        return true
    end
    return false, STRINGS.CITY_PIG_TALK_REFUSE_PRICELESS_GIFT
end, function(inst, item, giver)
    if item.prefab == "relic_4" or item.prefab == "relic_5" then
        item:Remove()
    elseif item.prefab == "pigcrownhat" then -- 戴帽子
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    elseif item.prefab == "pig_scepter" then -- 手持
        inst.components.inventory:Equip(item)
    end
    inst:PushEvent("behappy")
end)

-- 文物
AddTradeCheck(function(inst, item, giver)
    return item:HasTag("relic") and (inst.prefab == "pigman_collector_shopkeep" or inst.prefab == "pigman_collector")
end, nil, function(inst, item, giver)
    if giver.components.inventory then
        inst:sayline(inst:getSpeechType(STRINGS.CITY_PIG_TALK_GIVE_RELIC_REWARD))
        local rewarditem = SpawnPrefab("oinc10")
        giver.components.inventory:GiveItem(rewarditem, nil, inst:GetPosition())
    end
end)

local function IsWantItem(inst, prefab)
    local econprefab = inst.econprefab or inst.prefab
    local wanteditems = TheWorld.components.economy:GetTradeItems(econprefab)
    for i, wanted in ipairs(wanteditems) do
        if wanted == prefab then
            return true
        end
    end
    return false
end

-- 收购
AddTradeCheck(function(inst, item, giver)
    return true
end, function(inst, item, giver)
    if IsWantItem(inst, item.prefab) then
        local city = inst:HasTag("city2") and 2 or 1
        local econprefab = inst.econprefab or inst.prefab
        local delay = TheWorld.components.economy:GetDelay(econprefab, city, inst)
        if delay > 0 then
            if delay == 1 then
                return false, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY_TOMORROW
            else
                inst:sayline(string.format(inst:getSpeechType(STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY), tostring(delay)))
                return false
            end
        end
        return true
    end

    if item:HasTag("relic") then
        return false, STRINGS.CITY_PIG_TALK_RELIC_GIFT
    end

    return false, STRINGS.CITY_PIG_TALK_REFUSE_GIFT --不收购
end, function(inst, item, giver)
    item:Remove()
    local econprefab = inst.econprefab or inst.prefab
    local city = inst:HasTag("city2") and 2 or 1
    local reward, qty = TheWorld.components.economy:MakeTrade(econprefab, city, inst)
    local desc = TheWorld.components.economy:GetTradeItemDesc(econprefab)
    if reward then
        if giver.components.inventory then
            inst:sayline(string.format(inst:getSpeechType(STRINGS.CITY_PIG_TALK_GIVE_REWARD), tostring(1), desc))
            for i = 1, qty do
                local rewarditem = SpawnPrefab(reward)
                giver.components.inventory:GiveItem(rewarditem, nil, inst:GetPosition())
            end
        end
    else
        inst:sayline(string.format(inst:getSpeechType(STRINGS.CITY_PIG_TALK_TAKE_GIFT), tostring(1), desc))
    end
end)

local function ShouldAcceptItem(inst, item, giver)
    if inst.components.sleeper:IsAsleep() then
        return false
    end

    for _, fns in ipairs(trader_check) do
        if fns.item_test(inst, item, giver) then
            if fns.want_test then
                local result, reason = fns.want_test(inst, item, giver)
                if not result then
                    inst:sayline(inst:getSpeechType(reason))
                    return false
                end
            end
            return true
        end
    end
    return false
end

local function OnAccept(inst, giver, item)
    for _, fns in ipairs(trader_check) do
        if fns.item_test(inst, item, giver) then
            fns.onaccept(inst, item, giver)
        end
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

----------------------------------------------------------------------------------------------------

local function sayline(inst, line, mood)
    inst.components.talker:Say(line, 1.5, nil, true, mood)
end

local function getSpeechType(inst, speech)
    local line = speech.DEFAULT
    if speech[inst.prefab] then
        line = speech[inst.prefab]
    end
    if type(line) == "table" then
        line = line[math.random(#line)]
    end
    return line
end

local function ontalk(inst, script)
    if inst.female then
        -- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream_female") --联机版ontalk这个方法没有心情这个变量
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_female", "talk")
    else
        -- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream")
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk", "talk")
    end
end

local function OnEat(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT
        and inst.components.werebeast
        and not inst.components.werebeast:IsInWereState()
        and food.components.edible:GetHealth() < 0 then
        inst.components.werebeast:TriggerDelta(1)
    elseif food.components.edible.foodtype == FOODTYPE.VEGGIE then
        SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end

local function CalcSanityAura(inst, observer)
    if inst.components.werebeast and inst.components.werebeast:IsInWereState() then
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

local function OnSave(inst, data)
    data.children = {}

    if inst:HasTag("angry_at_player") then
        data.angryatplayer = true
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

    if inst.save_post_fn then
        inst:save_post_fn(data)
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

----------------------------------------------------------------------------------------------------
local function NormalShouldSleep(inst)
    if not DefaultSleepTest(inst) then
        return false
    end

    local has_leader = inst.components.follower and inst.components.follower.leader ~= nil or false
    if not has_leader then
        return true
    end

    local fire = FindEntity(inst, 6, function(ent)
        return ent.components.burnable and ent.components.burnable:IsBurning()
    end, { "campfire" })
    return fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
end

----------------------------------------------------------------------------------------------------

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.CITY_PIG_GUARD_TARGET_DIST,
        function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                if guy and guy:HasTag("player") and inst:HasTag("angry_at_player") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not (inst.components.combat.target and inst.components.combat.target:HasTag("player")) then
                    inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
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


---创建哈姆雷特猪人预制件
---@param name string 预制件名称
---@param data table 配置数据表
---@param data.build string 必选，动画构建名称
---@param data.sex? string 可选，性别类型："MALE" | "FEMALE"
---@param data.econprefab? string 可选
---@param data.common_post_fn? function 可选，通用后处理函数
---@param data.master_post_fn? function 可选，主服务器后处理函数
---@return Prefab 返回创建的预制件对象
local function MakeHamletPigman(name, data)
    assert(data.build)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddLightWatcher()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("townspig")
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:Hide("hat")
        inst.AnimState:Hide("desk")
        inst.AnimState:Hide("ARM_carry")

        inst.DynamicShadow:SetSize(1.5, .75)

        inst.Transform:SetFourFaced()

        inst.female = data.sex == "FEMALE"
        inst.sayline = sayline
        inst.getSpeechType = getSpeechType

        inst:AddComponent("talker")
        inst.components.talker.ontalk = ontalk
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0, -600, 0)
        inst.components.talker:StopIgnoringAll()

        MakeCharacterPhysics(inst, 50, .5)

        inst:AddTag("character")
        inst:AddTag("pig")
        inst:AddTag("civilized")
        inst:AddTag("scarytoprey")
        inst:AddTag("firecrackerdance")
        inst:AddTag("city_pig")

        if data.common_post_fn then
            data.common_post_fn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.throwcrackers = throwcrackers

        inst:AddComponent("locomotor")                              -- locomotor must be constructed before the stategraph
        inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED   --5
        inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED --3

        inst:AddComponent("eater")
        inst.components.eater:SetCanEatHorrible()
        inst.components.eater.strongstomach = true -- can eat monster meat!
        inst.components.eater:SetOnEatFn(OnEat)

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "pig_torso"
        inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
        inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
        inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
        inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)

        MakeMediumBurnableCharacter(inst, "pig_torso")

        inst:AddComponent("named")
        local names = {}
        for i, v in ipairs(STRINGS.CITYPIGNAMES["UNISEX"]) do
            table.insert(names, v)
        end
        if data.sex then
            for i, v in ipairs(STRINGS.CITYPIGNAMES[data.sex]) do
                table.insert(names, v)
            end
        end
        inst.components.named.possiblenames = names
        inst.components.named:PickNewName()

        inst:AddComponent("follower")
        inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)

        inst:AddComponent("sleeper")
        inst.components.sleeper:SetResistance(2)
        inst.components.sleeper:SetSleepTest(NormalShouldSleep)
        inst.components.sleeper:SetWakeTest(DefaultWakeTest)

        inst:AddComponent("inventory")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({})
        inst.components.lootdropper:AddRandomLoot("meat", 3)
        inst.components.lootdropper:AddRandomLoot("pigskin", 1)
        inst.components.lootdropper.numrandomloot = 1

        inst:AddComponent("timer")
        inst:AddComponent("entitytracker")

        inst:AddComponent("trader")
        -- inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        -- inst.components.trader.onaccept = OnAccept
        inst.components.trader.onrefuse = OnRefuseItem

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aurafn = CalcSanityAura

        ------------------------------------------
        MakeMediumFreezableCharacter(inst, "pig_torso")
        --------------------------------------------

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = getstatus

        if data.econprefab then
            inst.econprefab = data.econprefab
            inst.components.inspectable.nameoverride = data.econprefab
        end

        inst.special_action = special_action

        inst:SetBrain(brain)
        inst:SetStateGraph("SGpig_city")

        if data.master_post_fn then
            data.master_post_fn(inst)
        end

        return inst
    end
    return Prefab(name, fn, assets)
end

return {
    MakeHamletPigman = MakeHamletPigman,
}
