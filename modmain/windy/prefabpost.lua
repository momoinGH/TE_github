local Utils = require("tropical_utils/utils")

local function HarvestBefore(self, harvester)
    if self.product_prefab ~= "peach" then return end
    if not self.matured then
        return { false }, true
    end

    local product = GLOBAL.SpawnPrefab("peach")
    if harvester then
        local rnd = math.random() * 100
        local count = 0
        if rnd <= 15 then count = 1 elseif rnd <= 75 then count = 2 else count = 3 end
        product.components.stackable:SetStackSize(count)
        harvester.components.inventory:GiveItem(product)
    else
        product.Transform:SetPosition(self.grower.Transform:GetWorldPosition())
        Launch(product, self.grower, TUNING.LAUNCH_SPEED_SMALL)
    end
    GLOBAL.ProfileStatsAdd("peach")
    self.matured = false
    self.growthpercent = 0
    self.product_prefab = nil
    self.grower.components.grower:RemoveCrop(self.inst)
    self.grower = nil
    return { true }, true
end

AddComponentPostInit("crop", function(self)
    Utils.FnDecorator(self, "Harvest", HarvestBefore)
end)

