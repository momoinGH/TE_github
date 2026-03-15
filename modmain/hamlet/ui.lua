table.insert(Assets, Asset("ANIM", "anim/leaves_canopy2.zip")) --头顶绿荫

local LeafBadge = require "widgets/leafbadge"
AddClassPostConstruct("widgets/controls", function(self)
    -- 雨林叶子
    self.hamlet_leafbadge = self:AddChild(LeafBadge(self.owner))
end)


-- 哈姆雷特血月
local luavermelha = require "widgets/bloodmoon"
if TUNING.tropical.aporkalypse then
    AddClassPostConstruct("widgets/uiclock", function(self)
        self.luadesangue = self:AddChild(luavermelha(self.owner))
    end)
end


local PlayerHud = require("screens/playerhud")
-- function PlayerHud:CreateOverlays(owner, ...)
--     -- 花粉
--     self.pollenover = self.overlayroot:AddChild(PollenOver(owner))
--     self.pollenover:Hide()
--     self.inst:ListenForEvent("updatehayfever", function(inst, data) return self.pollenover:UpdateState(data.sneezetime) end, self.owner)
-- end

----------------------------------------------------------------------------------------------------

local CraftingMenuIngredients = require("widgets/redux/craftingmenu_ingredients")
local set_recipe = CraftingMenuIngredients.SetRecipe
function CraftingMenuIngredients:SetRecipe(...)
    self.owner.replica.inventory.check_all_oincs = true
    local ret = { set_recipe(self, ...) }
    self.owner.replica.inventory.check_all_oincs = nil
    return unpack(ret)
end
