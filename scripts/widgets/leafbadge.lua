local UIAnim = require "widgets/uianim"

--- 哈姆雷特UI顶部树叶动画
local LeafBadge = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_TOP)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
    self:GetAnimState():SetMultColour(1, 1, 1, 1)
    self:GetAnimState():SetBank("leaves_canopy2")
    self:GetAnimState():SetBuild("leaves_canopy2")
    self:GetAnimState():PlayAnimation("idle", true)
    self:Hide()

    self.leavestop_intensity = nil
    self.leavestopmultiplytarget = nil
    self.leavestopmultiplycurrent = nil
    self.leavesfullyin = nil
    self.leavesmoving = nil
    self:StartUpdating()
end)

function LeafBadge:SetLeavesTopColorMult(r, g, b)
    self.leavestopmultiplytarget = { r = r, g = g, b = b }
end

--- 显示树叶的地皮
local IS_CANOPY_TILE =
{
    WORLD_TILES.GASJUNGLE,
    WORLD_TILES.DEEPRAINFOREST,
    WORLD_TILES.PIGRUINS,
}

function LeafBadge:OnUpdate(dt)
    local wasup = false
    if self.leavestop_intensity and self.leavestop_intensity > 0 then
        wasup = true
    end

    if not self.leavestopmultiplytarget then
        self.leavestopmultiplytarget = { r = 1, g = 1, b = 1 }
        self.leavestopmultiplycurrent = { r = 1, g = 1, b = 1 }
    end

    if TheWorld.state.isdusk then
        self:SetLeavesTopColorMult(0.6, 0.6, 0.6)
    elseif TheWorld.state.isnight then
        self:SetLeavesTopColorMult(0.1, 0.1, 0.1)
    else
        self:SetLeavesTopColorMult(1, 1, 1)
    end


    if self.leavestopmultiplycurrent ~= self.leavestopmultiplytarget then
        if self.leavestopmultiplycurrent.r > self.leavestopmultiplytarget.r then
            self.leavestopmultiplycurrent.r = math.max(self.leavestopmultiplytarget.r, self.leavestopmultiplycurrent.r - (1 * dt))
            self.leavestopmultiplycurrent.g = math.max(self.leavestopmultiplytarget.g, self.leavestopmultiplycurrent.g - (1 * dt))
            self.leavestopmultiplycurrent.b = math.max(self.leavestopmultiplytarget.b, self.leavestopmultiplycurrent.b - (1 * dt))
        else
            self.leavestopmultiplycurrent.r = math.min(self.leavestopmultiplytarget.r, self.leavestopmultiplycurrent.r + (1 * dt))
            self.leavestopmultiplycurrent.g = math.min(self.leavestopmultiplytarget.g, self.leavestopmultiplycurrent.g + (1 * dt))
            self.leavestopmultiplycurrent.b = math.min(self.leavestopmultiplytarget.b, self.leavestopmultiplycurrent.b + (1 * dt))
        end
        self:GetAnimState():SetMultColour(self.leavestopmultiplycurrent.r, self.leavestopmultiplycurrent.g, self.leavestopmultiplycurrent.b, 1)
    end

    if not self.leavestop_intensity then
        self.leavestop_intensity = 0
        -- if wasup then
        --     GetPlayer():PushEvent("canopyout") --用来播放音乐的
        -- end
    end

    local under_leaves = false

    local x, y, z = ThePlayer.Transform:GetWorldPosition()
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    for i, tiletype in ipairs(IS_CANOPY_TILE) do
        if tiletype == tile then
            under_leaves = true
            break
        end
    end

    if under_leaves then
        self.leavestop_intensity = math.min(1, self.leavestop_intensity + (1 / 30))
    else
        self.leavestop_intensity = math.max(0, self.leavestop_intensity - (1 / 30))
    end

    if self.leavestop_intensity == 0 then
        self:Hide()
    else
        self:Show()
        if self.leavestop_intensity == 1 then
            if not self.leavesfullyin then
                self:GetAnimState():PlayAnimation("idle", true)
                self.leavesfullyin = true
                -- GetPlayer():PushEvent("canopyin")
            else
                if self.owner:HasTag("moving") then
                    if not self.leavesmoving then
                        self.leavesmoving = true
                        self:GetAnimState():PlayAnimation("run_pre")
                        self:GetAnimState():PushAnimation("run_loop", true)
                    end
                else
                    if self.leavesmoving then
                        self.leavesmoving = nil
                        self:GetAnimState():PlayAnimation("run_pst")
                        self:GetAnimState():PushAnimation("idle", true)
                        self.leaves_olddir = nil
                    end
                end
            end
        else
            self.leavesfullyin = nil
            self.leavesmoving = nil
            self:GetAnimState():SetPercent("zoom_in", self.leavestop_intensity)
        end
    end
end

return LeafBadge
