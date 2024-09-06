local Utils = require("tropical_utils/utils")

AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end

    -- Only fightable mobs can be poisonable 中毒组件
    if inst.components.combat and not inst.components.poisonable then
        inst:AddComponent("poisonable")
    end
end)


local function OnPoisonOverDirty(inst)
    local player = inst._parent
    if player and player.HUD then
        if inst.poisonover:value() then
            player.HUD.poisonover:Flash()
        end
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst.poisonover = net_bool(inst.GUID, "poison.poisonover", "poisonoverdirty") --中毒HUD

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("poisonoverdirty", OnPoisonOverDirty)
    end
end)

----------------------------------------------------------------------------------------------------

local PoisonOver = require("widgets/poisonover")
AddClassPostConstruct("screens/playerhud", function(self)
    Utils.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner)
        self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
    end)
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
