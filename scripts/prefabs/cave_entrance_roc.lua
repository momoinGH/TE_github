local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/cave_entrance.zip"),
    Asset("ANIM", "anim/ruins_entrance.zip"),
    Asset("ANIM", "anim/cave_exit_rope.zip"),

    Asset("MINIMAP_IMAGE", "cave_closed"),
    Asset("MINIMAP_IMAGE", "cave_open"),
    Asset("MINIMAP_IMAGE", "cave_open2"),
    Asset("MINIMAP_IMAGE", "ruins_closed"),
}

local prefabs = { "exitcavelight", "roc_nest", "roc_nest_tree1", "roc_nest_tree2", "roc_nest_bush", "roc_nest_branch1", "roc_nest_branch2", "roc_nest_trunk", "roc_nest_house",
    "roc_nest_rusty_lamp",
    "roc_nest_egg1", "roc_nest_egg2", "roc_nest_egg3", "roc_nest_egg4", "roc_nest_debris1", "roc_nest_debris2", "roc_nest_debris3", "roc_cave_light_beam",
}

local function GetStatus(inst)
    return inst:HasTag("teleporter") and "OPEN" or nil
end

local function GetDoorProp(room, dir, exit, width, depth)
    local x_offset, z_offset
    if dir == InteriorSpawnerUtils.GetNorth() then
        x_offset = -depth / 2
    elseif dir == InteriorSpawnerUtils.GetSouth() then
        x_offset = depth / 2
    elseif dir == InteriorSpawnerUtils.GetEast() then
        z_offset = -width / 2
    elseif dir == InteriorSpawnerUtils.GetWest() then
        z_offset = width / 2
    end

    return {
        name = "ant_cave_" .. dir.label .. "_door",
        x_offset = x_offset,
        z_offset = z_offset,
    }
end

local function getlocationoutofcenter(dist, hole, random, invert)
    local pos = (math.random() * ((dist / 2) - (hole / 2))) + hole / 2
    if invert or (random and math.random() < 0.5) then
        pos = pos * -1
    end
    return pos
end

