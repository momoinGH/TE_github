local waveassets =
{
    Asset("ANIM", "anim/waverripple.zip"),
}

local rogueassets =
{
    Asset("ANIM", "anim/wave_rogue.zip"),
}

local Constructor = require("tropical_utils/constructor")

local function wave_ripple_fn(inst)
    inst:AddTag("ondamedia")

    inst.AnimState:SetBuild("waverripple")
    inst.AnimState:SetBank("wave_ripple_sw")
end

local function rogue_wave_fn(inst)
    inst.AnimState:SetBuild("wave_rogue")
    inst.AnimState:SetBank("wave_rogue")
end

return Constructor.CopyPrefab("wave_ripple", "wave_med", { --低
    assets = waveassets,
    init = wave_ripple_fn
}), Constructor.CopyPrefab("rogue_wave", "wave_med", { --高
    assets = rogueassets,
    init = rogue_wave_fn
})
