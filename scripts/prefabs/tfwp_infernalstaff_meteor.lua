local a = { Asset("ANIM", "anim/lavaarena_firestaff_meteor.zip") }
local b = { Asset("ANIM", "anim/lavaarena_fire_fx.zip") }
local c = { "infernalstaff_meteor_splash", "infernalstaff_meteor_splashhit" }
local d = { "infernalstaff_meteor_splashbase" }
local e = TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF.ALT_RADIUS;

local function f()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_firestaff_meteor")
    inst.AnimState:SetBuild("lavaarena_firestaff_meteor")
    inst.AnimState:PlayAnimation("crash")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end;

    inst.AttackArea = function(g, h, i, j)
        i.meteor = g;
        g.attacker = h;
        g.owner = i;
        g.Transform:SetPosition(j:Get())
    end;

    inst:ListenForEvent("animover", function(inst)
        inst:DoTaskInTime(FRAMES * 3, function(inst)
            SpawnPrefab("infernalstaff_meteor_splash"):SetPosition(inst:GetPosition())
            local k = {}
            local l, m, n = inst:GetPosition():Get()
            local o = TheSim:FindEntities(l, m, n, e, nil, { "player", "companion" })
            for p, v in ipairs(o) do
                if inst.attacker ~= nil
                    and v ~= inst.attacker
                    and v.entity:IsValid()
                    and v.entity:IsVisible()
                    and (v.components.health
                        and not v.components.health:IsDead() or v.components.workable and v.components.workable:CanBeWorked()
                        and v.components.workable:GetWorkAction())
                then
                    table.insert(k, v)
                end
            end;
            if inst.owner.components.weapon and inst.owner.components.weapon:HasAltAttack() then
                inst.owner.components.weapon:DoAltAttack(inst.attacker, k, nil, "explosive")
            end;
            inst:Remove()
        end)
    end)

    inst.persists = false

    return inst
end;
local function r()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_fire_fx")
    inst.AnimState:SetBuild("lavaarena_fire_fx")
    inst.AnimState:PlayAnimation("firestaff_ult")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end;

    inst.SetPosition = function(g, j)
        g.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/meteor_strike")
        g.Transform:SetPosition(j:Get())
        SpawnPrefab("infernalstaff_meteor_splashbase"):SetPosition(j)
    end;

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end;
local function s()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_fire_fx")
    inst.AnimState:SetBuild("lavaarena_fire_fx")
    inst.AnimState:PlayAnimation("firestaff_ult_projection")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end;

    inst.SetPosition = function(inst, j)
        inst.Transform:SetPosition(j:Get())
    end;

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end;
local function t()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_fire_fx")
    inst.AnimState:SetBuild("lavaarena_fire_fx")
    inst.AnimState:PlayAnimation("firestaff_ult_hit")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst.SetTarget = function(g, u)
        g.Transform:SetPosition(u:GetPosition():Get())
        local v = u:
        HasTag("minion") and .5 or (u:
        HasTag("largecreature") and 1.3 or .8)
        g.AnimState:SetScale(v, v)
    end;

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end;
return Prefab("infernalstaff_meteor", f, a, c),
    Prefab("infernalstaff_meteor_splash", r, b, d),
    Prefab("infernalstaff_meteor_splashbase", s, b),
    Prefab("infernalstaff_meteor_splashhit", t, b)
