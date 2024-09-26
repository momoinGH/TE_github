local Utils = require("tropical_utils/utils")

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

----------------------------------------------------------------------------------------------------
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATCANNON, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATDISMOUNT, function(inst, act)
    local x, y, z = act:GetActionPoint():Get()
    act.doer.components.locomotor:StartHopping(x, z)
end))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SHEAR, function(inst)
    if not inst.sg:HasStateTag("preshear") then
        if inst.sg:HasStateTag("shearing") then
            return "shear"
        else
            return "shear_start"
        end
    end
end))




AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATMOUNT, function(inst, act)
    local x, y, z = act.target.Transform:GetWorldPosition()
    inst.components.embarker:SetDisembarkPos(x, z)

    if (inst.components.health == nil or not inst.components.health:IsDead()) and (inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("idle")) then
        if not inst.sg:HasStateTag("jumping") then
            return "hop_pre"
        end
    elseif inst.components.embarker then
        inst.components.embarker:Cancel()
    end
end))

----------------------------------------------------------------------------------------------------


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
            local target = inst.sg.statemem.target
            if not inst.sg.statemem.heavy and target and target:IsValid() and target.usesound then
                inst.SoundEmitter:PlaySound(target.usesound) --使用门的声音
            end
        end),
        TimeEvent(5 * FRAMES, function(inst)
            local target = inst.sg.statemem.target
            if inst.sg.statemem.heavy and target and target:IsValid() and target.usesound then
                inst.SoundEmitter:PlaySound(target.usesound)
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






----------------------------------------------------------------------------------------------------

-- 号角
for _, data in ipairs({
    -- {id，symbol}
    { name = "play_horn2", "swap_wind_conch" },
    { name = "play_horn3", "swap_antler" }
}) do
    AddStategraphState("wilson", State {
        name = "play_horn" .. data[1],
        tags = { "doing", "busy", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", data[2], "horn01")
            inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil)
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                else
                    inst.sg.statemem.action_failed = true
                end
            end),
            TimeEvent(29 * FRAMES, function(inst)
                if inst.sg.statemem.action_failed then
                    inst.AnimState:SetFrame(50)
                end
            end),
            TimeEvent(34 * FRAMES, function(inst)
                if inst.sg.statemem.action_failed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(43 * FRAMES, function(inst)
                if not inst.sg.statemem.action_failed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("horn01")
        end,
    })
end

--长笛
AddStategraphState("wilson", State {
    name = "play_flutesw",
    tags = { "doing", "busy", "playing" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("flute", false)

        local inv_obj = inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil
        inst.AnimState:OverrideSymbol("pan_flute01", "ox_flute", "ox_flute01")
        inst.components.inventory:ReturnActiveActionItem(inv_obj)
    end,

    timeline =
    {
        TimeEvent(30 * FRAMES, function(inst)
            if inst:PerformBufferedAction() then
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/ox_flute", "flute")
            else
                inst.sg.statemem.action_failed = true
                inst.AnimState:SetFrame(94)
            end
        end),
        TimeEvent(36 * FRAMES, function(inst)
            if inst.sg.statemem.action_failed then
                inst.sg:RemoveStateTag("busy")
            end
        end),
        TimeEvent(52 * FRAMES, function(inst)
            if not inst.sg.statemem.action_failed then
                inst.sg:RemoveStateTag("busy")
            end
        end),
        TimeEvent(85 * FRAMES, function(inst)
            if not inst.sg.statemem.action_failed then
                inst.SoundEmitter:KillSound("flute")
            end
        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.SoundEmitter:KillSound("flute")
        inst.AnimState:ClearOverrideSymbol("pan_flute01")
    end,
})

-- 喷
AddStategraphState("wilson", State {
    name = "crop_dust",
    tags = { "busy", "canrotate" },

    onenter = function(inst)
        if inst.components.rider:IsRiding() then
            inst.Transform:SetFourFaced()
        end

        local pos = inst:GetBufferedAction() and inst:GetBufferedAction():GetActionPoint()
        if pos then
            inst:FacePoint(pos:Get())
        end

        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("cropdust_pre")
        inst.AnimState:PushAnimation("cropdust_loop")
        inst.AnimState:PushAnimation("cropdust_pst", false)
    end,

    timeline =
    {
        TimeEvent(20 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("busy")
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/bugrepellant")
        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },

    onexit = function(inst)
        if inst.components.rider:IsRiding() then
            inst.Transform:SetSixFaced()
        end
    end,
})

----------------------------------------------------------------------------------------------------
-- 淘金
AddStategraphState("wilson", State {
    name = "pan",
    tags = { "prepan", "panning", "working" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("pan_pre")
        inst.AnimState:PushAnimation("pan_loop", true)
        inst.sg:SetTimeout(1 + math.random())
    end,

    timeline =
    {
        TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent(14 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 15) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 15) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 30) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 30) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 45) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 45) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 60) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 60) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
    },

    ontimeout = function(inst)
        inst:PerformBufferedAction()
        inst.sg:GoToState("idle", "pan_pst")
    end,

    events =
    {
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle", "pan_pst") end),
    },
})

