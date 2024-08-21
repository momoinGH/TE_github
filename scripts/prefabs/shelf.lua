local Utils = require("tropical_utils/utils")

local assets =
{
    Asset("ANIM", "anim/room_shelves.zip"),
    Asset("ANIM", "anim/pedestal_key.zip"),
    Asset("ANIM", "anim/pedestal_crate.zip"), --一个容器的展柜和一些装饰
}

local prefabs =
{
    "shelf_slot",
}

local function SetImage(inst, ent, slot)
    local image = ent ~= nil and ent.replica.inventoryitem ~= nil and ent.replica.inventoryitem:GetImage()

    if image ~= nil then
        --mod物品drawatlasoverride或atlasname至少指定一个
        local atlas = FunctionOrValue(ent.drawatlasoverride, ent, inst) or ent.components.inventoryitem.atlasname
        if atlas ~= nil then
            atlas = resolvefilepath_soft(atlas) --需要找到路径，例如../mods/PigmanTribe/images/inventoryimages/upgrade.xml
        end
        inst.AnimState:OverrideSymbol(slot, atlas or GetInventoryItemAtlas(image), image)
        inst.imagename = image
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol(slot)
    end
end

local function SetImageFromName(inst, name, slot)
    if name ~= nil then
        local texname = name .. ".tex"
        inst.AnimState:OverrideSymbol(slot, GetInventoryItemAtlas(texname), texname)
        --inst.AnimState:OverrideSymbol("SWAP_SIGN", "store_items", image)
        inst.imagename = name
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol(slot)
    end
end

----------------------------------------------------------------------------------------------------
local function PutOnShelf(item, shelf, slot)
    item:AddTag("bookshelfed")
    item.bookshelfslot = slot
    item.bookshelf = shelf
    if item.Physics then
        item.Physics:SetActive(false)
    end
    local follower = item.entity:AddFollower()
    follower:FollowSymbol(shelf.GUID, slot, 10, 0, 0.6)
    item.follower = follower
end

local function spawnshelfslots(inst)
    for i = 1, inst.size do
        local object = SpawnPrefab("shelf_slot")
        if inst:HasTag("playercrafted") then
            object:AddTag("playercrafted")
        end

        object.components.shelfer.slotindex = i
        if inst.swp_img_list then
            PutOnShelf(object, inst, inst.swp_img_list[i])
            object.components.shelfer:SetShelf(inst, inst.swp_img_list[i])
        else
            PutOnShelf(object, inst, "SWAP_img" .. i)
            object.components.shelfer:SetShelf(inst, "SWAP_img" .. i)
        end
        table.insert(inst.shelves, object)
    end
end

local function DropEverything(inst)
    for _, v in ipairs(inst.shelves) do
        local item = v.components.shelfer and v.components.shelfer:GiveGift()
        if item then
            inst.components.lootdropper:FlingItem(item)
        end
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    DropEverything(inst)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    DropEverything(inst)
end

local function RemoveShelves(inst)
    for _, v in ipairs(inst.shelves) do
        v:Remove()
    end
end

local function setPlayerUncraftable(inst)
    inst:RemoveTag("NOCLICK")

    inst:AddComponent("lootdropper")

    inst.entity:AddSoundEmitter()
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
end

local function OnBuilt(inst)
    inst:AddTag("playercrafted") --等待初始化
end

local function OnSave(inst, data)
    data.playercrafted = inst:HasTag("playercrafted") or nil
end

local function OnLoad(inst, data)
    if data.playercrafted then
        inst:AddTag("playercrafted")
    end
end

local function common(size, swp_img_list)
    size = size or 6

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBuild("room_shelves")
    inst.AnimState:SetBank("bookcase")
    inst.AnimState:PlayAnimation("wood")
    inst.Transform:SetRotation(-90)

    inst:AddTag("NOCLICK")
    -- inst:AddTag("NOBLOCK")
    inst:AddTag("furniture")
    inst:AddTag("structure")
    inst:AddTag("shop_shelf")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetImage = SetImage
    inst.SetImageFromName = SetImageFromName

    inst.swp_img_list = swp_img_list
    inst.size = size
    if swp_img_list then
        for i = 1, size do
            SetImageFromName(inst, nil, swp_img_list[i])
        end
    else
        for i = 1, size do
            SetImageFromName(inst, nil, "SWAP_img" .. i)
        end
    end

    inst:AddComponent("container")
    local slotpos = {}
    if inst.size == 6 then
        -- inst.components.container:WidgetSetup("sacred_chest")
        slotpos[1] = Vector3(-165, -80, 0)
        slotpos[2] = Vector3(-85, -80, 0)
        slotpos[3] = Vector3(-165, 0, 0)
        slotpos[4] = Vector3(-85, 0, 0)
        slotpos[5] = Vector3(-165, 80, 0)
        slotpos[6] = Vector3(-85, 80, 0)
    elseif inst.size == 3 then
        -- inst.components.container:WidgetSetup("livingtree_halloween")
        -- 3 slots
        slotpos[1] = Vector3(-85 + 20, 0, 0)
        slotpos[2] = Vector3(-85 + 20, -80, 0)
        slotpos[3] = Vector3(-85 + 20, 80, 0)
    else
        -- inst.components.container:WidgetSetup("alterguardianhatshard")
        -- single slot containers won't really use the interface, but need to know number of slots
        slotpos[1] = Vector3(0, 0, 0)
    end
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.canbeopened = false

    inst.shelves = {} --展柜槽
    spawnshelfslots(inst)

    inst:DoTaskInTime(0, function()
        -- -- put the container items in there
        for index, v in ipairs(inst.shelves) do
            local item = inst.components.container:GetItemInSlot(index)
            if item then
                v.components.shelfer:UpdateGift(item)
            end
        end
    end)

    -- inst:AddComponent("inspectable")

    inst:DoTaskInTime(0, function()
        if inst:HasTag("playercrafted") then
            setPlayerUncraftable(inst)
        end
    end)

    inst:ListenForEvent("onremove", RemoveShelves)
    inst:ListenForEvent("onbuilt", OnBuilt)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function BasicShelf(anim)
    local inst = common()
    inst.AnimState:PlayAnimation(anim, false)
    return inst
