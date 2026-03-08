local LeafBadge = require "widgets/leafbadge"
local Clouds = require "widgets/hamlet_clouds"
local Pollenover = require "widgets/pollenover"
AddClassPostConstruct("widgets/controls", function(self)
    -- 花粉
    self.hamlet_pollenover = self:AddChild(Pollenover(self.owner))

    -- 雨林叶子
    self.hamlet_leafbadge = self:AddChild(LeafBadge(self.owner))

    self.hamlet_clouds = self:AddChild(Clouds(self.owner))
end)


-- 哈姆雷特血月
local luavermelha = require "widgets/bloodmoon"
if TUNING.tropical.aporkalypse then
    AddClassPostConstruct("widgets/uiclock", function(self)
        self.luadesangue = self:AddChild(luavermelha(self.owner))
    end)
end


-- local PollenOver = require("widgets/pollenover")
local FogOver = require("widgets/fogover")
local PlayerHud = require("screens/playerhud")
-- function PlayerHud:CreateOverlays(owner, ...)
--     -- 花粉
--     self.pollenover = self.overlayroot:AddChild(PollenOver(owner))
--     self.pollenover:Hide()
--     self.inst:ListenForEvent("updatehayfever", function(inst, data) return self.pollenover:UpdateState(data.sneezetime) end, self.owner)
-- end

AddClassPostConstruct("screens/playerhud", function(self)
    Utils.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner, ...)
        -- 大雾
        self.fogover = self.overlayroot:AddChild(FogOver(owner))
        self.fogover:Hide()

        return retTab
    end)

    Utils.FnDecorator(self, "SetMainCharacter", nil, function(retTab, self, maincharacter)
        if not maincharacter then return retTab end

        self.inst:ListenForEvent("pro_fogchange", function(inst, data) return self.fogover:OnFogStateChange() end, self.owner)

        return retTab
    end)
end)
