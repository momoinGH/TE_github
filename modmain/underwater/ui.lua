table.insert(Assets, Asset("ANIM", "anim/oxygen_meter_player.zip")) --玩家氧气条

local OxygenBadge = require "widgets/oxygenbadge"
AddClassPostConstruct("widgets/statusdisplays", function(self)
    -- 氧气条
    self.oxygen = self:AddChild(OxygenBadge(self.owner))

    local badge_stomach = self.stomach:GetPosition()
    local badge_brain = self.brain:GetPosition()
    local badge_heart = self.heart:GetPosition()
    self.oxygen:SetPosition(badge_brain.x + badge_stomach.x - badge_heart.x,
        badge_brain.y + badge_stomach.y - badge_heart.y, 0)

    self.oxygen:SetPercent(self.owner.components.oxygen:GetPercent(), self.owner.components.oxygen.max)

    local function OxygenDelta(data)
        self.oxygen:SetPercent(self.owner.components.oxygen:GetPercent(), self.owner.components.oxygen.max)

        if data.newpercent <= 0 then
            self.oxygen:StartWarning()
        else
            self.oxygen:StopWarning()
        end

        if not data.overtime then
            if data.newpercent > data.oldpercent then
                self.oxygen:PulseGreen()
                TheFrontEnd:GetSound():PlaySound("citd/HUD/thirst_up")
            elseif data.newpercent < data.oldpercent then
                TheFrontEnd:GetSound():PlaySound("citd/HUD/thirst_down")
                self.oxygen:PulseRed()
            end
        end
    end

    self.owner:ListenForEvent("oxygendelta", function(inst, data) OxygenDelta(data) end, self.owner)
end)
