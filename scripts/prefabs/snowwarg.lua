local prefabs_basic =
{
    "hound",
    "icehound",
    "firehound",
    "monstermeat",
    "houndstooth",
}

local brain = require("brains/wargbrain")

local sounds =
{
    idle = "dontstarve_DLC001/creatures/vargr/idle",
    howl = "dontstarve_DLC001/creatures/vargr/howl",
    hit = "dontstarve_DLC001/creatures/vargr/hit",
    attack = "dontstarve_DLC001/creatures/vargr/attack",
    death = "dontstarve_DLC001/creatures/vargr/death",
    sleep = "dontstarve_DLC001/creatures/vargr/sleep",
}

SetSharedLootTable('snowwarg',
    {
        { 'monstermeat',      1.00 },
        { 'monstermeat',      1.00 },
        { 'monstermeat',      1.00 },
        { 'monstermeat',      1.00 },
        { 'monstermeat',      0.50 },
        { 'monstermeat',      0.50 },
        { 'snowwarg_spawner', 1.00 },
        { 'houndstooth',      1.00 },
        { 'houndstooth',      0.66 },
        { 'houndstooth',      0.33 },
    })

local RETARGET_MUST_TAGS = { "character" }
local RETARGET_CANT_TAGS = { "wall", "warg", "hound", "houndfriend", "walrus" }
local function RetargetFn(inst)
    return not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue"))
        and FindEntity(
            inst,
            TUNING.WARG_TARGETRANGE,
            function(guy)
                return inst.components.combat:CanTarget(guy)
            end,
            inst.sg:HasStateTag("intro_state") and RETARGET_MUST_TAGS or nil,
            RETARGET_CANT_TAGS
        )
        or nil
end

local function KeepTargetFn(inst, target)
    return target ~= nil
        and not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue"))
        and inst:IsNear(target, 40)
        and inst.components.combat:CanTarget(target)
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, TUNING.WARG_MAXHELPERS,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("hound") or dude:HasTag("warg"))
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, TUNING.WARG_TARGETRANGE)
end

local TARGETS_MUST_TAGS = { "player" }
local TARGETS_CANT_TAGS = { "playerghost" }
local function NumHoundsToSpawn(inst)
    local numHounds = TUNING.WARG_BASE_HOUND_AMOUNT

    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.WARG_NEARBY_PLAYERS_DIST, TARGETS_MUST_TAGS,
        TARGETS_CANT_TAGS)
    for i, player in ipairs(ents) do
        local playerAge = player.components.age:GetAgeInDays()
        local addHounds = math.clamp(Lerp(1, 4, playerAge / 100), 1, 4)
        numHounds = numHounds + addHounds
    end
    local numFollowers = inst.components.leader:CountFollowers()
    local num = math.min(numFollowers + numHounds / 2, numHounds) -- only spawn half the hounds per howl
    num = (math.log(num) / 0.4) + 1                               -- 0.4 is approx log(1.5)

    num = RoundToNearest(num, 1)

    return num - numFollowers
end

local function NoHoundsToSpawn(inst)
    return 0
end

local TOSSITEMS_MUST_TAGS = { "_inventoryitem" }
local TOSSITEMS_CANT_TAGS = { "locomotor", "INLIMBO" }
local function TossItems(inst, x, z, minradius, maxradius)
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, maxradius + 3, TOSSITEMS_MUST_TAGS, TOSSITEMS_CANT_TAGS)) do
        local x1, y1, z1 = v.Transform:GetWorldPosition()
        local dx, dz = x1 - x, z1 - z
        local dsq = dx * dx + dz * dz
        local range = GetRandomMinMax(minradius, maxradius) + v:GetPhysicsRadius(.5)
        if dsq < range * range and y1 < .2 then
            if v.components.mine ~= nil then
                v.components.mine:Deactivate()
            end
            if dsq > 0 then
                range = range / math.sqrt(dsq)
                x1 = x + dx * range
                z1 = z + dz * range
            else
                local angle = TWOPI * math.random()
                x1 = x + math.cos(angle) * range
                z1 = z + math.sin(angle) * range
            end
            if v.Physics ~= nil then
                v.Physics:Teleport(x1, y1, z1)
            else
                v.Transform:SetPosition(x1, y1, z1)
            end
        end
    end
end

