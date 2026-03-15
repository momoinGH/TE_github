table.insert(Assets, Asset("ATLAS", "images/overlays/hayfever.xml")) --对应单机文件fx4.xml
table.insert(Assets, Asset("ANIM", "anim/player_sneeze.zip"))        --花粉打喷嚏，有动画lightsneeze、sneeze

----------------------------------------------------------------------------------------------------

AddReplicableComponent("hayfever")

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("hayfever")
end)

----------------------------------------------------------------------------------------------------

local PollenOver = require "widgets/pollenover"
AddClassPostConstruct("screens/playerhud", function(self)
    Hooks.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner, ...)
        -- 花粉症
        self.pollenover = self.overlayroot:AddChild(PollenOver(owner))
        self.pollenover:Hide()
        return retTab
    end)

    Hooks.FnDecorator(self, "SetMainCharacter", nil, function(retTab, self, maincharacter)
        if not maincharacter then return retTab end

        self.inst:ListenForEvent("pro_updatepollen", function(inst, data) return self.pollenover:UpdateState(data.sneezetime) end, self.owner)

        return retTab
    end)
end)

----------------------------------------------------------------------------------------------------

--花粉打喷嚏
AddStategraphEvent("wilson", EventHandler("sneeze", function(inst, data)
    if not inst.components.health:IsDead() and not inst.components.health.invincible then
        if inst.sg:HasStateTag("busy") and inst.sg.currentstate.name ~= "emote" then
            inst.components.hayfever.wantstosneeze = true
        else
            inst.sg:GoToState("sneeze")
        end
    end
end))


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
