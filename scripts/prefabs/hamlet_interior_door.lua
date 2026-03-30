local MakeDoor = require("prefabs/tro_interior_door_defs").MakeDoor

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

        inst:SetPrefabNameOverride("prop_door")
    end),
    --宫殿
    MakeDoor("interior_palace_south_door", {
        assets = assets,
        bank = "palace_door",
        build = "palace_door",
        anim = "south",
        trader = true,
        is_inner = true,
    }, function(inst)
        inst:SetPrefabNameOverride("prop_door")
        inst.AnimState:SetLayer(LAYER_WORLD)
    end),
    MakeDoor("interior_palace_west_door", {
        assets = assets,
        bank = "wall_decals_palace",
        build = "interior_wall_decals_palace",
        anim = "door_sidewall",
        trader = true,
        is_inner = true,
    }, function(inst)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst:SetPrefabNameOverride("prop_door")
    end),
    MakeDoor("interior_palace_east_door", {
        assets = assets,
        bank = "wall_decals_palace",
        build = "interior_wall_decals_palace",
        anim = "door_sidewall",
        trader = true,
        is_inner = true,
    }, function(inst)
        inst.AnimState:SetScale(-1, 1)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst:SetPrefabNameOverride("prop_door")
    end)
