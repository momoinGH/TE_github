-- 定义一些TheWorld.state.xxx变量，用的时候可能还得判断模块的地形，可以先看看EntityScript有没有封装给实体判断用的方法

AddComponentPostInit("worldstate", function(self, inst)
    local _watchers = Hooks.GetUpValue(self.AddWatcher, "_watchers")

    ---@param check_fn fn 检查实体是否符合条件来决定是否给这个实体推送事件
    local function SetVariable(var, val, check_fn)
        if self.data[var] ~= val and val ~= nil then
            self.data[var] = val

            local watchers = _watchers[var]
            if watchers ~= nil then
                for k, v in pairs(watchers) do
                    for i, fn in ipairs(v) do
                        if not (check_fn and fn[2] and EntityScript.is_instance(fn[2]) and not check_fn(fn[2])) then
                            fn[1](fn[2], val)
                        end
                    end
                end
            end
        end
    end

    local function OnSeasonChange(inst, season)
        print("季节变化", season)

        -- 海难
        SetVariable("ismild", season == "autumn", EntityScript.IsInShipwreckedArea)  --温和季，秋
        SetVariable("iswet", season == "winter", EntityScript.IsInShipwreckedArea)   --飓风季，冬
        SetVariable("isdry", season == "summer", EntityScript.IsInShipwreckedArea)   --旱季，夏
        SetVariable("isgreen", season == "spring", EntityScript.IsInShipwreckedArea) --雨季，春
    end

    self:WatchWorldState("season", OnSeasonChange)
    inst:DoTaskInTime(0, function() OnSeasonChange(inst, self.data.season) end)

    -- 大灾变
    inst:ListenForEvent("beginaporkalypse", function() SetVariable("isaporkalypse", true, EntityScript.IsInHamletArea) end)
    inst:ListenForEvent("endaporkalypse", function() SetVariable("isaporkalypse", false, EntityScript.IsInHamletArea) end)
end)


AddPrefabPostInit("log", function(inst)
    inst:WatchWorldState("ismild", function(inst, ismild)
        print("温和季到了", inst, ismild)
    end)
    print("是温和季吗", TheWorld.state.ismild)
end)
