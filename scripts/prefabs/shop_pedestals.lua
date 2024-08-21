
local assets =
{
    Asset("ANIM", "anim/pedestal_crate.zip"),
    Asset("ATLAS_BUILD", "images/inventoryimages.xml", 256),
    Asset("INV_IMAGE", "cost-1"),
    Asset("INV_IMAGE", "cost-2"),
    Asset("INV_IMAGE", "cost-3"),
    Asset("INV_IMAGE", "cost-4"),
    Asset("INV_IMAGE", "cost-5"),
    Asset("INV_IMAGE", "cost-10"),
    Asset("INV_IMAGE", "cost-20"),
    Asset("INV_IMAGE", "cost-30"),
    Asset("INV_IMAGE", "cost-40"),
    Asset("INV_IMAGE", "cost-50"),
    Asset("INV_IMAGE", "cost-100"),
    Asset("INV_IMAGE", "cost-200"),
    Asset("INV_IMAGE", "cost-300"),
    Asset("INV_IMAGE", "cost-400"),
    Asset("INV_IMAGE", "cost-500"),
    Asset("INV_IMAGE", "cost-nil"),
    Asset("MINIMAP_IMAGE", "accomplishment_shrine"),
}

local function OnInteriorSpawn(inst, data)
    inst.components.shopped.saleitem = data.saleitem
    inst.components.shopped.shoptype = data.shoptype
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("accomplishment_shrine.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("pedestal")
    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("shop_pedestal")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tropical_saveanim")

    inst:AddComponent("shopped")

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    inst:ListenForEvent("oninteriorspawn", OnInteriorSpawn)

    return inst
end

return Prefab("shop_buyer", fn, assets)
