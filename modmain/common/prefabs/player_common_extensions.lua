local function GiveItem(inst, prefab)
    local item = SpawnAt(prefab, inst)
    if item then
        inst.components.inventory:GiveItem(item)
    end
end

local player_common_extensions = require("prefabs/player_common_extensions")
Hooks.FnDecorator(player_common_extensions, "GivePlayerStartingItems", function(inst)
    inst.components.inventory.ignoresound = true

    -- 哈姆雷特开局送一把砍刀
    if TUNING.tropical.startlocation == "hamlet" then
        GiveItem(inst, "machete")
    end

    inst.components.inventory.ignoresound = false
end)
