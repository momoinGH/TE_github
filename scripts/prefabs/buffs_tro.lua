local speedupattr = {
    coffee = {
        mult = 11 / 6, -- 基础速度+5
        duration = 240,
    },
    tropicalbouillabaisse = {
        mult = 1.5, -- 基础速度+3
        duration = 60,
    },
    tea = {
        mult = 17 / 12, -- 咖啡的一半
        duration = 120, -- 咖啡的一半
    },
    icedtea = {
        mult = 23 / 18, -- 咖啡的1/3
        duration = 80,  -- 咖啡的1/3
    },
}

local function speedup_attach(inst, target, followsymbol, followoffset, data)
    if not data then
        return
    end
    inst._debuffkey_tro = data.debuffkey
    inst.components.timer:StopTimer("buffover")
    inst.components.timer:StartTimer("buffover", speedupattr[data.debuffkey].duration)
    if target.components.locomotor then
        target.components.locomotor:SetExternalSpeedMultiplier(target, "speedup_tro", speedupattr[data.debuffkey].mult)
    end
end

local function speedup_extend(inst, target, followsymbol, followoffset, data)
    if not inst._debuffkey_tro then
        speedup_attach(inst, target, followsymbol, followoffset, data)
    end
    if not data then
        return
    end
    if speedupattr[data.debuffkey].mult > speedupattr[inst._debuffkey_tro].mult then
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", speedupattr[data.debuffkey].duration)
        if target.components.locomotor then
            target.components.locomotor:RemoveExternalSpeedMultiplier(target, "speedup_tro")
            target.components.locomotor:SetExternalSpeedMultiplier(target, "speedup_tro",
                speedupattr[data.debuffkey].mult)
        end
        inst._debuffkey_tro = data.debuffkey
    elseif data.debuffkey == inst._debuffkey_tro then
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", speedupattr[data.debuffkey].duration)
    end
end

local function speedup_detach(inst, target)
    if target.components.locomotor then
        target.components.locomotor:RemoveExternalSpeedMultiplier(target, "speedup_tro")
    end
    inst._debuffkey_tro = nil
end

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local ATTACH_BUFF_DATA = {
        -- buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name),
        priority = priority
    }
    local DETACH_BUFF_DATA = {
        -- buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name),
        priority = priority
    }

    local function OnAttached(inst, target, ...)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if onattachedfn ~= nil then
            onattachedfn(inst, target, ...)
        end
    end

    local function OnExtended(inst, target, ...)
        if duration and duration > 0 then
            inst.components.timer:StopTimer("buffover")
            inst.components.timer:StartTimer("buffover", duration)
        end

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if onextendedfn ~= nil then
            onextendedfn(inst, target, ...)
        end
    end

    local function OnDetached(inst, target, ...)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target, ...)
        end

        target:PushEvent("foodbuffdetached", DETACH_BUFF_DATA)
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_" .. name, fn, nil, prefabs)
end

return MakeBuff("speedup_tro", speedup_attach, speedup_extend, speedup_detach, 0, 2)
