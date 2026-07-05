local RoomUtils = require("tropical_utils/room_utils")
local MakeDoor = require("prefabs/tro_interior_door_defs").MakeDoor

local assets =
{
    Asset("ANIM", "anim/ant_hill_entrance.zip"),
    Asset("ANIM", "anim/ant_queen_entrance.zip"),
    Asset("SOUND", "sound/pig.fsb"),
    Asset("MINIMAP_IMAGE", "ant_hill_entrance"),
    Asset("MINIMAP_IMAGE", "ant_cave_door"),
}

local prefabs =
{
    "antman",
    "antman_warrior",
    "int_ceiling_dust_fx",
    "antchest",
    "giantgrub",
    "ant_cave_lantern",
    "antqueen",
}


local function spawnDust(inst, dustCount)
    if dustCount > 0 then
        local interior_spawner = TheWorld.components.interiorspawner

        local pt = interior_spawner:getSpawnOrigin()
        local fx = SpawnPrefab("int_ceiling_dust_fx")
        local VARIANCE = 8.0

        fx.Transform:SetPosition(pt.x + math.random(-VARIANCE, VARIANCE), 0.0, pt.z + math.random(-VARIANCE, VARIANCE))
        fx.Transform:SetScale(2.0, 2.0, 2.0)
        inst:DoTaskInTime(0.5, function() spawnDust(inst, dustCount - 1) end)
    else
        inst:DoTaskInTime(0.5, function() inst.SoundEmitter:KillSound("miniearthquake") end)
    end
end

local NUM_ENTRANCES = 3
local function CreateMaze(inst)
    if inst.components.teleporter:GetTarget() then return end

    local MazeDefs = require("prefabs/anthill_defs")
    local rooms = MazeDefs.CreateMaze(NUM_ENTRANCES)

    --连接三个入口
    local isEntranceId = NUM_ENTRANCES
    local doors = RoomUtils.CreateRooms(rooms)
    inst.components.teleporter:Target(doors["exit" .. isEntranceId])
    doors["exit" .. isEntranceId].components.teleporter:Target(inst)
    isEntranceId = isEntranceId - 1

    for _, v in ipairs(TroGetEntsByPrefab("anthill_exit")) do
        if v.components.teleporter and not v.components.teleporter:GetTarget() then
            v.components.teleporter:Target(doors["exit" .. isEntranceId])
            doors["exit" .. isEntranceId].components.teleporter:Target(v)
            isEntranceId = isEntranceId - 1
            if isEntranceId <= 0 then
                break
            end
        end
    end

    while isEntranceId > 0 do --以防万一，就算没有剩下两个出口也要删掉，留个没法用的门也不好
        doors["exit" .. isEntranceId]:Remove()
        isEntranceId = isEntranceId - 1
    end

    --构建蚁后房间
    local queen_rooms = MazeDefs.CreateQueenChambers()
    local queen_doors = RoomUtils.CreateRooms(queen_rooms)
    --连接这两个房间
    doors.boss_door.components.teleporter:Target(queen_doors.boss_door)
    queen_doors.boss_door.components.teleporter:Target(doors.boss_door)
end

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function CommonPost(inst)
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("ant_hill_entrance.png")

    inst.AnimState:SetBank("ant_hill_entrance")
    inst.AnimState:SetBuild("ant_hill_entrance")
    inst.AnimState:PlayAnimation("idle")

    local light = inst.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180 / 255, 195 / 255, 50 / 255)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    MakeObstaclePhysics(inst, 1.3)

    inst:SetPrefabNameOverride("anthill")

    inst:AddTag("structure")
    inst:AddTag("anthill_outside")
end

local function MasterPost(inst)
    inst:AddComponent("lootdropper")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "antman"
    inst.components.childspawner:SetRegenPeriod(TUNING.ANTMAN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.ANTMAN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(TUNING.ANTMAN_MIN, TUNING.ANTMAN_MAX))
    inst.components.childspawner:StartSpawning()

    inst.components.inspectable.getstatus = getstatus
    inst.components.inspectable.nameoverride = "anthill"

    inst.name = STRINGS.NAMES.ANTHILL

    MakeSnowCovered(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:ListenForEvent("onbuilt", onbuilt)
end

-- 一个anthill搭配两个anthill_exit使用
return
    MakeDoor("anthill", {
            assets = assets,
            prefabs = prefabs,
        },
        CommonPost,
        function(inst)
            MasterPost(inst)
            inst:DoTaskInTime(0, CreateMaze)
        end),
    MakeDoor("anthill_exit", {
            assets = assets,
            prefabs = prefabs,
        },
        CommonPost,
        MasterPost)
