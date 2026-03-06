-- 中毒

AddPrefabPostInitAny(function(inst)
    if inst.components.combat then
        AddComponentIfNot(inst, "poisonable")
    end
end)

----------------------------------------------------------------------------------------------------

AddClassPostConstruct("screens/playerhud", function(inst)
    local PoisonOver = require("widgets/poisonover")
    local fn = inst.CreateOverlays
    function inst:CreateOverlays(owner)
        fn(self, owner)
        self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
    end
end)

local function OnPoisonOverDirty(inst)
    if inst._parent and inst._parent.HUD then
        if inst.poisonover:value() then
            inst._parent.HUD.poisonover:Flash()
        end
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst.poisonover = net_bool(inst.GUID, "poison.poisonover", "poisonoverdirty") --中毒HUD

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("poisonoverdirty", OnPoisonOverDirty)
    end
end)

-- 中毒时血条显示下降箭头
local function HealthBadgeOnUpdateBefore(self)
    if not TheNet:IsServerPaused()
        and self.owner:HasTag("tro_poisoned")
    then
        local anim = "arrow_loop_decrease"
        if self.arrowdir ~= anim then
            self.arrowdir = anim
            self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
        end
        return nil, true
    end
end

AddClassPostConstruct("widgets/healthbadge", function(self)
    Utils.FnDecorator(self, "OnUpdate", HealthBadgeOnUpdateBefore)
end)
