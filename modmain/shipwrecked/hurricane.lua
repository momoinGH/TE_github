--给草追加单机的刮风动画
table.insert(Assets, Asset("ANIM", "anim/grass_blown.zip"))
table.insert(Assets, Asset("ANIM", "anim/sapling_blown.zip"))

----------------------------------------------------------------------------------------------------

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("tro_hurricane")   --海难飓风季
    inst:AddComponent("tro_hailmanager") --冰雹
end)


----------------------------------------------------------------------------------------------------
local function ongustpick(inst)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
        inst.components.pickable:Pick(inst)
    end
end

for _, data in ipairs({
    { "grass",   0.2, 0.1 },
    { "nettle",  0.2, 0.1 },
    { "sapling", 0.2, 0.1, "sway" }
}) do
    AddPrefabPostInit(data[1], function(inst)
        if not TheWorld.ismastersim then return end
        MakePickableBlowInWindGust(inst, data[2], data[3], data[4])
    end)
end

for _, data in ipairs({
    { "bamboo",        0.2, 0.1 },
    { "bambootree",    0.2, 0.1 },
    { "bambootreebig", 0.2, 0.1 },
    { "bush_vine",     0.2, 0.1 },
}) do
    AddPrefabPostInit(data[1], function(inst)
        if not TheWorld.ismastersim then return end
        MakeHackableBlowInWindGust(inst, data[2], data[3])
    end)
end

for _, v in ipairs({
    "berrybush",
    "berrybush_snake",
    "berrybush2",
    "berrybush2_snake",
    "coffeebush"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:AddComponent("blowinwindgust")
        inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.BERRYBUSH_WINDBLOWN_SPEED)
        inst.components.blowinwindgust:SetDestroyChance(TUNING.BERRYBUSH_WINDBLOWN_FALL_CHANCE)
        inst.components.blowinwindgust:SetDestroyFn(ongustpick)
        inst.components.blowinwindgust:Start()
    end)
end

AddPrefabPostInit("reeds", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
    inst.components.blowinwindgust:SetDestroyChance(0.1)
    inst.components.blowinwindgust:SetDestroyFn(ongustpick)
    inst.components.blowinwindgust:Start()
end)


modimport "modmain/shipwrecked/prefabs/hurricane_tree.lua"
