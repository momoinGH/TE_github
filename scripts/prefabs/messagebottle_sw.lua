local assets =
{
    Asset("ANIM", "anim/messagebottle.zip"),
    Asset("MINIMAP_IMAGE", "messageBottle"),
}

local function getrevealtargetpos(inst, doer)
    -- 关键单位的位置
    local pos = TheWorld.components.tro_messagebottlemanager and TheWorld.components.tro_messagebottlemanager:UseMessageBottle(inst, doer)
    if pos then
        local empty_bottle = SpawnPrefab("messagebottleempty")
        empty_bottle.Transform:SetPosition(inst.Transform:GetWorldPosition())
        local inventory = inst.components.inventoryitem:GetContainer()
        if inventory ~= nil then
            inventory:GiveItem(empty_bottle)
        end
        inst:Remove()
        return pos
    end

    -- 宝箱
    local map = TheWorld.Map
    local x, y, z
    local sx, sy = TheWorld.Map:GetSize()
    for i = 1, 500 do
        x = math.random(-sx, sx)
        z = math.random(-sy, sy)
        if map:IsAboveGroundAtPoint(x, 0, z) then
            break
        end
    end
    SpawnPrefab("buriedtreasure").Transform:SetPosition(x, 0, z)
    return Vector3(x, 0, z)
end

local function messagebottlefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("messagebottle")
    inst.AnimState:SetBuild("messagebottle")
    inst.AnimState:PlayAnimation("idle", true)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("messageBottle.png")

    inst:AddTag("aquatic")
    inst:AddTag("messagebottle")
    inst:AddTag("nosteal")
    inst:AddTag("unwrappable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("mapspotrevealer")
    inst.components.mapspotrevealer:SetGetTargetFn(getrevealtargetpos)
    inst.components.mapspotrevealer.postreveal = inst.Remove

    return inst
end

local function emptybottlefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("messagebottle")
    inst.AnimState:SetBuild("messagebottle")
    inst.AnimState:PlayAnimation("idle_empty", true)

    inst:AddTag("aquatic")
    inst:AddTag("messagebottleempty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    return inst
end

return Prefab("messagebottle_sw", messagebottlefn, assets),
    Prefab("messagebottleempty_sw", emptybottlefn, assets)
