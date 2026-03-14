local assets =
{
    Asset("ANIM", "anim/vamp_bat_entrance.zip"),
}


local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("vamp_bat_cave.png")

    inst.AnimState:SetBuild("vamp_bat_entrance")
    inst.AnimState:SetBank("vampbat_den")
    inst.AnimState:PlayAnimation("idle")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 558
    inst.components.worldmigrator.receivedPortal = 557

    if TUNING.tropical.tropicalshards == 5 or TUNING.tropical.tropicalshards == 10 or TUNING.tropical.tropicalshards == 20 or TUNING.tropical.tropicalshards == 30 then
        inst.components.worldmigrator.auto = false
        inst.components.worldmigrator.linkedWorld = "2"
    end

    return inst
end

return Prefab("cave_entrance_frost", fn2, assets)
