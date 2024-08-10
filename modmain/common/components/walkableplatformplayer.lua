local Utils = require("tropical_utils/utils")

-- 海难小船

local function SetPlayerCenter(inst, platform)
    if platform:IsValid() then
        inst.Physics:Stop()
        inst.components.locomotor:Stop()
        inst.Transform:SetPosition(platform.Transform:GetWorldPosition())
    end
end

-- 跳上船
local function GetOnPlatformBefore(self, platform)
    if not platform:HasTag("shipwrecked_boat") then return end

    if TheWorld.ismastersim then
        self.inst:DoTaskInTime(0.5, SetPlayerCenter, platform)
        -- platform.Follower:FollowSymbol(self.inst.GUID, "foot") --船动人就会动，会导致一直移动
        if platform.components.container then
            platform.components.container.canbeopened = true
            platform:DoTaskInTime(0, function()
                if self.inst:IsValid() and not platform.components.container:IsOpen() then
                    platform.components.container:Open(self.inst)
                end
            end)
        end
        platform.components.shipwreckedboat:OnPlayerMounted(self.inst)
    else
        -- TODO 如果开启了延迟补偿，强制关闭。因为延迟补偿会让船的运动变得很奇怪，或者客机发送rpc让船移动？
        if Profile:GetMovementPredictionEnabled() then
            Profile:SetMovementPredictionEnabled(false)
            self.inst:EnableMovementPrediction(false)
        end
    end
end

local function GetOffPlatformBefore(self)
    if TheWorld.ismastersim then
        if self.platform and self.platform:IsValid() and self.platform:HasTag("shipwrecked_boat") then
            if self.platform.components.container then
                self.platform.components.container.canbeopened = false
            end
            self.platform.components.shipwreckedboat:OnPlayerDismounted(self.inst)
        end
    end
end

AddClassPostConstruct("components/walkableplatformplayer", function(self)
    Utils.FnDecorator(self, "GetOnPlatform", GetOnPlatformBefore)
    Utils.FnDecorator(self, "GetOffPlatform", GetOffPlatformBefore)
end)
