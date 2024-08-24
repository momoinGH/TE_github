local assets =
{
    Asset("ANIM", "anim/shelf_slot.zip"),
}

local function displaynamefn(inst)
    local item = inst.components.shelfer:GetGift()
    if not item then
        return ""
    end
    return item:GetDisplayName()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- 这个动画不是完全透明的，完全透明的贴图无法触发action
    inst.AnimState:SetBuild("shelf_slot")
    inst.AnimState:SetBank("shelf_slot")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(255 / 255, 255 / 255, 255 / 255, 0.02) --好像这个也行

    inst:AddTag("cost_one_oinc")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")

    inst:AddComponent("named")

    inst:AddComponent("shelfer")

    inst.displaynamefn = displaynamefn

    -- we're not saving those anymore
    inst.persists = false

    return inst
end

return Prefab("shelf_slot", fn, assets)
