-- 扣除身上的钱
local function PayMoney(self, cost)
    local _, oincamount = self:Has("oinc", 0, true)
    local _, oinc10amount = self:Has("oinc10", 0, true)
    local _, oinc100amount = self:Has("oinc100", 0, true)
    local debt = cost

    local oincused = 0
    local oinc10used = 0
    local oinc100used = 0
    local oincgained = 0
    local oinc10gained = 0
    while debt > 0 do
        while debt > 0 and oincamount > 0 do
            oincamount = oincamount - 1
            debt = debt - 1
            oincused = oincused + 1
        end
        if debt > 0 then
            if oinc10amount > 0 then
                oinc10amount = oinc10amount - 1
                oinc10used = oinc10used + 1
                oincamount = oincamount + 10
                oincgained = oincgained + 10
            elseif oinc100amount > 0 then
                oinc100amount = oinc100amount - 1
                oinc100used = oinc100used + 1
                oinc10amount = oinc10amount + 10
                oinc10gained = oinc10gained + 10
            end
        end
    end
    local oincresult = oincgained - oincused
    if oincresult > 0 then
        for i = 1, oincresult do
            local coin = SpawnPrefab("oinc")
            self:GiveItem(coin)
        end
    end
    if oincresult < 0 then
        for i = 1, math.abs(oincresult) do
            self:ConsumeByName("oinc", 1, true)
        end
    end
    local oinc10result = oinc10gained - oinc10used
    if oinc10result > 0 then
        for i = 1, oinc10result do
            local coin = SpawnPrefab("oinc10")
            self:GiveItem(coin)
        end
    end
    if oinc10result < 0 then
        for i = 1, math.abs(oinc10result) do
            self:ConsumeByName("oinc10", 1)
        end
    end
    local oinc100result = 0 - oinc100used
    if oinc100result < 0 then
        for i = 1, math.abs(oinc100result) do
            self:ConsumeByName("oinc100", 1)
        end
    end
end

local function GetMoney(self)
    local _, oincamount = self:Has("oinc", 0)
    local _, oinc10amount = self:Has("oinc10", 0)
    local _, oinc100amount = self:Has("oinc100", 0)
    return oincamount + (oinc10amount * 10) + (oinc100amount * 100)
end

AddComponentPostInit("inventory", function(self)
    self.PayMoney = PayMoney
    self.GetMoney = GetMoney
end)

-- 身上总钱数
AddClassPostConstruct("components/inventory_replica", function(self)
    self.check_all_oincs = nil

    local OldHas = self.Has
    function self:Has(prefab, amount, checkallcontainers, ...)
        if self.check_all_oincs and prefab == "oinc" then
            local _, oincamount = OldHas(self, "oinc", 0, true)
            local _, oinc10amount = OldHas(self, "oinc10", 0, true)
            local _, oinc100amount = OldHas(self, "oinc100", 0, true)
            local total = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
            return total >= amount, total
        end
        return OldHas(self, prefab, amount, checkallcontainers, ...)
    end

    self.GetMoney = GetMoney
end)



local CraftingMenuIngredients = require("widgets/redux/craftingmenu_ingredients")
local set_recipe = CraftingMenuIngredients.SetRecipe
function CraftingMenuIngredients:SetRecipe(...)
    self.owner.replica.inventory.check_all_oincs = true
    local ret = { set_recipe(self, ...) }
    self.owner.replica.inventory.check_all_oincs = nil
    return unpack(ret)
end
