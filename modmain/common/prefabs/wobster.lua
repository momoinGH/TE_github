-- 龙虾可以被陷阱捕捉
for _, v in ipairs({ "wobster_sheller", "wobster_moonglass" }) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("lobster")
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("lootdropper"):SetLoot({ v .. "_land" })
    end)
end
