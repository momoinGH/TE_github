local pig_shop_defs = require("prefabs/pig_shop_defs")

local assets =
{
    Asset("ANIM", "anim/room_shelves.zip"),
    Asset("ANIM", "anim/pedestal_crate.zip"), --一个容器的展柜和一些装饰
}

local prefabs =
{
    "shelf_slot",
}

----------------------------------------------------------------------------------------------------

local function spawnshelfslots(inst)
    for i = 1, inst.size do
        local object = SpawnPrefab("shelf_slot")
        local slot = inst.swp_img_list and inst.swp_img_list[i] or ("SWAP_img" .. i)
        object.entity:AddFollower():FollowSymbol(inst.GUID, slot, 10, 0, 0.6)
        object.components.shelfer:SetShelf(inst, slot, i)
        table.insert(inst.shelves, object)
    end
end

----------------------------------------------------------------------------------------------------

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function setPlayerUncraftable(inst)
    inst:AddTag("playercrafted")
    inst:RemoveTag("NOCLICK")

    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end

    if not inst.components.workable then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onhammered)
    end
end

local function OnSave(inst, data)
    data.playercrafted = inst:HasTag("playercrafted") or nil
end

local function OnLoad(inst, data)
    if not data then return end

    if data.playercrafted then
        setPlayerUncraftable(inst)
    end
end

local function RemoveShelves(inst)
    for _, v in ipairs(inst.shelves) do
        v:Remove()
    end
end

local function OnLoadPostPass(inst)
    -- put the container items in there
    for index, v in ipairs(inst.shelves) do
        local item = inst.components.container:GetItemInSlot(index)
        if item then
            v.components.shelfer:UpdateGift(item)
        end
    end
end

local function OnItemGet(inst, data)
    if data and data.item and data.slot then
        inst.shelves[data.slot].components.shelfer:UpdateGift(data.item)
    end
end

local function OnItemLose(inst, data)
    if data and data.slot then
        inst:SetImageFromName(nil, data.slot)
        inst.shelves[data.slot].components.shelfer:OnItemLose()
    end
end

