local MakePlayerCharacter = require "prefabs/player_common"

local assets =
{
    --	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/player_ghost_withhat.zip"),
    Asset("ANIM", "anim/ghost_build.zip"),
    Asset("IMAGE", "images/avatars/avatar_woodlegs.tex"),
    Asset("ATLAS", "images/avatars/avatar_woodlegs.xml"),
    Asset("IMAGE", "images/avatars/avatar_ghost_woodlegs.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_woodlegs.xml"),
    Asset("IMAGE", "images/avatars/self_inspect_woodlegs.tex"),
    Asset("ATLAS", "images/avatars/self_inspect_woodlegs.xml"),
    Asset("IMAGE", "bigportraits/woodlegs.tex"),
    Asset("ATLAS", "bigportraits/woodlegs.xml"),
    Asset("ANIM", "anim/woodlegs.zip"),
}

local prefabs =
{
}

local start_inv =
{
    "boards",
    "boards",
    "boards",
    "boards",
}

if TUNING.tropical.shipwrecked then
    table.insert(start_inv, "woodlegshat")
    table.insert(start_inv, "boatcannon")
    for i = 1, 4 do
        table.insert(start_inv, "dubloon")
    end
end

local function onbecamehuman(inst)
    if inst:HasTag("aquatic") then
        inst.components.sanity.dapperness = 0
    else
        inst.components.sanity.dapperness = -TUNING.DAPPERNESS_MED
    end
end

local function onbecameghost(inst)
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function CanShaveTest(inst)
    return false, "REFUSE"
end

local common_postinit = function(inst)
    inst.MiniMapEntity:SetIcon("woodlegs.png")
    inst:AddTag("woodlegs")
    inst.soundsname = "woodlegs"
    inst:AddTag("bearded")
end

local function sanityfn(inst)
    local delta = 0
    if inst:IsOnOcean() then
        delta = 0.08
    end
    return delta
end

local master_postinit = function(inst)
    inst.components.health:SetMaxHealth(150)
    inst.components.hunger:SetMax(150)
    inst.components.sanity:SetMax(120)
    inst.components.sanity.dapperness = -TUNING.DAPPERNESS_MED
    inst.components.sanity.custom_rate_fn = sanityfn

    inst.components.foodaffinity:AddPrefabAffinity("jellyopop", TUNING.AFFINITY_15_CALORIES_HUGE)

    inst:AddComponent("beard")
    inst.components.beard.canshavetest = CanShaveTest
    inst.components.beard:EnableGrowth(false)
    inst.ghostbuild = "ghost_build"

    inst:ListenForEvent("locomote", onbecamehuman)

    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("woodlegs", prefabs, assets, common_postinit, master_postinit, start_inv)
