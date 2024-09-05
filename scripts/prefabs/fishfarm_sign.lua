require "prefabs/roe_fish"

local assets =
{
    Asset("ANIM", "anim/fish_farm_sign.zip"),
}

local function determineSign(inst)
    if inst.parent and inst.parent.fish then
        return inst.parent.harvested and ROE_FISH[inst.parent.fish].sign or "buoy_sign_1"
    end
end

local function resetArt(inst)
    inst.AnimState:Hide("buoy_sign_1")
    inst.AnimState:Hide("buoy_sign_2")
    inst.AnimState:Hide("buoy_sign_3")
    inst.AnimState:Hide("buoy_sign_4")
    inst.AnimState:Hide("buoy_sign_5")

    local sign = determineSign(inst)
    if sign then
        inst.AnimState:Show(sign)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fish_farm_sign")
    inst.AnimState:SetBuild("fish_farm_sign")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.resetArt = resetArt
    return inst
end

return Prefab("fish_farm_sign", fn, assets)
