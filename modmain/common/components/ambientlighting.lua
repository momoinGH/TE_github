local COLOURS = {
    INTERIOR_COLOURS =
    {
        PHASE_COLOURS =
        {
            default =
            {
                day = { colour = Point(171 / 255, 146 / 255, 147 / 255), time = 4 },
                dusk = { colour = Point(101 / 255, 76 / 255, 77 / 255), time = 6 },
                night = { colour = Point(11 / 255, 6 / 255, 7 / 255), time = 8 },
            },
        },

        FULL_MOON_COLOUR = { colour = Point(0, 0, 0), time = 8 },
        CAVE_COLOUR = { colour = Point(0, 0, 0), time = 2 },
    },

    -- 遗迹，啥也看不见
    NIGHT_ROOM = {
        PHASE_COLOURS =
        {
            default =
            {
                day = { colour = Point(0, 0, 0), time = 2 },
                dusk = { colour = Point(0, 0, 0), time = 2 },
                night = { colour = Point(0, 0, 0), time = 2 },
            },
        },

        FULL_MOON_COLOUR = { colour = Point(0, 0, 0), time = 2 },
        CAVE_COLOUR = { colour = Point(0, 0, 0), time = 2 },
    },

    --大灾变
    APORKALYPSE_COLOURS = {
        PHASE_COLOURS =
        {
            default =
            {
                day = { colour = Point(200 / 255, 0, 0), time = 2 },
                dusk = { colour = Point(200 / 255, 0, 0), time = 2 },
                night = { colour = Point(200 / 255, 0, 0), time = 2 },
            },
        },

        FULL_MOON_COLOUR = { colour = Point(200 / 255, 0, 0), time = 2 },
        CAVE_COLOUR = { colour = Point(20 / 255, 0, 0), time = 2 },
    },
}



AddComponentPostInit("ambientlighting", function(self, inst)
    local DoUpdateFlash = Hooks.GetUpValue(self.OnUpdate, "DoUpdateFlash")
    local PushCurrentColour = Hooks.GetUpValue(self.OnUpdate, "PushCurrentColour")
    local _realcolour = Hooks.GetUpValue(DoUpdateFlash, "_realcolour")         ---真正的颜色(控制查理)
    local _overridecolour = Hooks.GetUpValue(DoUpdateFlash, "_overridecolour") ---表现的颜色
    local _ComputeTargetColour = Hooks.GetUpValue(DoUpdateFlash, "ComputeTargetColour")

    local function ComputeTargetColour(targetsettings, timeoverride, ...)
        local temp = targetsettings.currentcolourset
        if not TheWorld.ismastersim and ThePlayer then
            -- 遗迹看不见，这里只是本地的修改，不是晚上还不会被查理攻击
            local room = ThePlayer:TroGetRoomCenter()
            if room and room:HasTag("night_room") then
                targetsettings.currentcolourset = COLOURS.NIGHT_ROOM
                _ComputeTargetColour(targetsettings, timeoverride, ...)
                targetsettings.currentcolourset = temp
                return
            end
        end

        -- 大灾变
        if not TheWorld:HasTag("cave") and TheWorld.state.isaporkalypse and targetsettings.currentcolourset.PHASE_COLOURS.spring then
            targetsettings.currentcolourset = COLOURS.APORKALYPSE_COLOURS
            _ComputeTargetColour(targetsettings, timeoverride, ...)
            targetsettings.currentcolourset = temp
            return
        end
        _ComputeTargetColour(targetsettings, timeoverride, ...)
    end

    Hooks.SetUpvalue(DoUpdateFlash, "ComputeTargetColour", ComputeTargetColour)

    local function TroOnClimateChanged()
        ComputeTargetColour(_realcolour)
        ComputeTargetColour(_overridecolour)
        PushCurrentColour()
    end
    self.TroOnClimateChanged = TroOnClimateChanged                     --暴露一下

    self.inst:WatchWorldState("startaporkalypse", TroOnClimateChanged) ----为什么 用isaporkalypse就不行呢
    self.inst:WatchWorldState("stopaporkalypse", TroOnClimateChanged)
    self.inst:DoTaskInTime(0, TroOnClimateChanged)                     --initialise

    ----------------------------------------------------------------------------------------------------
end)
