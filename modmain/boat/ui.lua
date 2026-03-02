local function UpdateUI(inst)
    -- 显示小船血量UI
    local boat = inst:TroGetSWBoat()
    local boatmeter = inst.HUD.controls.status.boatmeter
    local is_show = boat and boat.components.healthsyncer

    if boatmeter.boat then
        if not is_show then
            -- 不显示的时候检查是不是在大船上，不在才能关
            local platform = inst:GetCurrentPlatform()
            if not (platform and platform.components.healthsyncer) then
                boatmeter:Disable()
            end
        end
    else
        if is_show then
            boatmeter:Enable(boat)
        end
    end
end

AddClassPostConstruct("widgets/statusdisplays", function(self)
    if not self.owner then return end

    self.owner:DoPeriodicTask(0.5, UpdateUI)
end)
