local Utils = require("tropical_utils/utils")

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    AddComponentIfNot(inst, "bigfooter")

    inst:AddComponent("tro_tempentitytracker") -- world存一点不需要保存的对象，省去查找Ents
end)
