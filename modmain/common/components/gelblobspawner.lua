-- 移除恶液生成点，不会在火山和海底地形生成
AddComponentPostInit("gelblobspawner", function(self)
    Hooks.FnDecorator(self, "TryToRegisterSpawningPoint", function(self, spawnpoint)
        if spawnpoint:IsInVolcanoArea()
            or spawnpoint:IsInUnderWaterArea()
        then
            spawnpoint:DoTaskInTime(0, spawnpoint.Remove)
            return { false }, true
        end
    end)
end)
