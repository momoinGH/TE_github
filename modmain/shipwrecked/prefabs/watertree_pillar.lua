local OldOnPhaseChanged

local FIREFLY_MUST = { "firefly" }
local FIREFLY_CANT = { "FX", "NOBLOCK", "NOCLICK", "DECOR", "flying", "boat", "walkingplank", "_inventoryitem", "structure" }
local function OnPhaseChanged(inst, phase)
    if phase ~= "day" then
        return
    end

    if math.random() > 0.7 then
        return
    end

    if not TheWorld.Map:IsShipwreckedAreaAtPoint(x, y, z) then
        return OldOnPhaseChanged(inst, phase) --只在海难区域的水中木才行
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if TheSim:CountEntities(x, y, z, TUNING.SHADE_CANOPY_RANGE, FIREFLY_MUST) >= 10 then
        return
    end

    local pos
    local offset = nil
    local count = 0
    while offset == nil and count < 10 do
        local angle = TWOPI * math.random()
        local radius = math.random() * (TUNING.SHADE_CANOPY_RANGE - 4)
        offset = { x = math.cos(angle) * radius, y = 0, z = math.sin(angle) * radius }
        count = count + 1

        pos = { x = x + offset.x, y = 0, z = z + offset.z }

        if TheSim:CountEntities(pos.x, pos.y, pos.z, 5, nil, FIREFLY_CANT) > 0 then
            offset = nil
        end
    end

    if offset then
        local firefly = SpawnPrefab("bioluminescence")
        firefly.Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

-- 水中木生成萤火虫换成荧光生物
AddPrefabPostInit("watertree_pillar", function(inst)
    if not TheWorld.ismastersim then return end

    OldOnPhaseChanged = Hooks.GetEventCallback(inst, "phasechanged", nil, "scripts/prefabs/watertree_pillar.lua")
    if OldOnPhaseChanged then
        inst:RemoveEventCallback("phasechanged", OldOnPhaseChanged)
        inst:ListenForEvent("phasechanged", function(src, phase) OnPhaseChanged(inst, phase) end, TheWorld)
    else
        print("水中木求上值失败，没有拿到OnPhaseChanged，无法把生成萤火虫换成生成荧光生物。")
    end
end)
