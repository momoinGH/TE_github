local assets =
{
    Asset("ANIM", "anim/snow_pile.zip"),
}

local prefabs =
{
    "snowbeetle",
    "cutgrass",
    "flint",
    "twigs",
    "boneshard",
    "rocks",
    "snowitem",
    "collapse_small",
}

local loots =
{
    { 'snowitem',  1.00 },
    { 'rocks',     1.00 },
    { 'cutgrass',  0.05 },
    { 'boneshard', 0.2 },
    { 'flint',     0.05 },
    { 'twigs',     0.05 },
}

local RESETTIME = 480 * 3
local RANDTIME = 480
local CATCOONDEN_REGEN_TIME = 30 * 4
local CATCOONDEN_RELEASE_TIME = 30

local function spawndungball(inst)
    local ball = SpawnPrefab("snowbigball")
    ball.Transform:SetPosition(inst.Transform:GetWorldPosition())
    ball.AnimState:PlayAnimation("idle")
end


local function ondug(inst, worker)
    inst.SoundEmitter:PlaySound("dontstarve/common/food_rot")
    local pt = Point(inst.Transform:GetWorldPosition())


    if worker:HasTag("player") then
        for i = 1, inst.components.pickable.cycles_left do
            local loots = inst.components.lootdropper:GenerateLoot()
            inst.components.lootdropper:DropLoot(pt, loots)
        end
    else
        spawndungball(inst)
    end

    inst.components.pickable:MakeBarren()
end

local function onhit(inst)
    if not inst.playing_dead_anim then
        inst.AnimState:PlayAnimation("hit", false)
    end
end

local function OnEntityWake(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StartSpawning()
    end
end

local function OnEntitySleep(inst)
end

local function makeemptyfn(inst)
    -- adjust art for empty
end

local function PlayStageAnim(inst, anim)
    if inst.components.pickable.cycles_left == 3 then
        inst.AnimState:PushAnimation("idle_full")
    elseif inst.components.pickable.cycles_left == 2 then
        inst.AnimState:PlayAnimation("dig_full", false)
        inst.AnimState:PushAnimation("idle_med")
    elseif inst.components.pickable.cycles_left == 1 then
        inst.AnimState:PlayAnimation("dig_med", false)
        inst.AnimState:PushAnimation("idle_low")
	else
        inst.AnimState:PlayAnimation("dig_low", false)
        --inst.AnimState:PushAnimation("idle_dead")
    end
end

local function onpickedfn(inst, picker)
    PlayStageAnim(inst)

    inst.SoundEmitter:PlaySound("dontstarve/common/food_rot")
    local loots = inst.components.lootdropper:GenerateLoot()
    local pt = Point(inst.Transform:GetWorldPosition())
    inst.components.lootdropper:DropLoot(pt, loots)

    if inst.components.pickable.cycles_left <= 0 then
        inst.components.pickable:MakeBarren()
    end
end

local function makefullfn(inst)
    if inst.components.pickable.cycles_left <= 0 then
        inst.components.workable:SetWorkLeft(1)
        inst:AddTag("snowpile1")
    end
end

local function reset(inst)
    inst.components.workable:SetWorkLeft(1)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.canbepicked = true
    inst:AddTag("snowpile1")
    inst.AnimState:PlayAnimation("dead_to_idle")
    inst.AnimState:PushAnimation("idle")

    inst.task = nil
end

local function destroy(inst)
    local time_to_erode = 1
    local tick_time = TheSim:GetTickTime()

    if inst.DynamicShadow then
        inst.DynamicShadow:Enable(false)
    end

    inst:StartThread(function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.AnimState:SetErosionParams(erode_amount, 0.1, 1.0)
            ticks = ticks + 1
            Yield()
        end

        local tamanhodomapa = (TheWorld.Map:GetSize()) * 2 - 2
        local map = TheWorld.Map
        local x
        local z
        local contagem = 0
        local numerodeitens = 1

        repeat
            x = math.random(-tamanhodomapa, tamanhodomapa)
            z = math.random(-tamanhodomapa, tamanhodomapa)
            local curr = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z))
            local curr1 = map:GetTile(map:GetTileCoordsAtPoint(x - 4, 0, z))
            local curr2 = map:GetTile(map:GetTileCoordsAtPoint(x + 4, 0, z))
            local curr3 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z - 4))
            local curr4 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z + 4))
            contagem = contagem + 1
            -------------------coloca os itens------------------------
            if (curr == GROUND.SNOWLAND and curr1 == GROUND.SNOWLAND and curr2 == GROUND.SNOWLAND and curr3 == GROUND.SNOWLAND and curr4 == GROUND.SNOWLAND) then
                local colocaitem = SpawnPrefab(inst.prefab)
                colocaitem.Transform:SetPosition(x, 0, z)
                numerodeitens = numerodeitens - 1
            end
            -----------------------------------------------------------
        until
            numerodeitens <= 0 or contagem == 500

        inst:Remove()
    end)
