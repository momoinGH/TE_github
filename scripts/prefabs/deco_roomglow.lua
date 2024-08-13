local function roomlightobjectfn(radius)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(197 / 255 / 2, 197 / 255 / 2, 50 / 255 / 2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(radius)
    inst.Light:Enable(true)

    inst:AddTag("NOBLOCK")

    return inst
end

return Prefab("deco_roomglow", function() return roomlightobjectfn(6) end),
    Prefab("deco_roomglow_large", function() return roomlightobjectfn(9) end)
