local assets = { Asset("ANIM", "anim/lavaarena_boarrior_fx.zip") }

local function Teleport(c, d, e, f, g)
    local h, i, j = d.Transform:GetWorldPosition()
    local k, l, m = c.Transform:GetWorldPosition()
    local n, o = k - h, m - j;
    local p = n * n + o * o;
    local q;
    if p > 0 then
        local r = math.sqrt(p)
        q = math.atan2(o / r, n / r) + (math.random() * 20 - 10) * DEGREES
    else
        q = TWOPI * math.random()
    end;
    local s, t = math.sin(q), math.cos(q)
    local u = e + math.random()
    c.Physics:Teleport(h + g * t, f, j + g * s)
    c.Physics:SetVel(t * u, u * 5 + math.random() * 2, s * u)
end;

local function Toss(c)
    local x, _, z = c.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, 0, z, 0.7, { "_inventoryitem" }, { "locomotor", "INLIMBO" })) do
        if v.components.mine ~= nil then v.components.mine:Deactivate() end;
        if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
            Teleport(v, c, .8 + .7, .7 * .4, .7 + v:GetPhysicsRadius(0))
        end
    end
end;

local function MakeLift(name, toss, anim, sound, I)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        if sound then
            inst.entity:AddSoundEmitter()
        end
        inst.entity:AddNetwork()

        if anim then
            inst.entity:AddAnimState()
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("lavaarena_boarrior_fx")
            inst.AnimState:PlayAnimation("ground_hit_2")
            if I ~= nil then
                for A, B in ipairs(I) do inst.AnimState:Hide(B) end
            end
        else
            inst:AddTag("CLASSIFIED")
        end;

        inst:AddTag("groundspike")
        inst:AddTag("hostile")
        inst:AddTag("notarget")
        inst:AddTag("object")
        inst:AddTag("stone")

        inst:SetPrefabNameOverride("boarrior")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then return inst end;

        if toss then
            inst:DoTaskInTime(0, Toss)
        end

        inst:ListenForEvent("animover", inst.Remove)

        inst.persists = false

        return inst
    end;
    return
        Prefab(name, fn, assets)
end;

return MakeLift("lavaarena_groundlift", .7, true, false, { "embers" }),
    MakeLift("lavaarena_groundliftembers", .7, true, false),
    MakeLift("lavaarena_groundliftrocks", .7, true, false, { "embers", "splash" }),
    MakeLift("lavaarena_groundliftwarning", .7, false, false),
    MakeLift("lavaarena_groundliftempty", 1, false, true)
