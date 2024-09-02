local LeafBadge = require "widgets/leafbadge"
local Clouds = require "widgets/hamlet_clouds"
local Pollenover = require "widgets/pollenover"
AddClassPostConstruct("widgets/controls", function(self)
    if TUNING.tropical.hayfever ~= 0 then
        self.hamlet_pollenover = self:AddChild(Pollenover(self.owner))
    end

    self.hamlet_leafbadge = self:AddChild(LeafBadge(self.owner))
    -- self.hamlet_leafbadge:SetPosition(0, 0, 0)
    -- self.hamlet_leafbadge:MoveToBack()

    if TUNING.tropical.fog ~= 0 then
        self.hamlet_clouds = self:AddChild(Clouds(self.owner))
    end
end)
