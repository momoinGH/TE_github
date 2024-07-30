local prefabs = {
    "rocks",
}

local assets = {
    Asset("ANIM", "anim/rock_antcave.zip")
}

local loot = { "rocks", "rocks", "rocks" }

local function OnWorked(inst, worker, workleft)
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        inst.components.lootdropper:DropLoot(inst:GetPosition())
        inst:Remove()
    else
        if workleft < TUNING.ROCKS_MINE * (1 / 3) then
            inst.AnimState:PlayAnimation("low")
        elseif workleft < TUNING.ROCKS_MINE * (2 / 3) then
            inst.AnimState:PlayAnimation("med")
        else
            inst.AnimState:PlayAnimation("full")
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("rock_antcave.png")

    inst.AnimState:SetBank("rock")
    inst.AnimState:SetBuild("rock_antcave")
    inst.AnimState:PlayAnimation("full", true)

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)

    return inst
end

return Prefab("anthill/items/rock_antcave", fn, assets, prefabs)
