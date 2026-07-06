local assets =
{
    Asset("ANIM", "anim/shelf_slot.zip"),
}

local function displaynamefn(inst)
    local item = inst.components.shelfer:GetGift()
    if not item then
        return ""
    end
    return item:GetDisplayName()
end

local function OnGetItem(inst, item)
    inst.components.shopped:OnItemGet(item.prefab)
    inst.components.named:SetName(STRINGS.NAMES[string.upper(item.components.inspectable.nameoverride or item.prefab)])
end

local function OnLoseItem(inst)
    inst.components.shopped:OnItemLose()
    inst.components.named:SetName(nil)
end

local function OnSetGoods(inst, goods, costprefab, cost)
    local ent = SpawnPrefab(goods)
    if inst.components.shelfer:AcceptGift(nil, ent) then
        inst.components.named:SetName(STRINGS.NAMES[string.upper(ent.components.inspectable.nameoverride or ent.prefab)])
    else
        ent:Remove()
    end
end

local function OnBought(inst, goods, buyer)
    inst.components.named:SetName(nil)
    local item = inst.components.shelfer:GiveGift()
    if item then
        buyer.components.inventory:GiveItem(item)
    end
end

local PigShopDefs = require("prefabs/pig_shop_defs")
local function GetNewGoods(inst)
    return PigShopDefs.SHELFS.DEFAULT[math.random(#PigShopDefs.SHELFS.DEFAULT)] --先使用默认的
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- 这个动画不是完全透明的，完全透明的贴图无法触发action
    inst.AnimState:SetBuild("shelf_slot")
    inst.AnimState:SetBank("shelf_slot")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(255 / 255, 255 / 255, 255 / 255, 0.02) --好像这个也行

    inst:AddTag("cost_one_oinc")
    inst:AddTag("NOBLOCK")
    inst:AddTag("_named")
    inst:AddTag("shopped")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")

    inst:AddComponent("named")

    inst:AddComponent("shelfer")

    inst:AddComponent("shopped")
    inst.components.shopped.onsetgoods = OnSetGoods
    inst.components.shopped.onbought = OnBought
    inst.components.shopped.getnewgoods = GetNewGoods

    inst.displaynamefn = displaynamefn

    inst.OnGetItem = OnGetItem
    inst.OnLoseItem = OnLoseItem

    inst.persists = false

    return inst
end

return Prefab("shelf_slot", fn, assets)
