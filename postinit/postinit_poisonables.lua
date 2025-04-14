--[[
	Lootdropper Postinit

	Allows one to add and remove named functions that are called when a
	loot item is spawned.
--]]
local Utils = require("tropical_utils/utils")

AddComponentPostInit("lootdropper", function(self, inst)
	self.loot_postinits = {}

	self.SetLootPostInit = function(_self, name, fn)
		if type(fn) == "function" then
			_self.loot_postinits[name] = fn
		end
	end

	self.RemoveLootPostInit = function(_self, name)
		_self.loot_postinits[name] = nil
	end

	self.old_SpawnLootPrefabVB = self.SpawnLootPrefab
	self.SpawnLootPrefab = function(_self, lootprefab, pt)
		local loot = _self.old_SpawnLootPrefabVB(_self, lootprefab, pt)
		if loot and _self.loot_postinits then
			for i, loot_postinit in ipairs(_self.loot_postinits) do
				loot = loot_postinit(_self, loot)
			end
		end
		return loot
	end
end)


HookInitPoisonable = function(player)
	if player.components.poisonable == nil then
		player:AddComponent("poisonable")
	end
end

AddPrefabPostInitAny(function(inst)
	-- Only fightable mobs can be poisonable 中毒组件
	if inst.components.combat and inst.components.poisonable == nil then
		inst:AddComponent("poisonable")
	end
end)

--------------poison-------by EvenMr----------------------------------------------------------------

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
