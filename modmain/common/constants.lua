-- TODO 定义新的FUELTYPE最好给图鉴一个图片，用于图鉴wiki
FUELTYPE.TAR = "TAR"                         -- tar.tex
FUELTYPE.REPARODEBARCO = "REPARODEBARCO"
FUELTYPE.LIVINGARTIFACT = "LIVINGARTIFACT"   -- living_artifact.tex
FUELTYPE.ANCIENT_REMNANT = "ANCIENT_REMNANT" -- ancient_remnant.tex
FUELTYPE.CORK = "CORK"                       -- cork.tex
FUELTYPE.BLOOD = "BLOOD"                     --新增一个燃料值：血，可以用蚊子血嚢给蝙蝠帽回耐久

MATERIALS.SANDBAG = "sandbag"
MATERIALS.LIMESTONE = "limestone"
MATERIALS.ENFORCEDLIMESTONE = "enforcedlimestone"

TOOLACTIONS["HACK"] = true
TOOLACTIONS["SHEAR"] = true
TOOLACTIONS["PAN"] = true

GLOBAL.SWP_WAVEBREAK_EFFICIENCY = { -- 破浪效率：var * 100%
    BUMPER = {
        kelp = .6,                  -- prefab = "boat_bumper_" .. k
        shell = .8,
        yotd = .8,
        crabking = 1,
    },
    BOAT = {
        boat = .3, -- prefab = k
        boat_pirate = .3,
        boat_ancient = .4,
        boatmetal = .9,
    }
}

----------------------------------------------------------------------------------------------------

function AddComponentIfNot(inst, name)
    if not inst.components[name] then
        inst:AddComponent(name)
    end
end

GLOBAL.AddComponentIfNot = AddComponentIfNot
