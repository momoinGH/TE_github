require("map/lockandkey")

local ARRAY_NEW =
{
    "JUNGLE_DEPTH_1",
    "JUNGLE_DEPTH_2",
    "JUNGLE_DEPTH_3",

    "CIVILIZATION_1",
    "CIVILIZATION_2",

    "LAND_DIVIDE_1",
    "LAND_DIVIDE_2",
    "LAND_DIVIDE_3",
    "LAND_DIVIDE_4",
    "LAND_DIVIDE_5", ------

    "OTHER_JUNGLE_DEPTH_1",
    "OTHER_JUNGLE_DEPTH_2",
    "LOST_JUNGLE_DEPTH_2",

    "ISLAND_1",
    "ISLAND_2",
    "ISLAND_3",
    "ISLAND_4",
    "ISLAND_5",

    "PINACLE",

    "OTHER_CIVILIZATION_1",
    "OTHER_CIVILIZATION_2",

    "WILD_JUNGLE_DEPTH_1",
    "WILD_JUNGLE_DEPTH_2",

    "ISLAND1",
    "ISLAND2",
    "ISLAND3",
    "ISLAND4",
    "ISLAND5",
    "ISLAND6",
    "ISLAND7",
    "ISLAND8",
    "ISLAND9",
    "ISLAND10",
    "ISLAND11",

    "VOLCANO_ENTRANCE", --火山洞穴
    "VOLCANO_DIVIDE"
}

-- 声明新的锁和钥匙
local function AddSimpleKeyLock(name)
    table.insert(KEYS_ARRAY, name)
    KEYS[name] = #KEYS_ARRAY
    table.insert(LOCKS_ARRAY, name)
    LOCKS[name] = #LOCKS_ARRAY
    LOCKS_KEYS[LOCKS[name]] = { KEYS[name] } --解锁这个只需要name钥匙
end


for i, v in ipairs(ARRAY_NEW) do
    AddSimpleKeyLock(v)
end
