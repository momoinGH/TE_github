-- 优化暴食大门交互，因为原版中心区域点不到了

local function CreatePortalBase(portal)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    inst.AnimState:SetBuild("quagmire_portal")
    inst.AnimState:SetBank("quagmire_portal")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetFinalOffset(2)

    inst.Transform:SetEightFaced()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

    inst.persists = false
    inst.entity:SetParent(portal.entity)

    return inst
end


AddPrefabPostInit("quagmire_portal", function(inst)
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("gorge_portal.png")

    inst.AnimState:SetBank("quagmire_portal_base")
    inst.AnimState:SetBuild("quagmire_portal_base")
    inst.AnimState:SetFinalOffset(0)
    if not TheNet:IsDedicated() then
        CreatePortalBase(inst)
    end
end)
