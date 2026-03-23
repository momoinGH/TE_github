local assets =
{
    Asset("ANIM", "anim/wave_hurricane.zip")
}

local function commonfn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    --[[Non-networked entity]]
    inst:AddTag("CLASSIFIED")

    inst.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.WAVE_TINT_AMOUNT)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_WAVES)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("ignorewalkableplatforms")

    if TheNet:GetIsClient() then
        inst.entity:AddClientSleepable()
    end

    inst.OnEntitySleep = inst.Remove
    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local function hurricane(Sim)
    local inst = commonfn(Sim)
    inst.AnimState:SetBuild("wave_hurricane")
    inst.AnimState:SetBank("wave_hurricane")
    inst.AnimState:PlayAnimation("idle_small", false)
    return inst
end

return Prefab("wave_shimmer_hurricane", hurricane, assets)
