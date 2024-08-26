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

modimport("scripts/modweab.lua")
