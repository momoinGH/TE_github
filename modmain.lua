IsServer, IsDedicated = TheNet:GetIsServer(), TheNet:IsDedicated()


----------------------------------------------------------------------------------------------------
modimport "modmain/tuning"
modimport "modmain/constants"
modimport "modmain/prefablist"
modimport "modmain/assets"
modimport "modmain/language"
modimport "modmain/containers"
modimport "modmain/character"
modimport "modmain/ui"
modimport "modmain/prefabpost"
modimport "modmain/playernet"
modimport "modmain/actions"
modimport "modmain/componentactions"
modimport "modmain/sg"
modimport "modmain/recipes"
modimport "modmain/rpc"
modimport "modmain/input"
modimport "modmain/modwiki"
modimport "scripts/prefabs/tropical_farm_plant_defs"

AddMinimap()

modimport("scripts/complementos.lua")

if GetModConfigData("windyplains") then
	modimport("scripts/windy")
end

if GetModConfigData("underwater") then
	modimport("scripts/creeps.lua")
end

if GetModConfigData("greenworld") then
	modimport("scripts/greenworld.lua")
end

------------inicio builder----------------

function RoundBiasedUp(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local TechTree = require("techtree")

AddClassPostConstruct("components/builder_replica", function(self)
	function self:KnowsRecipe(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if self.inst.components.builder ~= nil then
			return self.inst.components.builder:KnowsRecipe(recipe)
		elseif self.classified ~= nil then
			if recipe ~= nil then
				if self.classified.isfreebuildmode:value()
					or self.inst:HasTag("brainjelly") --###
				then
					return true
				elseif recipe.builder_tag ~= nil and not self.inst:HasTag(recipe.builder_tag) then -- builder_tag check is require due to character swapping
					return false
				elseif self.classified.recipes[recipe.name] ~= nil and self.classified.recipes[recipe.name]:value() then
					return true
				end

				local has_tech = true
				for i, v in ipairs(TechTree.AVAILABLE_TECH) do
					local bonus = self.classified[string.lower(v) .. "bonus"]
					if recipe.level[v] > (bonus ~= nil and bonus:value() or 0) then
						return false
					end
				end

				return true
			end
		end
		return false
	end

	function self:HasIngredients(recipe)
		if self.inst.components.builder ~= nil then
			return self.inst.components.builder:HasIngredients(recipe)
		elseif self.classified ~= nil then
			if type(recipe) == "string" then
				recipe = GetValidRecipe(recipe)
			end
			if recipe ~= nil then
				if self.classified.isfreebuildmode:value() then
					return true
				end
				for i, v in ipairs(recipe.ingredients) do
					if v.type == "oinc" then
						if self.inst.replica.inventory:GetMoney() >= v.amount then
							return true
						end
					end
					if not self.inst.replica.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self:IngredientMod())), true) then
						return false
					end
				end
				for i, v in ipairs(recipe.character_ingredients) do
					if not self:HasCharacterIngredient(v) then
						return false
					end
				end
				for i, v in ipairs(recipe.tech_ingredients) do
					if not self:HasTechIngredient(v) then
						return false
					end
				end
				return true
			end
		end

		return false
	end

	function self:CanBuildAtPoint(pt, recipe, rot)
		if recipe.product == "sprinkler1" and (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then return true end

		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end                   --adicionado por vagner
		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end                   --adicionado por vagner
		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and TheWorld:HasTag("cave")) then return false end  --adicionado por vagner
		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		return TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot)
	end
end)

