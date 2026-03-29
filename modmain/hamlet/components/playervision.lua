local interior = resolvefilepath("images/colour_cubes/pigshop_interior_cc.tex")

local OVERRIDE_SEASON_COLOURCUBES = {
    interior = {
        day = interior,
        dusk = interior,
        night = interior,
        full_moon = interior

    },
}

local VISION_PHASEFN = {
    interior = {
        blendtime = 0.5,
        events = {},
        fn = nil,
    },
}

local function OnRoomChange(inst, data)
    local self = inst.components.playervision
    self:UpdateCCTable()
end

-- 哈姆雷特室内视觉效果
AddComponentPostInit("playervision", function(self)
    self.inst:ListenForEvent("tro_curroomcenter", OnRoomChange)

    Hooks.FnDecorator(self, "UpdateCCTable", function(self)
        if not self.inst:TroGetPlayerClassifiedNetVar("tro_curroomcenter") then
            return
        end

        local ccphasefn = VISION_PHASEFN.interior
        local cctable = OVERRIDE_SEASON_COLOURCUBES.interior
        if self.currentcctable ~= cctable then
            self.currentcctable = cctable
            self.currentccphasefn = ccphasefn
            self.inst:PushEvent("ccoverrides", cctable)
            self.inst:PushEvent("ccphasefn", ccphasefn)
        end
        return nil, true
    end)
end)
