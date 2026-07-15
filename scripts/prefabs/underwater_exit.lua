local assets =
{
    Asset("ANIM", "anim/cave_exit_rope.zip"),
    Asset("ANIM", "anim/underwater_exit.zip"),
}

local function OnEntityWake(inst)
    inst.components.und_bubbleblower:Start()
end

local function OnEntitySleep(inst)
    inst.components.und_bubbleblower:Stop()
end

-- portal_id
-- 地上入口和地下出口的id要一致，可以是字符串可以是数字
-- 不过如果地上地下有两套出入口需要不同的预制件，每套指定不同的id
local function MakeExit(name, portal_id)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("cave_open2.png")

        inst.Transform:SetScale(2, 2, 2)

        MakeObstaclePhysics(inst, 1)

        inst.AnimState:SetBank("underwater_exit")
        inst.AnimState:SetBuild("underwater_exit")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("vent")
        inst:AddTag("underwater")

        inst:AddComponent("und_bubbleblower")
        inst.components.und_bubbleblower:SetYOffset(40)
        inst.components.und_bubbleblower:SetYOffset(30)
        inst.components.und_bubbleblower:SetBubbleRate(5)

        inst:AddComponent("oxygenaura")
        inst.components.oxygenaura:SetAura(TUNING.GEOTHERMAL_VENT_AIR * 0.5)

        inst:SetPrefabNameOverride("underwater_exit")

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

        inst.OnEntityWake = OnEntityWake
        inst.OnEntitySleep = OnEntitySleep

        return inst
    end
    return Prefab(name, fn, assets)
end

return
    MakeExit("underwater_exit", "underwater_portal"),
    MakeExit("underwater_exit2", "underwater_portal") --入口现在就一个，这个出口也指向第一个入口吧