AddComponentPostInit("inventoryitem", function(self)
	self.inst:AddTag("isinventoryitem")

	self.inst:ListenForEvent("onremove", function()
		if self.inst.onshelf then
			local shelf = self.inst.onshelf
			local item = shelf.components.shelfer:GetGift()
			-- doing this check to save players from a bug that was fixed, but some items may still suffer from it
			if item and item.GUID == self.inst.GUID then
				shelf.components.shelfer:GiveGift()
			end
		end
	end)

	function self:OnPickup(pickupguy, src_pos)
		-- not only the player can have inventory!

		self:SetLanded(false, false)

		if self.isnew and self.inst.prefab and pickupguy:HasTag("player") then
			ProfileStatsAdd("collect_" .. self.inst.prefab)
			self.isnew = false
		end

		if self.inst.components.burnable and self.inst.components.burnable:IsSmoldering() then
			self.inst.components.burnable:StopSmoldering()
			if pickupguy.components.health ~= nil then
				pickupguy.components.health:DoFireDamage(TUNING.SMOTHER_DAMAGE, nil, true)
				pickupguy:PushEvent("burnt")
			end
		end

		if self.inst.bookshelf then
			self:TakeOffShelf()
		end

		self.inst:PushEvent("onpickup", { owner = pickupguy })
		return self.onpickupfn and self.onpickupfn(self.inst, pickupguy, src_pos)
	end

	function self:TakeOffShelf()
		local shelf_slot = SpawnPrefab("shelf_slot")
		shelf_slot.components.inventoryitem:PutOnShelf(self.inst.bookshelf, self.inst.bookshelfslot)
		shelf_slot.components.shelfer:SetShelf(self.inst.bookshelf, self.inst.bookshelfslot)

		self.inst:RemoveTag("bookshelfed")
		self.inst.bookshelfslot = nil
		self.inst.bookshelf = nil
		self.inst.follower:FollowSymbol(0, "dumb", 0, 0, 0)
		if self.inst.Physics then
			self.inst.Physics:SetActive(true)
		end
	end

	function self:PutOnShelf(shelf, slot)
		self.inst:AddTag("bookshelfed")
		self.inst.bookshelfslot = slot
		self.inst.bookshelf = shelf
		if self.inst.Physics then
			self.inst.Physics:SetActive(false)
		end
		local follower = self.inst.entity:AddFollower()
		follower:FollowSymbol(shelf.GUID, slot, 10, 0, 0.6)
		self.inst.follower = follower
	end

	function self:OnSave()
		local data = {}
		local refs = {}

		if self.inst:HasTag("bookshelfed") and self.inst.bookshelf then
			data.bookshelfGUID = self.inst.bookshelf.GUID
			data.bookshelfslot = self.inst.bookshelfslot
			table.insert(refs, self.inst.bookshelf.GUID)
		end

		if self.canbepickedup then
			data.canbepickedup = self.canbepickedup
		end

		if self.inst.onshelf then
			data.onshelf = self.inst.onshelf.GUID
			table.insert(refs, self.inst.onshelf.GUID)
		end

		return data, refs
	end

	function self:OnLoad(data)
		if data.canbepickedup then
			self.canbepickedup = data.canbepickedup
		end
	end

	function self:LoadPostPass(newents, data)
		if data and data.bookshelfGUID then
			if newents[data.bookshelfGUID] then
				local bookshelf = newents[data.bookshelfGUID].entity
				self:PutOnShelf(bookshelf, data.bookshelfslot)
			end
		end
		if data and data.onshelf then
			if newents[data.onshelf] and newents[data.onshelf].entity:IsValid() then
				self.inst.onshelf = newents[data.onshelf].entity
				-- fixup for items that misremembered they were on a shelf.
				self.inst:DoTaskInTime(1, function()
					if self.inst.onshelf then
						local shelfitem = self.inst.onshelf and self.inst.onshelf.components and
							self.inst.onshelf.components.shelfer and self.inst.onshelf.components.shelfer:GetGift()
						if self.inst ~= shelfitem then
							-- we thought we were on a shelf. Alas, we were not
							self.inst.onshelf = nil
						end
					end
				end)
			end
		end
	end
end)

