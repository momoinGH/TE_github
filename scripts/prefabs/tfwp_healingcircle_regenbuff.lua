local function Heal(b, c)
    if c.components.health ~= nil and not c.components.health:IsDead() and not c:HasTag("playerghost") then
        local d = b.heal_value;
        local e = c.healmult and c.healmult or 1;
        if c.components.buffable then d = d * (c.components.buffable:GetBuffData("heal_recieved_mult") + 1) end;
        c.components.health:DoDelta(d * e, true, "healingcircle", nil, b.caster)
    else
        b.components.debuff:Stop()
    end
end;

local function Attached(b, c)
    b.entity:SetParent(c.entity)
    b.task = b:DoPeriodicTask(b.tick_rate, Heal, nil, c)
    b:ListenForEvent("death", function() b.components.debuff:Stop() end, c)
end;

local function OnTimerDone(b, h) if h.name == "regenover" then b.components.debuff:Stop() end end;

local function Extended(b, c)
    b.components.timer:StopTimer("regenover")
    b.components.timer:StartTimer("regenover", b.duration)
    b.task:Cancel()
    b.task = b:DoPeriodicTask(b.tick_rate, Heal, nil, c)
end;

local function Init(inst)
    local k = inst.entity:GetParent()
    if k ~= nil then k:PushEvent("starthealthregen", inst) else inst:Remove() end
end;

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:DoTaskInTime(0, Init)

    if not TheWorld.ismastersim then
        return inst
    end;

    inst.tick_rate = 1 / 30;
    inst.heal_value = TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.HEAL_RATE * inst.tick_rate;
    inst.duration = TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.DURATION;
    inst.caster = nil;

    inst.entity:Hide()

    inst.persists = false;

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(Attached)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(Extended)
    inst.components.debuff.keepondespawn = true;

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("regenover", inst.duration)

    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end;
return Prefab("healingcircle_regenbuff", fn)
