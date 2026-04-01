local skinlist = require("datadefs/skin_nature_defs").skinlist




----inventory
-- local inventory = require("components/inventory")
-- local old_giveitem = inventory.GiveItem

-- function inventory:GiveItem(item, giver, source)
--     if item.components and item.components.natureskin then
--         self.inst:DoTaskInTime(0, function(inst)
--             old_giveitem(self, item, giver, source)
--         end)
--     else
--         old_giveitem(self, item, giver, source)
--     end
-- end

--stackable
local Stackable = require("components/stackable")
local old_Get = Stackable.Get
function Stackable:Get(num, ...)
    local rets = { old_Get(self, num, ...) }

    if rets[1] and rets[1].components.natureskin then
        rets[1].components.natureskin:InheritFrom(self.inst)
    end

    return unpack(rets)
end

--cookable
local Cookable = require("components/cookable")
local old_Cook = Cookable.Cook
function Cookable:Cook(...)
    local prod = old_Cook(self, ...)

    if prod.components.natureskin then
        prod.components.natureskin:InheritFrom(self.inst)
    end

    return prod
end
