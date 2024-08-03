modimport "uw_tuning"

--RemapSoundEvent("dontstarve/music/music_FE", "dontstarve/music/gramaphone_drstyle") --Again, it's just a placeholder until we have a proper theme

RegisterInventoryItemAtlas("images/inventoryimages/sponge_piece.xml", "sponge_piece.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fish_fillet.xml", "fish_fillet.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fish_fillet_cooked.xml", "fish_fillet_cooked.tex")
--RegisterInventoryItemAtlas("images/inventoryimages/food/fish_n_chips.xml", "fish_n_chips.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/sponge_cake.xml", "sponge_cake.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/fish_gazpacho.xml", "fish_gazpacho.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/tuna_muffin.xml", "tuna_muffin.tex"  )
RegisterInventoryItemAtlas("ATLAS", "images/inventoryimages/sea_cucumber.xml", "sea_cucumber.tex")
--RegisterInventoryItemAtlas("images/inventoryimages/food/tentacle_sushi.xml", "tentacle_sushi.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/fish_sushi.xml", "fish_sushi.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/flower_sushi.xml", "flower_sushi.tex"  )
RegisterInventoryItemAtlas("images/inventoryimages/shrimp_tail.xml", "shrimp_tail.tex")
RegisterInventoryItemAtlas("images/inventoryimages/sea_petals.xml", "sea_petals.tex")
RegisterInventoryItemAtlas("images/inventoryimages/seagrass_chunk.xml", "seagrass_chunk.tex")
RegisterInventoryItemAtlas("images/inventoryimages/sea_petals.xml", "sea_petals.tex")
RegisterInventoryItemAtlas("images/inventoryimages/jelly_cap.xml", "jelly_cap.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed_dried")

RegisterInventoryItemAtlas("images/inventoryimages/creepindeep_cuisine.xml", "creepindeep_cuisine.tex")

-- Mod recipes
modimport "modrecipes"

-- Mod cooking recipes and ingredients
AddIngredientValues({ "fish_fillet" }, { fish = 1, meat = 0.5 }, true, false)
AddIngredientValues({ "sponge_piece" }, { sponge = 1 }, false, false)
AddIngredientValues({ "seagrass_chunk" }, { sea_veggie = 1, veggie = 0.5 }, false, false)
AddIngredientValues({ "trinket_12" }, { tentacle = 1, meat = 0.5 }, false, false)
AddIngredientValues({ "petals" }, { flower = 1 }, false, false)
AddIngredientValues({ "sea_petals" }, { flower = 1 }, false, false)
AddIngredientValues({ "jelly_cap" }, { sea_jelly = 1 }, false, false)
AddIngredientValues({ "saltrock" }, { saltrock = 1 }, false, false)

