-- 这些东西浮起来
if TUNING.tropical.only_sea then
    for _, v in ipairs({
        "rocks",
        "nitre",
        "flint",
        "goldnugget",
        "moonrocknugget",
        "moonglass",
        "moonrockseed"
    }) do
        AddPrefabPostInit(v, function(inst)
            MakeInventoryFloatable(inst, "small", 0.15)

            if not TheWorld.ismastersim then return end

            if inst.components.inventoryitem ~= nil then
                inst.components.inventoryitem:SetSinks(false)
            end
        end)
    end
end
