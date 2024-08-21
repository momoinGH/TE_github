local function onFloodedStart(inst)
    if not inst.components.floodable.flooded then return end

    if inst:HasTag("prototyper") then
        inst:RemoveTag("prototyper") --通过这个方法禁掉科技
        inst.shipwrecked_prototyper = true
    end
    if inst:HasTag("trader") then
        inst:RemoveTag("trader")
        inst.shipwrecked_trader = true
    end
    if inst.components.container then
        inst.components.container.canbeopened = false
    end
    if inst.components.stewer then
        if inst.components.stewer.cooking then
            inst.components.stewer.product = "wetgoop"
        end
    end
    if inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    if inst.components.machine then
        inst.components.machine:TurnOff()
    end
end

local function onFloodedEnd(inst)
    if inst.components.container then
        inst.components.container.canbeopened = true
    end
    if inst.shipwrecked_prototyper then
        inst:AddTag("prototyper")
    end
    if inst.shipwrecked_trader then
        inst:AddTag("trader")
    end
end

local function InitFlood(inst)
    if not inst.components.floodable then
        inst:AddComponent("floodable")
        inst.components.floodable.onStartFlooded = onFloodedStart
        inst.components.floodable.onStopFlooded = onFloodedEnd
        inst.components.floodable.floodEffect = "shock_machines_fx"
        inst.components.floodable.floodSound = "dontstarve_DLC002/creatures/jellyfish/electric_land"

        inst:ListenForEvent("takefuel", onFloodedStart)
    end
end

for _, v in ipairs({
    "rainometer",
    "winterometer"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end
        InitFlood(inst)
    end)
end

for _, v in ipairs({
    "prototyper",
    "burnable",
    "stewer",
    "container",
    "trader"
}) do
    AddComponentPostInit(v, function(self)
        if not TheWorld.ismastersim then return end
        InitFlood(self.inst)
    end)
end

----------------------------------------------------------------------------------------------------
