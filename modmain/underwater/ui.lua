table.insert(Assets, Asset("ANIM", "anim/oxygen_meter_player.zip")) --玩家氧气条

local OxygenBadge = require "widgets/oxygenbadge"
AddClassPostConstruct("widgets/statusdisplays", function(status)
    -- 氧气条
    status.oxygen = status:AddChild(OxygenBadge(status.owner))

    local badge_stomach = status.stomach:GetPosition()
    local badge_brain = status.brain:GetPosition()
    local badge_heart = status.heart:GetPosition()
    status.oxygen:SetPosition(badge_brain.x + badge_stomach.x - badge_heart.x,
        badge_brain.y + badge_stomach.y - badge_heart.y, 0)

    local function GetOxygenReplica()
        return status.owner.replica and status.owner.replica.oxygen or nil
    end

    do
        local oxygen = GetOxygenReplica()
        if oxygen ~= nil then
            status.oxygen:SetPercent(oxygen:GetPercent(), oxygen:Max())
        end
    end

    local function OxygenDelta(data)
        local oxygen = GetOxygenReplica()
        if oxygen == nil then
            return
        end
        status.oxygen:SetPercent(oxygen:GetPercent(), oxygen:Max())

        if data.newpercent <= 0 then
            status.oxygen:StartWarning()
        else
            status.oxygen:StopWarning()
        end

        if not data.overtime then
            if data.newpercent > data.oldpercent then
                status.oxygen:PulseGreen()
                TheFrontEnd:GetSound():PlaySound("citd/HUD/thirst_up")
            elseif data.newpercent < data.oldpercent then
                TheFrontEnd:GetSound():PlaySound("citd/HUD/thirst_down")
                status.oxygen:PulseRed()
            end
        end
    end

    status.inst:ListenForEvent("oxygendelta", function(_, data) OxygenDelta(data) end, status.owner)

    --------------------------------------------------------------------------
    -- 跟随 heart 的幽灵模式显隐（死亡隐藏 / 复活后按水下条件恢复）
    --------------------------------------------------------------------------
    Hooks.FnDecorator(status, "SetGhostMode", nil, function(retTab, self, ghostmode)
        if self.oxygen == nil then
            return
        end

        if ghostmode then
            -- 与 heart:Hide() 对齐
            self.oxygen:Hide()
            self.oxygen:StopWarning()
        else
            -- 不盲目 Show：保留水下才显示的机制
            self.oxygen:RefreshVisibility()
        end
        return retTab
    end)

    -- 数值常显/隐藏时与 heart.num 同步
    Hooks.FnDecorator(status, "ShowStatusNumbers", nil, function(retTab, self)
        if self.oxygen ~= nil and self.oxygen.num ~= nil then
            self.oxygen.num:Show()
        end
        return retTab
    end)

    Hooks.FnDecorator(status, "HideStatusNumbers", nil, function(retTab, self)
        if self.oxygen ~= nil and self.oxygen.num ~= nil then
            self.oxygen.num:Hide()
        end
        return retTab
    end)

    -- 构造时若已是幽灵，立即隐藏
    if status.isghostmode or (status.owner ~= nil and status.owner:HasTag("playerghost")) then
        status.oxygen:Hide()
    else
        status.oxygen:RefreshVisibility()
    end
end)
