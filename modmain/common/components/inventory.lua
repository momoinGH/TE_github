-- 身上总钱数
function GetMoney(self)
    local money = 0

    local _, oincamount = self:Has("oinc", 0)
    local _, oinc10amount = self:Has("oinc10", 0)
    local _, oinc100amount = self:Has("oinc100", 0)

    money = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
    return money
end

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
            --				inventory:ConsumeByName("oinc", 1 )	
            local item = next(self:GetItemByName("oinc", 1, true))
            if item then self:RemoveItem(item, false, true) end
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
            --				inventory:ConsumeByName("oinc10", 1 )
            local item = next(self:GetItemByName("oinc10", 1, true))
            if item then self:RemoveItem(item, false, true) end
        end
    end
    local oinc100result = 0 - oinc100used
    if oinc100result < 0 then
        for i = 1, math.abs(oinc100result) do
            --				inventory:ConsumeByName("oinc100", 1)
            local item = next(self:GetItemByName("oinc100", 1, true))
            if item then self:RemoveItem(item, false, true) end
        end
    end
end

AddComponentPostInit("inventory", function(self)
    self.GetMoney = GetMoney
    self.PayMoney = PayMoney
end)

AddClassPostConstruct("components/inventory_replica", function(self)
    self.GetMoney = GetMoney
end)
