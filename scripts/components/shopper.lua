--- 玩家购买商品，针对货架或柜子里的商品
local Shopper = Class(function(self, inst)
    self.inst = inst
end)

--- 是否有足够的钱购买
function Shopper:CanPayFor(target)
    local inventory = self.inst.components.inventory
    if target.components.shopped then
        --货架
        local prefab_wanted = target.components.shopped.costprefab
        if prefab_wanted == "oinc" then
            if inventory:GetMoney() >= target.components.shopped.cost then
                return true
            end
        else
            -- 需要物品来换
            if inventory:FindItem(function(look) return look.prefab == prefab_wanted end) then
                return true
            end
        end
    elseif target:HasTag("cost_one_oinc") then
        --柜子
        if inventory:GetMoney() >= 1 then
            return true
        end
    end
    return false
end

function Shopper:BoughtItem(target)
    if target.components.shopped then
        target.components.shopped:BuyGoods(self.inst)
    end
end

--- 购买商品
function Shopper:PayFor(target)
    local inventory = self.inst.components.inventory
    if target.components.shopped then
        -- 货架
        local prefab_wanted = target.components.shopped.costprefab
        if prefab_wanted == "oinc" then
            inventory:PayMoney(target.components.shopped.cost)
        else
            inventory:ConsumeByName(prefab_wanted, 1)
        end
        self:BoughtItem(target)
    elseif target:HasTag("cost_one_oinc") then
        --柜子

        inventory:PayMoney(1)
    end
end

--- 偷取货架上商品
function Shopper:Take(target)
    if target.components.shopped then
        target.components.shopped.robbed = true
    end
    self:BoughtItem(target)
end

return Shopper
