
local assets =
{
	Asset("ANIM", "anim/quagmire_victorian_structures.zip"),
	Asset("ANIM", "anim/quagmire_rubble.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    fx:SetMaterial("stone")
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.prefab == "quagmire_rubble_bike" then
        inst.AnimState:PushAnimation("penny_farthing")
    elseif inst.prefab == "quagmire_rubble_carriage" then
        inst.AnimState:PushAnimation("carriage")
    elseif inst.prefab == "quagmire_rubble_cathedral" then
        inst.AnimState:PushAnimation("cathedral")
    elseif inst.prefab == "quagmire_rubble_chimney" then
        inst.AnimState:PushAnimation("chimney")
    elseif inst.prefab == "quagmire_rubble_chimney2" then
        inst.AnimState:PushAnimation("chimney2")
    elseif inst.prefab == "quagmire_rubble_clock" then
        inst.AnimState:PushAnimation("grandfather_clock")
    elseif inst.prefab == "quagmire_rubble_clocktower" then
        inst.AnimState:PushAnimation("clocktower")
    elseif inst.prefab == "quagmire_rubble_door" then
        inst.AnimState:PushAnimation("door")
    elseif inst.prefab == "quagmire_rubble_house" then
        inst.AnimState:PushAnimation("house")
    elseif inst.prefab == "quagmire_rubble_pubdoor" then
        inst.AnimState:PushAnimation("pub_door")
    elseif inst.prefab == "quagmire_rubble_roof" then
        inst.AnimState:PushAnimation("roof")
    end
end

local function onbuilt(inst)
    if inst.prefab == "quagmire_rubble_bike" then
        inst.AnimState:PushAnimation("penny_farthing")
    elseif inst.prefab == "quagmire_rubble_carriage" then
        inst.AnimState:PushAnimation("carriage")
    elseif inst.prefab == "quagmire_rubble_cathedral" then
        inst.AnimState:PushAnimation("cathedral")
    elseif inst.prefab == "quagmire_rubble_chimney" then
        inst.AnimState:PushAnimation("chimney")
    elseif inst.prefab == "quagmire_rubble_chimney2" then
        inst.AnimState:PushAnimation("chimney2")
    elseif inst.prefab == "quagmire_rubble_clock" then
        inst.AnimState:PushAnimation("grandfather_clock")
    elseif inst.prefab == "quagmire_rubble_clocktower" then
        inst.AnimState:PushAnimation("clocktower")
    elseif inst.prefab == "quagmire_rubble_door" then
        inst.AnimState:PushAnimation("door")
    elseif inst.prefab == "quagmire_rubble_house" then
        inst.AnimState:PushAnimation("house")
    elseif inst.prefab == "quagmire_rubble_pubdoor" then
        inst.AnimState:PushAnimation("pub_door")
    elseif inst.prefab == "quagmire_rubble_roof" then
        inst.AnimState:PushAnimation("roof")
    end
end

local function decorfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

    --[[Non-networked entity]]
    inst.persists = false

    inst.AnimState:SetBank("quagmire_rubble")
    inst.AnimState:SetBuild("quagmire_rubble")

    return inst
end

local decore_seed = 123456789;
local function decore_rand()
    decore_seed = (1664525 * decore_seed + 1013904223) % 2147483648
    return decore_seed / 2147483649;
end

local function SpawnDecor(inst, x, z)
    if decore_rand() < 0.8 then
        local rubble = SpawnPrefab("quagmire_old_rubble")
        rubble.entity:SetParent(inst.entity)

        local r = 0.15
        rubble.Transform:SetPosition(x + decore_rand() * r - r * .5, 0, z + decore_rand() * r - r * .5)

        local scale = .8 - (decore_rand() * .2)
        rubble.Transform:SetScale(scale, scale, scale)
        local tint = .8 - (decore_rand() * .1)
        rubble.AnimState:OverrideMultColour(tint, tint, tint, 1)
        rubble.AnimState:PlayAnimation("f" .. math.floor(decore_rand() * 8) + 1)
    end
end

local function PopulateDecor(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    decore_seed = math.floor(math.abs(x) * 281 + math.abs(z) * 353)
    local half_cells = 3
    local cell_spacing = .72
    for x = -half_cells + 1, half_cells - 1 do
        SpawnDecor(inst, x * cell_spacing, -half_cells * cell_spacing)
        SpawnDecor(inst, x * cell_spacing, half_cells * cell_spacing)
    end
    for z = -half_cells, half_cells do
        SpawnDecor(inst, -half_cells * cell_spacing, z * cell_spacing)
        SpawnDecor(inst, half_cells * cell_spacing, z * cell_spacing)
    end
end

local function common_fn(name, anim, add_decor)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    if anim ~= nil then
        inst.entity:AddAnimState()
    end
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    if anim ~= nil then
        inst.AnimState:SetBank("quagmire_victorian_structures")
        inst.AnimState:SetBuild("quagmire_victorian_structures")
        inst.AnimState:PlayAnimation(anim)

        MakeObstaclePhysics(inst, 1)
    else
        inst:AddTag("NOCLICK")
    end

    if not TheNet:IsDedicated() then
        if add_decor then
            inst:DoTaskInTime(0, PopulateDecor)
        end
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if anim ~= nil then
        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        print(inst.prefab)
        if name == "bike" or name == "carriage" or name == "pubdoor" then
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(3)
        else
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(6)
        end
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:ListenForEvent("onbuilt", onbuilt)

        MakeHauntableWork(inst)
    end

    return inst
end

local function MakeStrcuture(name, anim, add_decor)
    local function fn()
        return common_fn(name, anim, add_decor)
    end

    return Prefab("quagmire_rubble_" .. name, fn, assets, {"quagmire_old_rubble"})
end

return Prefab("quagmire_old_rubble", decorfn, assets),

		MakeStrcuture("bike", "penny_farthing"),
		MakeStrcuture("carriage", "carriage"),
		MakeStrcuture("cathedral", "cathedral", true),
		MakeStrcuture("chimney", "chimney", true),
		MakeStrcuture("chimney2", "chimney2", true),
		MakeStrcuture("clock", "grandfather_clock", true),
		MakeStrcuture("clocktower", "clocktower", true),		
		MakeStrcuture("door", "door", true),
		MakeStrcuture("empty", nil, true),
		MakeStrcuture("house", "house", true),
		MakeStrcuture("pubdoor", "pub_door", true),
		MakeStrcuture("roof", "roof", true),

        MakePlacer("quagmire_rubble_bike_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "penny_farthing"),
		MakePlacer("quagmire_rubble_carriage_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "carriage"),
		MakePlacer("quagmire_rubble_cathedral_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "cathedral"),
		MakePlacer("quagmire_rubble_chimney_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "chimney"),
		MakePlacer("quagmire_rubble_chimney2_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "chimney2"),
		MakePlacer("quagmire_rubble_clock_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "grandfather_clock"),
		MakePlacer("quagmire_rubble_clocktower_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "clocktower"),
		MakePlacer("quagmire_rubble_door_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "door"),
		MakePlacer("quagmire_rubble_house_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "house"),
		MakePlacer("quagmire_rubble_pubdoor_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "pub_door"),
		MakePlacer("quagmire_rubble_roof_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "roof")
