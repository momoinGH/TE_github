local RoomUtils = require("tropical_utils/room_utils")
local MakeDoor = require("tro_interior_door_defs").MakeDoor

local assets =
{
    Asset("ANIM", "anim/cave_exit_rope.zip"),
}

local function onnear(inst)
    inst.AnimState:PlayAnimation("down")
    inst.AnimState:PushAnimation("idle_loop", true)
    inst.SoundEmitter:PlaySound("dontstarve/cave/rope_down")
end

local function onfar(inst)
    inst.AnimState:PlayAnimation("up")
    inst.SoundEmitter:PlaySound("dontstarve/cave/rope_up")
end

return MakeDoor("hamlet_cave_exit", {
    assets = assets,
    is_inner = true
}, function(inst)
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cave_open2.png")

    inst.AnimState:SetBank("exitrope")
    inst.AnimState:SetBuild("cave_exit_rope")
    inst.AnimState:PlayAnimation("idle")

    inst:SetPrefabNameOverride("cave_exit")
end, function(inst)
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetOnPlayerNear(onnear)
end)
