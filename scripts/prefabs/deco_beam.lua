local DecoCreator = require "prefabs/deco_util"
local InteriorSpawnerUtils = require("interiorspawnerutils")

-- 这次不替换了，直接移除并重新生成
local function OnBuilt(inst)
    local isCorner, isLeft = InteriorSpawnerUtils.TestBeam(inst)

    if isCorner then
        if not isLeft then
            inst.AnimState:SetScale(-1, 1)
        end
    else
        local beam = SpawnAt(inst.prefab:gsub("cornerbeam", "beam"), inst)
        if not isLeft then
            beam.AnimState:SetScale(-1, 1)
        end

        inst:Remove()
    end
end

local function MasterInit(inst)
    inst:ListenForEvent("onbuilt", OnBuilt)
end

return
-- 玩家能建造的柱子
    DecoCreator:Create("deco_wood_beam", "interior_wall_decals", "wall_decals", "3",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_wood_cornerbeam", "interior_wall_decals", "wall_decals", "4",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true, background = 3, masterInit = MasterInit }),
    DecoCreator:Create("deco_millinery_beam", "interior_wall_decals_millinery", "wall_decals_millinery", "pillar_front",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true, masterInit = MasterInit }),
    DecoCreator:Create("deco_millinery_cornerbeam", "interior_wall_decals_millinery", "wall_decals_millinery",
        "pillar_corner",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true, background = 3, masterInit = MasterInit }),
    DecoCreator:Create("deco_round_beam", "interior_wall_decals_accademia", "wall_decals_accademia", "pillar_round_front",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_round_cornerbeam", "interior_wall_decals_accademia", "wall_decals_accademia",
        "pillar_round_corner",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true, background = 3, masterInit = MasterInit }),
    DecoCreator:Create("deco_marble_beam", "interior_wall_decals_hoofspa", "wall_decals_hoofspa", "pillar",
        {
            decal = true,
            loopanim = true,
            light = DecoCreator:GetLights().SMALL,
            tags = { "NOBLOCK", "cornerpost" },
            onbuilt = true,
        }),
    DecoCreator:Create("deco_marble_cornerbeam", "interior_wall_decals_hoofspa", "wall_decals_hoofspa", "pillar_corner",
        {
            decal = true,
            loopanim = true,
            light = DecoCreator:GetLights().SMALL,
            tags = { "NOBLOCK", "cornerpost" },
            onbuilt = true,
            background = 3,
            masterInit = MasterInit
        }),

    ----------------------------------------------------------------------------------------------------

    DecoCreator:Create("deco_millinery_beam2", "interior_wall_decals_millinery", "wall_decals_millinery",
        "pillar_boxes_front", { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_millinery_beam3", "interior_wall_decals_millinery", "wall_decals_millinery",
        "pillar_quilted_front", { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_millinery_cornerbeam2", "interior_wall_decals_millinery", "wall_decals_millinery",
        "pillar_boxes_corner", { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true, background = 3 }),
    DecoCreator:Create("deco_millinery_cornerbeam3", "interior_wall_decals_millinery", "wall_decals_millinery",
        "pillar_quilted_corner", { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true, background = 3 }),
    DecoCreator:Create("deco_weapon_beam1", "interior_wall_decals_weapons", "wall_decals_weapons", "pillar_front",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_weapon_beam2", "interior_wall_decals_weapons", "wall_decals_weapons", "pillar_corner",
        { decal = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_ruins_cornerbeam", "interior_wall_decals_ruins", "interior_wall_decals_ruins",
        "pillar_corner", { decal = true, background = 3, tags = { "cornerpost" } }),
    DecoCreator:Create("deco_ruins_cornerbeam_heavy", "interior_wall_decals_ruins", "interior_wall_decals_ruins",
        "pillar_corner_lg", { decal = true, background = 3, tags = { "cornerpost" } }),
    DecoCreator:Create("deco_ruins_corner_tree", "interior_wall_decals_ruins", "interior_wall_decals_ruins",
        "giant_roots", { decal = true, background = 3, physics = "tree_physics" }), -- , minimapicon="pig_ruins_tree_roots_int.png"
    DecoCreator:Create("deco_ruins_beam_heavy", "interior_wall_decals_ruins", "interior_wall_decals_ruins",
        "pillar_side_lg", { decal = true, background = 3 }),
    DecoCreator:Create("deco_ruins_beam", "interior_wall_decals_ruins", "interior_wall_decals_ruins", "pillar_front",
        { decal = true }),
    DecoCreator:Create("deco_ruins_beam_room", "interior_wall_decals_ruins", "interior_wall_decals_ruins", "pillar_front",
        { decal = true, physics = "post_physics", workable = true, minimapicon = "pig_ruins_pillar.png" }),
    DecoCreator:Create("deco_ruins_beam_room_broken", "interior_wall_decals_ruins", "interior_wall_decals_ruins",
        "pillar_broken", { decal = true, physics = "post_physics", minimapicon = "pig_ruins_pillar.png" }),
    DecoCreator:Create("deco_ruins_beam_broken", "interior_wall_decals_ruins", "interior_wall_decals_ruins",
        "pillar_broken", { decal = true, background = 3 }),
    DecoCreator:Create("deco_ruins_cornerbeam_blue", "interior_wall_decals_ruins_blue", "interior_wall_decals_ruins",
        "pillar_corner", { decal = true, background = 3, tags = { "cornerpost" } }),
    DecoCreator:Create("deco_ruins_cornerbeam_heavy_blue", "interior_wall_decals_ruins_blue",
        "interior_wall_decals_ruins", "pillar_corner_lg", { decal = true, background = 3, tags = { "cornerpost" } }),
    DecoCreator:Create("deco_ruins_beam_heavy_blue", "interior_wall_decals_ruins_blue", "interior_wall_decals_ruins",
        "pillar_side_lg", { decal = true, background = 3 }),
    DecoCreator:Create("deco_ruins_beam_blue", "interior_wall_decals_ruins_blue", "interior_wall_decals_ruins",
        "pillar_front", { decal = true }),
    DecoCreator:Create("deco_ruins_beam_room_blue", "interior_wall_decals_ruins_blue", "interior_wall_decals_ruins",
        "pillar_front", { decal = true, physics = "post_physics", workable = true, minimapicon = "pig_ruins_pillar.png" }),
    DecoCreator:Create("deco_ruins_beam_room_broken_blue", "interior_wall_decals_ruins_blue",
        "interior_wall_decals_ruins", "pillar_broken",
        { decal = true, physics = "post_physics", minimapicon = "pig_ruins_pillar.png" }),
    DecoCreator:Create("deco_ruins_beam_broken_blue", "interior_wall_decals_ruins_blue", "interior_wall_decals_ruins",
        "pillar_broken", { decal = true, background = 3 }),
    DecoCreator:Create("deco_cave_beam_room", "interior_wall_decals_batcave", "interior_wall_decals_cave",
        "pillar_front",
        { decal = true, physics = "big_post_physics", workable = true, minimapicon = "vamp_cave_pillar.png" }),
    DecoCreator:Create("deco_cave_cornerbeam", "interior_wall_decals_batcave", "interior_wall_decals_cave",
        "pillar_corner", { decal = true, background = 3, tags = { "cornerpost" } }),
    DecoCreator:Create("deco_hive_beam_room", "interior_wall_decals_antcave", "interior_wall_decals_antcave",
        "pillar_front", {
            decal = true,
            physics = "big_post_physics",
            workable = true,
            minimapicon =
            "vamp_cave_pillar.png"
        }),
    DecoCreator:Create("deco_hive_cornerbeam", "interior_wall_decals_antcave", "interior_wall_decals_antcave",
        "pillar_corner", { decal = true, background = 3, tags = { "cornerpost" } }),
    DecoCreator:Create("deco_produce_stone_cornerbeam", "interior_wall_decals_deli", "wall_decals_deli",
        "pillar_sidewall", { decal = true, light = DecoCreator:GetLights().SMALL_YELLOW }), -- loopanim=true,

    DecoCreator:Create("deco_cityhall_cornerbeam", "interior_wall_decals_mayorsoffice", "wall_decals_mayorsoffice",
        "pillar_flag_corner", { decal = true, tags = { "cornerpost" } }), -- , background=3

    DecoCreator:Create("deco_palace_beam_room_tall", "interior_wall_decals_palace", "wall_decals_palace", "pillar_tall",
        { decal = true, physics = "post_physics" }),
    DecoCreator:Create("deco_palace_beam_room_tall_lights", "interior_wall_decals_palace", "wall_decals_palace",
        "pillar_tall_lights", { decal = true, physics = "post_physics", light = DecoCreator:GetLights().SMALL }),
    DecoCreator:Create("deco_palace_beam_room_tall_corner", "interior_wall_decals_palace", "wall_decals_palace",
        "pillar_tall_corner", { decal = true, physics = "post_physics" }),
    DecoCreator:Create("deco_palace_beam_room_tall_corner_front", "interior_wall_decals_palace", "wall_decals_palace",
        "pillar_tall_front", { decal = true, physics = "post_physics" }),
    DecoCreator:Create("deco_palace_beam_room_short_corner_lights", "interior_wall_decals_palace", "wall_decals_palace",
        "pillar_lights_corner", { decal = true, physics = "post_physics", light = DecoCreator:GetLights().SMALL }),
    DecoCreator:Create("deco_palace_beam_room_short_corner_front_lights", "interior_wall_decals_palace",
        "wall_decals_palace", "pillar_lights_front",
        { decal = true, physics = "post_physics", light = DecoCreator:GetLights().SMALL }),
    DecoCreator:Create("deco_palace_beam_room_short", "interior_wall_decals_palace", "wall_decals_palace", "pillar",
        { decal = true, physics = "post_physics" }),
    DecoCreator:Create("deco_bank_marble_beam", "interior_pillar", "interior_pillar", "pillar_bank_front",
        { decal = true, loopanim = true, light = DecoCreator:GetLights().SMALL, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_bank_marble_cornerbeam", "interior_pillar", "interior_pillar", "pillar_bank_corner",
        { decal = true, loopanim = true, light = DecoCreator:GetLights().SMALL, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_tinker_beam", "interior_pillar", "interior_pillar", "basic_front",
        { decal = true, loopanim = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true }),
    DecoCreator:Create("deco_tinker_cornerbeam", "interior_pillar", "interior_pillar", "basic_corner",
        { decal = true, loopanim = true, tags = { "NOBLOCK", "cornerpost" }, onbuilt = true })
