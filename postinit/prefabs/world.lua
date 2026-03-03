--[[这些是TA的
AddPrefabPostInit("forest", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("climatespawner") -----这个东西很复杂--海浪在这里
        inst:AddComponent("economy")
        inst:AddComponent("contador")
        inst:AddComponent("bigfooter")
        inst:AddComponent("roottrunkinventory") ---------------这个是啥啊
        inst:AddComponent("creature_spawner")   ----不只有生物，还有旋涡，天光之类的内容
        -- inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
        inst:AddComponent("quaker_interior") ------------这是啥


        if TUNING.sealnado then
            inst:AddComponent("twisterspawner")
        end


        if TUNING.hamlet then
            inst:AddComponent("banditmanager")

            if TUNING.roc then
                inst:AddComponent("rocmanager")
            end
        end
    end
end)


AddPrefabPostInit("cave", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("roottrunkinventory")
        inst:AddComponent("quaker_interior")
        inst:AddComponent("economy")
        inst:AddComponent("contador")
    end
end)

AddPrefabPostInitAny(function(inst)
    if not TheWorld or TheWorld.net ~= inst then
        return
    end

    if TUNING.aporkalypse then
        print("add aporkalypse in world net")
        inst:AddComponent("aporkalypse")
    else
        print("not add aporkalypse in world net")
    end
end)


AddPrefabPostInit("forest_network", function(inst)
    print("print forest_network", inst)
    inst:AddComponent("weatherham")
end)]]

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("economy")
    inst:AddComponent("shadowmanager")

    if TUNING.tropical.sealnado then
        inst:AddComponent("twisterspawner")
    end

    if TUNING.tropical.only_hamlet or GetModConfigData("Hamlet") ~= 5 then
        inst:AddComponent("roottrunkinventory")
    end

    if not TUNING.tropical.only_shipwrecked
        and (TUNING.tropical.only_hamlet or GetModConfigData("Hamlet") ~= 5
            and TUNING.tropical.pigruins
            and TUNING.tropical.aporkalypse)
    then
        inst:AddComponent("aporkalypse")
    end

    if not TUNING.tropical.only_shipwrecked and GetModConfigData("Hamlet") ~= 5 then
        inst:AddComponent("tropicalgroundspawner")
    end

    if GetModConfigData("aquaticcreatures") and (
            TUNING.tropical.kindofworld == 15 or TUNING.tropical.only_shipwrecked or TUNING.tropical.only_sea)
    then
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
    end

    if TUNING.tropical.only_hamlet then
        inst:AddComponent("shadowmanager")
        inst:AddComponent("rocmanager")
    end

    if not TUNING.tropical.only_shipwrecked then
        inst:AddComponent("quaker_interior")
    end
end)

AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("roottrunkinventory")
    inst:AddComponent("quaker_interior")
    inst:AddComponent("economy")
end)