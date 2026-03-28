local MakeDoor = require("prefabs/tro_interior_door_defs").MakeDoor

local assets =
{
    Asset("ANIM", "anim/new_interior_wall_decals_ruins_cracks.zip"),
    Asset("ANIM", "anim/new_interior_wall_decals_ruins_cracks_fake.zip"),
}

local prefabs = {

}

local function IsFakeDoor(inst)
    return inst.components.teleporter:GetTarget() == nil --有传送目标就是真的门，没有就是假门
end


-- 门被摧毁
local function reveal(inst)
    if not IsFakeDoor(inst) then
        --真的门
        inst.AnimState:SetBank("interior_wall_decals_ruins")
        inst.AnimState:SetBuild("interior_wall_decals_ruins_cracks")
        inst.components.teleporter:SetEnabled(true)
    end

    inst.AnimState:PlayAnimation(inst.door_orientation .. "_open")
    inst.AnimState:PushAnimation(inst.door_orientation)
end

local function OnDestroy(inst, worker)
    reveal(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    if not IsFakeDoor(inst) and worker and worker.SoundEmitter then
        worker.SoundEmitter:PlaySound("dontstarve_DLC003/music/secret_found")
    end
end

local function CommonPost(inst)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetRayTestOnBB(true)
    inst:AddTag("secret_room")
end

local function OnLoadPostPass(inst)
    if inst.components.workable:GetWorkLeft() <= 0 then
        reveal(inst)
    end
end

local function MasterPost(inst)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.BLANK)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnDestroy)
    inst.components.workable.savestate = true

    inst.components.teleporter:SetEnabled(false)

    inst.OnLoadPostPass = OnLoadPostPass
end

return MakeDoor("wallcrack_ruins", {
    assets = assets,
    prefabs = prefabs,
    bank = "interior_wall_decals_ruins_fake", --默认假门
    build = "interior_wall_decals_ruins_cracks_fake",
    anim = "north_closed",
    door_orientation = "north",
    is_inner = true,
}, CommonPost, MasterPost)
