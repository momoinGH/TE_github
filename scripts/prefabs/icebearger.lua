local assets =
{
    Asset("ANIM", "anim/bearger_build.zip"),
    Asset("ANIM", "anim/bearger_basic.zip"),
    Asset("ANIM", "anim/bearger_actions.zip"),
    Asset("ANIM", "anim/bearger_yule.zip"),
    Asset("SOUND", "sound/bearger.fsb"),
}

local prefabs =
{
    "groundpound_fx",
    "groundpoundring_fx",
    "bearger_fur",
    "furtuft",
    "meat",
    "chesspiece_bearger_sketch",
    "collapse_small",
}

local function fn()
    local inst = Prefabs.bearger.fn()
    inst.AnimState:SetBuild("bearger_yule")
    return inst
end

return Prefab("icebearger", fn, assets, prefabs)
