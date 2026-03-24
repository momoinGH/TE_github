local mazemaker    = require("prefabs/hamlet_pig_ruins_entrance_defs")
local MakeBaseDoor = require("prefabs/tro_interior_door_defs").MakeBaseDoor

local RoomUtils    = require("tropical_utils/room_utils")

local assets       =
{
    Asset("ANIM", "anim/pig_ruins_entrance.zip"),
    Asset("ANIM", "anim/pig_door_test.zip"),
    Asset("MINIMAP_IMAGE", "pig_ruins_entrance"),
    Asset("ANIM", "anim/pig_ruins_entrance_build.zip"),
    Asset("ANIM", "anim/pig_ruins_entrance_top_build.zip"),
}

local prefabs      =
{
    "deco_roomglow",
    "light_dust_fx",
    "deco_ruins_wallcrumble_1",
    "deco_ruins_wallcrumble_side_1",
    "deco_ruins_cornerbeam",
    "deco_ruins_beam",
    "deco_ruins_wallstrut",
    "deco_ruins_beam_broken",
    "deco_ruins_cornerbeam_heavy",
    "deco_ruins_beam_room",
    "deco_ruins_fountain",
    "pig_ruins_torch_sidewall",
    "deco_ruins_pigman_relief_side",
    "deco_ruins_writing1",
    "pig_ruins_dart",
    "pig_ruins_pressure_plate",
    "pig_ruins_torch_wall",
    "deco_ruins_crack_roots1",
    "deco_ruins_crack_roots2",
    "deco_ruins_crack_roots3",
    "deco_ruins_crack_roots4",
    "deco_ruins_pigqueen_relief",
    "deco_ruins_pigking_relief",
    "deco_ruins_pigman_relief1",
    "deco_ruins_pigman_relief2",
    "deco_ruins_pigman_relief3",
    "pig_ruins_creeping_vines",
    "pig_ruins_wall_vines_north",
    "pig_ruins_wall_vines_east",
    "pig_ruins_wall_vines_west",
    "smashingpot",
    "aporkalypse_clock",
    "wallcrack_ruins"
}

local function refreshImage(inst, push)
    local anim
    if inst.components.workable then
        local stage = inst.components.workable:GetWorkLeft()
        if stage == 2 then
            anim = "idle_med"
        elseif stage == 1 then
            anim = "idle_low"
        elseif stage == 0 then
            anim = "idle_open"
        else
            anim = "idle_closed"
        end
    else
        anim = "idle_open"
    end

    if push then
        inst.AnimState:PushAnimation(anim, true)
    else
        inst.AnimState:PlayAnimation(anim, true)
    end
end

local function onhammered(inst, worker)
    inst.components.teleporter:SetEnabled(true)
end

