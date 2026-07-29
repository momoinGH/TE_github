local assets =
{
    Asset("ANIM", "anim/underwater_entrance.zip"),
}

local prefabs =
{
}


local function MakeEntrance(name, portal_id)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, 1)
        inst.Transform:SetScale(0.3, 0.3, 0.3)
        inst.MiniMapEntity:SetIcon("entrance_open.png")

        anim:SetBank("entrance_reef")
        anim:SetBuild("underwater_entrance")
        inst.AnimState:PlayAnimation("idle_open")

        inst:SetPrefabNameOverride("underwater_entrance")

        inst:AddTag("entrada_submersa")

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
        inst.components.worldmigrator:SetID(portal_id)

        return inst
    end
    return Prefab(name, fn, assets, prefabs)
end

return
    MakeEntrance("underwater_entrance", "underwater_portal"),
    MakeEntrance("underwater_entrance2", "underwater_portal2") --这个给海难布局用