table.insert(Assets, Asset("ATLAS", "images/overlays/living_artifact.xml"))

local VisorOver = require "widgets/visorover"
AddClassPostConstruct("screens/playerhud", function(self)
    Hooks.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner, ...)
        -- 面甲的UI
        self.visorover = self.overlayroot:AddChild(VisorOver(owner))
        self.visorover:Hide()
        return retTab
    end)

    Hooks.FnDecorator(self, "SetMainCharacter", nil, function(retTab, self, maincharacter)
        if not maincharacter then return retTab end

        self.inst:ListenForEvent("unequip", function(inst, data) self.visorover:UpdateState(data) end, self.owner)
        self.inst:ListenForEvent("equip", function(inst, data) self.visorover:UpdateState(data) end, self.owner)

        return retTab
    end)
end)
