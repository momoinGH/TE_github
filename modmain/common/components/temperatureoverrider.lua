-- 修改环境温度判断
local OldGetTemperatureAtXZ = GetTemperatureAtXZ
GLOBAL.GetTemperatureAtXZ = function(x, z, ...)
    if TheWorld.Map:TroIsWorldOut(x, 0, z) then
        return 20 --世界外恒温，这里也包括在虚空房子里
    end
    if TheWorld.Map:TroIsWinterAtPoint(x, 0, z) then
        return -20 --冰岛
    end

    local temperature = OldGetTemperatureAtXZ(x, z, ...)

    -- 哈姆雷特不会过冷过热
    if TheWorld.Map:IsHamletAreaAtPoint(x, 0, z) then
        return math.clamp(temperature, 10, 40)
    end

    -- 海难只会过热不会过冷
    if TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z) then
        return math.max(temperature, 10)
    end

    return temperature
end
