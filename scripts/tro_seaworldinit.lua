-- 海洋世界用的，用于在世界生成后删除实体和替换地皮，不过现在不需要海洋世界配置了

-- 需要保留的重要实体，值是应该保留几个
local important_ents = {
    pigking = 1,                    --猪王
    pighouse = math.random(10, 18), --猪人房
    monkeyqueen = 1,                --月亮码头女王
    multiplayer_portal = 1,         --绚丽之门
    cave_entrance = 99,             --被堵住的洞穴
    cave_entrance_open = 99,        --洞穴
}

local function ShouldRemoveEnt(ent)
    if ent.prefab
        and not ent.widget
        and not ent.isplayer
        and not ent.entity:GetParent()
        and ent.Network
        and not ent:HasTag("CLASSIFIED")
        and not ent:HasTag("INLIMBO")
        and not ent:HasTag("irreplaceable")
        and (important_ents[ent.prefab] or 0) <= 0
    then
        if important_ents[ent.prefab] then
            important_ents[ent.prefab] = important_ents[ent.prefab] - 1
        end
        return true
    end
end

-- 世界生成后把大量地面地皮换成海洋地皮，只保留重要实体附近的地皮，其他陆地地皮上的东西可以看着删了
return function()
    print("开启仅海洋世界设置，现在将不重要的实体和地形删除...")
    for _, ent in pairs(Ents) do
        if ShouldRemoveEnt(ent) then
            ent:Remove()
        end
    end
end
