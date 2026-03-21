local RoomUtils = require("tropical_utils/room_utils")
local assets    =
{
    Asset("ANIM", "anim/pig_ruins_entrance.zip"),
    Asset("ANIM", "anim/pig_door_test.zip"),
    Asset("MINIMAP_IMAGE", "pig_ruins_entrance"),
    Asset("ANIM", "anim/pig_ruins_entrance_build.zip"),
    Asset("ANIM", "anim/pig_ruins_entrance_top_build.zip"),
}
local prefabs   = {

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

    local maze_data = get_maze_fn(inst) --迷宫数据
end

local function Init(inst)
    refreshImage(inst, false)

    local can_enter = not (inst.components.workable and inst.components.workable:GetWorkLeft() >= 0)
    inst.components.teleporter:SetEnabled(can_enter)
end

---遗迹门
---@param data.hack boolean 是否可被剪，为true就会被藤蔓缠住进不去
---@param data.maze_id string 迷宫id
---@param data.get_maze_fn function 迷宫数据生成函数
local function MakeRuinDoor(name, data, common_post_fn, master_post_fn)
    assert(not (not data.get_maze_fn and not data.maze_id), name .. "迷宫没有get_maze_fn字段被视为出口，但又没有maze_id表示是哪个迷宫的出口")

    local function fn()
        local inst = RoomUtils.MakeBaseDoor("pig_ruins_entrance", "pig_ruins_entrance_build", "idle_closed", true, false, "pig_ruins_entrance.png")

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

        if data.hack then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.SHEAR)
            inst.components.workable:SetWorkLeft(4)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)
            inst.components.workable.savestate = true --重新上线不会再长回来

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

return MakeRuinDoor