----------------------------------------------------------------------------------------------------

AddStategraphState("wilson", State {
    name = "investigate",
    tags = { "preinvestigate", "investigating", "working" },
    onenter = function(inst)
        inst.AnimState:PlayAnimation("lens")
        inst.AnimState:PushAnimation("lens_pst", false)
    end,

    timeline =
    {
        TimeEvent(9 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("preinvestigate")
        end),


        TimeEvent(16 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("investigating")
        end),

        TimeEvent(45 * FRAMES, function(inst)
            -- this covers both mystery and lighting now
            inst:PerformBufferedAction()
        end),
    },

    events =
    {
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
    },
})

----------------------------------------------------------------------------------------------------

-- 硬控玩家几秒
AddStategraphState("wilson", State {
    name = "sanity_stun",
    tags = { "busy" },

    onenter = function(inst, duration)
        inst.components.playercontroller:Enable(false)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("idle_sanity_pre", false)
        inst.AnimState:PushAnimation("idle_sanity_loop", true)

        inst.sg:SetTimeout(duration or 4)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,

    onexit = function(inst)
        inst.components.playercontroller:Enable(true)
    end
})

----------------------------------------------------------------------------------------------------

AddStategraphState("wilson", State {
    name = "tap",
    tags = { "doing", "busy" },

    onenter = function(inst, timeout)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("tamp_pre")
        inst.AnimState:PushAnimation("tamp_loop", true)
        inst.sg:SetTimeout(timeout or 1)
    end,

    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end),
        TimeEvent(5 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(12 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(20 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(28 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(36 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
    },

    ontimeout = function(inst)
        inst:PerformBufferedAction()
        inst.sg:GoToState("tap_pst")
    end,
})
AddStategraphState("wilson", State {
    name = "tap_pst",
    tags = { "idle" },

    onenter = function(inst)
        inst.AnimState:PlayAnimation("tamp_pst")
    end,
    events =
    {
        EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
    },
})

----------------------------------------------------------------------------------------------------

AddStategraphState("wilson", State {
    name = "speargun",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        if inst.components.rider:IsRiding() then
            inst.Transform:SetFourFaced()
        end
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("speargun")
        if inst.sg.prevstate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
            inst.AnimState:SetTime(5 * FRAMES)
        end

        inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES,
            inst.components.combat.min_attack_period + .5 * FRAMES))

        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end

        if (equip ~= nil and equip.projectiledelay or 0) > 0 then
            --V2C: Projectiles don't show in the initial delayed FRAMES so that
            --     when they do appear, they're already in front of the player.
            --     Start the attack early to keep animation in sync.
            inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES -
                equip.projectiledelay
            if inst.sg.statemem.projectiledelay <= 0 then
                inst.sg.statemem.projectiledelay = nil
            end
        end
    end,

    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= 0 then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end
    end,

    timeline =
    {
        TimeEvent(8 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),

        TimeEvent(15 * FRAMES, function(inst)
            if not inst.sg.statemem.chained then
                if inst.components.combat:GetWeapon() and inst.components.combat:GetWeapon():HasTag("blunderbuss") then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_shoot")
                    if inst.components.rider:IsRiding() then
                        local cloud = SpawnPrefab("cloudpuff")
                        local pt = inst:GetPosition()
                        cloud.Transform:SetPosition(pt.x, 4.5, pt.z)
                    else
                        local cloud = SpawnPrefab("cloudpuff")
                        local pt = inst:GetPosition()
                        cloud.Transform:SetPosition(pt.x, 2, pt.z)
                    end
                else
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                end
            end
        end),

        TimeEvent(16 * FRAMES, function(inst)
            if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
        if inst.components.rider:IsRiding() then
            inst.Transform:SetSixFaced()
        end
    end,
})




----------------------------------------------------------------------------------------------------

-- 花粉症打喷嚏
AddStategraphState("wilson", State {
    name = "sneeze",
    tags = { "busy", "sneeze", "pausepredict" },

    onenter = function(inst)
        local usehit = inst.components.rider:IsRiding() or inst:HasTag("wereplayer")
        local stun_frames = usehit and 6 or 9
        inst.components.hayfever.wantstosneeze = false
        inst:ClearBufferedAction()
        inst.components.locomotor:Stop()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/hit", nil, .02)


        if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("sneeze")
        end

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
        end


        if inst.prefab ~= "wes" then
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/sneeze")
            inst.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SNEEZE)
        end
    end,

    events =
    {
        EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
    },

    timeline =
    {
        TimeEvent(1 * FRAMES, function(inst)
            local itemstodrop = 0
            if math.random() < 0.6 then itemstodrop = itemstodrop + 1 end
            if math.random() < 0.3 then itemstodrop = itemstodrop + 1 end
            if math.random() < 0.2 then itemstodrop = itemstodrop + 1 end
            if math.random() < 0.1 then itemstodrop = itemstodrop + 1 end

            if itemstodrop > 0 then
                for i = 1, itemstodrop do
                    if inst.components.inventory and inst.components.inventory.isopen then
                        local item = inst.components.inventory:FindItem(function(item)
                            return not item:HasTag(
                                "nosteal")
                        end)
                        if item then
                            local direction = inst:GetPosition() -
                                inst:GetPosition()
                            inst.components.inventory:DropItem(item, false, direction:GetNormalized())
                        end
                    end
                end
            end
        end),
        TimeEvent(10 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
            if inst.components.sanity then inst.components.sanity:DoDelta(-3) end
        end),
    },

})

----------------------------------------------------------------------------------------------------
-- 望远镜
AddStategraphState("wilson", State {
    name = "peertelescope",
    tags = { "doing", "busy", "nopredict", "canrotate" },

    onenter = function(inst, data)
        inst.components.locomotor:Stop()
        local pos = inst:GetBufferedAction() and inst:GetBufferedAction():GetActionPoint()
        if pos then
            inst:ForceFacePoint(pos:Get())
        end

        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation("telescope", false)
        inst.AnimState:PushAnimation("telescope_pst", false)
    end,

    timeline =
    {
        TimeEvent(20 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_spyglass")
        end),
    },

    events = {
        EventHandler("animover", function(inst)
            inst:PerformBufferedAction()
        end),
        EventHandler("animqueueover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },

    onexit = function(inst)
        inst.components.playercontroller:Enable(true)
    end,
})


----------------------------------------------------------------------------------------------------

-- 源代码拷贝
local function ConfigureRunState(inst)
    if inst.components.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")
        inst.sg:AddStateTag("nodangle")
        inst.sg:AddStateTag("noslip")

        local mount = inst.components.rider:GetMount()
        inst.sg.statemem.ridingwoby = mount and mount:HasTag("woby")
    elseif inst.components.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
        inst.sg.statemem.heavy_fast = inst.components.mightiness ~= nil and inst.components.mightiness:IsMighty()
        inst.sg:AddStateTag("noslip")
    elseif inst:IsChannelCasting() then
        inst.sg.statemem.channelcast = true
        inst.sg.statemem.channelcastitem = inst:IsChannelCastingItem()
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        inst.sg:AddStateTag("noslip")

        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        else
            inst.sg.statemem.normal = true
        end
    elseif inst:IsInAnyStormOrCloud() and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
        inst.sg:AddStateTag("noslip")
    else
        inst.sg.statemem.normal = true
        inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") or nil
    end
end

local function Chronological(a, b)
    return a.time < b.time
end

-- 划船
AddStategraphPostInit("wilson", function(sg)
    Utils.FnDecorator(sg.actionhandlers[ACTIONS.CASTSPELL], "deststate", function(inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item and item:HasTag("telescope") then
            return { "peertelescope" }, true
        end
    end)

    ------------------------------------------------------------------------------------------------

    Utils.FnDecorator(sg.states["run_start"], "onenter", nil, function(retTab, inst)
        local boat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
        if boat then
            local item = boat.components.container and boat.components.container:GetItemInSlot(1)
            local anim = inst.components.inventory:IsHeavyLifting() and "heavy_idle"
                or boat:HasTag("surf") and "surf_pre"
                or item and item:HasTag("sail") and "sail_pre"
                or "row_pre"

            inst.AnimState:PlayAnimation(anim)
        end
    end)

    Utils.FnDecorator(sg.states["run"], "onenter", function(inst)
        local boat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
        if not boat then
            return
        end

        ConfigureRunState(inst)
        inst.components.locomotor:RunForward()

        local item = boat.components.container and boat.components.container:GetItemInSlot(1)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local move_sound = item and item.components.shipwreckedboatparts.move_sound
        if move_sound then
            inst.SoundEmitter:PlaySound(move_sound, "sailmove")
        end
        local anim = inst.components.inventory:IsHeavyLifting() and "heavy_idle"
            or boat:HasTag("surf") and "surf_loop"
            or item and item:HasTag("sail") and "sail_loop"
            or equip and equip:HasTag("oar") and "row_medium"
            or "row_loop"
        if anim == "row_loop" then
            inst.AnimState:AddOverrideBuild("player_actions_paddle")
        end
        inst.sg.statemem.row_boat = anim == "row_loop" or anim == "row_medium"
        if not inst.AnimState:IsCurrentAnimation(anim) then
            inst.AnimState:PlayAnimation(anim, true)
        end

        inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

        return nil, true
    end)

    table.insert(sg.states["run"].timeline, TimeEvent(5 * FRAMES, function(inst)
        if inst.sg.statemem.row_boat then
            inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
        end
    end))
    table.sort(sg.states["run"].timeline, Chronological)

    Utils.FnDecorator(sg.states["run"], "onexit", function(inst)
        inst.SoundEmitter:KillSound("sailmove")
        inst.AnimState:ClearOverrideBuild("player_actions_paddle")
    end)

    Utils.FnDecorator(sg.states["run_stop"], "onenter", nil, function(retTab, inst)
        local boat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
        if boat then
            local item = boat.components.container and boat.components.container:GetItemInSlot(1)
            local anim = inst.components.inventory:IsHeavyLifting() and "heavy_idle"
                or boat:HasTag("surf") and "surf_pst"
                or item and item:HasTag("sail") and "sail_pst"
                or "row_pst"
            inst.AnimState:PlayAnimation(anim)
        end
    end)

    ------------------------------------------------------------------------------------------------

    Utils.FnDecorator(sg.states["bedroll"], "onenter", nil, function(retTab, inst)
        local bed = inst:GetBufferedAction() and inst:GetBufferedAction().target
        if bed and bed:HasTag("bed") then
            inst.AnimState:PlayAnimation("bedroll", false)
            inst.AnimState:SetFrame(60) --直接躺下！
        end
    end)

    ------------------------------------------------------------------------------------------------

    Utils.FnDecorator(sg.actionhandlers[ACTIONS.JUMPIN], "deststate", function(inst, act)
        return { "jumpin_interior" }, act.target and (act.target:HasTag("interior_door") or act.target.prefab == "lavaarena_portal")
    end)

    ----------------------------------------------------------------------------------------------------
    --跳船
    Utils.FnDecorator(sg.states["hop_pre"], "onenter", nil, function(retTab, inst)
        local act = inst:GetBufferedAction()
        if act and act.action == ACTIONS.BOATMOUNT then
            inst:PerformBufferedAction() --直接执行
        end
    end)
end)
