local PigShopDefs = require("prefabs/pig_shop_defs")

local function ongoodsprefab(self, goodsprefab)
    if goodsprefab then
        self.inst:AddTag("slot_one") --有商品了
    else
        self.inst:RemoveTag("slot_one")
    end
end

-- 商品相关字段太琐碎，单独写个组件存储
local Shopped = Class(function(self, inst)
    self.inst = inst

    inst:AddTag("shop_pedestal")

    self.goodsprefab = nil --商品名
    self.goods_atlas = nil
    self.goods_image = nil

    self.costprefab = nil   --货币名
    self.cost = nil         --如果是呼噜币，呼噜币数量

    self.saleitem = nil     --固定售卖的商品
    self.shoptype = nil     --商店类型，这里是商店预制件名，从pig_shop_defs.lua中随机选择商品
    self.robbed = nil       --被偷了
    self.justsellonce = nil --只卖一次
end, nil, {
    goodsprefab = ongoodsprefab
})

function Shopped:SetImage(ent)
    local image = ent and ent.replica.inventoryitem ~= nil and ent.replica.inventoryitem:GetImage()

    if image then
        --mod物品drawatlasoverride或atlasname至少指定一个
        local atlas = FunctionOrValue(ent.drawatlasoverride, ent, self.inst) or ent.components.inventoryitem.atlasname
        if atlas ~= nil then
            atlas = resolvefilepath_soft(atlas) --需要找到路径，例如../mods/PigmanTribe/images/inventoryimages/ptribe_upgrade.xml
        end

        self.goodsprefab = ent.prefab
        self.goods_atlas = atlas or GetInventoryItemAtlas(image)
        self.goods_image = image
        self.inst.AnimState:OverrideSymbol("SWAP_SIGN", self.goods_atlas, self.goods_image)
    else
        self.goodsprefab = nil
        self.goods_atlas = nil
        self.goods_image = nil
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
---@param goodsprefab string 商品
---@param costprefab string 购买需要的货币
---@param cost number 货币数量
function Shopped:SpawnInventory(goodsprefab, costprefab, cost)
    local item = SpawnPrefab(goodsprefab or self.goodsprefab)
    self:SetImage(item)
    self:SetCost(costprefab, cost)
    item:Remove()
end

--- 当商品被买后
function Shopped:SoldItem()
    self:SetImage(nil)
end

local function shopkeeper_speech(inst, speech)
    local ent = FindEntity(inst, 20, nil, { "shopkeep" })
    if ent then
        ent:shopkeeper_speech(speech)
    end
end

--- 补货
function Shopped:Restock(force)
    if self.robbed then --被偷了
        self:SetCost("cost-nil")
        shopkeeper_speech(self.inst, STRINGS.CITY_PIG_SHOPKEEPER_ROBBED[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_ROBBED)])
    elseif force or ((not self.goodsprefab or math.random() < 0.16) and not self.justsellonce) then
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
        goodsprefab = self.goodsprefab,
        goods_atlas = self.goods_atlas,
        goods_image = self.goods_image,
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

    if data.goodsprefab then
        self.goodsprefab = data.goodsprefab
        self.goods_atlas = data.goods_atlas
        self.goods_image = data.goods_image
        self.inst.AnimState:OverrideSymbol("SWAP_SIGN", self.goods_atlas, self.goods_image)
    end

    if data.costprefab then
        self:SetCost(data.costprefab, data.cost)
    end

    self.saleitem = data.saleitem
    self.shoptype = data.shoptype
    self.robbed = data.robbed
    self.justsellonce = data.justsellonce
end

return Shopped
