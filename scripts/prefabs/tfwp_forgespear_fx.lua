local assets = { Asset("ANIM", "anim/lavaarena_hits_variety.zip") }

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("lavaarena_hits_variety")
    inst.AnimState:SetBuild("lavaarena_hits_variety")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst.SetTarget = function(c, d)
        c.Transform:SetPosition(d:GetPosition():Get())
        c.AnimState:PlayAnimation("hit_" .. (d:HasTag("minion") and 1 or (d:HasTag("largecreature") and 3 or 2)))
        c.AnimState:SetScale(d:HasTag("minion") and 1 or -1, 1)
    end;

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end;
return Prefab("forgespear_fx", fn, assets)
