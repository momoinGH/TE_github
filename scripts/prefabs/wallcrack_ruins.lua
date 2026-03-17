local assets =
{
    Asset("ANIM", "anim/wallcrack_ruins.zip"),
}

local prefabs = {

}

-- 假门被摧毁
local function reveal(inst, worker)
    if inst.revealed then return end

    local door = inst.door and inst.door:IsValid() and inst.door or nil
    if not door then
        inst.revealed = true
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_open")
        inst.AnimState:PushAnimation(inst.door_orientation)
        return
    end

    inst.revealed = true
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")

    if inst.dest_fake_door then
        inst.dest_fake_door:reveal()
    end

    if worker and worker.SoundEmitter then
        worker.SoundEmitter:PlaySound("dontstarve_DLC003/music/secret_found")
    end

    inst:Remove()
end

-- 初始化，传入door和dest_fake_door就表示这是一个有门的裂缝
local function InitFakeDoor(inst, door_orientation, door, dest_fake_door)
    trodevassert(not (door and not door:IsValid()) and not (dest_fake_door and not dest_fake_door:IsValid()))

    inst.door_orientation = door_orientation
    inst.door = door
    inst.dest_fake_door = dest_fake_door
    inst.AnimState:PlayAnimation(inst.door_orientation .. "_closed")
    -- door:SetFakeDoor(inst) --放外面调用
end


local function OnSave(inst, data)
    local refs = {}
    data.door_orientation = inst.door_orientation
    data.revealed = inst.revealed
    if inst.dest_fake_door then
        data.dest_fake_door_guid = inst.dest_fake_door.GUID
        table.insert(refs, data.dest_fake_door_guid)
    end
    if inst.door then
        data.door_guid = inst.door.GUID
        table.insert(refs, data.door_guid)
    end
    return #refs > 0 and refs or nil
end

local function OnLoad(inst, ents, data)
    if not data then return end
    if data.door_orientation then
        inst.door_orientation = data.door_orientation
        inst.AnimState:PlayAnimation(inst.door_orientation .. "_closed")
    end
    if data.revealed then
        inst.AnimState:PushAnimation(inst.door_orientation)
    end
end

local function OnLoadPostPass(inst, ents, data)
    if data.door_guid then
        inst.door = ents[data.door_guid].entity
    end
    if data.dest_fake_door_guid then
        inst.dest_fake_door = ents[data.dest_fake_door_guid].entity
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("interior_wall_decals_ruins_fake")
    inst.AnimState:SetBuild("interior_wall_decals_ruins_cracks_fake")
    inst.AnimState:PlayAnimation("north_closed") --先随便播
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("secret_room")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.door = nil             --真正的门
    inst.dest_fake_door = nil   --对面的假门
    inst.door_orientation = nil --门朝向，决定要播放的动画
    inst.revealed = nil         --是否已经被打开
    inst.reveal = reveal
    inst.InitFakeDoor = InitFakeDoor

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(reveal)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("wallcrack_ruins", fn, assets, prefabs)
