local tro_pig_defs = require "prefabs/tro_pig_defs"

local extra_assets = {
    Asset("ANIM", "anim/ds_pig_charge.zip"),
    Asset("ANIM", "anim/wildbore_build.zip"),
}

local normalbrain = require "brains/wildborebrain"
local guardbrain = require "brains/pigguardbrain"
local werepigbrain = require "brains/werepigbrain"

-- 外观变体设置
local function SetVariation(inst)
    inst.variation = inst.variation or math.random(1, 4)
    if inst.sg and inst.sg.mem then
        inst.sg.mem.variation = inst.variation
    end

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

local function SetGuardPigPost(inst)
    SetVariation(inst)
end

local function common_post(inst)
    inst.entity:AddLightWatcher()
    inst.annoyance = 0
end

-- master_post：覆盖OnSave/OnLoad、设置大脑
local function master_post(inst)
    inst:SetBrain(normalbrain)
end

return tro_pig_defs.MakePig("wildbore", {
        assets = extra_assets,
        builds = { "wildbore_build" },
        sg = "SGwildbore",
        brain = normalbrain,
        were_brain = werepigbrain,
    }, common_post, master_post),
    tro_pig_defs.MakePig("wildboreguard", {
        assets = extra_assets,
        builds = { "wildbore_build" },
        is_guard = true,
        sg = "SGwildbore",
        brain = guardbrain,
        SetNormalPigPost = SetGuardPigPost,
    }, common_post, master_post)
