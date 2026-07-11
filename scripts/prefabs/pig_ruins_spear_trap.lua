require "stategraphs/SGspear_trap"

local assets =
{
    Asset("ANIM", "anim/spear_trap.zip"),
    Asset("MINIMAP_IMAGE", "spear_trap"),
}

local prefabs =
{

}

local SPEAR_TRAP_HEALTH = 100
local SPEAR_TRAP_DAMNAGE = 34

local AREA = 1.3

local function inflictdamage(inst)
    local pt = Point(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, AREA, nil, { "spear_trap", "INTERIOR_LIMBO" })
    for i, ent in ipairs(ents) do
        if ent.components.health then
            inst.components.combat:DoAttack(ent)
        end
        if ent.components.workable and ent.components.workable.workleft > 0 then
            ent.components.workable:Destroy(inst)
        end
    end
end

local function setextendeddata(inst, extended)
    if extended then
        inst:RemoveTag("NOCLICK")
        inst.extended = true
        inst:AddTag("hostile")
        inst:RemoveTag("fireimmune")
        inst.components.health.vulnerabletoheatdamage = true
        inst.name = STRINGS.NAMES.PIG_RUINS_SPEAR_TRAP_TRIGGERED
        inst.Physics:SetActive(true)
        inst.MiniMapEntity:SetIcon("spear_trap.png")
    else
        inst:AddTag("NOCLICK")
        inst.extended = nil
        inst:RemoveTag("hostile")
        inst:AddTag("fireimmune")
        inst.components.health.vulnerabletoheatdamage = false
        inst.name = STRINGS.NAMES.PIG_RUINS_SPEAR_TRAP
        inst.Physics:SetActive(false)
        inst.MiniMapEntity:SetIcon("")
    end
end

local function onsave(inst, data)
    if inst.extended then
        data.extended = true
    end

    if inst:HasTag("up_3") then
        data.up_3 = true
    end
    if inst:HasTag("down_6") then
        data.down_6 = true
    end
    if inst:HasTag("delay_3") then
        data.delay_3 = true
    end
    if inst:HasTag("delay_6") then
        data.delay_6 = true
    end
    if inst:HasTag("delay_9") then
        data.delay_9 = true
    end
end

local function onload(inst, data)
    if data then
        if data.extended then
            inst.sg:GoToState("extended")
        end
        if data.up_3 then
            inst:AddTag("up_3")
        end
        if data.down_6 then
            inst:AddTag("down_6")
        end
        if data.delay_3 then
            inst:AddTag("delay_3")
        end
        if data.delay_6 then
            inst:AddTag("delay_6")
        end
        if data.delay_9 then
            inst:AddTag("delay_9")
        end
    end
end

local function OnKilled(inst)
    inst:PushEvent("dead")
end

local function burnt(inst)
    local debris = SpawnPrefab("pig_ruins_spear_trap_broken")
    debris.AnimState:PlayAnimation("burnt")
    debris.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function OnHit(inst)
    inst:PushEvent("hit")
end

local function cycletrap(inst)
    if not inst:HasTag("burnt") and not inst:HasTag("dead") then
        if inst.sg:HasStateTag("extended") then
            inst:PushEvent("reset")
        elseif inst.sg:HasStateTag("retracted") then
            inst:PushEvent("triggertrap")
        end
    end
end


local function cycleup(inst)
    if inst.cycletask then
        inst.cycletask:Cancel()
        inst.cycletask = nil
    end
end

local function cycledown(inst)
    if inst.cycletask then
        inst.cycletask:Cancel()
        inst.cycletask = nil
    end
end

local function returntointeriorscene(inst)
    cycletrap(inst)
end

local function removefrominteriorscene(inst)
    cycletrap(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetActive(false)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("")

    anim:SetBank("spear_trap")
    anim:SetBuild("spear_trap")
    anim:PlayAnimation("idle_retract")

    inst:AddTag("spear_trap")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.setextendeddata = setextendeddata
    inst.inflictdamage = inflictdamage

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)
    inst.components.combat:SetDefaultDamage(SPEAR_TRAP_DAMNAGE)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(SPEAR_TRAP_HEALTH)

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.SHEAR)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnKilled)

    inst:SetStateGraph("SGspear_trap")

    MakeSmallBurnable(inst)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(burnt)
    MakeSmallPropagator(inst)


    inst.cycleup = cycleup
    inst.cycledown = cycledown
    inst.returntointeriorscene = returntointeriorscene
    inst.removefrominteriorscene = removefrominteriorscene

    inst.OnLoad = onload
    inst.OnSave = onsave

    inst:ListenForEvent("death", OnKilled)
    inst:ListenForEvent("triggertrap", function(inst, data)
        if inst:IsValid() then
            inst:DoTaskInTime(math.random() * 0.25, function()
                inst:PushEvent("spring")
            end)
        end
    end)

    return inst
end

local function debrisfn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    anim:SetBank("spear_trap")
    anim:SetBuild("spear_trap")
    anim:PlayAnimation("broken")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("pig_ruins_spear_trap", fn, assets, prefabs),
    Prefab("pig_ruins_spear_trap_broken", debrisfn, assets, prefabs)
