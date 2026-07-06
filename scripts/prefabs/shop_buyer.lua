local pig_shop_defs = require("prefabs/pig_shop_defs")

local assets =
{
    Asset("ANIM", "anim/pedestal_crate.zip"),
    Asset("ATLAS_BUILD", "images/inventoryimages.xml", 256),
    Asset("INV_IMAGE", "cost-1"),
    Asset("INV_IMAGE", "cost-2"),
    Asset("INV_IMAGE", "cost-3"),
    Asset("INV_IMAGE", "cost-4"),
    Asset("INV_IMAGE", "cost-5"),
    Asset("INV_IMAGE", "cost-10"),
    Asset("INV_IMAGE", "cost-20"),
    Asset("INV_IMAGE", "cost-30"),
    Asset("INV_IMAGE", "cost-40"),
    Asset("INV_IMAGE", "cost-50"),
    Asset("INV_IMAGE", "cost-100"),
    Asset("INV_IMAGE", "cost-200"),
    Asset("INV_IMAGE", "cost-300"),
    Asset("INV_IMAGE", "cost-400"),
    Asset("INV_IMAGE", "cost-500"),
    Asset("INV_IMAGE", "cost-nil"),
}

local function OnInteriorSpawn(inst, data)
    inst.saleitem = data.saleitem
    inst.shoptype = data.shoptype
end

local function OnSetGoods(inst, goods, costprefab, cost)
    for _, v in ipairs(inst.components.container:RemoveAllItems()) do
        v:Remove()
    end
    local item = SpawnPrefab(goods)
    if item then
        inst.components.container:GiveItem(item)
    else
        TroErrorHandle("生成物品失败：" .. tostring(goods) .. "   " .. tostring(goods), false)
    end
end

local function OnBought(inst, goods, buyer)
    local item = inst.components.container:RemoveItemBySlot(1)
    if item then
        buyer.components.inventory:GiveItem(item)
    end
end

local function OnSetCost(inst, costprefab, cost)
    local image = nil
    if costprefab == "oinc" and cost then
        image = "cost-" .. cost
    else
        image = costprefab
    end
    if image ~= nil then
        local texname = image .. ".tex"
        inst.AnimState:OverrideSymbol("SWAP_COST", GetInventoryItemAtlas(texname), texname)
    else
        inst.AnimState:ClearOverrideSymbol("SWAP_COST")
    end
end

local function GetNewGoods(inst)
    if inst.saleitem then
        return inst.saleitem[1], inst.saleitem[2], inst.saleitem[3]
    end

    local tab = pig_shop_defs.SHOPTYPES[inst.shoptype or "DEFAULT"]
    if not tab or #tab <= 0 then return end
    local newproduct = tab[math.random(#tab)]
    return newproduct[1], newproduct[2], newproduct[3]
end

local function OnSave(inst, data)
    data.saleitem = inst.saleitem
    data.shoptype = inst.shoptype
end

local function OnLoad(inst, data)
    if not data then return end
    inst.saleitem = data.saleitem or inst.saleitem
    inst.shoptype = data.shoptype or inst.shoptype
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- inst.MiniMapEntity:SetIcon("accomplishment_shrine.png") --货架没有自己的小地图图标

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("pedestal")
    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("shop_pedestal")
    inst:AddTag("shopped")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 原版是生成商品，获取数据然后删除，但是我客机需要知道商品的名字，为了方便，这里物品一直留着
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("shop_buyer")
    inst.components.container.canbeopened = false

    inst:AddComponent("shopped")
    inst.components.shopped.onsetgoods = OnSetGoods
    inst.components.shopped.onbought = OnBought
    inst.components.shopped.onsetcost = OnSetCost
    inst.components.shopped.getnewgoods = GetNewGoods

    inst:AddComponent("tro_saveanim")

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    inst:ListenForEvent("oninteriorspawn", OnInteriorSpawn)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("shop_buyer", fn, assets)
