local Utils = require("tropical_utils/utils")

-- 海难洪水仪器失灵

local function Failure(inst)
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
        inst.components.machine.enabled = false --不考虑原来是否可以使用
    end
end

local function onFloodedStart(inst)
    Failure(inst)
    inst:ListenForEvent("takefuel", Failure)
end

local function onFloodedEnd(inst)
    if inst.components.container then
        inst.components.container.canbeopened = true
    end
    if inst.shipwrecked_prototyper then
        inst:AddTag("prototyper")
        inst.shipwrecked_prototyper = nil
    end
    if inst.shipwrecked_trader then
        inst:AddTag("trader")
        inst.shipwrecked_trader = nil
    end
    if inst.components.machine then
        inst.components.machine.enabled = true
    end

    inst:RemoveEventCallback("takefuel", Failure)
end

local function InitFlood(inst, metal)
    if not inst.components.floodable then
        inst:AddComponent("floodable")
        inst.components.floodable.onStartFlooded = onFloodedStart
        inst.components.floodable.onStopFlooded = onFloodedEnd
        if metal then
            inst.components.floodable.floodEffect = "shock_machines_fx"
            inst.components.floodable.floodSound = "dontstarve_DLC002/creatures/jellyfish/electric_land"
        end
    end
end

local function TestCanBuildBefore(self)
    return { false, false }, GetClosestInstWithTag("mare", self.inst, 10) ~= nil
end

for _, data in ipairs({
    -- {预制件名、是否播放特效和音效、禁止建造的placer}
    { "rainometer", true },
    { "winterometer" },

    { "researchlab", true },
    { "researchlab2", true },
    { "researchlab3", true },
    { "researchlab4", true },
    { "piratihatitator", true },
    { "seafaring_prototyper", true },
    { "hogusporkusator", true },
    { "tacklestation", true },
    { "madscience_lab", true },

    { "cookpot", true },
    { "portablecookpot", true },
    { "portableblender", true },
    { "portablespicer", true },

    { "winona_spotlight", true },
    { "winona_catapult", true },

    { "firesuppressor", true },
    { "icemaker", true },
    { "icebox", true },
    { "slotmachine", true },

    { "campfire", false, "campfire_placer" },
    { "firepit", false, "firepit_placer" },
    { "coldfire", false, "coldfire_placer" },
    { "coldfirepit", false, "coldfirepit_placer" },
    { "obsidianfirepit", false, "obsidianfirepit_placer" },
}) do
    AddPrefabPostInit(data[1], function(inst)
        if not TheWorld.ismastersim then return end
        InitFlood(inst, data[2])
    end)

    if data[3] then
        AddPrefabPostInit(data[3], function(inst)
            Utils.FnDecorator(inst.components.placer, "TestCanBuild", TestCanBuildBefore)
        end)
    end
end



----------------------------------------------------------------------------------------------------
