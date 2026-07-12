-- 设置不同地形青蛙雨生成的青蛙预制件
AddComponentPostInit("frograin", function(self)
    local OldGetFrogPrefab, parent_fn, fn_i = Hooks.GetUpValue(self.SetSpawnTimes,
        "ToggleUpdate", "ScheduleSpawn", "SpawnFrogForPlayer", "SpawnFrog", "GetFrogPrefab")
    if OldGetFrogPrefab then
        local function GetFrogPrefab(spawn_point, player, ...)
            if player then
                if player:IsInHamletArea() then
                    return "frog_poison_ham"
                end
                if player:IsInShipwreckedArea() then
                    return "frog_poison_sw"
                end
            end
            return OldGetFrogPrefab(spawn_point, player, ...)
        end
        Hooks.SetUpvalue(parent_fn, "GetFrogPrefab", GetFrogPrefab)
    else
        TroErrorHandle("错误，获取frograin组件上值GetFrogPrefab失败，无法控制青蛙雨生成的青蛙预制件了", false)
    end
end)
