local DecoCreator = require "prefabs/deco_util"

return
    DecoCreator:Create("deco_antiquities_screamcatcher", "ceiling_decor", "ceiling_decor", "scream_catcher_idle",{ loopanim = true }),
    DecoCreator:Create("deco_antiquities_windchime", "ceiling_decor", "ceiling_decor", "windchime_idle", { loopanim = true }),
    DecoCreator:Create("deco_antiquities_cornerbeam", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "pillar_corner", { decal = true, background = 3, tags = { "NOBLOCK", "cornerpost" }}),
    DecoCreator:Create("deco_antiquities_cornerbeam2", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "pillar_sidewall", { decal = true, tags = { "NOBLOCK", "cornerpost" } }),
    DecoCreator:Create("deco_antiquities_endbeam", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "pillar_front", { decal = true }),
    DecoCreator:Create("deco_antiquities_pallet_sidewall", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "pallet_sidewall", { decal = true, background = 3 }),
    DecoCreator:Create("deco_antiquities_wallpaper_rip1", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "hole_1", { decal = true, background = 3 }),
    DecoCreator:Create("deco_antiquities_wallpaper_rip2", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "hole_2", { decal = true, background = 3 }),
    DecoCreator:Create("deco_antiquities_wallpaper_rip3", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "hole_3", { decal = true, background = 3 }),
    DecoCreator:Create("deco_antiquities_walllight", "interior_wall_decals_antiquities", "wall_decals_antiquities",
            "sconce_sidewall1", { decal = true, light = DecoCreator:GetLights().SMALL, tags = { "NOBLOCK" } })
