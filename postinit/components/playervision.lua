local interior = resolvefilepath("images/colour_cubes/pigshop_interior_cc.tex")
local batvision = resolvefilepath("images/colour_cubes/bat_vision_on_cc.tex")

local OVERRIDE_SEASON_COLOURCUBES = {

    interior = {
        day = interior,
        dusk = interior,
        night = interior,
        full_moon = interior

    },

    batvision = {
        day = batvision,
        dusk = batvision,
        night = batvision,
        full_moon = batvision

    }

}

local VISION_PHASEFN = {
    interior = {
        blendtime = 0.5,
        events = {},
        fn = nil,
    },

}

AddComponentPostInit("playervision", function(self)
    -- local NIGHTVISION_COLOURCUBES = Hooks.FindUpvalue(self.UpdateCCTable, "NIGHTVISION_COLOURCUBES")
    -- local GHOSTVISION_COLOURCUBES = Hooks.FindUpvalue(self.UpdateCCTable, "GHOSTVISION_COLOURCUBES")
    -- local NIGHTVISION_PHASEFN = Hooks.FindUpvalue(self.UpdateCCTable, "NIGHTVISION_PHASEFN")

    -- self.inst:ListenForEvent("enterinterior_client", function() self:UpdateCCTable() end)
    -- self.inst:ListenForEvent("leaveinterior_client", function() self:UpdateCCTable() end)
    -- self.inst:WatchWorldState("isaporkalypse", function() self:UpdateCCTable() end)
    self.inst:ListenForEvent("changearea", function() self:UpdateCCTable() end)

    local _UpdateCCTable = self.UpdateCCTable
    function self:UpdateCCTable()
        _UpdateCCTable(self)

        -- if TheWorld.state.isaporkalypse --[[and not TheWorld:HasTag("cave")]] then
        --     local cc = OVERRIDE_SEASON_COLOURCUBES.aporkalypse
        --     self.currentcctable = cc
        --     self.inst:PushEvent("ccoverrides", cc)
        --     self.inst:PushEvent("ccphasefn", VISION_PHASEFN.aporkalypse)
        --     return
        -- end

        if self.inst:TroGetRoomCenter() then
            local cc = OVERRIDE_SEASON_COLOURCUBES.interior
            self.currentcctable = cc
            self.inst:PushEvent("ccoverrides", cc)
            self.inst:PushEvent("ccphasefn", VISION_PHASEFN.interior)
        end
    end
end)
