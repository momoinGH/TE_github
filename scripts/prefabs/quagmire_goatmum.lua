local assets =
{
    Asset("ANIM", "anim/quagmire_goatmom_basic.zip"),
}

local prefabs =
{
    "meat",
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("goatmum.png")

    MakeCharacterPhysics(inst, 50, .4)

    inst.DynamicShadow:SetSize(2, 1)

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.3, 1.3, 1.3)

    inst.MiniMapEntity:SetPriority(1)

    inst.AnimState:SetBank("quagmire_goatmom_basic")
    inst.AnimState:SetBuild("quagmire_goatmom_basic")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("hat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED

    MakeHauntablePanic(inst)

    --    inst:AddComponent("lootdropper")
    --    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")

    --    MakeMediumBurnableCharacter(inst, "pig_torso")
    --    MakeMediumFreezableCharacter(inst, "pig_torso")

    --    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("prototyper")
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_GOATMUM

    inst:SetStateGraph("SGgoatmum")

    local brain = require "brains/goatbrain" --"brains/goatmumbrain"
    inst:SetBrain(brain)




    return inst
end

return Prefab("quagmire_goatmum", fn, assets, prefabs)