----- desembarque automatico resto do código dentro de locomotor ----------------
AddClassPostConstruct("components/playercontroller", function(self)
	local RUBBER_BAND_PING_TOLERANCE_IN_SECONDS = 0.7
	local RUBBER_BAND_DISTANCE = 4

	function self:OnRemoteStartHop(x, z, platform)
		if not self.ismastersim then return end
		if not self:IsEnabled() then return end
		if not self.handler == nil then return end

		local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
		local target_x, target_y, target_z = x, 0, z
		local platform_for_velocity_calculation = platform

		if platform ~= nil then
			target_x, target_z = platform.components.walkableplatform:GetEmbarkPosition(my_x, my_z)
		else
			platform_for_velocity_calculation = self.inst:GetCurrentPlatform()
			--		if TUNING.tropical.disembarkation then platform_for_velocity_calculation = self.inst:GetCurrentPlatform() or GetClosestInstWithTag("barcoapto", self.inst, 0.5) end
			platform_for_velocity_calculation = self.inst:GetCurrentPlatform() or
				GetClosestInstWithTag("barcoapto", self.inst, 0.5)
		end

		if platform == nil and (platform_for_velocity_calculation == nil or TheWorld.Map:IsOceanAtPoint(target_x, 0, target_z)) then
			return
		end

		local hop_dir_x, hop_dir_z = target_x - my_x, target_z - my_z
		local hop_distance_sq = hop_dir_x * hop_dir_x + hop_dir_z * hop_dir_z

		local target_velocity_rubber_band_distance = 0
		local platform_velocity_x, platform_velocity_z = 0, 0
		if platform_for_velocity_calculation ~= nil then
			local platform_physics = platform_for_velocity_calculation.Physics
			if platform_physics ~= nil then
				platform_velocity_x, platform_velocity_z = platform_physics:GetVelocity()
				if platform_velocity_x ~= 0 or platform_velocity_z ~= 0 then
					local hop_distance = math.sqrt(hop_distance_sq)
					local normalized_hop_dir_x, normalized_hop_dir_z = hop_dir_x / hop_distance, hop_dir_z / hop_distance
					local velocity = math.sqrt(platform_velocity_x * platform_velocity_x +
						platform_velocity_z * platform_velocity_z)
					local normalized_platform_velocity_x, normalized_platform_velocity_z = platform_velocity_x / velocity,
						platform_velocity_z / velocity
					local hop_dir_dot_platform_velocity = normalized_platform_velocity_x * normalized_hop_dir_x +
						normalized_platform_velocity_z * normalized_hop_dir_z
					if hop_dir_dot_platform_velocity > 0 then
						target_velocity_rubber_band_distance = RUBBER_BAND_PING_TOLERANCE_IN_SECONDS * velocity *
							hop_dir_dot_platform_velocity
					end
				end
			end
		end

		local locomotor = self.inst.components.locomotor
		local hop_rubber_band_distance = RUBBER_BAND_DISTANCE + target_velocity_rubber_band_distance +
			locomotor:GetHopDistance()
		local hop_rubber_band_distance_sq = hop_rubber_band_distance * hop_rubber_band_distance

		if hop_distance_sq > hop_rubber_band_distance_sq then
			print("Hop discarded:", "\ntarget_velocity_rubber_band_distance", target_velocity_rubber_band_distance,
				"\nplatform_velocity_x", platform_velocity_x, "\nplatform_velocity_z", platform_velocity_z,
				"\nhop_distance", math.sqrt(hop_distance_sq), "\nhop_rubber_band_distance",
				math.sqrt(hop_rubber_band_distance_sq))
			return
		end

		self.remote_vector.y = 6
		self.inst.components.locomotor:StartHopping(x, z, platform)
	end
end)

----- sai pulando automaticamente do barco cliente outra parte dentro de locomotor ----------------
AddClassPostConstruct("components/embarker", function(self)
	function self:GetEmbarkPosition()
		if self.embarkable ~= nil and self.embarkable:IsValid() then
			local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
			if self.embarkable.components.walkableplatform then
				return self.embarkable.components.walkableplatform:GetEmbarkPosition(my_x, my_z, self.embarker_min_dist)
			end
			local embarker_x, embarker_y, embarker_z = self.inst.Transform:GetWorldPosition()
			local embarkable_radius = 0.1
			local alvo = GetClosestInstWithTag("barcoapto", self.inst, 6) or self.inst.Transform:GetWorldPosition()
			local embarkable_x, embarkable_y, embarkable_z = alvo.Transform:GetWorldPosition()
			local embark_x, embark_z = VecUtil_Normalize(embarker_x - embarkable_x, embarker_z - embarkable_z)
			return embarkable_x + embark_x * embarkable_radius, embarkable_z + embark_z * embarkable_radius
		else
			local x, z = (self.disembark_x or self.last_embark_x), (self.disembark_z or self.last_embark_z)
			if x == nil or z == nil then
				local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
				x, z = my_x, my_z
			end
			return x, z
		end
	end
end)

local wx78_moduledefs = require("wx78_moduledefs")
local module_definitions = wx78_moduledefs.module_definitions
local AddCreatureScanDataDefinition = wx78_moduledefs.AddCreatureScanDataDefinition
AddCreatureScanDataDefinition("crab", "movespeed_sw", 2)
AddCreatureScanDataDefinition("piko", "movespeed_ham", 2)

