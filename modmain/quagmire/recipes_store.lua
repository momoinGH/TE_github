local Ig = Ingredient

TroAddTech("QUAGMIRE_TRADER_MERM") --直接用商人预制件名作为TECH省事点
TroAddPrototyperDef("quagmire_trader_merm", {
    is_crafting_station = true,
    action_str = "STORE",
    shop = true
})

for _, product in ipairs({
    "quagmire_seedpacket_1",
    "quagmire_seedpacket_2",
    "quagmire_seedpacket_4",
    "quagmire_seedpacket_5",
    "quagmire_seedpacket_6",
    "quagmire_seedpacket_mix",
    "quagmire_key_park"
}) do
    TroAddStoreRecipe("quagmire_trader_merm", product, { Ig("quagmire_coin1", 1) }, TECH.QUAGMIRE_TRADER_MERM_ONE) --注意科技是后缀_ONE
end

----------------------------------------------------------------------------------------------------
TroAddTech("QUAGMIRE_TRADER_MERM2")
TroAddPrototyperDef("quagmire_trader_merm2", {
    is_crafting_station = true,
    action_str = "STORE",
    shop = true
})

local food_atlas = resolvefilepath("images/quagmire_food_common_inv_images.xml")
for _, data in ipairs({
    { "quagmire_seedpacket_7",  "quagmire_coin1", 1 },
    { "quagmire_seedpacket_3",  "quagmire_coin1", 1 },
    { "quagmire_sapbucket",     "quagmire_coin1", 3 },
    { "quagmire_pot_syrup",     "quagmire_coin1", 4 },
    { "quagmire_pot",           "quagmire_coin1", 4 },
    { "quagmire_casseroledish", "quagmire_coin1", 4 },
    { "quagmire_crate_grill",   "quagmire_coin1", 8 },
}) do
    TroAddStoreRecipe("quagmire_trader_merm2", data[1], { Ig(data[2], data[3]) }, TECH.QUAGMIRE_TRADER_MERM2_ONE, { atlas = data[4], image = data[5] })
end

----------------------------------------------------------------------------------------------------

TroAddTech("QUAGMIRE_GOATMUM")
TroAddPrototyperDef("quagmire_goatmum", {
    is_crafting_station = true,
    action_str = "STORE",
    shop = true
})

for _, data in ipairs({
    { "quagmire_crate_pot_hanger",  "quagmire_coin1", 6 },
    { "quagmire_crate_oven",        "quagmire_coin1", 6 },
    { "quagmire_crate_grill_small", "quagmire_coin1", 6 },
    { "quagmire_plate_silver",      "quagmire_coin2", 2, food_atlas, "plate_silver.tex" },
    { "quagmire_bowl_silver",       "quagmire_coin2", 2, food_atlas, "bowl_silver.tex" },
    { "quagmire_goatmilk",          "quagmire_coin3", 1 },
    { "quagmire_portal_key",        "quagmire_coin4", 3 },
}) do
    TroAddStoreRecipe("quagmire_goatmum", data[1], { Ig(data[2], data[3]) }, TECH.QUAGMIRE_GOATMUM_ONE, { atlas = data[4], image = data[5] })
end

----------------------------------------------------------------------------------------------------

TroAddTech("QUAGMIRE_SWAMPIGELDER")
TroAddPrototyperDef("quagmire_swampigelder", {
    is_crafting_station = true,
    action_str = "STORE",
    shop = true
})

for _, data in ipairs({
    { "axe",          "log",           5, nil, "axe_victorian.tex" },
    { "shovel",       "log",           5, nil, "shovel_victorian.tex" },
    { "quagmire_hoe", "log",           5 },
    { "fertilizer",   "log",           10 },
    { "quagmire_key", "quagmire_salt", 3 },
}) do
    TroAddStoreRecipe("quagmire_swampigelder", data[1], { Ig(data[2], data[3]) }, TECH.QUAGMIRE_SWAMPIGELDER_ONE, { atlas = data[4], image = data[5] })
end

----------------------------------------------------------------------------------------------------

TroAddTech("QUAGMIRE_GOATKID")
TroAddPrototyperDef("quagmire_goatkid", {
    is_crafting_station = true,
    action_str = "STORE",
    shop = true
})

for _, data in ipairs({
    -- { "quagmire_pigeon_shop_item", "quagmire_coin1", 3 }, --好像没有这个，科雷删了
    { "quagmire_salt_rack_item", "quagmire_coin1", 8 },
    { "fishingrod",              "quagmire_coin1", 3 },
    { "trap",                    "quagmire_coin1", 4 },
    { "birdtrap",                "quagmire_coin1", 5 },
    { "quagmire_crabtrap",       "quagmire_coin3", 1 },
    { "quagmire_slaughtertool",  "quagmire_coin3", 1 },
}) do
    TroAddStoreRecipe("quagmire_goatkid", data[1], { Ig(data[2], data[3]) }, TECH.QUAGMIRE_GOATKID_ONE, { atlas = data[4], image = data[5] })
end
