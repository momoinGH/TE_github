-- 采集猪镇的浆果会被打
local function OnPicked(inst, data)
    local picker = data and data.picker
    if not picker or picker:HasTag("sneaky") then return end
    if not inst:IsInHamletArea() then return end

    local x, y, z = inst.Transform:GetWorldPosition()
    for _, guard in ipairs(TheSim:FindEntities(x, y, z, 40, { "guard", "_combat" })) do
        guard.components.combat:SuggestTarget(picker)
    end
end

for _, v in ipairs({
    "berrybush",
    "berrybush2"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:ListenForEvent("picked", OnPicked)
    end)
end