local function onhit(inst, worker)
    local fx = SpawnPrefab("hacking_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random() * 2, z)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
    refreshImage(inst, true)

    inst.components.shearable.workleft = inst.components.workable.workleft --同步一下
end

local function OnShearableFinished(inst, data)
    inst.components.workable:Destroy(data.worker)
end

local function inspect(inst)
    if not inst.components.teleporter:GetEnabled() then
        return "LOCKED"
    end
end

local function InitMaze(inst, get_maze_fn)
    if inst.components.teleporter:GetTarget() then
        return --已经生成过迷宫了
    end

    local rooms_data = get_maze_fn(inst) --迷宫数据
    local doors = RoomUtils.CreateRooms(rooms_data)

    print("构建遗迹迷宫，房间数量：" .. tostring(#rooms_data) .. "，入口一：" .. tostring(inst))

    --关联第一个入口
    inst.components.teleporter:Target(doors.entrance1)
    doors.entrance1.components.teleporter:Target(inst)
    --关联第二个入口
    if doors.entrance2 then
        for _, v in pairs(Ents) do
            if v:HasTag(inst.maze_id .. "_exit_target") and v.components.teleporter and not v.components.teleporter:GetTarget() then
                doors.entrance2.components.teleporter:Target(v)
                v.components.teleporter:Target(doors.entrance2)
                print("入口二：" .. tostring(doors.entrance2))
                break
            end
        end
    end
end

local function Init(inst)
    refreshImage(inst, false)

    local can_enter = not (inst.components.workable and inst.components.workable:GetWorkLeft() > 0)
    inst.components.teleporter:SetEnabled(can_enter)
end

---遗迹门
---@param data.vine boolean 是否可被剪，为true就会被藤蔓缠住进不去
---@param data.maze_id string 迷宫id
---@param data.get_maze_fn function 迷宫数据生成函数
local function MakeRuinDoor(name, data, common_post_fn, master_post_fn)
    assert(not (not data.get_maze_fn and not data.maze_id), name .. "迷宫没有get_maze_fn字段被视为出口，但又没有maze_id表示是哪个迷宫的出口")

    local function fn()
        local inst = MakeBaseDoor("pig_ruins_entrance", "pig_ruins_entrance_build", "idle_closed", true, false, "pig_ruins_entrance.png")

        MakeObstaclePhysics(inst, 1.20)

        if not data.get_maze_fn then
            --遗迹出口
            inst:AddTag(data.maze_id .. "_exit_target")
        end

        if common_post_fn then
            common_post_fn(inst)
        end

        if not TheWorld.ismastersim then
            return inst
        end

        inst.maze_id = data.maze_id

        if data.vine then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HACK)
            inst.components.workable:SetWorkLeft(4)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)
            inst.components.workable.savestate = true --重新上线不会再长回来

            inst:AddComponent("shearable")
            inst.components.shearable:SetWorkLeft(1)
            inst:ListenForEvent("onshearfinished", OnShearableFinished)
            inst.components.shearable.savestate = true

            inst.components.teleporter:SetEnabled(false)
        end

        inst.components.inspectable.getstatus = inspect

        if data.get_maze_fn then
            inst:DoTaskInTime(0, InitMaze, data.get_maze_fn)
        end
        inst:DoTaskInTime(0, Init)

        MakeSnowCovered(inst)

        if master_post_fn then
            master_post_fn(inst)
        end

        return inst
    end
    return Prefab(name, fn, assets, prefabs)
end

----------------------------------------------------------------------------------------------------

local function Runis1AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament4")
end

local function GetMaze1(inst)
    return mazemaker({
        name        = inst.maze_id,
        rooms       = 24,
        lock        = true,
        doorvines   = 0.3,
        deepruins   = true,
        secretrooms = 2,
    })
end

local function Runis2AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament4")
    inst.AnimState:Hide("swap_ornament")
end

local function GetMaze2(inst)
    return mazemaker({
        name        = inst.maze_id,
        rooms       = 15,
        lock        = true,
        doorvines   = 0.6,
        deepruins   = true,
        secretrooms = 2,
    })
end

local function Runis3AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament4")
    inst.AnimState:Hide("swap_ornament")
end

local function GetMaze3(inst)
    return mazemaker({
        name         = inst.maze_id,
        rooms        = 15,
        lock         = true,
        doorvines    = 0.3,
        deepruins    = true,
        secretrooms  = 2,
        nosecondexit = true,
    })
end

local function Runis4AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament")
end

local function GetMaze4(inst)
    return mazemaker({
        name        = inst.maze_id,
        rooms       = 20,
        lock        = true,
        doorvines   = 0.4,
        deepruins   = true,
        secretrooms = 2,
    })
end

local function GetMaze5(inst)
    return mazemaker({
        name         = inst.maze_id,
        rooms        = 30,
        lock         = true,
        doorvines    = 0.6,
        deepruins    = true,
        secretrooms  = 2,
        nosecondexit = true
    })
end

local function RunisSmallAnimInit(inst)
    inst.AnimState:Hide("swap_ornament4")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament")
    inst.AnimState:OverrideSymbol("statue_01", "pig_ruins_entrance", "")
    inst.AnimState:OverrideSymbol("swap_ornament", "pig_ruins_entrance", "")
end

local function GetSmallMaze(inst)
    return mazemaker({
        rooms        = math.random(6, 8),
        nosecondexit = true,
        smallsecret  = true
    })
end

return MakeRuinDoor("pig_ruins_entrance", { vine = true, maze_id = "runis_1", get_maze_fn = GetMaze1 }, Runis1AnimInit),
    MakeRuinDoor("pig_ruins_exit", { maze_id = "runis_1" }, Runis1AnimInit),

    MakeRuinDoor("pig_ruins_entrance2", { vine = true, maze_id = "runis_2", get_maze_fn = GetMaze2 }, Runis2AnimInit),
    MakeRuinDoor("pig_ruins_exit2", { maze_id = "runis_2" }, Runis2AnimInit),

    MakeRuinDoor("pig_ruins_entrance3", { vine = true, get_maze_fn = GetMaze3 }, Runis3AnimInit),

    MakeRuinDoor("pig_ruins_entrance4", { vine = true, maze_id = "runis_4", get_maze_fn = GetMaze4 }, Runis4AnimInit),
    MakeRuinDoor("pig_ruins_exit4", { maze_id = "runis_4" }, Runis4AnimInit),

    MakeRuinDoor("pig_ruins_entrance5", { vine = true, get_maze_fn = GetMaze5 }, Runis4AnimInit),
    MakeRuinDoor("pig_ruins_entrance_small", { get_maze_fn = GetSmallMaze }, RunisSmallAnimInit)
