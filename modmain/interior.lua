local Utils = require("tropical_utils/utils")

Utils.FnDecorator(GLOBAL, "GetTemperatureAtXZ", nil, function(retTab, x, z)
    local val = next(retTab)
    if val > TUNING.WILDFIRE_THRESHOLD then
        -- 防止室内野火
        if TheWorld.Map:OutsideWorldAtPoint(x, z) then
            return { TUNING.WILDFIRE_THRESHOLD }
        end

        local player = FindClosestPlayerInRangeSq(x, 0, z, 400)
        if player and player.components.areaaware and player.components.areaaware:CurrentlyInTag("frost") then
            return { TUNING.WILDFIRE_THRESHOLD }
        end
    end

    return retTab
end)

----------------------------------------------------------------------------------------------------
--室内避雨？
local function ShelteredOnUpdateBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if not self.mounted
        and TheWorld.Map:OutsideWorldAtPoint(x, z)
    then
        self:SetSheltered(true)
        return nil, true
    end
end

AddComponentPostInit("sheltered", function(self)
    Utils.FnDecorator(self, "OnUpdate", ShelteredOnUpdateBefore)
end)

----------------------------------------------------------------------------------------------------
--室内屏蔽花粉、雪、雨粒子？
AddSimPostInit(function()
    EmitterManager.old_updatefuncs = { snow = nil, rain = nil, pollen = nil }
    Utils.FnDecorator(EmitterManager, "PostUpdate", function(self, ...)
        for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
            if inst.prefab == "pollen" or inst.prefab == "snow" or inst.prefab == "rain" then
                if self.old_updatefuncs[inst.prefab] == nil then
                    self.old_updatefuncs[inst.prefab] = data.updateFunc
                end
                local x, y, z = inst.Transform:GetWorldPosition()
                if TheWorld.Map:OutsideWorldAtPoint(x, z) then
                    data.updateFunc = function() end -- empty function
                else
                    data.updateFunc = self.old_updatefuncs[inst.prefab] ~= nil and self.old_updatefuncs[inst.prefab] or
                        function() end -- the original one
                end
            end
        end
    end)
end)
