table.insert(Assets, Asset("ATLAS", "images/overlays/hayfever.xml"))   --对应单机文件fx4.xml
table.insert(Assets, Asset("ANIM", "anim/player_sneeze.zip"))          --花粉打喷嚏，有动画lightsneeze、sneeze
table.insert(Assets, Asset("ANIM", "anim/player_mount_sneeze.zip"))    --骑牛打喷嚏动画


----------------------------------------------------------------------------------------------------

TroAddPlayerClassifiedNetVar(net_float, "tro_sneezetime")


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

        self.inst:ListenForEvent("tro_sneezetime", function(inst)
            local sneezetime = self.owner and self.owner:TroGetPlayerClassifiedNetVar("tro_sneezetime")
            if sneezetime then
                self.pollenover:UpdateState(sneezetime)
            end
        end, self.owner)

        return retTab
    end)
end)

----------------------------------------------------------------------------------------------------

--花粉打喷嚏
AddStategraphEvent("wilson", EventHandler("sneeze", function(inst, data)
    if not inst.components.health:IsDead() and not inst.components.health.invincible and not inst.sg:HasStateTag("busy") then
        inst.sg:GoToState("sneeze")
    end
end))


AddStategraphState("wilson", State {
    name = "sneeze",
    tags = { "busy", "sneeze", "pausepredict" },

    onenter = function(inst)
        if inst:TroGetMount() then
            inst.Transform:SetFourFaced()
        end
        if inst.components.hayfever then
            inst.components.hayfever.wantstosneeze = false
        end

        inst.AnimState:PlayAnimation("sneeze")
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/characters/sneeze")
        inst:ClearBufferedAction()
        inst.components.locomotor:Stop()

        if inst.components.playercontroller ~= nil then
            local usehit = inst.components.rider:IsRiding() or inst:HasTag("wereplayer")
            local stun_frames = usehit and 6 or 9
            inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
        end

        if inst.prefab ~= "wes" then
            inst.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_SNEEZE"))
        end
    end,

    events =
    {
        EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
    },

    timeline =
    {
        TimeEvent(10 * FRAMES, function(inst)
            if inst.components.hayfever then
                inst.components.hayfever:DoSneezeEffects()
            end
            inst.sg:RemoveStateTag("busy")
        end),
    },

    onexit = function(inst)
        if inst.components.rider:IsRiding() then
            inst.Transform:SetSixFaced()
        end
    end,
})
