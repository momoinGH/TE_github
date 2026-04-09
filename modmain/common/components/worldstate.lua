-- 定义一些TheWorld.state.xxx变量，用的时候可能还得判断模块的地形，可以先看看EntityScript有没有封装给实体判断用的方法

AddComponentPostInit("worldstate", function(self, inst)
    local OnTemperatureTick = Hooks.GetEventCallback(inst, "temperaturetick", inst, "scripts/components/worldstate.lua")
    local SetVariable = Hooks.GetUpvalue(OnTemperatureTick, "SetVariable")

    local function OnSeasonChange(inst, season)
        print("季节变化", season)

        -- 海难
        SetVariable("ismild", season == "autumn")  --温和季，秋
        SetVariable("iswet", season == "winter")   --飓风季，冬
        SetVariable("isdry", season == "summer")   --旱季，夏
        SetVariable("isgreen", season == "spring") --雨季，春
    end

    self:WatchWorldState("season", OnSeasonChange)
    inst:DoTaskInTime(0, function() OnSeasonChange(inst, self.data.season) end)

    -- 大灾变
    inst:ListenForEvent("beginaporkalypse", function() SetVariable("isaporkalypse", true) end)
    inst:ListenForEvent("endaporkalypse", function() SetVariable("isaporkalypse", false) end)
end)
