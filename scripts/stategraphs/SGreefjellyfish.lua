require("stategraphs/commonstates")

local events =
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),
}

local states =
{
    State {
        name = "idle",
        tags = { "idle", "canrotate", "canslide" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)
            inst:DoTaskInTime(math.random(0, 1), function(inst)
                local x, y, z = inst.Transform:GetWorldPosition()
                local bubble = SpawnPrefab("bubble_fx_small")
                bubble.Transform:SetPosition(x, y + 2, z)
            end)
        end,
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
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.shockaura:Enable(false)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            if TheWorld:HasTag("cave") then
                local tamanhodomapa = (TheWorld.Map:GetSize()) * 2 - 2
                local x
                local z
                local numerodeitens = 1

                repeat
                    x = math.random(-tamanhodomapa, tamanhodomapa)
                    z = math.random(-tamanhodomapa, tamanhodomapa)
                    -------------------coloca os itens------------------------
                    if TheWorld.Map:IsUnderWaterAreaAtPoint(x, 0, z) then
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

CommonStates.AddSleepStates(states)
CommonStates.AddWalkStates(states)
CommonStates.AddRunStates(states)

return StateGraph("reefjellyfish", states, events, "idle")
