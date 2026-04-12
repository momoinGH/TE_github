local assets =
{
    Asset("ANIM", "anim/wind_fx.zip")
}

local function Update(inst)
    local speed = TheWorld.components.tro_hurricane and TheWorld.components.tro_hurricane:GetHurricaneWindSpeed() or 0
    speed = math.clamp(speed, 0.0, 1.0)
    inst.AnimState:SetMultColour(1, 1, 1, speed)
    if speed < 0.01 then
        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    anim:SetBuild("wind_fx")
    anim:SetBank("wind_fx")
    anim:SetOrientation(ANIM_ORIENTATION.OnGround)
    anim:PlayAnimation("side_wind_loop", true)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("vento")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
    inst:ListenForEvent("entitysleep", inst.Remove)
    inst:DoPeriodicTask(0, Update) --替代单机windfx组件

    return inst
end

return Prefab("windswirl", fn, assets, nil)
