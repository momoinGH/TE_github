local assets =
{
    Asset("ANIM", "anim/butterfly_tropical_basic.zip"),
}

local prefabs =
{
    "butterflywings",
    "butter",
    "planted_flower",
}

local function CommonPost(inst)
    inst.AnimState:SetBuild("butterfly_tropical_basic")
    inst.AnimState:SetBank("butterfly")
    inst.AnimState:PlayAnimation("idle")
end

local brain = require "brains/butterflybrain"
local function MasterPost(inst)
    inst:SetStateGraph("SGbutterfly")
    inst.sg.mem.burn_on_electrocute = true

    MakeSmallBurnableCharacter(inst, "butterfly_body")
    MakeTinyFreezableCharacter(inst, "butterfly_body")

    inst.components.lootdropper:AddRandomLoot("butter", 0.1)
    inst.components.lootdropper:AddRandomLoot("butterfly_tropical_wings", 5)
    inst.components.lootdropper.numrandomloot = 1

    inst:SetBrain(brain)
end

local MakeButterfly = require("prefabs/tro_butterflydefs").MakeButterfly
return MakeButterfly("butterfly_tropical", CommonPost, MasterPost, assets, prefabs)