local function OnEyeFlamesDirty(inst)
    if TheWorld.ismastersim then
        if not inst._eyeflames:value() then
            inst.AnimState:SetLightOverride(0)
            inst.SoundEmitter:KillSound("eyeflames")
        else
            inst.AnimState:SetLightOverride(.07)
            if not inst.SoundEmitter:PlayingSound("eyeflames") then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "eyeflames")
                inst.SoundEmitter:SetParameter("eyeflames", "intensity", 1)
            end
        end
        if TheNet:IsDedicated() then
            return
        end
    end

    if inst._eyeflames:value() then
        if inst.eyefxl == nil then
            inst.eyefxl = SpawnPrefab("eyeflame")
            inst.eyefxl.entity:SetParent(inst.entity) --prevent 1st frame sleep on clients
            inst.eyefxl.entity:AddFollower()
            inst.eyefxl.Follower:FollowSymbol(inst.GUID, "warg_eye_left", 0, 0, 0)
        end
        if inst.eyefxr == nil then
            inst.eyefxr = SpawnPrefab("eyeflame")
            inst.eyefxr.entity:SetParent(inst.entity) --prevent 1st frame sleep on clients
            inst.eyefxr.entity:AddFollower()
            inst.eyefxr.Follower:FollowSymbol(inst.GUID, "warg_eye_right", 0, 0, 0)
        end
    else
        if inst.eyefxl ~= nil then
            inst.eyefxl:Remove()
            inst.eyefxl = nil
        end
        if inst.eyefxr ~= nil then
            inst.eyefxr:Remove()
            inst.eyefxr = nil
        end
    end
end

local function FindClosestOffset(hound, x, z, offsets)
    if #offsets > 0 then
        local mindsq = math.huge
        local mini = nil
        for i, offset in ipairs(offsets) do
            local dsq = hound:GetDistanceSqToPoint(x + offset.x, 0, z + offset.z)
            if dsq < mindsq then
                mindsq = dsq
                mini = i
            end
        end
        hound:OnUpdateOffset(table.remove(offsets, mini))
    else
        hound:OnUpdateOffset()
    end
end

local function SpawnHounds(inst, radius_override)
    local hounds = nil
    local hounded = TheWorld.components.hounded
    if hounded == nil then
        return hounds
    end

    local num = inst:NumHoundsToSpawn()
    if inst.max_hound_spawns then
        num = math.min(num, inst.max_hound_spawns)
        inst.max_hound_spawns = inst.max_hound_spawns - num
    end

    local forcemutate = inst:HasTag("lunar_aligned") or nil
    local pt = inst:GetPosition()
    for i = 1, num do
        local hound = hounded:SummonSpawn(pt, radius_override)
        if hound ~= nil then
            if hound.components.follower ~= nil then
                hound.components.follower:SetLeader(inst)
            end
            if hounds == nil then
                hounds = {}
            end
            table.insert(hounds, hound)
        end
    end
    return hounds
end

local function GetStatus(inst)
    return (inst.sg:HasStateTag("statue") and "STATUE")
        or nil
end

local function NoGooIcing()
end

local function MakeWarg(name, bank, build, prefabs, tag)
    local assets =
    {
        Asset("SOUND", "sound/vargr.fsb"),
    }
    if bank == "warg" then
        table.insert(assets, Asset("ANIM", "anim/warg_actions.zip"))
    end

    table.insert(assets, Asset("ANIM", "anim/" .. build .. ".zip"))

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        inst.DynamicShadow:SetSize(2.5, 1.5)

        inst.Transform:SetSixFaced()

        MakeCharacterPhysics(inst, 1000, 1)

        inst:AddTag("monster")
        inst:AddTag("warg")
        inst:AddTag("scarytoprey")
        inst:AddTag("houndfriend")
        inst:AddTag("largecreature")
        inst:AddTag("walrus")

        if tag ~= nil then
            inst:AddTag(tag)
        end

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop", true)

        inst.SpawnHounds = SpawnHounds
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = GetStatus

        inst:AddComponent("leader")

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = TUNING.WARG_RUNSPEED
        inst.components.locomotor:SetShouldRun(true)

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(TUNING.WARG_DAMAGE)
        inst.components.combat:SetRange(TUNING.WARG_ATTACKRANGE)
        inst.components.combat:SetAttackPeriod(TUNING.WARG_ATTACKPERIOD)
        inst.components.combat:SetRetargetFunction(1, RetargetFn)
        inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
        inst:ListenForEvent("attacked", OnAttacked)

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.WARG_HEALTH)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetChanceLootTable("snowwarg")

        inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/vargr/hit")

        inst:AddComponent("sleeper")

        inst.NumHoundsToSpawn = NumHoundsToSpawn
        inst.LaunchGooIcing = NoGooIcing

        inst.sounds = sounds

        MakeLargeBurnableCharacter(inst, "swap_fire")

        MakeLargeFreezableCharacter(inst)

        inst:SetStateGraph("SGwarg")

        MakeHauntableGoToState(inst, "howl", TUNING.HAUNT_CHANCE_OCCASIONAL, TUNING.HAUNT_COOLDOWN_MEDIUM,
            TUNING.HAUNT_CHANCE_LARGE)

        inst:SetBrain(brain)
        inst:SetPrefabNameOverride("warg")

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeWarg("snowwarg", "warg", "frost_warg", prefabs_basic, nil)
