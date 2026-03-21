local MakeDoor = require("tro_interior_door_defs").MakeDoor

local assets = {
    Asset("ANIM", "anim/ant_hill_entrance.zip"),
    Asset("ANIM", "anim/ant_queen_entrance.zip"),
}

return
--通往蚁后的门
    MakeDoor("anthill_cave_queen_door", {
        assets = assets,
        trader = true,
        is_inner = true,
    }, function(inst)
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("ant_queen_entrance.png")

        inst.AnimState:SetBank("entrance")
        inst.AnimState:SetBuild("ant_queen_entrance")
        inst.AnimState:PlayAnimation("idle")
    end),
    --宫殿
    MakeDoor("interior_palace_south_door", {
        assets = assets,
        trader = true,
        is_inner = true,
    }, function(inst)
        inst.AnimState:SetBank("palace_door")
        inst.AnimState:SetBuild("palace_door")
        inst.AnimState:PlayAnimation("south")
    end),
    MakeDoor("interior_palace_west_door", {
        assets = assets,
        trader = true,
        is_inner = true,
    }, function(inst)
        inst.AnimState:SetBank("wall_decals_palace")
        inst.AnimState:SetBuild("interior_wall_decals_palace")
        inst.AnimState:PlayAnimation("door_sidewall")
    end),
    MakeDoor("interior_palace_south_door", {
        assets = assets,
        trader = true,
        is_inner = true,
    }, function(inst)
        inst.AnimState:SetBank("wall_decals_palace")
        inst.AnimState:SetBuild("interior_wall_decals_palace")
        inst.AnimState:PlayAnimation("door_sidewall")
        inst.AnimState:SetScale(-1, 1)
    end)