AddCreatureScanDataDefinition("twister", "movespeed2", 6)
AddCreatureScanDataDefinition("rookwater", "movespeed2", 3)
AddCreatureScanDataDefinition("pangolden", "movespeed2", 1)
AddCreatureScanDataDefinition("wildbore", "movespeed2", 1)

AddCreatureScanDataDefinition("butterfly_tropical", "maxsanity1", 1)
--AddCreatureScanDataDefinition("glowfly", "maxsanity1", 1)

AddCreatureScanDataDefinition("ancient_herald", "maxsanity", 6)

AddCreatureScanDataDefinition("crocodog", "maxhunger1", 2)
AddCreatureScanDataDefinition("pog", "maxhunger1", 2)

AddCreatureScanDataDefinition("tigershark", "maxhunger_sw", 6)
AddCreatureScanDataDefinition("spider_monkey", "maxhunger", 3)

AddCreatureScanDataDefinition("glowfly", "light", 1)
-- AddCreatureScanDataDefinition("bioluminescence", "light", 1)

AddCreatureScanDataDefinition("dragoon", "heat", 2)
AddCreatureScanDataDefinition("scorpion", "heat", 1)

AddCreatureScanDataDefinition("watercrocodog", "cold", 4)
AddCreatureScanDataDefinition("hippopotamoose", "cold", 4)

-- AddCreatureScanDataDefinition("bioluminescence", "nightvision", 1)
AddCreatureScanDataDefinition("vampirebat", "nightvision", 2)

AddCreatureScanDataDefinition("antqueen", "bee", 10)

AddCreatureScanDataDefinition("mandrakeman", "music", 2)
AddCreatureScanDataDefinition("whale_blue", "music", 4)
AddCreatureScanDataDefinition("whale_white", "music", 8)

-- AddCreatureScanDataDefinition("jellyfish_planted", "taser", 1)
AddCreatureScanDataDefinition("thunderbird", "taser_ham", 2)

---------------------
--[[
if GetModConfigData("kindofworld") == 5 then
function HamletcloudPostInit()
if not TheNet:IsDedicated() and TheWorld and TheWorld.WaveComponent then
TheWorld.Map:SetUndergroundFadeHeight(0)
TheWorld.Map:SetTransparentOcean(false)
TheWorld.Map:AlwaysDrawWaves(true)
TheWorld.WaveComponent:SetWaveTexture(resolvefilepath("images/fog_cloud.tex"))	
local scale = 1
local map_width, map_height = TheWorld.Map:GetSize()
TheWorld.WaveComponent:SetWaveParams(13.5, 2.5, -1)
TheWorld.WaveComponent:Init(map_width, map_height)
TheWorld.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)
TheWorld.WaveComponent:SetWaveMotion(3, 0.5, 0.25)

if TheWorld.ismastersim then
TheWorld:AddComponent("cloudpuffmanager")
end

end
end

AddSimPostInit(HamletcloudPostInit)

end
]]


