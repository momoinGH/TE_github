local assets =
{
    Asset("ANIM", "anim/volcano.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("volcano.png")

    inst.AnimState:SetBank("volcano")
    inst.AnimState:SetBuild("volcano")
    inst.AnimState:PlayAnimation("dormant_idle", true)
    inst:AddTag("vulcaomigrador")

    inst.Transform:SetScale(0.5, 0.5, 0.5)
    inst.entity:AddLight()
    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(10)
    inst.Light:SetColour(249 / 255, 130 / 255, 117 / 255)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    --[[
    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0,0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end
]]
    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 778
    inst.components.worldmigrator.receivedPortal = 777

    if TUNING.tropical.tropicalshards == 5 or TUNING.tropical.tropicalshards == 10 or TUNING.tropical.tropicalshards == 20 or TUNING.tropical.tropicalshards == 30 then
        inst.components.worldmigrator.auto = false
        inst.components.worldmigrator.linkedWorld = "2"
    end



    --	if not inst:HasTag("NOCLICK") then
    --	inst:DoPeriodicTask(15, OnSeasonChange)
    --	end

    inst:SetStateGraph("SGvolcano")

    return inst
end


return Prefab("cave_entrance_vulcao", fn, assets)
