local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets =
{
    Asset("ANIM", "anim/vamp_bat_entrance.zip"),
    Asset("SOUND", "sound/hound.fsb"),
    Asset("MINIMAP_IMAGE", "vamp_bat_cave"),
}

local prefabs =
{
    "vampirebat",
    "cave_fern",
}


local function getlocationoutofcenter(dist, hole, random, invert)
    local pos = (math.random() * ((dist / 2) - (hole / 2))) + hole / 2
    if invert or (random and math.random() < 0.5) then
        pos = pos * -1
    end
    return pos
end

local function creatInterior(inst)
    if inst.components.teleporter:GetTarget() then return end

    local depth = 18
    local width = 26
    local addprops = {
        { name = "interior_floor_batcave", x_offset = -5.5 },
        { name = "interior_wall_batcave_wall_rock", x_offset = -4, scale = { 4.4, 4.4 } },
        { name = "vamp_bat_cave_exit_door", x_offset = -depth / 2, key = "exit" },
        { name = "deco_cave_cornerbeam", x_offset = -depth / 2, z_offset = -width / 2 },
        { name = "deco_cave_cornerbeam", x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } },
        { name = "deco_cave_pillar_side", x_offset = depth / 2, z_offset = -width / 2 },
        { name = "deco_cave_pillar_side", x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } },
        { name = "deco_cave_bat_burrow" },
    }
    for i = 1, math.random(1, 3) do
        table.insert(addprops, { name = "deco_cave_ceiling_trim", x_offset = -depth / 2, z_offset = getlocationoutofcenter(width * 0.6, 3, true) })
    end

    table.insert(addprops, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = -width / 4 })
    table.insert(addprops, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, addtags = { "roc_cave_delete_me" }, roc_cave_delete_me = true })
    table.insert(addprops, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = width / 4, })

    if math.random() < 0.7 then
        table.insert(addprops, { name = "deco_cave_floor_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = -width / 2, })
    end
    if math.random() < 0.7 then
        table.insert(addprops, { name = "deco_cave_floor_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = width / 2, scale = { -1, 1 } })
    end

    if math.random() < 0.7 then
        table.insert(addprops, { name = "deco_cave_ceiling_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = -width / 2, })
    end
    if math.random() < 0.7 then
        table.insert(addprops, { name = "deco_cave_ceiling_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = width / 2, scale = { -1, 1 } })
    end

    if math.random() < 0.5 then
        table.insert(addprops,
            { name = "deco_cave_beam_room", x_offset = (math.random() * depth * 0.65) - depth / 2 * 0.65, z_offset = getlocationoutofcenter(width * 0.65, 7, false, true), })
    end
    if math.random() < 0.5 then
        table.insert(addprops, { name = "deco_cave_beam_room", x_offset = (math.random() * depth * 0.65) - depth / 2 * 0.65, z_offset = getlocationoutofcenter(width * 0.65, 7), })
    end

    table.insert(addprops, { name = "flint", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    if math.random() < 0.5 then
        table.insert(addprops, { name = "flint", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    end

    table.insert(addprops, { name = "stalagmite", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
    if math.random() < 0.5 then
        if math.random() < 0.5 then
            table.insert(addprops, { name = "stalagmite", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
        else
            table.insert(addprops, { name = "stalagmite_tall", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
        end
    end
    if math.random() < 0.5 then
        table.insert(addprops, { name = "stalagmite_tall", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    end

    if math.random() < 0.5 then
        table.insert(addprops, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
    end
    if math.random() < 0.5 then
        table.insert(addprops, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
    end
    if math.random() < 0.5 then
        table.insert(addprops, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
    end
    if math.random() < 0.5 then
        table.insert(addprops, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
    end

    for i = 1, math.random(2, 5) do
        table.insert(addprops, { name = "cave_fern", x_offset = getlocationoutofcenter(depth * 0.7, 3, true), z_offset = getlocationoutofcenter(width * 0.7, 3, true) })
    end

    for i = 1, math.random(0, 2) do
        table.insert(addprops, { name = "blue_mushroom", x_offset = getlocationoutofcenter(depth * 0.8, 3, true), z_offset = getlocationoutofcenter(width * 0.8, 3, true) })
    end
    for i = 1, math.random(0, 2) do
        table.insert(addprops, { name = "red_mushroom", x_offset = getlocationoutofcenter(depth * 0.8, 3, true), z_offset = getlocationoutofcenter(width * 0.8, 3, true) })
    end
    for i = 1, math.random(0, 2) do
        table.insert(addprops, { name = "green_mushroom", x_offset = getlocationoutofcenter(depth * 0.8, 3, true), z_offset = getlocationoutofcenter(width * 0.8, 3, true) })
    end

    local room = {
        width = width,
        depth = depth,
        addprops = addprops
    }

    local doors = InteriorSpawnerUtils.CreateRoom(room)
    inst.components.teleporter:Target(doors.exit)
    doors.exit.components.teleporter:Target(inst)
end

local function fn()
    local inst = InteriorSpawnerUtils.MakeBaseDoor("vampbat_den", "vamp_bat_entrance", "idle", false, false, "vamp_bat_cave.png")

    MakeObstaclePhysics(inst, .5)

    inst:AddTag("houndmound")
    inst:AddTag("batcave")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, creatInterior)

    MakeSnowCovered(inst)

    return inst
end

return Prefab("vampirebatcave", fn, assets, prefabs)
