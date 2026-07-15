local pig_shop_defs = require("prefabs/pig_shop_defs")

local function ongoods(self, goods)
    self.inst.replica.shopped:SetGoods(goods)
end

local function oncostprefab(self, costprefab)
    self.inst.replica.shopped:SetCostPrefab(costprefab or "")
end

local function oncost(self, cost)
    self.inst.replica.shopped:SetCost(cost)
end

-- 存储商品的一个格子
local Shopped = Class(function(self, inst)
    self.inst = inst

    inst:AddTag("shopped")

    self.goods = nil         --商品预制件名
    self.costprefab = "oinc" --货币名
    self.cost = 0            --如果是呼噜币，呼噜币数量

    -- inst:AddTag("disable_rob") --禁止偷窃标签，一般物品没人看着可以直接拿，但是有这个标签就必须有对应物品才能换取
    self.robbed = nil --被偷了
    -- self.justsellonce = nil  --只卖一次

    self.getnewgoods = nil --补货新商品
    self.onsetgoods = nil  --设置商品时
    self.onbought = nil    --被购买时
    self.onsetcost = nil   --设置价格时
end, nil, {
    goods = ongoods,
    costprefab = oncostprefab,
    cost = oncost
})

function Shopped:OnItemGet(prefab)
    self.inst:AddTag("slot_one") --有商品了
    self.goods = prefab
    self:SetImage(prefab)
end

function Shopped:OnItemLose()
    self.inst:RemoveTag("slot_one")
    self.goods = nil
    self:SetImage()
    self:SetCost(self.robbed and "cost-nil" or nil)
end

function Shopped:SetImage(prefab)
    pig_shop_defs.SetImageFromName(self.inst, prefab, "SWAP_SIGN")
end

---设置价格
---@param costprefab string 货币名
---@param cost number|nil 如果是呼噜币的话这里填呼噜币的个数，可取值见pig_shop_defs.lua
function Shopped:SetCost(costprefab, cost)
    self.costprefab = costprefab or "oinc"
    self.cost = cost or 0

    if self.onsetcost then
        self.onsetcost(self.inst, costprefab, cost)
    end
end

---设置商品
---@param costprefab string 购买需要的货币
---@param cost number 货币数量
function Shopped:SpawnInventory(goods, costprefab, cost)
    goods = goods or self.goods
    costprefab = costprefab or "oinc"
    cost = cost or 1
    if self.onsetgoods then
        self.onsetgoods(self.inst, goods, costprefab, cost)
    end
    self:OnItemGet(goods)
    self:SetCost(costprefab, cost)
end

--- 当商品被买后
function Shopped:BuyGoods(buyer)
    if not self.goods then
        return
    end

    if self.onbought then
        self.onbought(self.inst, self.goods, buyer)
    else
        -- 默认实现，生成实体并给购买者
        if buyer and buyer.components.inventory then
            local ent = SpawnPrefab(self.goods)
            if ent then
                buyer.components.inventory:GiveItem(ent)
            end
        else
            TroSpawnDropItem(self.inst, self.goods, 1, buyer)
        end
    end
    self:OnItemLose()
end

--- 补货
function Shopped:Restock()
    if self.robbed then --被偷了
        local ent = FindEntity(self.inst, 20, nil, { "shopkeep" })
        if ent then
            ent.components.talker:Say(STRINGS.CITY_PIG_SHOPKEEPER_ROBBED[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_ROBBED)])
        end
    else
        local goods, costprefab, cost = FunctionOrValue(self.getnewgoods, self.inst)
        if not goods then
            goods = "log" --随便给个东西，我不想商人一直卡在补货的状态
            TroErrorHandle(string.trofmt("错误，商品补货失败 {}   {}", self.inst, self.getnewgoods))
        end
        costprefab = costprefab or "oinc"
        cost = cost or 1
        self:SpawnInventory(goods, costprefab, cost)
    end
end

function Shopped:OnSave()
    return {
        disable_rob = self.inst:HasTag("disable_rob"),
        goods = self.goods,
        costprefab = self.costprefab,
        cost = self.cost,
        robbed = self.robbed,
        playercrafted = self.inst:HasTag("playercrafted")
    }
end

function Shopped:OnLoad(data)
    if not data then return end

    if data.goods then
        self.goods = data.goods
    end
    if data.costprefab then
        self.costprefab = data.costprefab
    end
    if data.cost then
        self.cost = data.cost
    end
    if data.disable_rob then
        self.inst:AddTag("disable_rob")
    end
    if data.playercrafted then
        self.inst:AddTag("playercrafted")
    end
    self.robbed = data.robbed

    if data.goods then
        self.inst:DoTaskInTime(0, function()
            if self.goods then
                self:SpawnInventory(self.goods, self.costprefab, self.cost)
            end
        end)
    end
end

return Shopped
