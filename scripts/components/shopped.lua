local PigShopDefs = require("prefabs/pig_shop_defs")

local function OnItemGet(inst, data)
    inst:AddTag("slot_one") --有商品了
    inst.components.shopped:SetImage(data.item)
end

local function OnItemLose(inst)
    local self = inst.components.shopped
    inst:RemoveTag("slot_one")
    self:SetImage()
    self:SetCost(self.robbed and "cost-nil" or nil)
end

-- 商品相关字段太琐碎，单独写个组件存储
local Shopped = Class(function(self, inst)
    self.inst = inst

    inst:AddTag("shopped")

    self.costprefab = nil   --货币名
    self.cost = nil         --如果是呼噜币，呼噜币数量

    self.saleitem = nil     --固定售卖的商品
    self.shoptype = nil     --商店类型，这里是商店预制件名，从pig_shop_defs.lua中随机选择商品
    self.robbed = nil       --被偷了
    self.justsellonce = nil --只卖一次

    inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("itemlose", OnItemLose)
end)

function Shopped:SetImage(ent)
    local image = ent and ent.replica.inventoryitem ~= nil and ent.replica.inventoryitem:GetImage()

    if image then
        --mod物品drawatlasoverride或atlasname至少指定一个
        local atlas = FunctionOrValue(ent.drawatlasoverride, ent, self.inst) or ent.components.inventoryitem.atlasname
        if atlas ~= nil then
            atlas = resolvefilepath_soft(atlas) --需要找到路径，例如../mods/PigmanTribe/images/inventoryimages/ptribe_upgrade.xml
        end
        self.inst.AnimState:OverrideSymbol("SWAP_SIGN", atlas or GetInventoryItemAtlas(image), image)
    else
        self.inst.AnimState:ClearOverrideSymbol("SWAP_SIGN")
    end
end

---设置价格
---@param costprefab string 货币名
---@param cost number|nil 如果是呼噜币的话这里填呼噜币的个数，可取值见pig_shop_defs.lua
function Shopped:SetCost(costprefab, cost)
    local image = nil

    if costprefab == "oinc" and cost then
        image = "cost-" .. cost
    else
        image = costprefab
    end

    if image ~= nil then
        local texname = image .. ".tex"
        self.inst.AnimState:OverrideSymbol("SWAP_COST", GetInventoryItemAtlas(texname), texname)
    else
        self.inst.AnimState:ClearOverrideSymbol("SWAP_COST")
    end

    self.costprefab = costprefab
    self.cost = cost
end

---设置商品
---@param costprefab string 购买需要的货币
---@param cost number 货币数量
function Shopped:SpawnInventory(goods, costprefab, cost)
    for _, v in ipairs(self.inst.components.container:RemoveAllItems()) do
        v:Remove()
    end

    local item = SpawnPrefab(goods or self.goods)
    assert(item.components.inventoryitem)
    self:SetImage(item)
    self:SetCost(costprefab, cost)
    self.inst.components.container:GiveItem(item)
end

--- 当商品被买后
function Shopped:BuyGoods(buyer)
    local item = self.inst.components.container:RemoveItemBySlot(1)
    if item.OnBought then
        item:OnBought(buyer, self.inst)
    end
    return item
end

--- 补货
function Shopped:Restock(force)
    if self.robbed then --被偷了
        local ent = FindEntity(inst, 20, nil, { "shopkeep" })
        if ent then
            ent.components.talker:Say(STRINGS.CITY_PIG_SHOPKEEPER_ROBBED[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_ROBBED)])
        end
    elseif force or ((self.inst.components.container:IsEmpty() or math.random() < 0.16) and not self.justsellonce) then
        local newproduct
        if self.saleitem then
            newproduct = self.saleitem
        else
            local tab = PigShopDefs.SHOPTYPES[self.shoptype or "DEFAULT"]
            newproduct = tab[math.random(#tab)] --如果shoptype存在但是没有在pig_shop_defs中定义会报错
        end
        self:SpawnInventory(newproduct[1], newproduct[2], newproduct[3])
    end
end

function Shopped:OnSave()
    return {
        costprefab = self.costprefab,
        cost = self.cost,
        saleitem = self.saleitem,
        shoptype = self.shoptype,
        robbed = self.robbed,
        justsellonce = self.justsellonce,
    }
end

function Shopped:OnLoad(data)
    if not data then return end

    self.saleitem = data.saleitem
    self.shoptype = data.shoptype
    self.robbed = data.robbed
    self.justsellonce = data.justsellonce
end

return Shopped
