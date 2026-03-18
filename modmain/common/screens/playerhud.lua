table.insert(Assets, Asset("ATLAS", "images/overlays/living_artifact.xml"))

local VisorOver = require "widgets/visorover"
AddClassPostConstruct("screens/playerhud", function(self)
    Hooks.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner, ...)
        -- 面甲的UI
        self.visorover = self.overlayroot:AddChild(VisorOver(owner))
        return retTab
    end)
end)
