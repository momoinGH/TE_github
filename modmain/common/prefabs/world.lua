AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    AddComponentIfNot(inst, "bigfooter")
    AddComponentIfNot(inst, "tro_tempentitytracker") -- world存一点不需要保存的对象，省去查找Ents
    AddComponentIfNot(inst, "roottrunkinventory")   --根箱物品管理
end)
