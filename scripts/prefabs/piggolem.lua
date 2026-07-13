local tro_pig_defs = require "prefabs/tro_pig_defs"

local extra_assets = {
    Asset("ANIM", "anim/pig_golem_build.zip"),
}

-- SetNormalPigPost回调：覆盖守卫目标函数，移除不需要的组件
local function SetGuardPigPost(inst)
    -- 覆盖掉落物为oinc
    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("oinc", 3)
    inst.components.lootdropper:AddRandomLoot("oinc", 1)
    inst.components.lootdropper.numrandomloot = 1
end

local function common_post(inst)
    inst:AddTag("piggolem")
end

local function master_post(inst)
end

return tro_pig_defs.MakePig("piggolem", {
    assets = extra_assets,
    builds = { "pig_golem_build" },
    is_guard = true,
    brain = require "brains/pigguardbrain",
    no_random_name = true,
    SetNormalPigPost = SetGuardPigPost,
}, common_post, master_post)
