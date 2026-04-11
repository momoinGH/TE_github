local assets =
{
    Asset("ANIM", "anim/doydoy_mate_fx.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.AnimState:SetBank("doydoy_mate_fx")
    inst.AnimState:SetBuild("doydoy_mate_fx")
    inst.AnimState:SetSortOrder(-1)
    inst.AnimState:PlayAnimation("mate_pre")
    inst.AnimState:PushAnimation("mate_loop")
    inst.AnimState:PushAnimation("mate_loop")
    inst.AnimState:PushAnimation("mate_loop")
    inst.AnimState:PushAnimation("mate_pst", false)

    inst.SoundEmitter:PlaySound("dontstarve_DLC002/doy_doy/mating_dance_LP", "voice")
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/doy_doy/mate_dance_post", "mating")

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animqueueover", inst.Remove)
    inst.persists = false

    return inst
end

return Prefab("doydoy_mate_fx", fn, assets)
