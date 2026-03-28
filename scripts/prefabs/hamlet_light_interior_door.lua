local MakeDoor = require("prefabs/tro_interior_door_defs").MakeDoor

local assets = {
    Asset("ANIM", "anim/new_ant_cave_door.zip"),
    Asset("ANIM", "anim/new_bat_cave_door.zip"),

    Asset("ANIM", "anim/new_pig_ruins_door.zip"),
    Asset("ANIM", "anim/new_pig_ruins_door_blue.zip"),
}

local lights =
{
    day = { rad = 3, intensity = 0.75, falloff = 0.5, color = { 1, 1, 1 } },
    dusk = { rad = 2, intensity = 0.75, falloff = 0.5, color = { 1 / 1.8, 1 / 1.8, 1 / 1.8 } },
    full = { rad = 2, intensity = 0.75, falloff = 0.5, color = { 0.8 / 1.8, 0.8 / 1.8, 1 / 1.8 } }
}

local function turnoff(inst, light)
    if light then
        light:Enable(false)
    end
end

local phasefunctions =
{
    day = function(inst)
        if not inst:IsInLimbo() then inst.Light:Enable(true) end
        inst.components.lighttweener:StartTween(nil, lights.day.rad, lights.day.intensity, lights.day.falloff,
            { lights.day.color[1], lights.day.color[2], lights.day.color[3] }, 2)
    end,

    dusk = function(inst)
        if not inst:IsInLimbo() then inst.Light:Enable(true) end
        inst.components.lighttweener:StartTween(nil, lights.dusk.rad, lights.dusk.intensity, lights.dusk.falloff,
            { lights.dusk.color[1], lights.dusk.color[2], lights.dusk.color[3] }, 2)
    end,

    night = function(inst)
        if TheWorld.state.isfullmoon then
            inst.components.lighttweener:StartTween(nil, lights.full.rad, lights.full.intensity, lights.full.falloff,
                { lights.full.color[1], lights.full.color[2], lights.full.color[3] }, 4)
        else
            inst.components.lighttweener:StartTween(nil, 0, 0, 1, { 0, 0, 0 }, 6, turnoff)
        end
    end,
}

local function CommonPost(inst)
    inst:AddTag("lockable_door")
end

local function OnPhase(inst, phase)
    if phase == "dusk" then
        inst.AnimState:PlayAnimation("to_dusk")
        inst.AnimState:PushAnimation("dusk_loop", true)
    elseif phase == "night" then
        inst.AnimState:PlayAnimation("to_night")
        inst.AnimState:PushAnimation("night_loop", true)
    elseif phase == "day" then
        inst.AnimState:PlayAnimation("to_day")
        inst.AnimState:PushAnimation("day_loop", true)
    end
    phasefunctions[phase](inst)
end

--- 让门的动画和光照随时段变化
local function SetDoorTimeChange(inst)
    if inst.components.lighttweener then
        return
    end

    inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(inst.entity:AddLight(), lights.day.rad, lights.day.intensity,
        lights.day.falloff, { lights.day.color[1], lights.day.color[2], lights.day.color[3] }, 0)
    inst.Light:Enable(true)

    inst:WatchWorldState("phase", OnPhase)
    OnPhase(inst, TheWorld.state.phase)
end

local function SetVine(inst)
    AddComponentIfNot(inst, "vineable")
end

local function OnSave(inst, data)
    data.light_door = inst.components.lighttweener ~= nil
    data.vined = inst.components.vineable ~= nil
end

local function OnLoad(inst, data)
    if not data then return end
    if data.light_door then
        SetDoorTimeChange(inst)
    end
    if data.vined then
        SetVine(inst)
    end
end

local function OnInteriorSpawn(inst, data)
    if data.vined then
        inst:SetVine()
    end
end

local function OpenDoor(inst, instant)
    if inst.components.teleporter:GetEnabled() then
        return
    end

    if not instant then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/stone_door/slide")
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_open")
        inst.AnimState:PushAnimation(inst.door_orientation)
    else
        inst.AnimState:PlayAnimation(inst.door_orientation)
    end

    inst.components.teleporter:SetEnabled(true)
end
local function CloseDoor(inst, instant)
    if not inst.components.teleporter:GetEnabled() then
        return
    end

    if not instant then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/stone_door/close")
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_shut")
        inst.AnimState:PushAnimation(inst.door_orientation .. "_closed")
        inst:DoTaskInTime(1 / 30 * 7, function() TheCamera:Shake("FULL", 0.7, 0.02, .5, 40) end)
    else
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_closed")
    end

    inst.components.teleporter:SetEnabled(false)
end

local function MasterPost(inst)
    inst.SetDoorTimeChange = SetDoorTimeChange --有太阳光的门
    inst.SetVine = SetVine                     --长藤蔓的门

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("oninteriorspawn", OnInteriorSpawn)
    inst:ListenForEvent("open", OpenDoor)
    inst:ListenForEvent("close", CloseDoor)
end

return
--猪人遗迹门，偷个懒，蓝色版本的替换个build得了
    MakeDoor("prop_door", {
        assets = assets,
        bank = "doorway_ruins",
        build = "pig_ruins_door",
        anim = "north",
        minimap = "pig_ruins_exit_int.png",
        trader = true,
        is_inner = true,
        door_orientation = "north"
    }, CommonPost, MasterPost),
    --洞穴门
    MakeDoor("vamp_bat_cave_exit_door", {
        bank = "doorway_cave",
        build = "bat_cave_door",
        anim = "north",
        minimap = "vamp_bat_cave_exit.png",
        trader = true,
        is_inner = true,
        door_orientation = "north"
    }, CommonPost, MasterPost),
    --蚁巢门
    MakeDoor("ant_cave_door", {
        bank = "ant_cave_door",
        build = "ant_cave_door",
        anim = "north",
        minimap = "ant_cave_door.png",
        trader = true,
        is_inner = true,
        door_orientation = "north"
    }, CommonPost, MasterPost)
