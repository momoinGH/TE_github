-- 中毒

table.insert(PrefabFiles, "poisonbubble") --中毒特效

table.insert(Assets, Asset("ANIM", "anim/poison.zip"))
table.insert(Assets, Asset("ANIM", "anim/poison_meter_overlay.zip"))
table.insert(Assets, Asset("ATLAS", "images/overlays/poison.xml"))

----------------------------------------------------------------------------------------------------

AddPrefabPostInitAny(function(inst)
    if inst.components.combat then
        AddComponentIfNot(inst, "poisonable")
    end
end)

TroAddPlayerClassifiedNetVar(net_event, "tro_poisonover", "poisondamage") --中毒扣血事件

----------------------------------------------------------------------------------------------------

local function HealthBadgeOnUpdateBefore(self)
    local is_poison = self.owner:HasTag("tro_poisoned")
    if is_poison ~= self.poisoned then
        self.poisoned = is_poison
        if is_poison then --中毒
            self.poisonanim:GetAnimState():PlayAnimation("activate")
            self.poisonanim:GetAnimState():PushAnimation("idle", true)
            self.poisonanim:Show()
        else --不再中毒
            self.owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/HUD_antivenom_use")
            self.poisonanim:GetAnimState():PlayAnimation("deactivate")
        end
    end
end

-- 血条上的中毒动画
local UIAnim = require "widgets/uianim"
AddClassPostConstruct("widgets/healthbadge", function(self)
    self.poisoned = false
    self.poisonanim = self.underNumber:AddChild(UIAnim())
    self.poisonanim:GetAnimState():SetBank("poison")
    self.poisonanim:GetAnimState():SetBuild("poison_meter_overlay")
    self.poisonanim:GetAnimState():PlayAnimation("deactivate")
    self.poisonanim:Hide()

    Hooks.FnDecorator(self, "OnUpdate", HealthBadgeOnUpdateBefore)
end)

-- 中毒扣血时屏幕闪一下
local PoisonOver = require("widgets/poisonover")
AddClassPostConstruct("screens/playerhud", function(self)
    Hooks.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner)
        self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
        return retTab
    end)

    Hooks.FnDecorator(self, "SetMainCharacter", nil, function(retTab, self, maincharacter)
        if not maincharacter then
            return retTab
        end

        self.inst:ListenForEvent("poisondamage", function(inst, data) return self.poisonover:Flash() end, self.owner)

        return retTab
    end)
end)
