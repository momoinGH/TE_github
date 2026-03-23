-- 可以考古把宝石取下来
local function OnDislodged(inst)
    local nogem = SpawnPrefab(inst.prefab .. "_nogem")
    if nogem then
        nogem.Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst.persists = false
        inst:DoTaskInTime(0, inst.Remove)
    end
end

local function CanBeDislodgedFn(inst)
    return inst.components.workable and inst.components.workable.workleft >= TUNING.MARBLEPILLAR_MINE * (1 / 3)
end

for _, v in ipairs({
    "ruins_statue_head",
    "ruins_statue_mage"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:AddComponent("dislodgeable")
        inst.components.dislodgeable:SetUp(inst.gemmed, 1)
        inst.components.dislodgeable:SetDropFromSymbol("swap_gem")
        inst.components.dislodgeable:SetOnDislodgedFn(OnDislodged)
        inst.components.dislodgeable:SetCanBeDislodgedFn(CanBeDislodgedFn)
    end)
end
