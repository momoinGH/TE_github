local assets = { Asset("ANIM", "anim/lavaarena_hit_sparks_fx.zip") }

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("hits_sparks")
    inst.AnimState:SetBuild("lavaarena_hit_sparks_fx")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst.SetPosition = function(c, d, e)
        local f = (d:GetPosition() - e:GetPosition()):GetNormalized() * (e.Physics ~= nil and e.Physics:GetRadius() or 1)
        f.y = f.y + 1 + math.random(-5, 5) / 10;
        c.Transform:SetPosition((e:GetPosition() + f):Get())
        c.AnimState:PlayAnimation("hit_3")
        c.AnimState:SetScale(d:GetRotation() > 0 and -.7 or .7, .7)
    end;

    inst.SetPiercing = function(c, g, e)
        local f = (g:GetPosition() - e:GetPosition()):GetNormalized() * (e.Physics ~= nil and e.Physics:GetRadius() or 1)
        f.y = f.y + 1 + math.random(-5, 5) / 10;
        c.Transform:SetPosition((e:GetPosition() + f):Get())
        c.AnimState:PlayAnimation("hit_3")
        c.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        c.Transform:SetRotation(c:GetAngleToPoint(e:GetPosition():Get()) + 90)
    end;

    inst.SetThrusting = function(c, g, e)
        local h = c:GetPosition()
        c.Transform:SetPosition(h.x, h.y + 1, h.z)
        c:SetPiercing(g, e)
    end;

    inst.SetBounce = function(c, i)
        c.Transform:SetPosition(i:GetPosition():Get())
        c.AnimState:PlayAnimation("hit_2")
        c.AnimState:Hide("glow")
        c.AnimState:SetScale(i:GetRotation() > 0 and 1 or -1, 1)
    end;

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end;

return Prefab("weaponsparks_fx", fn, assets)
