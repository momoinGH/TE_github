for _, prefab in pairs({ "ash" }) do --灰烬施肥，给咖啡的
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("fertilizer")
    end)
end


for _, prefab in pairs({ "anchor" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("ancora")
    end)
end



for _, prefab in pairs({ "gogglesheathat", "bathat", "molehat" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("clearfog")
    end)
end

------------------------para a onda quebrar--------------

for _, prefab in pairs({ "cave_entrance_open", "cave_entrance_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportapracaverna")
    end)
end

for _, prefab in pairs({ "cave_exit", "cave_exit_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportaprafloresta")
    end)
end

for _, prefab in pairs({ "cave_exit", "cave_exit_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportaprafloresta")
    end)
end

-- 浪花碰撞检测对象
for _, prefab in pairs({ "seastack",
    "coralreef",
    "wreck",
    "waterygrave",
    "octopusking",
    "kraken",
    "ballphinhouse",
    "coral_brain_rock",
    "saltstackthen",
    "wall_enforcedlimestone",
    "kraken_tentacle",
    "sea_chiminea",
    "sea_yard",
    "buoy" }) do
    AddPrefabPostInit(prefab, function(inst)
        inst:AddTag("quebraonda")
    end)
end



for _, prefab in pairs({ "saplingnova", "sapling" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst.entity:AddSoundEmitter() --ventania风相关
        inst:AddTag("saplingsw")
    end)
end


for _, prefab in pairs({ "sewing_tape" }) do
    AddPrefabPostInit(prefab, function(inst)
        inst:AddTag("boatrepairkit")
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("interactions")
    end)
end



for _, prefab in pairs(
    { "houndstooth",
        "gunpowder",
        "boards",
        "mosquitosack",
        "nightmarefuel",
        "stinger",
        "spear",
        "spear_wathgrithr" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("tradable")
    end)
end

-- 防止在季节/潮湿季节里雾的减速效果。
for _, v in ipairs({
    "bathat",
    "pithhat",
    "armor_weevole",
}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("velocidadenormal")
    end)
end
