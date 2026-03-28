local assets =
{
    Asset("ANIM", "anim/pressure_plate.zip"),
    Asset("ANIM", "anim/pressure_plate_build.zip"),
}

local prefabs =
{
    "pig_ruins_dart",
}

local function OnSave(inst, data)
    data.trap_dart = inst:HasTag("trap_dart") or nil
    data.trap_spear = inst:HasTag("trap_spear") or nil
    data.trap_door = inst:HasTag("trap_door") or nil
    data.localtrap = inst:HasTag("localtrap") or nil
    data.reversetrigger = inst:HasTag("reversetrigger") or nil
end

local function OnLoad(inst, data)
    if not data then return end
    if data.trap_dart then
        inst:AddTag("trap_dart")
    end
    if data.trap_spear then
        inst:AddTag("trap_spear")
    end
    if data.trap_door then
        inst:AddTag("trap_door")
    end
    if data.localtrap then
        inst:AddTag("localtrap")
    end
    if data.reversetrigger then
        inst:AddTag("reversetrigger")
    end
end

local function trigger(inst)
    if inst:HasTag("trap_dart") then
        local pt = inst:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 50, { "dartthrower" }, { "INTERIOR_LIMBO" })
        for i, ent in ipairs(ents) do
            if ent.SetAutodartThrower then
                ent:SetAutodartThrower(true)
            elseif ent.shoot then
                ent:shoot()
            end
        end
    elseif inst:HasTag("trap_spear") then
        local pt = inst:GetPosition()
        local dist = 50
        if inst:HasTag("localtrap") then
            dist = 4
        end
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, dist, { "spear_trap" }, { "INTERIOR_LIMBO" })
        for i, ent in ipairs(ents) do
            if ent then
                ent:PushEvent("triggertrap")
            end
        end
    else
        --开门
        local pt = inst:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 50, nil, { "INTERIOR_LIMBO" })
        for i, ent in ipairs(ents) do
            if ent:HasTag("lockable_door") then
                ent:PushEvent("open")
            end
        end
    end
end

local function untrigger(inst)
    if inst:HasTag("trap_dart") then
    elseif inst:HasTag("trap_spear") then
        local pt = inst:GetPosition()
        local dist = 50
        if inst:HasTag("localtrap") then
            dist = 4
        end
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, dist, { "spear_trap" }, { "INTERIOR_LIMBO" })
        for i, ent in ipairs(ents) do
            if ent then
                ent:PushEvent("reset")
            end
        end
    else
        local pt = inst:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 50, nil, { "INTERIOR_LIMBO" })
        for i, ent in ipairs(ents) do
            if ent:HasTag("lockable_door") then
                ent:PushEvent("close")
            end
        end
    end
end

local function onnear(inst)
    if inst.components.disarmable and inst.components.disarmable.armed and not inst.down then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/pressure_plate/hit")
        inst.AnimState:PlayAnimation("popdown")
        inst.AnimState:PushAnimation("down_idle")
        inst.down = true
        if inst:HasTag("reversetrigger") then
            untrigger(inst)
        else
            trigger(inst)
        end
    end
end

local function onfar(inst)
    if inst.components.disarmable and inst.components.disarmable.armed and inst.down then
        inst.AnimState:PlayAnimation("popup")
        inst.AnimState:PushAnimation("up_idle")
        inst.down = false
        if inst:HasTag("reversetrigger") then
            trigger(inst)
        else
            untrigger(inst)
        end
    end
end

local function disarm(inst, doer)
    inst.AnimState:PlayAnimation("disarmed")
    inst.components.creatureprox:SetEnabled(false)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/traps/disarm_floor")
    inst.down = false
end

local function rearm(inst, doer)
    inst.AnimState:PlayAnimation("up_idle")
    inst.components.creatureprox:SetEnabled(true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/traps/disarm_floor")
    if inst.components.creatureprox then
        inst.components.creatureprox:ForceTest()
    end
end

local function testfn(testinst)
    return not testinst:HasTag("flying") and not testinst:HasTag("notraptrigger")
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    anim:SetBank("pressure_plate")
    anim:SetBuild("pressure_plate_build")
    anim:PlayAnimation("up_idle")

    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("structure")
    inst:AddTag("weighdownable")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.down = false

    inst:AddComponent("disarmable")
    inst.components.disarmable.disarmfn = disarm
    inst.components.disarmable.rearmfn = rearm
    inst.components.disarmable.rearmable = true

    inst:AddComponent("creatureprox")
    inst.components.creatureprox:SetOnNear(onnear)
    inst.components.creatureprox:SetOnFar(onfar)
    inst.components.creatureprox:SetTestfn(testfn)
    inst.components.creatureprox:SetDist(0.8, 0.9)
    inst.components.creatureprox.inventorytrigger = true
    inst.components.creatureprox.period = 0.01

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("pig_ruins_pressure_plate", fn, assets, prefabs)
