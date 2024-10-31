local assets =
{
    Asset("ANIM", "anim/fan_tropical.zip"),
    Asset("ANIM", "anim/fan.zip"),
}

local function OnUse(inst, target)
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.FEATHERFAN_RADIUS, nil,
        { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }, { "smolder", "fire", "player" })
    for i, v in pairs(ents) do
        if v.components.burnable ~= nil then
            -- Extinguish smoldering/fire and reset the propagator to a heat of .2
            v.components.burnable:Extinguish(true, 0)
        end
        if v.components.temperature ~= nil then
            -- cool off yourself and any other nearby players
            v.components.temperature:DoDelta(math.clamp(
                TUNING.FEATHERFAN_MINIMUM_TEMP - v.components.temperature:GetCurrent(), TUNING.FEATHERFAN_COOLING, 0))
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.05)

    inst.AnimState:SetBank("fan_tropical")
    inst.AnimState:SetBuild("fan_tropical")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fan")
    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fan")
    inst.components.fan:SetOnUseFn(OnUse)
    --    inst.components.fan:SetOverrideSymbol("swap_fan_tropical")
    inst.components.fan:SetOverrideSymbol("fan01")
    inst.components.fan.overridebuild = "fan_tropical"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.FAN, 1)
    inst.components.finiteuses:SetMaxUses(TUNING.FEATHERFAN_USES)
    inst.components.finiteuses:SetUses(TUNING.FEATHERFAN_USES)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tropicalfan", fn, assets)
