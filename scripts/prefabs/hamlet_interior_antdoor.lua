local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/ant_cave_door.zip"),
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

local function common(bank, build, anim, door_orientation)
    local inst = InteriorSpawnerUtils.MakeBaseDoor(bank, build, anim, true, true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.door_orientation = door_orientation

    inst.components.inspectable:RecordViews()

    inst:ListenForEvent("open", opendoor)
    inst:ListenForEvent("close", closedoor)

    return inst
end

local function anthill_door_entrada_fn()
    local inst = common("ant_cave_door", "ant_cave_door", "day_loop")
    inst:AddTag("timechange_anims")
    InteriorSpawnerUtils.SetDoorTimeChange(inst)
    return inst
end

local function anthill_door_cima_fn()
    local inst = common("ant_cave_door", "ant_cave_door", "north", "north")
    InteriorSpawnerUtils.SetDoorTimeChange(inst)
    return inst
end

local function anthill_door_baixo_fn()
    return common("ant_cave_door", "ant_cave_door", "south", "south")
end

local function anthill_door_esquerda_fn()
    return common("ant_cave_door", "ant_cave_door", "east", "east")
end

local function anthill_door_direita_fn()
    return common("ant_cave_door", "ant_cave_door", "west", "west")
end

local function anthill_door_queen_fn()
    return common("entrance", "ant_queen_entrance", "idle")
end

-- 不同朝向的门命名有什么规则吗o(￣ヘ￣o＃).
return Prefab("anthill_door_entrada", anthill_door_entrada_fn, assets),
    Prefab("anthill_door_cima", anthill_door_cima_fn, assets),
    Prefab("anthill_door_baixo", anthill_door_baixo_fn, assets),
    Prefab("anthill_door_esquerda", anthill_door_esquerda_fn, assets),
    Prefab("anthill_door_direita", anthill_door_direita_fn, assets),
    Prefab("anthill_door_queen", anthill_door_queen_fn, assets)
