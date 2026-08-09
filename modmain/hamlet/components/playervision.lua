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

    --更新一下室内亮度
    if not TheWorld.ismastersim and TheWorld.components.ambientlighting.TroOnClimateChanged then
        TheWorld.components.ambientlighting:TroOnClimateChanged()
    end
end

-- 哈姆雷特室内视觉效果
AddComponentPostInit("playervision", function(self)
    self.inst:ListenForEvent("tro_curroomcenter", OnRoomChange)

    Hooks.FnDecorator(self, "UpdateCCTable", function(self)
        -- Night vision (including WX-78's forced night vision) must keep the
        -- priority used by the vanilla PlayerVision component.  The Hamlet
        -- room override is only a fallback for players without night vision;
        -- otherwise it replaces NIGHTVISION_COLOURCUBES and makes caves/
        -- ruins appear dark again.
        if self:HasNightVision() then
            return
        end

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
