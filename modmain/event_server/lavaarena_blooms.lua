local GetPrefab = require("tropical_utils/getprefab")

local function Kill(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds", "flower_sound")
    inst.SoundEmitter:SetVolume("flower_sound", .25)
    inst.AnimState:PlayAnimation("out_" .. inst.variation, false)
    inst:ListenForEvent("animover", inst.Remove)
end

local function bloom_postinit(inst)
    inst.AnimState:PushAnimation("idle_" .. inst.variation)

    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds", "flower_sound")
    inst.SoundEmitter:SetVolume("flower_sound", .25)

    inst.Kill = Kill
    inst.persists = false
end

local function SpawnBlooms(inst)
    local pos = inst:GetPosition()
    local list = { pos }
    local radius = 4.1
    for i = 1, 14 do
        local ang, k
        if i < 6 then
            ang = i / 5 * TWOPI;
            k = radius / 2
        else
            ang = (i - 4) / 9 * TWOPI;
            k = radius
        end
        local spawnPos = FindWalkableOffset(pos, ang, k, 2, true, true)
        if spawnPos then
            spawnPos.x = spawnPos.x + pos.x;
            spawnPos.z = spawnPos.z + pos.z;
            table.insert(list, spawnPos)
        end
    end

    for _, p in ipairs(list) do
        inst:DoTaskInTime(math.random(), function()
            local ent = SpawnPrefab("lavaarena_bloom")
            ent.Transform:SetPosition(p:Get())
            table.insert(inst.blooms, ent)
        end)
    end
end

local function KillBlooms(inst)
    for _, v in ipairs(inst.blooms) do
        v:Kill()
    end
    inst:Remove()
end

local MUST_TAGS = { "_health" }
local HEAL_ONEOF_TAGS = { "player", "companion" }
local function HealAndSleep(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, 8, MUST_TAGS)) do
        if v:HasOneOfTags(HEAL_ONEOF_TAGS) then
            if not GetPrefab.IsEntityDeadOrGhost(v) then
                v.components.health:DoDelta(6)
            end
        else
            if v.components.sleeper and not v.components.sleeper:IsAsleep() then
                v.components.sleeper:AddSleepiness(10, 5 / v.components.sleeper:GetSleepTimeMultiplier())
            end
        end
    end
end

local function createhealblooms()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.blooms = {}
    inst:DoTaskInTime(0, SpawnBlooms)
    inst:DoPeriodicTask(1, HealAndSleep)
    inst:DoTaskInTime(10, KillBlooms)
    inst.Kill = KillBlooms

    inst.persists = false

    return inst
end

add_event_server_data("lavaarena", "prefabs/lavaarena_blooms", {
    bloom_postinit = bloom_postinit,
    createhealblooms = createhealblooms,
    -- createsleepdebuff = createsleepdebuff, --感觉用不到，一个周期任务就搞定了
    -- healbuff_postinit = healbuff_postinit
})
