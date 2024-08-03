AddIngredientValues({ "full_bottle_green_milk" }, { dairy = 3 })
AddIngredientValues({ "half_bottle_green_milk" }, { dairy = 2 })
AddIngredientValues({ "less_bottle_green_milk" }, { dairy = 1 })
AddIngredientValues({ "full_bottle_green" }, { water = 1 })
AddIngredientValues({ "magicpowder" }, { goddessmagic = 1 })
AddIngredientValues({ "peach" }, { fruit = 1 })
AddIngredientValues({ "grilled_peach" }, { fruit = 1 })
AddIngredientValues({ "peach_juice_bottle_green" }, { peachy = 1 })
AddIngredientValues({ "peachy_meatloaf" }, { loaf = 1 })

local peach_juice =
{
	name = "peach_juice_bottle_green",
	test = function(cooker, names, tags)
		return (names.peach or names.grilled_peach) and
			(names.peach or names.grilled_peach) >= 2 and tags.sweetener and tags.water and not tags.meat and
			not tags.egg and
			not tags.monster
	end,
	priority = 100,
	weight = 1,
	foodtype = FOODTYPE.GOODIES,
	health = 15,
	hunger = 35,
	sanity = 5,
	cooktime = 0.5,
	cookbook_atlas = "images/inventoryimages/peach_juice_bottle_green.xml",
	tags = { "honeyed" },
	card_def = { ingredients = { { "peach", 2 }, { "honey", 1 }, { "full_bottle_green", 1 } } },
}
local potion =
{
	name = "potion_bottle_green",
	test = function(cooker, names, tags)
		return tags.peachy and tags.goddessmagic and tags.loaf and
			(names.peach or names.grilled_peach)
	end,
	priority = 100,
	weight = 1,
	foodtype = FOODTYPE.GOODIES,
	health = 75,
	hunger = 75,
	sanity = 75,
	cooktime = 0.5,
	cookbook_atlas = "images/inventoryimages/potion_bottle_green.xml",
	card_def = { ingredients = { { "peach", 1 }, { "peach_juice_bottle_green", 1 }, { "peachy_meatloaf", 1 }, { "magicpowder", 1 } } },
}
AddCookerRecipe("cookpot", potion)
AddCookerRecipe("cookpot", peach_juice)
AddCookerRecipe("portablecookpot", potion)
AddCookerRecipe("portablecookpot", peach_juice)
--local goddess_tab = AddRecipeTab("Wind Goddess Magic", 969, "images/inventoryimages/windyfan1.xml", "windyfan1.tex", nil )
AddRecipe2("magicpowder",
	{ Ingredient("goddess_butterflywings", 8, "images/inventoryimages/goddess_butterflywings.xml"), Ingredient(
		"nightmarefuel", 8), Ingredient("cutgreengrass", 8, "images/inventoryimages/cutgreengrass.xml") },
	TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/magicpowder.xml", numtogive = 8 }, { "CRAFTING_STATION" })
AddRecipe2("goddess_ribbon",
	{ Ingredient("goddess_rabbit_fur", 3, "images/inventoryimages/goddess_rabbit_fur.xml"), Ingredient("silk", 9),
		Ingredient("magicpowder", 1, "images/inventoryimages/magicpowder.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_ribbon.xml", numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("forbidden_fruit",
	{ Ingredient("mixed_gem", 1, "images/inventoryimages/mixed_gem.xml"), Ingredient("magicpowder", 8,
		"images/inventoryimages/magicpowder.xml"), Ingredient("peach", 1, "images/inventoryimages/peach.xml") },
	TECH.GODDESS_TWO, { atlas = "images/inventoryimages/forbidden_fruit.xml" }, { "CRAFTING_STATION" })
AddRecipe2("glass_bomb",
	{ Ingredient("full_bottle_green_dirty", 3, "images/inventoryimages/full_bottle_green_dirty.xml"), Ingredient(
		"magicpowder", 3, "images/inventoryimages/magicpowder.xml"), Ingredient("gunpowder", 9) }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/glass_bomb.xml", numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("goddess_hat",
	{ Ingredient("eyebrellahat", 1), Ingredient("goddess_feather", 2, "images/inventoryimages/goddess_feather.xml"),
		Ingredient("forbidden_fruit", 1, "images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_hat.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_bowtie",
	{ Ingredient("goddess_ribbon", 8, "images/inventoryimages/goddess_ribbon.xml"), Ingredient("goddess_butterfly", 3,
		"images/inventoryimages/goddess_butterfly.xml"), Ingredient("forbidden_fruit", 1,
		"images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_bowtie.xml" }, { "CRAFTING_STATION" })
AddRecipe2("usedfan",
	{ Ingredient("goddess_feather", 8, "images/inventoryimages/goddess_feather.xml"), Ingredient("goldnugget", 12),
		Ingredient("goose_feather", 8) }, TECH.GODDESS_TWO, { atlas = "images/inventoryimages/usedfan.xml" },
	{ "CRAFTING_STATION" })
AddRecipe2("windyfan",
	{ Ingredient("usedfan", 1, "images/inventoryimages/usedfan.xml"), Ingredient("magicpowder", 8,
		"images/inventoryimages/magicpowder.xml"), Ingredient("forbidden_fruit", 1,
		"images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO, {
		atlas =
		"images/inventoryimages/windyfan.xml"
	}, { "CRAFTING_STATION" })
AddRecipe2("goddess_sword",
	{ Ingredient("magicpowder", 10, "images/inventoryimages/magicpowder.xml"), Ingredient("nightsword", 3), Ingredient(
		"forbidden_fruit", 1, "images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_sword.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_flute",
	{ Ingredient("staff_tornado", 3), Ingredient("cutreeds", 10), Ingredient("forbidden_fruit", 1,
		"images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_flute.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_bell",
	{ Ingredient("goldnugget", 8), Ingredient("steelwool", 8), Ingredient("forbidden_fruit", 1,
		"images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_bell.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_staff",
	{ Ingredient("goldnugget", 8), Ingredient("goddess_ribbon", 8, "images/inventoryimages/goddess_ribbon.xml"),
		Ingredient("forbidden_fruit", 1, "images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_staff.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_lantern",
	{ Ingredient("yellowstaff", 2), Ingredient("goddess_ribbon", 8, "images/inventoryimages/goddess_ribbon.xml"),
		Ingredient("forbidden_fruit", 1, "images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_lantern.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_fountainette",
	{ Ingredient("full_bottle_green", 4, "images/inventoryimages/full_bottle_green.xml"), Ingredient("moonrocknugget", 15),
		Ingredient("forbidden_fruit", 1, "images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_fountainette.xml" }, { "CRAFTING_STATION" })
AddRecipe2("goddess_figure",
	{ Ingredient("windyfan", 1, "images/inventoryimages/windyfan.xml"), Ingredient("marble", 15), Ingredient(
		"forbidden_fruit", 1, "images/inventoryimages/forbidden_fruit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/goddess_figure.xml" }, { "CRAFTING_STATION" })
AddRecipe2("gem_seeds",
	{ Ingredient("mixed_gem", 1, "images/inventoryimages/mixed_gem.xml"), Ingredient("seeds", 3), Ingredient("peach_pit",
		3, "images/inventoryimages/peach_pit.xml") }, TECH.GODDESS_TWO,
	{ atlas = "images/inventoryimages/gem_seeds.xml", numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("peachy_poop", { Ingredient("guano", 6), Ingredient("peach", 6, "images/inventoryimages/peach.xml") },
	TECH.SCIENCE_TWO, { atlas = "images/inventoryimages/peachy_poop.xml", numtogive = 6 }, { "GARDENING" })

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
-- New Action (Extrafillable)

AddStategraphActionHandler("wilson", ActionHandler(GLOBAL.ACTIONS.FILLED, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.FILLED, "dolongaction"))

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
-- New Action (Milker)

AddStategraphActionHandler("wilson", ActionHandler(GLOBAL.ACTIONS.MILK, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.MILK, "dolongaction"))

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (give) [too lazy to make new component for goddess item repair]
AddStategraphActionHandler("wilson", ActionHandler(GLOBAL.ACTIONS.GIVE, function(inst, action)
	return action.invobject ~= nil and action.target ~= nil and (
			(action.target:HasTag("moonportal") and action.invobject:HasTag("moonportalkey") and "dochannelaction") or
			(action.invobject.prefab == "quagmire_portal_key" and action.target:HasTag("quagmire_altar") and "quagmireportalkey") or
			(action.target:HasTag("goddess_item") and "dolongaction") or
			(action.target:HasTag("trader") and "give"))
		or "give"
end))
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (play_goddess_bell) [this should make the bell appear in cave servers and let this bell work with other bell mods]
AddStategraphState("wilson", State {
	name = "play_goddess_bell",
	tags = { "doing", "playing" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("action_uniqueitem_pre")
		inst.AnimState:PushAnimation("bell", false)
		inst.AnimState:OverrideSymbol("bell01", "goddess_bell", "bell01")
		inst.AnimState:Show("ARM_normal")
		inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or
			nil)
	end,
	timeline = {
		TimeEvent(15 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell")
		end),
		TimeEvent(60 * FRAMES, function(inst)
			inst:PerformBufferedAction()
		end),
	},
	events = {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
	onexit = function(inst)
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
	end,
})
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (play_goddess_flute)
AddStategraphState("wilson", State {
	name = "play_goddess_flute",
	tags = { "doing", "playing" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("action_uniqueitem_pre")
		inst.AnimState:PushAnimation("flute", false)
		inst.AnimState:OverrideSymbol("pan_flute01", "goddess_flute", "pan_flute01")
		inst.AnimState:Hide("ARM_carry")
		inst.AnimState:Show("ARM_normal")
		inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or
			nil)
	end,
	timeline =
	{
		TimeEvent(30 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/flute_LP", "flute")
			inst:PerformBufferedAction()
		end),
		TimeEvent(85 * FRAMES, function(inst)
			inst.SoundEmitter:KillSound("flute")
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
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
	end,
})
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Peach Farming
local Crop = require('components/crop')
local oldCropHarvest = Crop.Harvest
Crop.Harvest = function(self, harvester, ...)
	if self.product_prefab == "peach" then
		if self.matured then
			local product = GLOBAL.SpawnPrefab("peach")
			if harvester then
				local rnd = math.random() * 100
				local count = 0
				if rnd <= 15 then count = 1 elseif rnd <= 75 then count = 2 else count = 3 end
				product.components.stackable:SetStackSize(count)
				harvester.components.inventory:GiveItem(product)
			else
				product.Transform:SetPosition(self.grower.Transform:GetWorldPosition())
				Launch(product, self.grower, TUNING.LAUNCH_SPEED_SMALL)
			end
			GLOBAL.ProfileStatsAdd("peach")
			self.matured = false
			self.growthpercent = 0
			self.product_prefab = nil
			self.grower.components.grower:RemoveCrop(self.inst)
			self.grower = nil
			return true
		end
		return
	end
	return oldCropHarvest(self, harvester, ...)
end
