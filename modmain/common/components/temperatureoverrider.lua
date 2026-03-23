Hooks.FnDecorator(GLOBAL, "GetTemperatureAtXZ", function(x, z)
    if TheWorld.Map:TroIsWorldOut(x, 0, z) then
        return { 20 }, true --世界外恒温
    end

    if TheWorld.Map:TroIsWinterAtPoint(x, 0, z) then
        return { -20 }, true --冰岛
    end
end)