if GetModConfigData("kindofworld") == 5 then
	function HamletcloudPostInit()
		local World = TheWorld
		if not TheNet:IsDedicated() and World and World.WaveComponent then
			World.Map:SetUndergroundFadeHeight(0)
			World.Map:AlwaysDrawWaves(true)
			World.WaveComponent:SetWaveTexture(resolvefilepath("images/fog_cloud.tex"))
			local scale = 1
			local map_width, map_height = World.Map:GetSize()
			World.WaveComponent:SetWaveParams(13.5, 2.5, -1)
			World.WaveComponent:Init(map_width, map_height)
			World.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)
			World.WaveComponent:SetWaveMotion(0.3, 0.5, 0.35)

			local map = World.Map
			local tuning = TUNING.OCEAN_SHADER
			map:SetOceanEnabled(true)
			map:SetOceanTextureBlurParameters(tuning.TEXTURE_BLUR_PASS_SIZE, tuning.TEXTURE_BLUR_PASS_COUNT)
			map:SetOceanNoiseParameters0(tuning.NOISE[1].ANGLE, tuning.NOISE[1].SPEED, tuning.NOISE[1].SCALE,
				tuning.NOISE[1].FREQUENCY)
			map:SetOceanNoiseParameters1(tuning.NOISE[2].ANGLE, tuning.NOISE[2].SPEED, tuning.NOISE[2].SCALE,
				tuning.NOISE[2].FREQUENCY)
			map:SetOceanNoiseParameters2(tuning.NOISE[3].ANGLE, tuning.NOISE[3].SPEED, tuning.NOISE[3].SCALE,
				tuning.NOISE[3].FREQUENCY)

			local waterfall_tuning = TUNING.WATERFALL_SHADER.NOISE
			map:SetWaterfallFadeParameters(TUNING.WATERFALL_SHADER.FADE_COLOR[1] / 255,
				TUNING.WATERFALL_SHADER.FADE_COLOR[2] / 255, TUNING.WATERFALL_SHADER.FADE_COLOR[3] / 255,
				TUNING.WATERFALL_SHADER.FADE_START)
			map:SetWaterfallNoiseParameters0(waterfall_tuning[1].SCALE, waterfall_tuning[1].SPEED,
				waterfall_tuning[1].OPACITY, waterfall_tuning[1].FADE_START)
			map:SetWaterfallNoiseParameters1(waterfall_tuning[2].SCALE, waterfall_tuning[2].SPEED,
				waterfall_tuning[2].OPACITY, waterfall_tuning[2].FADE_START)

			local minimap_ocean_tuning = TUNING.OCEAN_MINIMAP_SHADER
			map:SetMinimapOceanEdgeColor0(minimap_ocean_tuning.EDGE_COLOR0[1] / 255,
				minimap_ocean_tuning.EDGE_COLOR0[2] / 255, minimap_ocean_tuning.EDGE_COLOR0[3] / 255)
			map:SetMinimapOceanEdgeParams0(minimap_ocean_tuning.EDGE_PARAMS0.THRESHOLD,
				minimap_ocean_tuning.EDGE_PARAMS0.HALF_THRESHOLD_RANGE)

			map:SetMinimapOceanEdgeColor1(minimap_ocean_tuning.EDGE_COLOR1[1] / 255,
				minimap_ocean_tuning.EDGE_COLOR1[2] / 255, minimap_ocean_tuning.EDGE_COLOR1[3] / 255)
			map:SetMinimapOceanEdgeParams1(minimap_ocean_tuning.EDGE_PARAMS1.THRESHOLD,
				minimap_ocean_tuning.EDGE_PARAMS1.HALF_THRESHOLD_RANGE)

			map:SetMinimapOceanEdgeShadowColor(minimap_ocean_tuning.EDGE_SHADOW_COLOR[1] / 255,
				minimap_ocean_tuning.EDGE_SHADOW_COLOR[2] / 255, minimap_ocean_tuning.EDGE_SHADOW_COLOR[3] / 255)
			map:SetMinimapOceanEdgeShadowParams(minimap_ocean_tuning.EDGE_SHADOW_PARAMS.THRESHOLD,
				minimap_ocean_tuning.EDGE_SHADOW_PARAMS.HALF_THRESHOLD_RANGE,
				minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_X, minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_Y)

			map:SetMinimapOceanEdgeFadeParams(minimap_ocean_tuning.EDGE_FADE_PARAMS.THRESHOLD,
				minimap_ocean_tuning.EDGE_FADE_PARAMS.HALF_THRESHOLD_RANGE,
				minimap_ocean_tuning.EDGE_FADE_PARAMS.MASK_INSET)

			map:SetMinimapOceanEdgeNoiseParams(minimap_ocean_tuning.EDGE_NOISE_PARAMS.UV_SCALE)

			map:SetMinimapOceanTextureBlurParameters(minimap_ocean_tuning.TEXTURE_BLUR_SIZE,
				minimap_ocean_tuning.TEXTURE_BLUR_PASS_COUNT, minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_SIZE,
				minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_PASS_COUNT)
			map:SetMinimapOceanMaskBlurParameters(minimap_ocean_tuning.MASK_BLUR_SIZE,
				minimap_ocean_tuning.MASK_BLUR_PASS_COUNT)

			if World.ismastersim then World:AddComponent("cloudpuffmanager") end
		end
	end

	AddSimPostInit(HamletcloudPostInit)
end

modimport("scripts/ham_fx.lua")


---------------------
modimport("scripts/cooking_tropical")
modimport("scripts/standardcomponents")



STRINGS.ACTIONS.JUMPIN.USE = STRINGS.ACTIONS.USEITEM
ACTIONS.JUMPIN.strfn = function(act)
	return act.doer ~= nil and act.doer:HasTag("playerghost") and "HAUNT"
		or act.target ~= nil and act.target:HasTag("stairs") and "USE"
		or nil
end
