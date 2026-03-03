-- 使用原版大船血条作为小船血条
-- local function UpdateUI(inst)
--     -- 显示小船血量UI
--     local boat = inst:TroGetSWBoat()
--     local boatmeter = inst.HUD.controls.status.boatmeter
--     local is_show = boat and boat.components.healthsyncer

--     if boatmeter.boat then
--         if not is_show then
--             -- 不显示的时候检查是不是在大船上，不在才能关
--             local platform = inst:GetCurrentPlatform()
--             if not (platform and platform.components.healthsyncer) then
--                 boatmeter:Disable()
--             end
--         end
--     else
--         if is_show then
--             boatmeter:Enable(boat)
--         end
--     end
-- end
-- AddClassPostConstruct("widgets/statusdisplays", function(self)
--     if not self.owner then return end
--     self.owner:DoPeriodicTask(0.5, UpdateUI)
-- end)

-- 海难小船血条
local SWBoatBadge = require("widgets/tro_swboatbadge")
AddClassPostConstruct("widgets/containerwidget", function(self)
    self.boatbadge = self:AddChild(SWBoatBadge(self.owner))
    self.boatbadge:SetPosition(0, 45, 0)
    self.boatbadge:Hide()

    local OldOpen = self.Open
    function self:Open(container, doer, ...)
        OldOpen(self, container, doer, ...)
        if container:HasTag("shipwrecked_boat") then
            self.boatbadge:Show()
            self.boatbadge:SetBoat(container)
        end
    end

    local OldClose = self.Close
    function self:Close(...)
        OldClose(self, ...)
        self.boatbadge:SetBoat()
        self.boatbadge:Hide()
    end
end)
