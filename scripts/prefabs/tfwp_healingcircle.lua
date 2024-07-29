local a = 1 / 1000;

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")

    inst.blooms = {}
    inst.caster = nil;

    inst:AddComponent("heal_aura")
    inst:DoTaskInTime(TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.DURATION, function(c)
        for d, e in pairs(c.blooms) do
            if e.Kill ~= nil then
                e:Kill(true)
            end
        end;
        c:Remove()
    end)

    function inst:SpawnBlooms()
        local f = "healingcircle_bloom"
        for i = 1, 15 do
            local h = inst:GetPosition()
            if i == 1 then
                inst:DoTaskInTime(math.random(),
                    function()
                        local ent = SpawnPrefab(f)
                        ent.Transform:SetPosition(h:Get())
                        ent.buffed = inst.buffed;
                        table.insert(inst.blooms, ent)
                    end)
            elseif i >= 2 and i < 7 then
                local j = (i - 1) / 5 * TWOPI;
                local k = inst.components.heal_aura.range / 2;
                local pos = FindWalkableOffset(h, j, k, 2, true, true)
                if pos ~= nil then
                    pos.x = pos.x + h.x;
                    pos.z = pos.z + h.z;
                    inst:DoTaskInTime(math.random(),
                        function()
                            local ent = SpawnPrefab(f)
                            ent.Transform:SetPosition(pos.x, 0, pos.z)
                            ent.buffed = inst.buffed;
                            table.insert(inst.blooms, ent)
                        end)
                end
            elseif i >= 7 then
                local j = (i - 5) / 9 * TWOPI;
                local k = inst.components.heal_aura.range;
                local pos = FindWalkableOffset(h, j, k, 2, true, true)
                if pos ~= nil then
                    pos.x = pos.x + h.x;
                    pos.z = pos.z + h.z;
                    inst:DoTaskInTime(math.random(),
                        function()
                            local ent = SpawnPrefab(f)
                            ent.Transform:SetPosition(pos.x, 0, pos.z)
                            ent.buffed = inst.buffed;
                            table.insert(inst.blooms, ent)
                        end)
                end
            end
        end
    end;

    function inst:SpawnCenter()
        local h = inst:GetPosition()
        local m = SpawnPrefab("healingcircle_center")
        m.Transform:SetPosition(h.x, 0, h.z)
        m:DoTaskInTime(TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.COOLDOWN / 2, inst.Remove)
    end;

    inst:DoTaskInTime(0, inst.SpawnCenter)
    inst:DoTaskInTime(0, inst.SpawnBlooms)

    inst.persists = false

    return inst
end;

local function BloomFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")
    inst.AnimState:SetBank("lavaarena_heal_flowers")

    if not TheWorld.ismastersim then return inst end;

    inst.variation = tostring(math.random(1, 6))

    inst:AddComponent("colourfader")

    local function o()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds", "flower_sound")
        inst.SoundEmitter:SetVolume("flower_sound", .25)
    end;

    function inst:Start()
        o()
        inst.AnimState:PlayAnimation("in_" .. inst.variation)
        inst.AnimState:PushAnimation("idle_" .. inst.variation)
        if inst.buffed then
            local p = 1 + (math.random(unpack(TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.SCALE_RNG)) + math.random()) /
                100;
            inst.Transform:SetScale(p, p, p)
        end;
        inst.components.colourfader:StartFade({ 0, 0.3, 0.1 }, 650 * a,
            function(c) c:DoTaskInTime(350 * a, function() c.components.colourfader:StartFade({ 0, 0, 0 }, 457 * a) end) end)
    end;

    function inst:Kill(q)
        local r = q and math.random() or 0;
        inst:DoTaskInTime(r,
            function(c)
                o()
                c.AnimState:PushAnimation("out_" .. c.variation, false)
                c:ListenForEvent("animover", c.Remove)
            end)
    end;

    inst.OnLoad = inst.Kill;

    inst:DoTaskInTime(0, inst.Start)

    inst.persists = false

    return inst
end;

local function CenterFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_heal_flowers")
    inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")
    inst.AnimState:SetMultColour(0, 0, 0, 0)

    inst:AddTag("healingcircle")

    if not TheWorld.ismastersim then return inst end;

    inst.variation = tostring(math.random(1, 6))

    inst.AnimState:PlayAnimation("in_" .. inst.variation)
    inst.AnimState:PushAnimation("idle_" .. inst.variation)

    inst:DoTaskInTime(12, inst.Remove)

    inst.persists = false

    return inst
end;
return Prefab("healingcircle", Fn, nil, prefabs),
    Prefab("healingcircle_bloom", BloomFn, nil, nil),
    Prefab("healingcircle_center", CenterFn, nil, nil)
