local tro_pig_defs = require("prefabs/tro_pig_defs")

local assets =
{
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("ANIM", "anim/ds_pig_charge.zip"),
    Asset("ANIM", "anim/ds_pig_boat_jump.zip"),
    Asset("ANIM", "anim/wildbore_build.zip"),
    Asset("ANIM", "anim/pigspotted_build.zip"),
    Asset("ANIM", "anim/pig_guard_build.zip"),
    Asset("ANIM", "anim/werepig_build.zip"),
    Asset("ANIM", "anim/werepig_basic.zip"),
    Asset("ANIM", "anim/werepig_actions.zip"),
    Asset("SOUND", "sound/pig.fsb"),
    --Asset("ANIM", "anim/merm_actions.zip"),
}

--jueying define
local normalpig_health = TUNING.PIG_HEALTH * 1.5
local normalpig_damage = TUNING.PIG_DAMAGE * 1.2

local normalbrain = require "brains/wildborebrain"

local function GetStatus(inst)
    return (inst:HasTag("werepig") and "WEREPIG")
        or (inst:HasTag("guard") and "GUARD")
        or (inst.components.follower.leader ~= nil and "FOLLOWER")
        or nil
end

local function CommonPost(inst)
    inst:AddTag("trader")

    inst.AnimState:SetBuild("wildbore_build")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")
end

local function MasterPost(inst)
    inst.components.inspectable.getstatus = GetStatus

    inst:SetBrain(normalbrain)
    inst:SetStateGraph("SGwildbore")

    inst.components.combat:SetDefaultDamage(normalpig_damage)

    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat", 3)
    inst.components.lootdropper:AddRandomLoot("pigskin", 1)
    inst.components.lootdropper.numrandomloot = 1

    inst.components.health:SetMaxHealth(normalpig_health)
end

return tro_pig_defs.MakePig("wildbore", {
    assets = assets,
    is_pig = true,
}, CommonPost, MasterPost)
