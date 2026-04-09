-- 定义一些TheWorld.state.xxx变量，用的时候可能还得判断模块的地形，可以先看看EntityScript有没有封装给实体判断用的方法

AddComponentPostInit("worldstate", function(self, inst)
    local _watchers = Hooks.GetUpValue(self.AddWatcher, "_watchers")

    local function SetVariable(var, val, togglename)
        if self.data[var] ~= val and val ~= nil then
            self.data[var] = val

            local watchers = _watchers[var]
            if watchers ~= nil then
                for k, v in pairs(watchers) do
                    for i, fn in ipairs(v) do
                        fn[1](fn[2], val)
                    end
                end
            end

            if togglename then
                watchers = _watchers[(val and "start" or "stop") .. togglename]
                if watchers ~= nil then
                    for k, v in pairs(watchers) do
                        for i, fn in ipairs(v) do
                            fn[1](fn[2])
                        end
                    end
                end
            end
        end
    end

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
