local function FindNearbyGuard(inst, picker)
    if not picker or picker:HasTag("sneaky") then return end
    if not inst:IsInHamletArea() then return end

    local x, y, z = inst.Transform:GetWorldPosition()
    for _, guard in ipairs(TheSim:FindEntities(x, y, z, 40, { "guard", "_combat" })) do
        guard.components.combat:SuggestTarget(picker)
    end
end

-- 采集猪镇的浆果会被打
local function OnPicked(inst, data)
    FindNearbyGuard(inst, data and data.picker)
end

for _, v in ipairs({
    "berrybush",
    "berrybush2",

    "flower",
    "flower_rose",
    "planted_flower"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:ListenForEvent("picked", OnPicked)
    end)
end

----------------------------------------------------------------------------------------------------
local function OnRockWorked(inst, data)
    FindNearbyGuard(inst, data and data.worker)
end
for _, v in ipairs({
    "rock1",
    "rock2",
    "rock_flintless",
    "rock_flintless_med",
    "rock_flintless_low",
    
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("worked", OnRockWorked)
    end)
end
