local HAM_FX =
{
    {
        name = "chop_mangrove_pink",
        bank = "chop_mangrove",
        build = "chop_mangrove_pink",
        anim = "chop",
    },
    {
        name = "fall_mangrove_pink",
        bank = "chop_mangrove",
        build = "chop_mangrove_pink",
        anim = "fall",
    },
    {
        name = "chop_mangrove_blue",
        bank = "chop_mangrove",
        build = "chop_mangrove_blue",
        anim = "chop",
    },
    {
        name = "fall_mangrove_blue",
        bank = "chop_mangrove",
        build = "chop_mangrove_blue",
        anim = "fall",
    },
    {
        name = "hacking_tall_grass_fx",
        bank = "hacking_fx",
        build = "hacking_tall_grass_fx",
        anim = "idle",
    },
    {
        name = "groundpound_fx_hulk",
        bank = "bearger_ground_fx",
        build = "bearger_ground_fx",
        sound = "dontstarve_DLC003/creatures/boss/hulk_metal_robot/dust",
        anim = "idle",
    },
    {
        name = "groundpound_nosound_fx",
        bank = "bearger_ground_fx",
        build = "bearger_ground_fx",
        anim = "idle",
    },
    {
        name = "snake_scales_fx",
        bank = "snake_scales_fx",
        build = "snake_scales_fx",
        anim = "idle",
    },
    {
        name = "splash_water",
        bank = "splash_water",
        build = "splash_water",
        anim = "idle",
    },
    {
        name = "bombsplash",
        bank = "bombsplash",
        build = "water_bombsplash",
        anim = "splash",
    },
    {
        name = "coconut_chunks",
        bank = "ground_breaking",
        build = "ground_chunks_breaking",
        anim = "idle",
        sound = "dontstarve_DLC003/creatures/palm_tree_guard/coconut_explode",
        tint = Vector3(183 / 255, 143 / 255, 85 / 255),
    },
    {
        name = "small_puff_light",
        bank = "small_puff",
        build = "smoke_puff_small",
        anim = "puff",
        sound = "dontstarve/common/deathpoof",
        tintalpha = 0.5,
    },
    {
        name = "pine_needles",
        bank = "pine_needles",
        build = "pine_needles",
        anim = "fall",
    },
    {
        name = "sparks_green_fx",
        bank = "sparks",
        build = "sparks_green",
        anim = "sparks_1",
    },
    {
        name = "robot_leaf_fx",
        bank = "robot_leaf_fx",
        build = "robot_leaf_fx",
        anim = "idle",
    },
    {
        name = "hacking_fx",
        bank = "hacking_fx",
        build = "hacking_fx",
        anim = "idle",
    },

    {
        name = "circle_puff_fx",
        bank = "circle_puff_fx",
        build = "circle_puff_fx",
        anim = "idle",
    },
    {
        name = "sparklefx",
        bank = "sparklefx",
        build = "sparklefx",
        anim = "sparkle",
        sound = "dontstarve/common/chest_positive",
        tintalpha = 0.6,
        --transform = Vector3(1.5, 1, 1)
    },
    {
        name = "laser_burst_fx",
        bank = "laser_ring_fx",
        build = "laser_ring_fx",
        anim = "idle",
    },
    {
        name = "living_suit_explode_fx",
        bank = "living_suit_explode_fx",
        build = "living_suit_explode_fx",
        anim = "idle",
    },
    {
        name = "rock_hit_debris",
        bank = "rock_hit_debris",
        build = "rock_hit_debris",
        anim = "hit_rock_ruins",
    },

    {
        name = "poop_splat",
        bank = "ground_breaking",
        build = "ground_chunks_breaking",
        anim = "idle",
        tint = Vector3(183 / 255, 143 / 255, 85 / 255),
    },
    {
        name = "shock_machines_fx",
        bank = "shock_machines_fx",
        build = "shock_machines_fx",
        anim = "shock",
        --sound = "dontstarve_DLC002/creatures/palm_tree_guard/coconut_explode",

    },
    {
        name = "hacking_bamboo_fx",
        bank = "hacking_bamboo_fx",
        build = "hacking_bamboo_fx",
        anim = "idle",
    },
    {
        name = "jungle_chop",
        bank = "chop_jungle",
        build = "chop_jungle",
        anim = "chop",
    },
    {
        name = "jungle_fall",
        bank = "chop_jungle",
        build = "chop_jungle",
        anim = "fall",
    },
    {
        name = "mangrove_chop",
        bank = "chop_mangrove",
        build = "chop_mangrove",
        anim = "chop",
    },
    {
        name = "mangrove_fall",
        bank = "chop_mangrove",
        build = "chop_mangrove",
        anim = "fall",
    },

    {
        name = "vortex_cloak_fx",
        bank = "vortex_cloak_fx",
        build = "vortex_cloak_fx",
        anim = "idle",
    },

    --头顶掉点尘土
    {
        name = "int_ceiling_dust_fx",
        bank = "int_ceiling_dust_fx",
        build = "int_ceiling_dust_fx",
        anim = "idle",
    },
    --冰块碎开
    {
        name = "ice_break_fx",
        bank = "ice_break",
        build = "ice_break",
        anim = "break"
    }
}

local fx = require("fx")
for _, v in ipairs(HAM_FX) do
    v.bank = v.bank or v.name
    v.build = v.build or v.name
    v.anim = v.anim or "idle"

    table.insert(Assets, Asset("ANIM", "anim/" .. v.build .. ".zip"))
    table.insert(fx, v)
end

package.loaded["prefabs/fx"] = nil