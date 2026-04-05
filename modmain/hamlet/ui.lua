table.insert(Assets, Asset("ANIM", "anim/leaves_canopy2.zip")) --头顶绿荫

local LeafBadge = require "widgets/leafbadge"
AddClassPostConstruct("screens/playerhud", function(self)
    Hooks.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner, ...)
        -- 雨林叶子
        self.hamlet_leafbadge = self:AddChild(LeafBadge(owner))
        self.hamlet_leafbadge:MoveToBack() --放后面，不能遮挡UI了
        return retTab
    end)
end)

----------------------------------------------------------------------------------------------------



local PlayerHud = require("screens/playerhud")
-- function PlayerHud:CreateOverlays(owner, ...)
--     -- 花粉
--     self.pollenover = self.overlayroot:AddChild(PollenOver(owner))
--     self.pollenover:Hide()
--     self.inst:ListenForEvent("updatehayfever", function(inst, data) return self.pollenover:UpdateState(data.sneezetime) end, self.owner)
-- end

----------------------------------------------------------------------------------------------------