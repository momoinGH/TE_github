local RoomUtils = require("tro_utils/room_utils")
local MakeDoor = require("prefabs/tro_interior_door_defs").MakeDoor

local assets = {
    Asset("ANIM", "anim/cave_entrance.zip"),
    Asset("ANIM", "anim/ruins_entrance.zip"),
    Asset("ANIM", "anim/cave_exit_rope.zip"),

    Asset("MINIMAP_IMAGE", "cave_closed"),
    Asset("MINIMAP_IMAGE", "cave_open"),
    Asset("MINIMAP_IMAGE", "cave_open2"),
    Asset("MINIMAP_IMAGE", "ruins_closed"),
}

local prefabs = { "roc_nest", "roc_nest_tree1", "roc_nest_tree2", "roc_nest_bush", "roc_nest_branch1", "roc_nest_branch2", "roc_nest_trunk", "roc_nest_house",
    "roc_nest_rusty_lamp",
    "roc_nest_egg1", "roc_nest_egg2", "roc_nest_egg3", "roc_nest_egg4", "roc_nest_debris1", "roc_nest_debris2", "roc_nest_debris3", "roc_cave_light_beam",
}

local function GetStatus(inst)
    return inst:HasTag("teleporter") and "OPEN" or nil
end

local function initmaze(inst)
    if inst._tro_interior_created then return end
    inst._tro_interior_created = true

    local CreateMaze = require("prefabs/cave_entrance_roc_defs")
    local rooms = CreateMaze()

    local doors = RoomUtils.CreateRooms(rooms)
    inst.components.teleporter:Target(doors.entrance1)
    doors.entrance1.components.teleporter:Target(inst)

    for _, v in ipairs(TroGetEntsByPrefab("cave_exit_roc")) do
        if v ~= doors.entrance2 and v.components.teleporter and not v.components.teleporter:GetTarget() then
            doors.entrance2.components.teleporter:Target(v)
            v.components.teleporter:Target(doors.entrance2)
            print("洞穴入口二：" .. tostring(doors.entrance2))
            break
        end
    end

    if not doors.entrance2.components.teleporter:GetTarget() then
        doors.entrance2:Remove() --没有就删了
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

local function CommonPost(inst)
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cave_closed.png")

    inst.AnimState:SetBank("cave_entrance")
    inst.AnimState:SetBuild("cave_entrance")
    inst.AnimState:PlayAnimation("idle_closed")

    MakeObstaclePhysics(inst, 1)
end

local function MasterPost(inst)
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

    MakeSnowCovered(inst)

    inst.OnSave = OnExitSave
    inst.OnLoad = OnExitLoad
end

-- 一个可以生成迷宫，一个单纯作为出口二
return
    MakeDoor("cave_entrance_roc",
        {
            assets = assets,
            prefabs = prefabs,
        },
        CommonPost,
        function(inst)
            MasterPost(inst)
            inst:DoTaskInTime(0, initmaze) --也可以凿开再生成
        end),
    MakeDoor("cave_exit_roc",
        {
            assets = assets,
            prefabs = prefabs,
        },
        CommonPost,
        MasterPost)