end

local function MakeFridge()
    local inst = BasicShelf("fridge")

    inst:AddTag("fridge")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.container:WidgetSetup("icebox")

    return inst
end

local function display(anim)
    local inst = common(3, nil, nil, true)

    inst.AnimState:SetBuild("room_shelves")
    inst.AnimState:SetBank("bookcase")
    inst.AnimState:PlayAnimation(anim)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function ruins()
    local inst = common(1, nil, nil, true)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("shelf_ruins.png")

    inst.AnimState:SetBuild("room_shelves")
    inst.AnimState:SetBank("bookcase")
    inst.AnimState:PlayAnimation("ruins")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function queen_display_common(anim)
    local inst = common(1, { "SWAP_SIGN" }, true, true)

    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:SetBank("pedestal")
    inst.AnimState:PlayAnimation(anim)

    inst:RemoveTag("NOCLICK")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "royal_gallery"

    return inst
end

-- 皇家画廊钥匙
local function key()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pedestal_key")
    inst.AnimState:SetBuild("pedestal_key")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("key")
    inst.components.key.keytype = "royal gallery"

    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"

    inst:AddComponent("tradable")

    return inst
end

return Prefab("shelves_wood", Utils.FnParameterExtend(BasicShelf, "wood"), assets, prefabs),
    Prefab("shelves_basic", Utils.FnParameterExtend(BasicShelf, "basic"), assets, prefabs),
    Prefab("shelves_marble", Utils.FnParameterExtend(BasicShelf, "marble"), assets, prefabs),
    Prefab("shelves_glass", Utils.FnParameterExtend(BasicShelf, "glass"), assets, prefabs),
    Prefab("shelves_ladder", Utils.FnParameterExtend(BasicShelf, "ladder"), assets, prefabs),
    Prefab("shelves_hutch", Utils.FnParameterExtend(BasicShelf, "hutch"), assets, prefabs),
    Prefab("shelves_industrial", Utils.FnParameterExtend(BasicShelf, "industrial"), assets, prefabs),
    Prefab("shelves_adjustable", Utils.FnParameterExtend(BasicShelf, "adjustable"), assets, prefabs),
    Prefab("shelves_fridge", MakeFridge, assets, prefabs),
    Prefab("shelves_cinderblocks", Utils.FnParameterExtend(BasicShelf, "cinderblocks"), assets, prefabs),
    Prefab("shelves_midcentury", Utils.FnParameterExtend(BasicShelf, "midcentury"), assets, prefabs),
    Prefab("shelves_wallmount", Utils.FnParameterExtend(BasicShelf, "wallmount"), assets, prefabs),
    Prefab("shelves_aframe", Utils.FnParameterExtend(BasicShelf, "aframe"), assets, prefabs),
    Prefab("shelves_crates", Utils.FnParameterExtend(BasicShelf, "crates"), assets, prefabs),
    -- Prefab("shelves_hooks", Utils.FnParameterExtend(BasicShelf, "hooks"), assets, prefabs), --没有动画，单机版也生成不出来，可能是遗留的bug
    Prefab("shelves_pipe", Utils.FnParameterExtend(BasicShelf, "pipe"), assets, prefabs),
    Prefab("shelves_hattree", Utils.FnParameterExtend(BasicShelf, "hattree"), assets, prefabs),
    Prefab("shelves_pallet", Utils.FnParameterExtend(BasicShelf, "pallet"), assets, prefabs),
    Prefab("shelves_floating", Utils.FnParameterExtend(BasicShelf, "floating"), assets, prefabs),
    Prefab("shelves_displaycase", Utils.FnParameterExtend(display, "displayshelf_wood"), assets, prefabs),
    Prefab("shelves_displaycase_metal", Utils.FnParameterExtend(display, "displayshelf_metal"), assets, prefabs),
    Prefab("shelves_queen_display_1", Utils.FnParameterExtend(queen_display_common, "lock19_east"), assets, prefabs),
    Prefab("shelves_queen_display_2", Utils.FnParameterExtend(queen_display_common, "lock17_east"), assets, prefabs),
    Prefab("shelves_queen_display_3", Utils.FnParameterExtend(queen_display_common, "lock12_west"), assets, prefabs),
    Prefab("shelves_queen_display_4", Utils.FnParameterExtend(queen_display_common, "lock12_west"), assets, prefabs),
    Prefab("shelves_ruins", ruins, assets, prefabs),

    Prefab("pedestal_key", key, assets, prefabs),
    Prefab("shelves_metal", Utils.FnParameterExtend(BasicShelf, "metalcrates"), assets, prefabs)
