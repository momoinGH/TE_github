local tro_pig_defs = require "prefabs/tro_pig_defs"

local extra_assets = {
    Asset("ANIM", "anim/ds_pig_elite.zip"),
    Asset("ANIM", "anim/ds_pig_elite_intro.zip"),
    Asset("ANIM", "anim/wildbore_elite_build.zip"),
    Asset("ANIM", "anim/wildbore_build.zip"),
}

local normalbrain = require "brains/wildboreguardbrain"

-- 固定扣理智光环
local function CalcSanityAura(inst, observer)
    return -TUNING.SANITYAURA_LARGE / 10
end

-- 野猪音效
local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/wild_boar/grunt")
end

-- 检测小队成员是否已攻击该目标
local function IsSquadAlreadyTargeting(inst, target, rangesq, checkfn)
    local x, y, z = target.Transform:GetWorldPosition()
    for k, v in pairs(inst.components.squadmember:GetOtherMembers()) do
        -- 检查队友状态：击退、着火、恐慌、睡眠、冰冻时跳过
        if checkfn(k, target) and k:GetDistanceSqToPoint(x, y, z) < rangesq and
            not (k.sg:HasStateTag("knockback") or
                k.components.health.takingfiredamage or
                k.components.hauntable.panic or
                k.components.sleeper:IsAsleep() or
                k.components.freezable:IsFrozen()) then
            return true
        end
    end
    return false
end

-- 攻击目标：玩家和boss，排除猪王
local function NormalRetargetFn(inst)
    return FindEntity(
        inst,
        TUNING.PIG_TARGET_DIST,
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and guy.prefab ~= "pigking"
        end,
        { "player", "epic", "_combat" },
        { "playerghost", "INLIMBO" }
    )
end

-- 设置外观变体（4种）
local function SetVariation(inst)
    inst.variation = inst.variation or math.random(1, 4)
    if inst.sg then
        inst.sg.mem = inst.sg.mem or {}
        inst.sg.mem.variation = inst.variation
    end

    -- 变体对应的动画符号覆盖
    local builds = {
        [1] = { "pig_arm_3", "pig_skirt_1", "pig_torso_1", "spin_bod_1" },
        [2] = { "pig_arm_2", "pig_skirt_2", "pig_torso_2", "spin_bod_2" },
        [3] = { nil, "pig_skirt_3", "pig_torso_3", "spin_bod_3" },
        [4] = { nil, "pig_skirt_4", "pig_torso_4", "spin_bod_4" },
    }

    local symbols = { "pig_arm", "pig_skirt", "pig_torso", "spin_bod" }
    local v = builds[inst.variation]
    for i, symbol in ipairs(symbols) do
        if v[i] then
            inst.AnimState:OverrideSymbol(symbol, "wildbore_elite_build", v[i])
        end
    end
    if inst.variation == 4 then
        inst.AnimState:OverrideSymbol("pig_head", "wildbore_elite_build", "pig_head_4")
    end
end

local function SetNormalPigPost(inst)
    -- 强化属性
    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH * 1.5)
    inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE * 1.2)
    -- 禁用交易
    inst.components.trader:SetAcceptTest(function() return false end)
    inst.components.trader.onaccept = function() end
    inst.components.trader.onrefuse = function() end
    inst.components.sanityaura.aurafn = CalcSanityAura
    -- 永不睡觉
    inst.components.sleeper:SetSleepTest(function() return false end)
    inst.components.sleeper:SetWakeTest(function() return true end)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    SetVariation(inst)
end

local function SetGuardPigPost(inst)
    -- 强化属性
    inst.components.health:SetMaxHealth(TUNING.PIG_GUARD_HEALTH * 1.2)
    inst.components.combat:SetDefaultDamage(TUNING.PIG_GUARD_DAMAGE * 1.2)
    -- 禁用交易
    inst.components.trader:SetAcceptTest(function() return false end)
    inst.components.trader.onaccept = function() end
    inst.components.trader.onrefuse = function() end
    inst.components.sanityaura.aurafn = CalcSanityAura
    -- 永不睡觉
    inst.components.sleeper:SetSleepTest(function() return false end)
    inst.components.sleeper:SetWakeTest(function() return true end)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    SetVariation(inst)
end

local function common_post(inst)
    inst:AddTag("pigminion")
end

local function master_post(inst)
    inst:AddComponent("entitytracker")

    -- 音效和小队系统
    inst.components.talker.ontalk = ontalk
    inst:AddComponent("squadmember")
    inst.components.squadmember:JoinSquad("pigkingelite4")
    inst.IsSquadAlreadyTargeting = IsSquadAlreadyTargeting

    -- 保存/加载外观变体
    inst.OnSave = function(inst, data)
        data.variation = inst.variation
    end

    inst.OnLoad = function(inst, data)
        if data then
            inst.variation = data.variation
        end
    end
end

return tro_pig_defs.MakePig("pigman_minion", {
        assets = extra_assets,
        builds = { "wildbore_build" },
        brain = normalbrain,
        sg = "SGpigminion",
        SetNormalPigPost = SetNormalPigPost,
    }, common_post, master_post),
    tro_pig_defs.MakePig("pigguard_minion", {
        assets = extra_assets,
        builds = { "wildbore_build" },
        is_guard = true,
        brain = normalbrain,
        sg = "SGpigminion",
        SetNormalPigPost = SetGuardPigPost,
    }, common_post, master_post)
