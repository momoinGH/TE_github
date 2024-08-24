local assets =
{
    Asset("ANIM", "anim/sea_yard_tools.zip")
}

local function stopfx(inst)
    inst.AnimState:PlayAnimation("out")
    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(10)
    inst.AnimState:SetBank("sea_yard_tools")
    inst.AnimState:SetBuild("sea_yard_tools")
    inst.AnimState:PlayAnimation("in")
    inst.AnimState:PushAnimation("loop", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seacreature_movement/splash_medium")
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/shipyard/fix_LP", "fix")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.stopfx = stopfx
    inst.persists = false

    return inst
end

return Prefab("sea_yard_arms_fx", fn, assets)