local function MakeShelf(name, data, common_post_fn, master_post_fn)
    assert(data.anim)

    local size = data.size or 6
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .5)

        inst.AnimState:SetBuild(data.build or "room_shelves")
        inst.AnimState:SetBank(data.bank or "bookcase")
        inst.AnimState:PlayAnimation(data.anim, false)
        inst.Transform:SetRotation(-90)

        inst:AddTag("NOCLICK")
        -- inst:AddTag("NOBLOCK")
        inst:AddTag("furniture")
        inst:AddTag("structure")
        inst:AddTag("shop_shelf")

        if common_post_fn then
            common_post_fn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.SetImage = pig_shop_defs.SetImage
        inst.SetImageFromName = pig_shop_defs.SetImageFromName

        inst.swp_img_list = data.swp_img_list
        inst.size = size
        if data.swp_img_list then
            for i = 1, size do
                inst:SetImageFromName(nil, data.swp_img_list[i])
            end
        else
            for i = 1, size do
                inst:SetImageFromName(nil, "SWAP_img" .. i)
            end
        end

        inst:AddComponent("container")
        local slotpos = {}
        if size == 6 then
            slotpos[1] = Vector3(-165, -80, 0)
            slotpos[2] = Vector3(-85, -80, 0)
            slotpos[3] = Vector3(-165, 0, 0)
            slotpos[4] = Vector3(-85, 0, 0)
            slotpos[5] = Vector3(-165, 80, 0)
            slotpos[6] = Vector3(-85, 80, 0)
        elseif size == 3 then
            slotpos[1] = Vector3(-85 + 20, 0, 0)
            slotpos[2] = Vector3(-85 + 20, -80, 0)
            slotpos[3] = Vector3(-85 + 20, 80, 0)
        else
            slotpos[1] = Vector3(0, 0, 0)
        end
        inst.components.container:SetNumSlots(#slotpos)
        inst.components.container.canbeopened = false

        inst.shelves = {} --展柜槽
        spawnshelfslots(inst)

        inst:AddComponent("tro_saveanim")

        inst:ListenForEvent("onremove", RemoveShelves)
        inst:ListenForEvent("onbuilt", setPlayerUncraftable)
        inst:ListenForEvent("itemget", OnItemGet)
        inst:ListenForEvent("itemlose", OnItemLose)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
        inst.OnLoadPostPass = OnLoadPostPass

        if master_post_fn then
            master_post_fn(inst)
        end

        return inst
    end
    return Prefab(name, fn, assets, prefabs)
end

local function ShelvesQueenCommonPost(inst)
    inst:RemoveTag("NOCLICK")
end

local function ShelvesQueenMasterPost(inst)
    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "royal_gallery"

end

local function OnOnShelvesInteriorSpawn(inst, data)
    if not data.shelfitems then
        return
    end

    for _, item_info in ipairs(data.shelfitems) do
        local item = SpawnAt(item_info[2], inst)
        if item_info[1] > 1 and item.components.stackable then
            item.components.stackable.stacksize = item_info[1]
        end
        inst.components.container:GiveItem(item)
    end
end

return MakeShelf("shelves_wood", { anim = "wood" }),
    MakeShelf("shelves_basic", { anim = "basic" }),
    MakeShelf("shelves_marble", { anim = "marble" }),
    MakeShelf("shelves_glass", { anim = "glass" }),
    MakeShelf("shelves_ladder", { anim = "ladder" }),
    MakeShelf("shelves_hutch", { anim = "hutch" }),
    MakeShelf("shelves_industrial", { anim = "industrial" }),
    MakeShelf("shelves_adjustable", { anim = "adjustable" }),
    MakeShelf("shelves_cinderblocks", { anim = "cinderblocks" }),
    MakeShelf("shelves_midcentury", { anim = "midcentury" }),
    MakeShelf("shelves_wallmount", { anim = "wallmount" }),
    MakeShelf("shelves_aframe", { anim = "aframe" }),
    MakeShelf("shelves_crates", { anim = "crates" }),
    MakeShelf("shelves_pipe", { anim = "pipe" }),
    MakeShelf("shelves_hattree", { anim = "hattree" }),
    MakeShelf("shelves_pallet", { anim = "pallet" }),
    MakeShelf("shelves_floating", { anim = "floating" }),
    MakeShelf("shelves_metal", { anim = "metalcrates" }),
    MakeShelf("shelves_fridge", { anim = "fridge" }, function(inst)
        inst:AddTag("fridge")
    end, function(inst)
        inst.components.container:WidgetSetup("icebox")
    end),
    MakeShelf("shelves_displaycase", { anim = "displayshelf_wood", size = 3 }),
    MakeShelf("shelves_displaycase_metal", { anim = "displayshelf_metal", size = 3 }),
    MakeShelf("shelves_queen_display_1", { size = 1, anim = "lock19_east", bank = "pedestal", build = "pedestal_crate", swp_img_list = { "SWAP_SIGN" } }, ShelvesQueenCommonPost, ShelvesQueenMasterPost),
    MakeShelf("shelves_queen_display_2", { size = 1, anim = "lock17_east", bank = "pedestal", build = "pedestal_crate", swp_img_list = { "SWAP_SIGN" } }, ShelvesQueenCommonPost, ShelvesQueenMasterPost),
    MakeShelf("shelves_queen_display_3", { size = 1, anim = "lock12_west", bank = "pedestal", build = "pedestal_crate", swp_img_list = { "SWAP_SIGN" } }, ShelvesQueenCommonPost, ShelvesQueenMasterPost),
    MakeShelf("shelves_queen_display_4", { size = 1, anim = "lock12_west", bank = "pedestal", build = "pedestal_crate", swp_img_list = { "SWAP_SIGN" } }, ShelvesQueenCommonPost, ShelvesQueenMasterPost),
    MakeShelf("shelves_ruins", { size = 1, anim = "ruins" }, nil, function(inst)
        inst:ListenForEvent("oninteriorspawn", OnOnShelvesInteriorSpawn)
    end)
