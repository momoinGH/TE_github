local Utils = require("tro_utils/utils")

table.insert(PrefabFiles, "shipwrecked_flood")

----------------------------------------------------------------------------------------------------

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("sw_floodspawner") --洪水
end)

----------------------------------------------------------------------------------------------------

-- 在水坑里奔跑时播放特效
local function CheckHasFlood(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 8, { "sw_flood" }) > 0 then
        SpawnPrefab("weregoose_splash_less" .. tostring(math.random(2))).entity:SetParent(inst.entity)
    end
end

AddStategraphPostInit("wilson", function(sg)
    local run_timeline1 = Utils.GetStateTimelineIndex(sg.states["run"].timeline, 1 * FRAMES)
    if run_timeline1 then
        Hooks.FnDecorator(sg.states["run"].timeline[run_timeline1], "fn", CheckHasFlood)
    end
    local run_timeline2 = Utils.GetStateTimelineIndex(sg.states["run"].timeline, 9 * FRAMES)
    if run_timeline2 then
        Hooks.FnDecorator(sg.states["run"].timeline[run_timeline2], "fn", CheckHasFlood)
    end
end)
