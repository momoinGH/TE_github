modimport("functions/MagicStore.lua")
modimport("functions/DataProvider.lua")
require("modweap")

---------------------------complemento 2-------------------------
local LeafBadge = require "widgets/leafbadge"
local HayfeverBadge = require "widgets/hayfeverbadge"
AddClassPostConstruct("widgets/controls", function(self)
    self.leaf = self:AddChild(LeafBadge(self.owner))
    self.owner.leafbadge = self.leaf
    self.leaf:SetPosition(0, 0, 0)
    self.leaf:MoveToBack()

    self.hayfever = self:AddChild(HayfeverBadge(self.owner))
    self.owner.hayfeverbadge = self.hayfever
    self.hayfever:SetPosition(0, 0, 0)
    self.hayfever:MoveToBack()
end)


-- TODO 抽时间整理一下，去掉熔炉定义的这些常量
-- for _, v in ipairs({
--     "hammer_mjolnir",
--     "spear_gungnir",
--     "healingstaff",
--     "blowdart_lava2",
--     "fireballstaff",
--     "spear_lance",
--     "lavaarena_firebomb",
--     "lavaarena_heavyblade",
--     "book_fossil",
--     "book_elemental",
-- }) do
--     AddPrefabPostInit(v, function(inst)
--         local name = inst.prefab:upper()
--         if TUNING.FORGE_ITEM_PACK[name]
--             and TUNING.FORGE_ITEM_PACK[name].DURABILITY
--             and TUNING.FORGE_ITEM_PACK[name].DURABILITY.AMOUNT
--         then
--             if TUNING.FORGE_ITEM_PACK[name].DURABILITY.AMOUNT > 0 then
--                 inst:AddComponent("finiteuses")
--                 inst.components.finiteuses:SetMaxUses(TUNING.FORGE_ITEM_PACK[name].DURABILITY.AMOUNT)
--                 inst.components.finiteuses:SetUses(TUNING.FORGE_ITEM_PACK[name].DURABILITY.AMOUNT)
--                 inst.components.finiteuses:SetOnFinished(inst.Remove)
--                 if TUNING.FORGE_ITEM_PACK[name].DURABILITY.CONSUMPTION_NORMAL then
--                     inst.components.finiteuses:SetConsumption(ACTIONS.ATTACK,
--                         TUNING.FORGE_ITEM_PACK[name].DURABILITY.CONSUMPTION_NORMAL)
--                 end;

--                 if TUNING.FORGE_ITEM_PACK[name].DURABILITY.CONSUMPTION_SPECIAL then
--                     inst.components.finiteuses:SetConsumption(
--                         ACTIONS.CASTAOE,
--                         TUNING.FORGE_ITEM_PACK[name].DURABILITY.AMOUNT *
--                         TUNING.FORGE_ITEM_PACK[name].DURABILITY.CONSUMPTION_SPECIAL / 100)
--                 end
--             end
--         else
--             print("Cannot find tunning for " .. name)
--         end
--     end)
-- end


modimport("scripts/modweab.lua")