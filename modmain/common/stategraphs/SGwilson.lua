local Utils = require("tropical_utils/utils")

AddStategraphPostInit("wilson", function(sg)
    Utils.FnDecorator(sg.actionhandlers[ACTIONS.JUMPIN], "deststate", function(inst, act)
        return { "jumpin_interior" }, act.target and act.target:HasTag("interior_door")
    end)
end)

local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

-- 进入小房子的门
AddStategraphState("wilson", State {
    name = "jumpin_interior",
    tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },

    onenter = function(inst, data)
        ToggleOffPhysics(inst)
        inst.components.locomotor:Stop()

        local teleporter = inst:GetBufferedAction() and inst:GetBufferedAction().target

        inst.sg.statemem.target = teleporter
        inst.sg.statemem.heavy = inst.components.inventory:IsHeavyLifting()


        if teleporter ~= nil and teleporter.components.teleporter ~= nil then
            teleporter.components.teleporter:RegisterTeleportee(inst)
        end

        inst.AnimState:PlayAnimation("give")

        inst.sg.statemem.teleportarrivestate = "idle" -- this can be overriden in the teleporter component
    end,

    timeline =
    {
        TimeEvent(1 * FRAMES, function(inst)
            if not inst.sg.statemem.heavy then
                inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
            end
        end),
        TimeEvent(5 * FRAMES, function(inst)
            if inst.sg.statemem.heavy then
                inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
            end
        end),

        --Normal
        TimeEvent(13 * FRAMES, function(inst)
            -- this is just hacked in here to make the sound play BEFORE the player hits the wormhole
            if inst.sg.statemem.target ~= nil then
                if inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.target:PushEvent("starttravelsound", inst)
                else
                    inst.sg.statemem.target = nil
                end
            end
        end),
    },

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                local should_teleport = false
                if inst.sg.statemem.target ~= nil and
                    inst.sg.statemem.target:IsValid() and
                    inst.sg.statemem.target.components.teleporter ~= nil then
                    --Unregister first before actually teleporting
                    inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)

                    if inst.sg.statemem.target.components.teleporter:Activate(inst) then
                        should_teleport = true
                    end
                end

                if should_teleport then
                    inst.sg.statemem.isteleporting = true
                    inst.components.health:SetInvincible(true)
                    if inst.components.playercontroller ~= nil then
                        inst.components.playercontroller:Enable(false)
                    end
                    inst:Hide()
                    inst.DynamicShadow:Enable(false)
                    return
                end

                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg.statemem.isphysicstoggle then
            ToggleOnPhysics(inst)
        end
        inst.Physics:Stop()

        if inst.sg.statemem.isteleporting then
            inst.components.health:SetInvincible(false)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst:Show()
            inst.DynamicShadow:Enable(true)
        elseif inst.sg.statemem.target ~= nil
            and inst.sg.statemem.target:IsValid()
            and inst.sg.statemem.target.components.teleporter ~= nil then
            inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
        end
    end,
})

----------------------------------------------------------------------------------------------------
AddStategraphState("wilson", State {
    name = "shear_start",
    tags = { "preshear", "shearing", "working" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("cut_pre")
    end,

    events =
    {
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst) inst.sg:GoToState("shear") end),
    },
})

AddStategraphState("wilson", State {
    name = "shear",
    tags = { "preshear", "shearing", "working" },
    onenter = function(inst)
        inst.AnimState:PlayAnimation("cut_loop")
        inst.AnimState:PushAnimation("cut_pst")
    end,

    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/grass_tall/shears")
            inst:PerformBufferedAction()
        end),


        TimeEvent(9 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("preshear")
        end),

        TimeEvent(16 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("shearing")
        end),
    },

    events =
    {
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
})

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SHEAR, function(inst)
    if not inst.sg:HasStateTag("preshear") then
        if inst.sg:HasStateTag("shearing") then
            return "shear"
        else
            return "shear_start"
        end
    end
end))
----------------------------------------------------------------------------------------------------