local depth = TUNING.ROOM_MEDIUM_DEPTH
local width = TUNING.ROOM_MEDIUM_WIDTH
local rooms_to_make = 6
local function initmaze(inst)
    if inst.components.teleporter:GetTarget() then return end

    local rooms = { { x = 0, y = 0, idx = 1, exits = {}, entrance1 = true, } }

    while #rooms < rooms_to_make do
        local dir = InteriorSpawnerUtils.DIR
        local dir_opposite = InteriorSpawnerUtils.DIR_OPPOSITE
        local dir_choice = math.random(#dir)
        local fromroom = rooms[math.random(#rooms)]

        local fail = false

        -- fail if this room of the maze is already set up.
        for i, checkroom in ipairs(rooms) do
            if checkroom.x == fromroom.x + dir[dir_choice].x and checkroom.y == fromroom.y + dir[dir_choice].y then
                fail = true
                break
            end
        end


        if not fail then
            local newroom = {
                x = fromroom.x + dir[dir_choice].x,
                y = fromroom.y + dir[dir_choice].y,
                idx = #rooms + 1,
                exits = {},
            }
            fromroom.exits[dir[dir_choice]] = { target_room = newroom.idx, room = fromroom.idx, }
            newroom.exits[dir_opposite[dir_choice]] = { target_room = fromroom.idx, room = newroom.idx, }
            table.insert(rooms, newroom)
        end
    end

    -- 随机选择一个顶部敞开的房间作为出口二，出口是个绳子，随便找个房间也行的
    local exits = {}
    for i, room in ipairs(rooms) do
        if not room.entrance1 then
            local northexitopen = not room.exits[InteriorSpawnerUtils:GetNorth()]
            if northexitopen then
                table.insert(exits, i)
            end
        end
    end
    rooms[exits[math.random(1, #exits)]].entrance2 = true

    local inc = 1
    for id, room in ipairs(rooms) do
        room.width = width
        room.depth = depth

        local westexitopen = not room.exits[InteriorSpawnerUtils:GetWest()]
        local southexitopen = not room.exits[InteriorSpawnerUtils:GetSouth()]
        local eastexitopen = not room.exits[InteriorSpawnerUtils:GetEast()]

        local addprops = room.addprops
        if not room.addprops then
            addprops = {}
            room.addprops = addprops
        end

        if room.entrance2 then
            table.insert(addprops, { name = "cave_exit_rope_door", z_offset = -width / 6, key = "entrance2" })
        end

        if room.entrance1 then
            table.insert(addprops, { name = "cave_exit_rope_door", z_offset = -width / 6, key = "entrance1" })
            table.insert(addprops, { name = "roc_cave_light_beam", z_offset = -width / 6 })
        end

        local roomtypes = { "stalacmites", "stalacmites", "glowplants", "ferns", "mushtree" }
        local roomtype = room.entrance1 and "stalacmites" or roomtypes[math.random(1, #roomtypes)]

        table.insert(addprops, { name = "deco_cave_cornerbeam", x_offset = -depth / 2, z_offset = -width / 2, })
        table.insert(addprops, { name = "deco_cave_cornerbeam", x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
        table.insert(addprops, { name = "deco_cave_pillar_side", x_offset = depth / 2, z_offset = -width / 2, })
        table.insert(addprops, { name = "deco_cave_pillar_side", x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })

        for i = 1, math.random(1, 3) do
            table.insert(addprops, { name = "deco_cave_ceiling_trim", x_offset = -depth / 2, z_offset = getlocationoutofcenter(width * 0.6, 3, true) })
        end

        table.insert(addprops, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = -width / 4, })
        if southexitopen then
            table.insert(addprops, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = 0, })
        end
        table.insert(addprops, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = width / 4, })

        if westexitopen and math.random() < 0.7 then
            table.insert(addprops, { name = "deco_cave_floor_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = -width / 2, })
        end

        if eastexitopen and math.random() < 0.7 then
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
            table.insert(addprops,
                { name = "deco_cave_beam_room", x_offset = (math.random() * depth * 0.65) - depth / 2 * 0.65, z_offset = getlocationoutofcenter(width * 0.65, 7), })
        end

        if math.random() < 0.5 then
            table.insert(addprops, { name = "flint", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
        end

        if roomtype == "stalacmites" then
            if math.random() < 0.3 then
                table.insert(addprops, { name = "stalagmite", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
            end
            if math.random() < 0.2 then
                if math.random() < 0.5 then
                    table.insert(addprops,
                        { name = "stalagmite", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
                else
                    table.insert(addprops,
                        { name = "stalagmite_tall", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
                end
            end
            if math.random() < 0.3 then
                table.insert(addprops,
                    { name = "stalagmite_tall", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
            end
            if math.random() < 0.5 then
                table.insert(addprops,
                    { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
            end
            if math.random() < 0.5 then
                table.insert(addprops,
                    { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
            end
        end

        if math.random() < 0.5 then
            table.insert(addprops, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
        end
        if math.random() < 0.5 then
            table.insert(addprops, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
        end

        if roomtype == "ferns" then
            for i = 1, math.random(5, 15) do
                table.insert(addprops, { name = "cave_fern", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
            end
        end

        if roomtype == "mushtree" then
            if math.random() < 0.3 then
                for i = 1, math.random(3, 8) do
                    table.insert(addprops,
                        { name = "mushtree_tall", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
                end
            elseif math.random() < 0.5 then
                for i = 1, math.random(3, 8) do
                    table.insert(addprops,
                        { name = "mushtree_medium", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
                end
            else
                for i = 1, math.random(3, 8) do
                    table.insert(addprops,
                        { name = "mushtree_small", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
                end
            end
        end

        if roomtype == "glowplants" then
            for i = 1, math.random(4, 12) do
                table.insert(addprops,
                    { name = "flower_cave", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
            end
        end

        for i = 1, math.random(2, 5) do
            table.insert(addprops, { name = "cave_fern", x_offset = getlocationoutofcenter(depth * 0.7, 3, true), z_offset = getlocationoutofcenter(width * 0.7, 3, true) })
        end

        --地板和墙壁
        table.insert(addprops, { name = "interior_floor_batcave" })
        table.insert(addprops, { name = "interior_wall_batcave_wall_rock" })

        --房间门
        for dir, exit in pairs(room.exits) do
            local opposite_dir = InteriorSpawnerUtils.GetOppositeFromDirection(dir)
            local doorprop = GetDoorProp(room, dir, exit, width, depth)

            -- 把隔壁门也一起生成
            local opposite_room = rooms[exit.target_room]
            local opposite_exit = opposite_room.exits[opposite_dir]
            local doorprop2 = GetDoorProp(opposite_room, opposite_dir, opposite_exit, width, depth)
            opposite_room.exits[opposite_dir] = nil --不再处理

            doorprop.key = inc
            inc = inc + 1
            doorprop2.key = inc
            inc = inc + 1
            doorprop.target_door = doorprop2.key
            doorprop2.target_door = doorprop.key
            -- print("房间" .. id .. "生成" .. dir.label .. "门", doorprop.key, doorprop2.key)
            table.insert(addprops, doorprop)
            opposite_room.addprops = opposite_room.addprops or {}
            table.insert(opposite_room.addprops, doorprop2)
        end
    end

    local doors = InteriorSpawnerUtils.CreateRooms(rooms)
    inst.components.teleporter:Target(doors.entrance1)
    doors.entrance1.components.teleporter:Target(inst)

    for _, v in ipairs(TheWorld.components.tro_tempentitytracker:GetEnts("cave_exit_roc")) do
        if v:IsValid() and not v.components.teleporter:GetTarget() then
            doors.entrance2.components.teleporter:Target(v)
            v.components.teleporter:Target(doors.entrance2)
            break
        end
    end
end

local function OpenDoor(inst)
    inst.components.teleporter:SetEnabled(true)
    if inst.components.teleporter:GetTarget() then
        inst.AnimState:PlayAnimation("open")
    else
        inst.AnimState:PlayAnimation("no_access")
    end
    inst.MiniMapEntity:SetIcon("cave_open.png")
    inst:RemoveComponent("workable")
end

local function OnWorked(inst, worker, workleft)
    if workleft > 0 then
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.ROCKS_MINE / 3 and "low") or
            (workleft < TUNING.ROCKS_MINE * 2 / 3 and "med") or
            "idle_closed"
        )
    else
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.components.lootdropper:DropLoot(pt)

        OpenDoor(inst)
    end
end

local function OnExitSave(inst, data)
    data.enable = inst.components.teleporter:GetEnabled()
end

local function OnExitLoad(inst, data)
    if not data then return end
    if data.enable then
        inst.components.teleporter:SetEnabled(true)
    end
end

--- 有玩家传送的话就摧毁
local function OnActivateByOther(inst, source, obj)
    if inst.components.workable then
        inst.components.workable:Destroy(obj or source) --obj应该不会为nil
    end
end

local function Init(inst)
    if inst.components.teleporter:GetEnabled() then
        OpenDoor(inst)
    end
end

local function common()
    local inst = InteriorSpawnerUtils.MakeBaseDoor("cave_entrance", "cave_entrance", "idle_closed", false, false, "cave_closed.png")

    MakeObstaclePhysics(inst, 1)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, Init)

    inst.components.teleporter.onActivateByOther = OnActivateByOther
    inst.components.teleporter:SetEnabled(false)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks", "flint", "flint", "flint" })

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)

    inst.components.inspectable:RecordViews()
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable.nameoverride = "CAVE_ENTRANCE"

    MakeSnowCovered(inst, .01)

    inst.OnSave = OnExitSave
    inst.OnLoad = OnExitLoad

    return inst
end

local function fn()
    local inst = common()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, initmaze) --也可以凿开再生成

    return inst
end

local function exitfn()
    local inst = common()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

-- 一个可以生成迷宫，一个单纯作为出口二
return Prefab("cave_entrance_roc", fn, assets, prefabs),
    Prefab("cave_exit_roc", exitfn, assets, prefabs)
