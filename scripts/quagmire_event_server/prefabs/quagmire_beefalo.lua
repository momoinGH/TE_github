local brain = require "brains/quagmirebeefalobrain"

local sounds =
{
	walk = "dontstarve/beefalo/walk",
	grunt = "dontstarve/beefalo/grunt",
	yell = "dontstarve/beefalo/yell",
	swish = "dontstarve/beefalo/tail_swish",
	curious = "dontstarve/beefalo/curious",
	angry = "dontstarve/beefalo/angry",
	sleep = "dontstarve/beefalo/sleep",
}

local function SetHome(inst)
	inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
		return dude:HasTag("beefalo") and not dude:HasTag("player") and not dude.components.health:IsDead()
	end, 5)
end

return {
	master_postinit = function(inst)
		inst:AddComponent("eater")
		inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })

		inst:AddComponent("combat")
		inst.components.combat.hiteffectsymbol = "beefalo_body"

		inst:AddComponent("sleeper")
		inst.components.sleeper:SetResistance(2)

		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(TUNING.BABYBEEFALO_HEALTH)

		inst:AddComponent("inspectable")

		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot({ "meat", "meat" })

		inst:AddComponent("locomotor")
		inst.components.locomotor.runspeed = 6
		inst.components.locomotor.walkspeed = 1

		inst:AddComponent("periodicspawner") --TODO: Hornet- These values might need to be changed, I have no idea how accurate they are
		inst.components.periodicspawner:SetPrefab("poop")
		inst.components.periodicspawner:SetRandomTimes(40, 60)
		inst.components.periodicspawner:SetDensityInRange(20, 2)
		inst.components.periodicspawner:SetMinimumSpacing(8)
		inst.components.periodicspawner:Start()

		inst:AddComponent("knownlocations")
		inst:AddComponent("herdmember")

		MakeMediumBurnableCharacter(inst, "beefalo_body")
		MakeHauntablePanic(inst)

		inst.sounds = sounds

		inst:SetStateGraph("SGquagmirebeefalo")
		inst:SetBrain(brain)

		inst:DoTaskInTime(0, SetHome)

		inst:ListenForEvent("attacked", OnAttacked)
	end,
}
