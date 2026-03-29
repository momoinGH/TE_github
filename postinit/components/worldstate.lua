local SetVariable = nil

AddComponentPostInit("worldstate", function(self, inst)
    --------------------------------------------------------------------------
    --[[ Member variables ]]
    --------------------------------------------------------------------------
    -- local inst = self.inst
    assert(inst == TheWorld, "Invalid world")

    -- Private
    local data = self.data

    --------------------------------------------------------------------------
    --[[ Private member functions ]]
    --------------------------------------------------------------------------

    if not SetVariable then
        local OnTemperatureTick = Hooks.GetEventCallback(inst, "temperaturetick", inst, "scripts/components/worldstate.lua")
        SetVariable = OnTemperatureTick and Hooks.GetUpValue(OnTemperatureTick, "SetVariable")
            or function(var, val, togglename) end --这个是hook失败
    end

    --------------------------------------------------------------------------
    --[[ Private event handlers ]]
    --------------------------------------------------------------------------

    local function OnAporkalypseChange(src, phase)
        -- print("aporkalypse world state changed:")
        SetVariable("aporkalypse", phase)
        SetVariable("isaporkalypsecalm", phase == "calm", "aporkalypsecalm")
        SetVariable("isaporkalypsenear", phase == "near", "aporkalypsenear")
        SetVariable("isaporkalypse", phase == "aporkalypse", "aporkalypse")
        SetVariable("isfiesta", phase == "fiesta", "fiesta")
    end

    local function OnWeatherHamChange(src, dat)
        -- print("listen for weatherham world state changed:")
        -- -----这里为什么接听不到事件呢？？
        -- print(dat.pollenduststate)
        SetVariable("ispollendust", dat.pollenduststate == true, "pollendust")
        SetVariable("isfoggy", dat.fogstate == true, "foggy")
        SetVariable("pollendustrate", dat.pollendustrate)
        SetVariable("fograte", dat.fograte)
    end


    --------------------------------------------------------------------------
    --[[ Initialization ]]
    --------------------------------------------------------------------------
    data.isaporkalypsecalm = true
    data.isaporkalypsenear = false
    data.isaporkalypse = false
    data.isfiesta = false

    data.ispollendust = false
    data.pollendustrate = 0
    data.isfoggy = false
    data.fograte = 0

    inst:ListenForEvent("aporkalypsephasechanged", OnAporkalypseChange)
    inst:ListenForEvent("hamweathertick", OnWeatherHamChange)
end)