end

local function makebarrenfn(inst)
    inst.components.workable.workleft = 0
    inst.AnimState:PlayAnimation("idle_to_dead")
    inst.SoundEmitter:PlaySound("dontstarve/common/food_rot")
    inst:RemoveTag("snowpile1")

    inst.task, inst.taskinfo = inst:ResumeTask(RESETTIME + (math.random() * RANDTIME), function() reset(inst) end)
end

local function getregentimefn(inst)
    return 0
end

local function onsave(inst, data)
    if inst:HasTag("snowpile1") then
        data.hasdung = true
    end
    if inst.taskinfo then
        data.timeleft = inst:TimeRemainingInTask(inst.taskinfo)
    end
end

local function onload(inst, data)
    PlayStageAnim(inst)
    if data then
        if data.hasdung then
            inst:AddTag("hasdung")
        else
            inst:RemoveTag("hasdung")
        end
        if data.timeleft then
            if inst.task then
                inst.task:Cancel()
                inst.task = nil
            end
            inst.taskinfo = nil
            inst.task, inst.taskinfo = inst:ResumeTask(data.timeleft, function() reset(inst) end)
        end
    end
end

local function land(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function fall(inst)
    inst.AnimState:PlayAnimation("fall")
    inst:DoTaskInTime(15 / 30, function() TheCamera:Shake("VERTICAL", 0.3, 0.02, 0.5) end)
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("snow_pile.png")

    inst.AnimState:SetBank("dung_pile")
    inst.AnimState:SetBuild("snow_pile")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("snowpile1")
    inst:AddTag("pick_digin")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    -------------------
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(ondug)
    inst.components.workable:SetOnWorkCallback(onhit)
    ---------------------
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable.getregentimefn = getregentimefn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.max_cycles = 3
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable:SetUp(nil, 0)
    inst.components.pickable.transplanted = true
    -------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "snowbeetle"
    inst.components.childspawner:SetRegenPeriod(CATCOONDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(CATCOONDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    -- inst.components.childspawner.canspawnfn = function(inst)
    -- end

    ---------------------
    inst:AddComponent("lootdropper")
    for i, v in pairs(loots) do
        inst.components.lootdropper:AddRandomLoot(v[1], v[2])
    end
    inst.components.lootdropper.numrandomloot = 1
    inst.components.lootdropper.speed = 2
    inst.components.lootdropper.alwaysinfront = true

    ---------------------
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst, viewer)
        if not inst:HasTag("snowpile1") then
            return "PICKED"
        end
    end

    inst:ListenForEvent("animover", function(inst, data)
        if inst.AnimState:IsCurrentAnimation("idle_to_dead") then
            destroy(inst)
        end
        if inst.AnimState:IsCurrentAnimation("fall") then
            land(inst)
        end
    end)

    MakeSnowCovered(inst)
    MakeHauntableIgnite(inst)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.fall = fall

    return inst
end

return Prefab("snowpile1", fn, assets, prefabs)
