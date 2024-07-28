local assets = { Asset("ANIM", "anim/lavaarena_sunder_armor.zip") }

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddFollower()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("lavaarena_sunder_armor")
    inst.AnimState:SetBuild("lavaarena_sunder_armor")
    inst.AnimState:PlayAnimation("pre")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    local d = {
        boarilla = "helmet",
        boarrior = "head",
        crocommander = "shell",
        pitpig = "helmet",
        scorpeon = "head",
        snortoise =
        "body"
    }

    inst.SetTarget = function(c, e)
        c.owner = e;
        if d[e.prefab] then c.Follower:FollowSymbol(e.GUID, d[e.prefab], -20, -150, 1) else c:Remove() end
    end;

    inst:ListenForEvent("animover", function(inst)
        if not inst.owner and not inst.AnimState:IsCurrentAnimation("pst") or inst.AnimState:IsCurrentAnimation("pst") then
            inst:Remove()
        else
            inst.AnimState:PlayAnimation("loop")
        end
    end)

    return inst
end;

return Prefab("forgedebuff_fx", fn, assets)
