local tasks = {
    "HomeIsland",
    "RockyGold",       --火山矿区  ["MagmaGold"] = 2,  ["MagmaGoldBoon"] = 1,
    "BoreKing",        --野猪王  ["PigVillagesw"] = 1,      ["JungleDenseBerries"] = 1,  ["BeachShark"] = 1,
    "RockyTallJungle", -- 火山矿  ["MagmaTallBird"] = 1,  ["MagmaGoldBoon"] = 1,
    "BeachSkull",      --骷髅岛 ["JungleRockSkull"] = 1, random
    "MagmaJungle",     --猴子 ["MagmaForest"] = 1, -- MR went from 1-3    ["JungleDense"] = 1,    ["JunglePigs"] = 1,没有猪
    "JungleMarshy",    --热带沼泽和沙滩
    "JungleBushy",     --沙滩和丛林，纯随机
    "JungleBeachy",    --热带丛林+纯随机
    "JungleMonkey",    --猴子  ["JungleMonkeyHell"] = 2,
    "BeachMarshy",     --纯随机 沙滩和沼泽
    "MoonRocky",       --月石矿
    "TigerSharky",     --虎鲨+沼泽+丛林   required_prefabs = { "tigersharkpool" },好奇怪
    "Verdent",         --绿草地  ["Beaverkinghome"] = 1,    ["Beaverkingcity"] = 1, beaver是什么东西
    "Casino",          --["BeachPalmCasino"] = 1, 抽奖机
    "BeachBeachy",     --随机  [salasbeach[math.random(1, 24)]] = 1,  ["BeachShark"] = 1,又是啥玩意
    "BeachPiggy",      --猪人沙滩
    "DoyDoyM",         ---doydoyM
    "DoyDoyF",         ---doydoyF
    "Volcano ground",  --火山  ["VolcanoAsh"] = 1,       ["Volcano"] = 1,    ["VolcanoObsidian"] = 1,

    -- "A_BLANK1",
    -- "A_BLANK2",
    -- "A_BLANK3",
    -- "A_BLANK4",
    -- "A_BLANK5",
    -- "A_BLANK6",
    -- "A_BLANK7",
    -- "A_BLANK8",
    -- "A_BLANK9",
    -- "A_BLANK10",
    -- "A_BLANK11",
    -- "A_BLANK12",
}

for _, t in ipairs(tasks) do
    AddTaskPreInit(t, function(task)
        -- task.region_id = "shipwrecked" --所有地形为一个岛
        task.region_id = t

        task.room_tags = task.room_tags or {}
        table.insert(task.room_tags, "tropical")     --我们mod地形
        table.insert(task.room_tags, "shipwrecked")  --模块专属标签
        table.insert(task.room_tags, "RoadPoison")   --禁止生成卵石路
        table.insert(task.room_tags, "not_mainland") --单独的小岛
        table.insert(task.room_tags, "No_Winter")    --没有冬天
        table.insert(task.room_tags, "nohasslers")   --不生成熊大
        table.insert(task.room_tags, "nohunt")
    end)
end

AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        for _, t in ipairs(tasks) do
            table.insert(level.tasks, t)
        end
    end
end)

----------------------------------------------------------------------------------------------------
-- 沿海地形
AddRoomPreInit("OceanCoastal", function(room)
    room.contents.countprefabs = room.contents.countprefabs or {}
    room.contents.countprefabs.mermboat = 4 --鱼人海盗船

    table.tromerge(room.contents.distributeprefabs, {
        messagebottle_sw = 0.1,
        seaweed_planted = 3,
        mussel_farm = 2,
        lobsterhole = 1 / 2,
        ballphinhouse = .1 / 2,
        jellyfish_spawner = 1 / 2,
        rainbowjellyfish_spawner = 0.25 / 2,
        bioluminescence_spawner = 0.1,
    })
end)

-- 给这些task添加新的钥匙，解锁该task就能凭借钥匙解锁其他的task了
AddTaskPreInit("RedForest", function(task)
    task.keys_given = task.keys_given or {}
    table.insert(task.keys_given, KEYS.VOLCANO_ENTRANCE)
end)

AddRoomPreInit("OceanSwell", function(room)
    table.tromerge(room.contents.distributeprefabs, {
        ballphinhouse = 2,
        redbarrel = 1,
        seagullspawner = 6,
        oceanfog = 2,
        tar_pool = 1,
        bioluminescence_spawner = 5,
    })

    room.contents.countprefabs =
    {
        oceanfish_shoalspawner = 3,
    }
end)

AddRoomPreInit("OceanRough", function(room)
    table.tromerge(room.contents.distributeprefabs, {
        redbarrel = 0.1,
        bioluminescence_spawner = .5,
        oceanfog = 0.1,
    })
    room.contents.countprefabs = {
        luggagechest = 4,
        rawling = 1
    }
end)

-- 很危险的深海
AddRoomPreInit("OceanHazardous", function(room)
    room.contents.distributepercent = 0.3
    table.tromerge(room.contents.distributeprefabs, {
        waterygrave = 5,
        wreck = 4,
        seaweed_planted = 3,

        pirateghost = 4,
        redbarrel = 2,
        bishopwaterfixo = .5,
        rookwater = .5,
        knightboat = .5,

        luggagechest_spawner = .3,
        whale_bluefinal = 1,

    })
    room.contents.countprefabs = {
        kraken = 1, --海妖
        octopusking = 1, --章鱼王
    }
end)

AddRoomPreInit("OceanRough", function(room)
    room.contents.countprefabs = room.contents.countprefabs or {}
    table.tromerge(room.contents.countprefabs, {
        rawling = 1,
        tar_pool = 8,
    })
end)
