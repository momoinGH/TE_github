local prefabs = {"luggagechest"}

local treasure = {"healingstaff", "purplegem", "orangegem", "yellowgem", "greengem", "redgem", "bluegem",
                  "supertelescope", "spear_poison", "boat_lantern", "papyrus", "tunacan", "goldnugget", "gears", "rope",
                  "minerhat", "dubloon", "obsidianaxe", "telescope", "captainhat", "peg_leg", "volcanostaff",
                  "footballhat", "spear", "goldenaxe", "goldenshovel", "goldenpickaxe", "seatrap", "compass",
                  "boneshard", "transistor", "gunpowder", "heatrock", "antivenom", "healingsalve", "blowdart_sleep",
                  "nightsword", "amulet", "clothsail", "boatrepairkit", "coconade", "boatcannon", "snakeskinhat",
                  "armor_snakeskin", "spear_launcher", "piratehat", "boomerang", "snakeskin", "strawhat", "blubbersuit",
                  "nightmarefuel", "obsidianmachete", "trap_teeth", "spear_obsidian", "armorobsidian", "goldenmachete",
                  "obsidiancoconade", "fabric", "harpoon", "umbrella", "birdtrap", "featherhat", "beehat", "bandage",
                  "armorwood", "armormarble", "blowdart_pipe", "armorgrass", "armorseashell", "cane", "icestaff",
                  "firestaff", "blowdart_fire", "yellowamulet", "armorruins", "ruins_bat", "ruinshat", "cutgrass",
                  "charcoal", "axe", "hammer", "shovel", "bugnet", "fishingrod", "spidergland", "silk", "flint",
                  "coral", "trinket_sw_13", "trinket_sw_14", "trinket_sw_15", "trinket_sw_19"}

local function fn()
    local chest = SpawnPrefab("luggagechest")

    local function GetRandItem(itemname, maxcount, chanceoverride)
        local chance = chanceoverride or .5
        for _ = 1, maxcount do
            if math.random() < chance then
                chest.components.container:GiveItem(SpawnPrefab(type(itemname) == "function" and itemname() or itemname))
            end
        end
    end

    GetRandItem("dubloon", 5)
    GetRandItem("coral", 4)
    GetRandItem(function() return treasure[math.random(1, #treasure)] end, 8)

    return chest
end

return Prefab("luggagechest_spawner", fn, nil, prefabs)
