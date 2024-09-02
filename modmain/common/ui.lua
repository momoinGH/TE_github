local Utils = require("tropical_utils/utils")

-- 这部分代码看起来是设置和缩放制作栏的什么东西，但是注释掉好像也没什么变化
-- AddClassPostConstruct("widgets/crafttabs", function(self)
--     local numtabs = 0

--     for i, v in ipairs(self.tabs.tabs) do
--         if not v.collapsed then
--             numtabs = numtabs + 1
--         end
--     end

--     if numtabs > 11 then
--         self.tabs.spacing = 67

--         local scalar = self.tabs.spacing * (1 - numtabs) * .5
--         local offset = self.tabs.offset * scalar

--         for i, v in ipairs(self.tabs.tabs) do
--             if i > 1 and not v.collapsed then
--                 offset = offset + self.tabs.offset * self.tabs.spacing
--             end
--             v:SetPosition(offset)
--             self.tabs.base_pos[v] = Vector3(offset:Get())
--         end

--         local scale = 67 * numtabs / 750.0
--         self.bg:SetScale(1, scale, 1)
--         self.bg_cover:SetScale(1, scale, 1)
--     end
-- end)

-- 中毒时血条显示下降箭头
local function HealthBadgeOnUpdateAfter(retTab, self)
    if not TheNet:IsServerPaused()
        and self.arrowdir == "neutral" --不扣血也不加血
        and self.owner.components.poisonable and self.owner.components.poisonable.dmg < 0
    then
        local anim = "arrow_loop_decrease"
        if self.arrowdir ~= anim then
            self.arrowdir = anim
            self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
        end
    end
end

AddClassPostConstruct("widgets/healthbadge", function(self)
    Utils.FnDecorator(self, "OnUpdate", nil, HealthBadgeOnUpdateAfter)
end)

----------------------------------------------------------------------------------------------------

AddClassPostConstruct("widgets/controls", function(self)
    local Widget = require("widgets/widget")
    local c = self:AddChild(Widget(""))
    c:SetHAnchor(ANCHOR_MIDDLE)
    c:SetVAnchor(ANCHOR_BOTTOM)
    c:SetScaleMode(SCALEMODE_PROPORTIONAL)
    c:SetMaxPropUpscale(MAX_HUD_SCALE)
    c:MoveToBack()

    self.containerroot_bottom = c:AddChild(Widget("contaierroot_bottom"))
    local scale = TheFrontEnd:GetHUDScale()
    self.containerroot_bottom:SetScale(scale, scale, scale)
    self.containerroot_bottom:Hide()


    Utils.FnDecorator(self, "SetHUDSize", nil, function()
        local scale = TheFrontEnd:GetHUDScale()
        self.containerroot_bottom:SetScale(scale, scale, scale)
    end)


    Utils.FnDecorator(self, "ShowCraftingAndInventory", nil, function()
        self.containerroot_bottom:Show()
    end)

    Utils.FnDecorator(self, "HideCraftingAndInventory", nil, function()
        self.containerroot_bottom:Hide()
    end)
end)

-- local ContainerWidget = require("widgets/containerwidget")
-- local function OpenContainerBefore(self, container, side)
--     if container.replica.container and container.replica.container:GetWidget() and container.replica.container:GetWidget().isboat then
--         local containerwidget = ContainerWidget(self.owner)
--         self.controls.containerroot_bottom:AddChild(containerwidget)
--         containerwidget:Open(container, self.owner)
--         self.controls.containers[container] = containerwidget
--         return nil, true
--     end
-- end

local PoisonOver = require("widgets/poisonover")
AddClassPostConstruct("screens/playerhud", function(self)
    -- Utils.FnDecorator(self, "OpenContainer", OpenContainerBefore)

    -- 中毒
    Utils.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner)
        self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
    end)
end)

----------------------------------------------------------------------------------------------------

local luavermelha = require "widgets/bloodmoon"
if TUNING.tropical.aporkalypse then
    AddClassPostConstruct("widgets/uiclock", function(self)
        self.luadesangue = self:AddChild(luavermelha(self.owner))
    end)
end



local iconedevelocidade = require "widgets/speedicon"
AddClassPostConstruct("widgets/statusdisplays", function(self)
    self.velocidadeativa = self:AddChild(iconedevelocidade(self.owner))

    if KnownModIndex:IsModEnabled("workshop-376333686") then --适配Combined Status模组
        self.velocidadeativa:SetPosition(-85, 6, 0)
    else
        self.velocidadeativa:SetPosition(-65.5, -9.5, 0)
    end
end)
