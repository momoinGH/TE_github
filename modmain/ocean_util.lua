---对波浪生成函数的一个封装
---@param inst ent 实体
---@param rotation number 发射方向，默认为实体朝向，如果不希望可以填 math.random(-180, 180)
---@param spawn_radius number 默认为实体的物理半径
---@param numWaves number
---@param totalAngle number
---@param waveSpeed number
---@param wavePrefab string 默认预制件为wave_med
---@param idleTime number
---@param instantActive boolean
---@return boolean wave_spawned 是否找到合适的点生成了波浪，inst在陆地上是不会生成的
function TroSpawnAttackWavesForEnt(inst, rotation, spawn_radius, numWaves, totalAngle, waveSpeed, wavePrefab, idleTime, instantActive)
    local position = inst:GetPosition()
    if spawn_radius == nil then
        spawn_radius = inst:GetPhysicsRadius(0)
    end
    if rotation == nil then
        rotation = inst.Transform:GetRotation()
    end
    return SpawnAttackWaves(position, rotation, spawn_radius, numWaves, totalAngle, waveSpeed, wavePrefab, idleTime, instantActive)
end
