local assets =
{
    Asset("ANIM", "anim/sprinkler_fx.zip")
}

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    anim:SetBank("sprinkler_fx")
    anim:SetBuild("sprinkler_fx")
    anim:PlayAnimation("spray_loop", true)
    inst.persists = false

    inst:AddTag("FX")

    return inst
end

return Prefab("water_spray", fn, assets)
