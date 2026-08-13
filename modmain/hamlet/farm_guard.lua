local function FindNearbyGuard(inst, threat)
    if not inst:HasTag("city1") and not inst:HasTag("city2") then return end --不是猪镇长的
    if not threat or (threat.replica.inventory ~= nil and threat.replica.inventory:EquipHasTag("sneaky")) then return end

    local range = 20
    if (threat.replica.inventory ~= nil and threat.replica.inventory:EquipHasTag("sneaky")) then
        range = 8
    end

    local playmusic = false
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, pig in ipairs(TheSim:FindEntities(x, y, z, range, { "city_pig" })) do
        if not pig.components.combat.target then
            pig:DoTaskInTime(math.random() * 1, function()
                pig:PushEvent("attacked", { attacker = threat, damage = 0, weapon = nil })
            end)
            playmusic = true
        end
    end

    local tower_range = 30
    if (threat.replica.inventory ~= nil and threat.replica.inventory:EquipHasTag("sneaky")) then
        tower_range = 8
    end

    for _, tower in ipairs(TheSim:FindEntities(x, y, z, tower_range, { "guard_tower" })) do
        tower:callguards(threat)
        playmusic = true
    end

    --玩家播放音乐
    -- if threat.components.dynamicmusic and playmusic then
    --     threat.components.dynamicmusic:OnStartDanger()
    -- end
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
