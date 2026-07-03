local Ig = Ingredient

TroAddTech("LAVAARENA_BOARLORD")
TroAddPrototyperDef("lavaarena_boarlord", {
    is_crafting_station = true,
    action_str = "STORE",
    shop = true
})

for _, data in ipairs({
    { "spiderbattle", "quagmire_coin1", 0 },
    { "houndbattle",  "quagmire_coin1", 4 },
    { "mermbattle",   "quagmire_coin1", 6 },
    { "knightbattle", "quagmire_coin1", 10 },
    { "boarbattle",   "quagmire_coin1", 8 },
    { "lizardbattle", "quagmire_coin1", 12 },
}) do
    TroAddStoreRecipe("lavaarena_boarlord", data[1], { Ig(data[2], data[3]) }, TECH.LAVAARENA_BOARLORD_ONE, { atlas = data[4], image = data[5] })
end

-- 暴食商人交易，同暴食一样改成制作栏配方
-- lavaarena_boarlord
-- lavaarena_spectator1
-- lavaarena_spectator2
-- lavaarena_spectator3
-- lavaarena_spectator4
-- lavaarena_cerca
