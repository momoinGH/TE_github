local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/ant_cave_door.zip"),
    Asset("ANIM", "anim/bat_cave_door.zip"),

    Asset("ANIM", "anim/pig_shop_doormats.zip"),
    Asset("ANIM", "anim/pig_ruins_door.zip"),
    Asset("ANIM", "anim/pig_ruins_door_blue.zip"),
    Asset("ANIM", "anim/interior_wall_decals_ruins_cracks.zip"),
    Asset("ANIM", "anim/interior_wall_decals_ruins_cracks_fake.zip"),

    Asset("ANIM", "anim/ant_hill_entrance.zip"),
    Asset("ANIM", "anim/ant_hill_entrance.zip"),
    Asset("ANIM", "anim/ant_queen_entrance.zip"),
}

local function OnBlasted(inst, worker)
    inst:RemoveTag("NOCLICK")
    inst.AnimState:PlayAnimation(inst.door_orientation .. "_open")
    inst.AnimState:PushAnimation(inst.door_orientation)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/music/secret_found")
    inst.components.teleporter:SetEnabled(true)

    local targetDoor = inst.components.teleporter.targetTeleporter
    if targetDoor
        and not inst.components.teleporter:GetEnabled()
        and targetDoor.components.workable
    then
        targetDoor.components.workable:Destroy(worker)
    end
end

local function OnHammered(inst)
    local pos = inst:GetPosition()
    SpawnPrefab("collapse_big").Transform:SetPosition(pos:Get())
    inst:Remove()
end

local function OnSave(inst, data)
    data.enable = inst.components.teleporter:GetEnabled()
end

local function OnLoad(inst, data)
    inst.components.teleporter:SetEnabled(data.enable)
    if inst.exploitable and data.enable then --已经被炸开了
        inst.AnimState:PlayAnimation(inst.door_orientation)
    end
end

local d = {
    door_orientation = "", --门的朝向
    minimap = "",          --小地图图标
    exploitable = false,   --是否可爆破
    vined = true,          --是否有藤蔓
    light = true,          --是否有灯光
    workcount = 4,         --是否可锤击
}

local function common(bank, build, anim, data)
    data = data or {}
    local inst = InteriorSpawnerUtils.MakeBaseDoor(bank, build, anim, true, true, data.minimap)

    if data.exploitable then
        inst:AddTag("NOCLICK")
    end
    if data.light then
        inst:AddTag("timechange_anims")
        InteriorSpawnerUtils.SetDoorTimeChange(inst)
    end

    if data.scale then
        inst.AnimState:SetScale(unpack(data.scale))
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.door_orientation = data.door_orientation

    if data.exploitable then
        inst.exploitable = true
        inst.components.teleporter:SetEnabled(false)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(OnBlasted)
    elseif data.workcount then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkLeft(data.workcount)
        inst.components.workable:SetOnFinishCallback(OnHammered)
    end

    if data.vined then
        inst:AddComponent("vineable")
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end



local function MakeDoor(name, bank, build, anim, data)
    local function fn() return common(bank, build, anim, data) end
    return Prefab(name, fn, assets)
end

-- 门动画的命名有点反直觉，位于房间顶部的门叫north北门，位于房间右侧的门叫west西门

return
--洞穴门
    MakeDoor("vamp_bat_cave_exit_door", "doorway_cave", "bat_cave_door", "day_loop", { light = true, minimap = "vamp_bat_cave_exit.png" }),
    MakeDoor("cave_exit_rope_door", "exitrope", "cave_exit_rope", "idle_loop"),


    --猪人遗迹门，偷个懒，蓝色版本的替换个build得了
    MakeDoor("pig_ruins_exit_door", "doorway_ruins", "pig_ruins_door", "day_loop", { light = true, minimap = "pig_ruins_exit_int.png" }),
    --猪人遗迹内部门
    MakeDoor("pig_ruins_north_door", "doorway_ruins", "pig_ruins_door", "north", { door_orientation = "north" }),
    MakeDoor("pig_ruins_south_door", "doorway_ruins", "pig_ruins_door", "south", { door_orientation = "south" }),
    MakeDoor("pig_ruins_east_door", "doorway_ruins", "pig_ruins_door", "east", { door_orientation = "east" }),
    MakeDoor("pig_ruins_west_door", "doorway_ruins", "pig_ruins_door", "west", { door_orientation = "west" }),
    --猪人遗迹藤蔓
    MakeDoor("pig_ruins_vine_north_door", "doorway_ruins", "pig_ruins_door", "north", { door_orientation = "north", vined = true }),
    MakeDoor("pig_ruins_vine_south_door", "doorway_ruins", "pig_ruins_door", "south", { door_orientation = "south", vined = true }),
    MakeDoor("pig_ruins_vine_east_door", "doorway_ruins", "pig_ruins_door", "east", { door_orientation = "east", vined = true }),
    MakeDoor("pig_ruins_vine_west_door", "doorway_ruins", "pig_ruins_door", "west", { door_orientation = "west", vined = true }),
    --猪人遗迹隐藏门
    MakeDoor("pig_ruins_cracks_north_door", "interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "north_closed", { door_orientation = "north", exploitable = true }),
    MakeDoor("pig_ruins_cracks_south_door", "interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "south_closed", { door_orientation = "south", exploitable = true }),
    MakeDoor("pig_ruins_cracks_east_door", "interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "east_closed", { door_orientation = "east", exploitable = true }),
    MakeDoor("pig_ruins_cracks_west_door", "interior_wall_decals_ruins", "interior_wall_decals_ruins_cracks", "west_closed", { door_orientation = "west", exploitable = true }),
    --猪人遗迹虚假隐藏门，为什么不用一样的动画呢？
    MakeDoor("pig_ruins_cracks_fake_north_door", "interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "north_closed",
        { door_orientation = "north", exploitable = true }),
    MakeDoor("pig_ruins_cracks_fake_south_door", "interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "south_closed",
        { door_orientation = "south", exploitable = true }),
    MakeDoor("pig_ruins_cracks_fake_east_door", "interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "east_closed",
        { door_orientation = "east", exploitable = true }),
    MakeDoor("pig_ruins_cracks_fake_west_door", "interior_wall_decals_ruins_fake", "interior_wall_decals_ruins_cracks_fake", "west_closed",
        { door_orientation = "west", exploitable = true }),

    --蚁巢门
    MakeDoor("ant_cave_exit_door", "ant_cave_door", "ant_cave_door", "day_loop", { light = true, minimap = "ant_cave_door.png" }),
    MakeDoor("ant_cave_north_door", "ant_cave_door", "ant_cave_door", "north", { door_orientation = "north" }),
    MakeDoor("ant_cave_south_door", "ant_cave_door", "ant_cave_door", "south", { door_orientation = "south" }),
    MakeDoor("ant_cave_east_door", "ant_cave_door", "ant_cave_door", "east", { door_orientation = "east" }),
    MakeDoor("ant_cave_west_door", "ant_cave_door", "ant_cave_door", "west", { door_orientation = "west" }),
    MakeDoor("anthill_cave_queen_door", "entrance", "ant_queen_entrance", "idle", { minimap = "ant_queen_entrance.png" }),

    --宫殿
    MakeDoor("interior_palace_south_door", "palace_door", "palace_door", "south", { door_orientation = "south" }),
    MakeDoor("interior_palace_west_door", "wall_decals_palace", "interior_wall_decals_palace", "door_sidewall"),
    MakeDoor("interior_palace_east_door", "wall_decals_palace", "interior_wall_decals_palace", "door_sidewall", { scale = { -1, 1 } })