-- local sponge_cake =
-- {
--     name = "sponge_cake",
-- 		test = function(cooker, names, tags) return tags.dairy and tags.sweetener and tags.sponge and tags.sponge >= 2 and not tags.meat end,
-- 		priority = 0,
-- 		weight = 1,
-- 		foodtype = FOODTYPE.GOODIES,
-- 		health = 0,
-- 		hunger = 25,
-- 		sanity = 50,
-- 		perishtime = TUNING.PERISH_SUPERFAST,
-- 		cooktime = .5,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",		
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",sponge_cake)
-- AddCookerRecipe("portablecookpot",sponge_cake)
-- AddCookerRecipe("xiuyuan_cookpot",sponge_cake)


-- local fish_n_chips =
-- {
--     name = "fish_n_chips",
-- 		test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.veggie and tags.veggie >= 2 end,
-- 		priority = 10,
-- 		weight = 1,
-- 		foodtype = "MEAT",
-- 		health = 25,
-- 		hunger = 42.5,
-- 		sanity = 10,
-- 		perishtime = TUNING.PERISH_FAST,
-- 		cooktime = 1,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",			
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",fish_n_chips)
-- AddCookerRecipe("portablecookpot",fish_n_chips)
-- AddCookerRecipe("xiuyuan_cookpot",fish_n_chips)

-- local tuna_muffin =
-- {
--     name = "tuna_muffin",
-- 		test = function(cooker, names, tags) return tags.fish and tags.fish >= 1 and tags.sponge and tags.sponge >= 1 and not tags.twigs end,
-- 		priority = 5,
-- 		weight = 1,
-- 		foodtype = "MEAT",
-- 		health = 0,
-- 		hunger = 32.5,
-- 		sanity = 10,
-- 		perishtime = TUNING.PERISH_MED,
-- 		cooktime = 2,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",			
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",tuna_muffin)
-- AddCookerRecipe("portablecookpot",tuna_muffin)
-- AddCookerRecipe("xiuyuan_cookpot",tuna_muffin)

-- local tentacle_sushi =
-- {
--     name = "tentacle_sushi",
-- 		test = function(cooker, names, tags) return tags.tentacle and tags.tentacle and tags.sea_veggie and tags.fish >= 0.5 and not tags.twigs end,
-- 		priority = 0,
-- 		weight = 1,
-- 		foodtype = "MEAT",
-- 		health = 35,
-- 		hunger = 5,
-- 		sanity = 5,
-- 		perishtime = TUNING.PERISH_MED,
-- 		cooktime = 2,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",		
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",tentacle_sushi)
-- AddCookerRecipe("portablecookpot",tentacle_sushi)
-- AddCookerRecipe("xiuyuan_cookpot",tentacle_sushi)

-- local flower_sushi =
-- {
--     name = "flower_sushi",
-- 		test = function(cooker, names, tags) return tags.flower and tags.sea_veggie and tags.fish and tags.fish >= 1 and not tags.twigs end,
-- 		priority = 0,
-- 		weight = 1,
-- 		foodtype = "MEAT",
-- 		health = 10,
-- 		hunger = 5,
-- 		sanity = 30,
-- 		perishtime = TUNING.PERISH_MED,
-- 		cooktime = 2,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",			
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",flower_sushi)
-- AddCookerRecipe("portablecookpot",flower_sushi)
-- AddCookerRecipe("xiuyuan_cookpot",flower_sushi)

-- local fish_sushi =
-- {
--     name = "fish_sushi",
-- 		test = function(cooker, names, tags) return tags.tentacle and tags.veggie >= 1 and tags.fish and tags.fish >= 1 and not tags.twigs end,
-- 		priority = 0,
-- 		weight = 1,
-- 		foodtype = "MEAT",
-- 		health = 5,
-- 		hunger = 50,
-- 		sanity = 0,
-- 		perishtime = TUNING.PERISH_MED,
-- 		cooktime = 2,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",			
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",fish_sushi)
-- AddCookerRecipe("portablecookpot",fish_sushi)
-- AddCookerRecipe("xiuyuan_cookpot",fish_sushi)

-- local seajelly =
-- {
--     name = "seajelly",
-- 		test = function(cooker, names, tags) return tags.sea_jelly and tags.sea_jelly > 1 and names.saltrock and names.saltrock > 1 and not tags.meat end,
-- 		priority = 0,
-- 		weight = 1,
-- 		foodtype = "MEAT",
-- 		health = 20,
-- 		hunger = 40,
-- 		sanity = 3,
-- 		perishtime = TUNING.PERISH_SLOW,
-- 		cooktime = 2,
-- 		cookbook_atlas = "images/inventoryimages/creepindeep_cuisine.xml",		
-- 	floater = {"small", 0.05, 0.7},
--     tags = {},
-- }

-- AddCookerRecipe("cookpot",seajelly)
-- AddCookerRecipe("portablecookpot",seajelly)
-- AddCookerRecipe("xiuyuan_cookpot",seajelly)

RegisterInventoryItemAtlas("images/inventoryimages/sponge_piece.xml", "sponge_piece.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fish_fillet.xml", "fish_fillet.tex")
RegisterInventoryItemAtlas("images/inventoryimages/fish_fillet_cooked.xml", "fish_fillet_cooked.tex")
--RegisterInventoryItemAtlas("images/inventoryimages/food/fish_n_chips.xml", "fish_n_chips.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/sponge_cake.xml", "sponge_cake.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/fish_gazpacho.xml", "fish_gazpacho.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/tuna_muffin.xml", "tuna_muffin.tex"  )
RegisterInventoryItemAtlas("ATLAS", "images/inventoryimages/sea_cucumber.xml", "sea_cucumber.tex")
--RegisterInventoryItemAtlas("images/inventoryimages/food/tentacle_sushi.xml", "tentacle_sushi.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/fish_sushi.xml", "fish_sushi.tex"  )
--RegisterInventoryItemAtlas("images/inventoryimages/food/flower_sushi.xml", "flower_sushi.tex"  )
RegisterInventoryItemAtlas("images/inventoryimages/shrimp_tail.xml", "shrimp_tail.tex")
RegisterInventoryItemAtlas("images/inventoryimages/sea_petals.xml", "sea_petals.tex")
RegisterInventoryItemAtlas("images/inventoryimages/seagrass_chunk.xml", "seagrass_chunk.tex")
RegisterInventoryItemAtlas("images/inventoryimages/sea_petals.xml", "sea_petals.tex")
RegisterInventoryItemAtlas("images/inventoryimages/jelly_cap.xml", "jelly_cap.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "seaweed_dried")

RegisterInventoryItemAtlas("images/inventoryimages/creepindeep_cuisine.xml", "creepindeep_cuisine.tex")

--TheSim:RemapSoundEvent("dontstarve/music/music_dawn_stinger", "citd/music/music_dawn_stinger")
--TheSim:RemapSoundEvent("dontstarve/music/music_dusk_stinger", "citd/music/music_dusk_stinger")

AddPrefabPostInitAny(function(inst)
	if inst.prefab == "trinket_12" then inst:AddTag("edible") end
	-------- Add bubbles on destruction
	if inst.components and (inst.components.workable or inst.components.health) then
		inst:AddComponent("deathbubbles")
	end

	if inst:HasTag("player") then
		inst:AddComponent("bubbleblower") ------- Blow bubble underwater to players
		inst:AddComponent("oxygen")
		---------- Custom Oxygen Levels
		if inst.prefab == "willow" then inst.components.oxygen.max = 80 end
		if inst.prefab == "wilson" then inst.components.oxygen.max = 100 end
		if inst.prefab == "wolfgang" then inst.components.oxygen.max = 150 end
		if inst.prefab == "waxwell" then inst.components.oxygen.max = 120 end
		if inst.prefab == "woodie" then inst.components.oxygen.max = 150 end
		if inst.prefab == "wendy" then inst.components.oxygen.max = 80 end
		if inst.prefab == "wickerbottom" then inst.components.oxygen.max = 100 end
		if inst.prefab == "wes" then inst.components.oxygen.max = 55 end
		if inst.prefab == "wigfrid" then inst.components.oxygen.max = 150 end
		if inst.prefab == "webber" then inst.components.oxygen.max = 85 end
		if inst.prefab == "wurt" then
			inst.components.oxygen.max = 5000
			inst.components.oxygen.current = 5000
		end

		inst:ListenForEvent("runningoutofoxygen", function(inst, data)
			inst.components.talker:Say("Low Oxygen") --GetString(inst.prefab, "ANNOUNCE_OUT_OF_OXYGEN"))
		end)

		inst:ListenForEvent("startdrowning",
			function(inst, data)
				if inst.HUD then
					inst.HUD.bloodover:UpdateState()
				end
			end,
			inst)

		inst:ListenForEvent("stopdrowning",
			function(inst, data)
				if inst.HUD then
					inst.HUD.bloodover:UpdateState()
				end
			end,
			inst)


		-- WX78 is a robot!
		if inst.prefab == "wx78" then
			inst:AddTag("robot")
		end
	end
end)


AddPrefabPostInit("cave", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("underwaterspawner")
	end
end)

AddComponentPostInit("fueled", function(self)
	------------------------
	function self:Ignite(immediate, source, doer)
		local map = GLOBAL.TheWorld.Map
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
		if ground == GROUND.UNDERWATER_SANDY or ground == GROUND.UNDERWATER_ROCKY or (ground == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end
		------------------------
		if not (self.burning or self.inst:HasTag("fireimmune")) then
			self:StopSmoldering()

			self.burning = true
			self.inst:ListenForEvent("death", OnKilled)
			self:SpawnFX(immediate)

			self.inst:PushEvent("onignite", { doer = doer })
			if self.onignite ~= nil then
				self.onignite(self.inst)
			end

			if self.inst.components.fueled ~= nil then
				self.inst.components.fueled:StartConsuming()
			end

			if self.inst.components.propagator ~= nil then
				self.inst.components.propagator:StartSpreading(source)
			end

			self:ExtendBurning()
		end
	end
end)
------------------------------------
modimport("scripts/widgets/oxygendisplay.lua")
