local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/pig_shop_doormats.zip"),
    Asset("ANIM", "anim/pig_ruins_door.zip"),
    Asset("ANIM", "anim/pig_ruins_door_blue.zip"),
}

local function opendoor(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/stone_door/slide")
    if inst.door_orientation then
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_open")
        inst.AnimState:PushAnimation(inst.door_orientation)
    end

    inst.components.teleporter.enabled = true
end

local function closedoor(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/stone_door/close")
    if inst.door_orientation then
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_shut")
        inst.AnimState:PushAnimation(inst.door_orientation .. "_closed")
    end

    inst.components.teleporter.enabled = false
end

local function revealcima(inst)
    inst:AddTag("explodida")
    inst:RemoveTag("NOCLICK")
    inst.AnimState:PlayAnimation(inst.door_orientation .. "_open")
    inst.AnimState:PushAnimation(inst.door_orientation)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/music/secret_found")

    local targetDoor = inst.components.teleporter.targetTeleporter
    if targetDoor and not targetDoor:HasTag("explodida") and targetDoor.components.workable then --不能循环了
        targetDoor.components.workable:Destroy()
    end
end

local function Init(inst)
    if inst:HasTag("explodida") then
        inst.AnimState:PlayAnimation("north")
    else
        inst:AddTag("NOCLICK")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(revealcima)

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(1)
        inst.components.health.nofadeout = true
        inst.components.health.vulnerabletoheatdamage = false
        inst.components.health.canmurder = false
        inst.components.health.canheal = false

        inst:ListenForEvent("death", revealcima)
    end
end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

end

local function common(bank, build, anim, door_orientation, vine, exploitable)
    local inst = InteriorSpawnerUtils.MakeBaseDoor(bank, build, anim, true, true, "pig_ruins_exit_int.png")

    if exploitable then
        inst:AddTag("escondida")
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.door_orientation = door_orientation

    if exploitable then
        inst:DoTaskInTime(0, Init)
    else
        inst:ListenForEvent("open", opendoor)
        inst:ListenForEvent("close", closedoor)
    end

    if vine then
        inst:AddComponent("vineable")
        inst.components.vineable:InitInteriorPrefab()
        inst.components.vineable:SetUpVine()
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function pig_ruins_exit_door_fn()
    local inst = common("doorway_ruins", "pig_ruins_door", "day_loop")
    inst:AddTag("timechange_anims")
    inst:AddTag("ruins_entrance") --遗迹出口
    InteriorSpawnerUtils.SetDoorTimeChange(inst)
    return inst
end
local function pig_ruins_north_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "north", "north")
end
local function pig_ruins_south_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "south", "south")
end
local function pig_ruins_east_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "east", "east")
end
local function pig_ruins_west_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "west", "west")
end
local function pig_ruins_vine_north_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "north", "north", true)
end
local function pig_ruins_vine_south_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "south", "south", true)
end
local function pig_ruins_vine_east_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "east", "east", true)
end
local function pig_ruins_vine_west_door_fn()
    return common("doorway_ruins", "pig_ruins_door", "west", "west", true)
end

local function pig_ruins_cracks_north_door_fn()
    return common("interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "north_closed", "north",
        nil, true)
end
local function pig_ruins_cracks_south_door_fn()
    return common("interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "south_closed", "south",
        nil, true)
end
local function pig_ruins_cracks_east_door_fn()
    return common("interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "east_closed", "east",
        nil, true)
end
local function pig_ruins_cracks_west_door_fn()
    return common("interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "west_closed", "west",
        nil, true)
end

local function pig_ruins_cracks_fake_north_door_fn()
    return common("interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "north_closed", "north",
        nil, true)
end
local function pig_ruins_cracks_fake_south_door_fn()
    return common("interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "south_closed", "south",
        nil, true)
end
local function pig_ruins_cracks_fake_east_door_fn()
    return common("interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "east_closed", "east",
        nil, true)
end
local function pig_ruins_cracks_fake_west_door_fn()
    return common("interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "west_closed", "west",
        nil, true)
end

return Prefab("pig_ruins_exit_door", pig_ruins_exit_door_fn, assets),

    --偷个懒，蓝色版本的替换个build得了
    Prefab("pig_ruins_north_door", pig_ruins_north_door_fn, assets),
    Prefab("pig_ruins_south_door", pig_ruins_south_door_fn, assets),
    Prefab("pig_ruins_east_door", pig_ruins_east_door_fn, assets),
    Prefab("pig_ruins_west_door", pig_ruins_west_door_fn, assets),
    Prefab("pig_ruins_vine_north_door", pig_ruins_vine_north_door_fn, assets),
    Prefab("pig_ruins_vine_south_door", pig_ruins_vine_south_door_fn, assets),
    Prefab("pig_ruins_vine_east_door", pig_ruins_vine_east_door_fn, assets),
    Prefab("pig_ruins_vine_west_door", pig_ruins_vine_west_door_fn, assets),

    Prefab("pig_ruins_cracks_north_door", pig_ruins_cracks_north_door_fn, assets),
    Prefab("pig_ruins_cracks_south_door", pig_ruins_cracks_south_door_fn, assets),
    Prefab("pig_ruins_cracks_east_door", pig_ruins_cracks_east_door_fn, assets),
    Prefab("pig_ruins_cracks_west_door", pig_ruins_cracks_west_door_fn, assets),

    Prefab("pig_ruins_cracks_fake_north_door", pig_ruins_cracks_fake_north_door_fn, assets),
    Prefab("pig_ruins_cracks_fake_south_door", pig_ruins_cracks_fake_south_door_fn, assets),
    Prefab("pig_ruins_cracks_fake_east_door", pig_ruins_cracks_fake_east_door_fn, assets),
    Prefab("pig_ruins_cracks_fake_west_door", pig_ruins_cracks_fake_west_door_fn, assets)
