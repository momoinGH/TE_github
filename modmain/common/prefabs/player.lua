----------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    inst._isopening = net_bool(inst.GUID, "IsOpening")

    if inst.components.drownable == nil then
        inst:AddComponent("drownable")
    end

    if TheNet:GetIsServer() then
        inst.findpigruinstask = inst:DoPeriodicTask(2, function()
            local x, y, z = inst.Transform:GetWorldPosition()
            if inst.LightWatcher ~= nil and #TheSim:FindEntities(x, y, z, 40, { "pisodaruina" }) > 0 then
                local thresh = TheSim:GetLightAtPoint(10000, 10000, 10000)
                inst.LightWatcher:SetLightThresh(0.075 + thresh)
                inst.LightWatcher:SetDarkThresh(0.05 + thresh)
            else
                inst.LightWatcher:SetLightThresh(0.075)
                inst.LightWatcher:SetDarkThresh(0.05)
            end
        end)
    end
end)
