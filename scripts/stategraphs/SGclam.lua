require("stategraphs/commonstates")

local events =
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),

    EventHandler("entershield", function(inst) inst.sg:GoToState("closing") end),
    EventHandler("exitshield", function(inst) inst.sg:GoToState("opening") end),
}

local states =
{
    State {
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(math.random() * 4 + 2)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("funnyidle")
        end,
    },

    State {
        name = "funnyidle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_throw", true)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "closing",
        tags = { "busy", "hiding" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("close")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/hide")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("closed") end),
        },
    },

    State {
        name = "closed",
        tags = { "busy", "hiding" },

        onenter = function(inst)
            if inst.components.health.SetAbsorbAmount then -- Why is this necessary Klei, whhhhyyyy?
                inst.components.health:SetAbsorbAmount(TUNING.ROCKY_ABSORB)
            else
                inst.components.health:SetAbsorptionAmount(TUNING.ROCKY_ABSORB)
            end

            inst.AnimState:PlayAnimation("closed")
            inst.sg:SetTimeout(3)
        end,

        onexit = function(inst)
            if inst.components.health.SetAbsorbAmount then
                inst.components.health:SetAbsorbAmount(0)
            else
                inst.components.health:SetAbsorptionAmount(0)
            end
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("closed")
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/sleep") end),
        },
    },

    State {
        name = "opening",
        tags = { "busy", "hiding" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("open")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley")
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley") end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("close") end),
        },
    },

    State {
        name = "hit_closed",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("close") end),
        },
    },

    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            if TheWorld:HasTag("cave") then
                local tamanhodomapa = (TheWorld.Map:GetSize()) * 2 - 2
                local map = TheWorld.Map
                local x
                local z
                local numerodeitens = 1

                repeat
                    x = math.random(-tamanhodomapa, tamanhodomapa)
                    z = math.random(-tamanhodomapa, tamanhodomapa)
                    local curr = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z))
                    local curr1 = map:GetTile(map:GetTileCoordsAtPoint(x - 4, 0, z))
                    local curr2 = map:GetTile(map:GetTileCoordsAtPoint(x + 4, 0, z))
                    local curr3 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z - 4))
                    local curr4 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z + 4))
                    -------------------coloca os itens------------------------
                    if (curr == WORLD_TILES.UNDERWATER_SANDY and curr1 == WORLD_TILES.UNDERWATER_SANDY and curr2 == WORLD_TILES.UNDERWATER_SANDY and curr3 == WORLD_TILES.UNDERWATER_SANDY and curr4 == WORLD_TILES.UNDERWATER_SANDY)
                        or (curr == WORLD_TILES.UNDERWATER_ROCKY and curr1 == WORLD_TILES.UNDERWATER_ROCKY and curr2 == WORLD_TILES.UNDERWATER_ROCKY and curr3 == WORLD_TILES.UNDERWATER_ROCKY and curr4 == WORLD_TILES.UNDERWATER_ROCKY)
                        or (curr == WORLD_TILES.BEACH and curr1 == WORLD_TILES.BEACH and curr2 == WORLD_TILES.BEACH and curr3 == WORLD_TILES.BEACH and curr4 == WORLD_TILES.BEACH)
                        or (curr == WORLD_TILES.MAGMAFIELD and curr1 == WORLD_TILES.MAGMAFIELD and curr2 == WORLD_TILES.MAGMAFIELD and curr3 == WORLD_TILES.MAGMAFIELD and curr4 == WORLD_TILES.MAGMAFIELD)
                        or (curr == WORLD_TILES.PAINTED and curr1 == WORLD_TILES.PAINTED and curr2 == WORLD_TILES.PAINTED and curr3 == WORLD_TILES.PAINTED and curr4 == WORLD_TILES.PAINTED)
                        or (curr == WORLD_TILES.PIGRUINS and curr1 == WORLD_TILES.PIGRUINS and curr2 == WORLD_TILES.PIGRUINS and curr3 == WORLD_TILES.PIGRUINS and curr4 == WORLD_TILES.BATTLEGROUNDS)
                        or (curr == WORLD_TILES.PEBBLEBEACH and curr1 == WORLD_TILES.PEBBLEBEACH and curr2 == WORLD_TILES.PEBBLEBEACH and curr3 == WORLD_TILES.PEBBLEBEACH and curr4 == WORLD_TILES.PEBBLEBEACH)
                    then
                        local colocaitem = SpawnPrefab(inst.prefab)
                        colocaitem.Transform:SetPosition(x, 0, z)
                        numerodeitens = numerodeitens - 1
                    end
                    -----------------------------------------------------------
                until
                    numerodeitens <= 0
            end
        end,

    },
}

local function hitanim(inst)
    if inst:HasTag("hiding") then
        return "hit_closed"
    else
        return "hit"
    end
end

local combatanims =
{
    hit = hitanim,
}

CommonStates.AddCombatStates(states,
    {
        hittimeline = {
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/hurt") end),
            TimeEvent(0 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley") end),
        },

        deathtimeline = {
            TimeEvent(0 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/death")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/explode")
            end),
        },
    },
    combatanims)

--CommonStates.AddSleepStates(states)

return StateGraph("clam", states, events, "idle")
