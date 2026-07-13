local tro_pig_defs = require "prefabs/tro_pig_defs"

local extra_assets = {
    Asset("ANIM", "anim/wanawana_build.zip"),
    Asset("ANIM", "anim/hat_peagawkfeather.zip"),
}

-- 守卫目标：排除tiki标签
local RETARGET_GUARD_CANT_TAGS = { "guard", "INLIMBO", "tiki" }
local function GuardRetargetFn(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    local defendDist = SpringCombatMod(TUNING.PIG_GUARD_DEFEND_DIST)
    local defenseTarget = FindEntity(inst, defendDist, nil, { "king" }) or
        (home ~= nil and inst:IsNear(home, defendDist) and home) or
        inst

    if not defenseTarget.happy then
        local invader = FindEntity(defenseTarget, SpringCombatMod(TUNING.PIG_GUARD_TARGET_DIST), nil, { "character" }, RETARGET_GUARD_CANT_TAGS)
        if invader ~= nil and
            not (defenseTarget.components.trader ~= nil and defenseTarget.components.trader:IsTryingToTradeWithMe(invader)) and
            not (inst.components.trader ~= nil and inst.components.trader:IsTryingToTradeWithMe(invader)) then
            return invader
        end

        if not TheWorld.state.isday and home ~= nil and home.components.burnable ~= nil and home.components.burnable:IsBurning() then
            local lightThief = FindEntity(
                home,
                home.components.burnable:GetLargestLightRadius(),
                function(guy)
                    return guy:IsInLight()
                        and not (defenseTarget.components.trader ~= nil and defenseTarget.components.trader:IsTryingToTradeWithMe(guy))
                        and not (inst.components.trader ~= nil and inst.components.trader:IsTryingToTradeWithMe(guy))
                end,
                { "player" }
            )
            if lightThief ~= nil then
                return lightThief
            end
        end
    end

    local oneof_tags = { "monster" }
    if not inst:HasTag("merm") then
        table.insert(oneof_tags, "merm")
    end

    return FindEntity(defenseTarget, defendDist, nil, {}, { "INLIMBO" }, oneof_tags)
end

-- 保持目标：排除tiki标签
local function GuardKeepTargetFn(inst, target)
    if not inst.components.combat:CanTarget(target) or
        (target.sg ~= nil and target.sg:HasStateTag("transform")) or
        (target:HasTag("guard") and target:HasTag("pig")) or
        target:HasTag("tiki") then
        return false
    end

    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home == nil then
        return true
    end

    local defendDist = not TheWorld.state.isday
        and home.components.burnable ~= nil
        and home.components.burnable:IsBurning()
        and home.components.burnable:GetLargestLightRadius()
        or SpringCombatMod(TUNING.PIG_GUARD_DEFEND_DIST)
    return target:IsNear(home, defendDist) and inst:IsNear(home, defendDist)
end

-- SetNormalPigPost回调：覆盖守卫目标函数
local function SetGuardPigPost(inst)
    inst.components.combat:SetRetargetFunction(1, GuardRetargetFn)
    inst.components.combat:SetKeepTargetFunction(GuardKeepTargetFn)
end

local function common_post(inst)
    inst:AddTag("tiki")
end

local function master_post(inst)
    -- 覆盖帽子动画符号
    inst.AnimState:OverrideSymbol("swap_hat", "peagawkfeatherhat", "swap_hat")
end

return tro_pig_defs.MakePig("wanawanatiki", {
    assets = extra_assets,
    builds = { "wanawana_build" },
    is_guard = true,
    brain = require "brains/pigguardbrain",
    SetNormalPigPost = SetGuardPigPost,
}, common_post, master_post)
