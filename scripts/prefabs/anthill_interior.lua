local assets =
{
	Asset("ANIM", "anim/ant_cave_door.zip"),
	Asset("ANIM", "anim/maparuina.zip"),
}


local function createroom(inst)
	--------------------------------------------------inicio da criacao---------------------------------------
	if TheWorld.components.contador then
		TheWorld.components.contador:Increment(1)
	end
	local x = TheWorld.components.contador:GetX()
	local y = 0
	local z = TheWorld.components.contador:GetZ()

	---------------------------cria a parede inicio------------------------------------------------------------------	
	local tipodemuro = "wall_tigerpond"
	---------------------------cria a parede inicio -------------------------------------
	---------------------------parade dos aposento------------------------------------------------------------------	

	x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
	inst.Transform:SetPosition(x, 0, z)

	local POS = {}
	for x = -8.5, 9.5 do
		for z = -13.5, 13.5 do
			if x == -8.5 or x == 9.5 or z == -13.5 or z == 13.5 then
				table.insert(POS, { x = x, z = z })
			end
		end
	end


	local count = 0
	for _, v in pairs(POS) do
		count = count + 1
		local part = SpawnPrefab(tipodemuro)
		part.Transform:SetPosition(x + v.x, 0, z + v.z)
	end

	----------------parede do fundo---------------------------------------------
	local part = SpawnPrefab("interior_wall_antcave_wall_rock")
	if part ~= nil then
		part.Transform:SetPosition(x - 3.8, 0, z)
		part.Transform:SetRotation(0)
	end

	------------------------piso-------------------------------------------------------------------------------
	if inst.tipodesala == 2 then
		local part = SpawnPrefab("anthill_floor")
		if part ~= nil then
			part.Transform:SetPosition(x - 4, 0, z)
		end
	else
		local part = SpawnPrefab("interior_floor_antcave")
		if part ~= nil then
			part.Transform:SetPosition(x - 4, 0, z)
		end
	end
	---------------------------------itens de dentro-------------------------------------------------------------------------
	local depth = 18
	local width = 26
	local saladarainha = false
	local chamber = false
	local comum = false
	local defalt = false
	local pertodarainha = false
	local entradadarainha = false

	if inst.tipodesala == 0 then
		comum = true
		defalt = true
	end
	if inst.tipodesala == 1 then
		comum = true
		defalt = true
		entradadarainha = true
	end
	if inst.tipodesala == 2 then
		comum = true
		chamber = true
		pertodarainha = true
	end
	if inst.tipodesala == 3 then
		comum = true
		saladarainha = true
	end

	if inst.tipodesala == 8 then
		comum = true
		defalt = false
	end

	local function getlocationoutofcenter(dist, hole, valor, invert)
		local pos = (math.random() * ((dist / 2) - (hole / 2))) + hole / 2
		if invert or (valor and math.random() < 0.5) then
			pos = pos * -1
		end
		return pos
	end
	------------------------------------adiciona para todos coisas dentro---------------------------------------------------------

	local function getOffsetBackX()
		return (math.random(0, 0.3) * 7) - (7 / 2)
	end

	local function getOffsetFrontX()
		return (math.random(0.7, 1.0) * 7) - (7 / 2)
	end

	local function getOffsetLhsZ()
		return (math.random(0, 0.3) * 13) - (13 / 2)
	end

	local function getOffsetRhsZ()
		return (math.random(0.7, 1.0) * 13) - (13 / 2)
	end


	-------------------adiciona as lanternas-----------------------------------
	if not saladarainha then
		if math.random(1, 2) == 1 then
			local part = SpawnPrefab("ant_cave_lantern")
			if part ~= nil then
				part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetLhsZ())
				part.Transform:SetRotation(-90)
			end
		end


		if math.random(1, 2) == 1 then
			local part = SpawnPrefab("ant_cave_lantern")
			if part ~= nil then
				part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetRhsZ())
				part.Transform:SetRotation(-90)
			end
		end

		if math.random(1, 2) == 1 then
			local part = SpawnPrefab("ant_cave_lantern")
			if part ~= nil then
				part.Transform:SetPosition(x + getOffsetFrontX(), 0, z + getOffsetLhsZ())
				part.Transform:SetRotation(-90)
			end
		end

		if math.random(1, 2) == 1 then
			local part = SpawnPrefab("ant_cave_lantern")
			if part ~= nil then
				part.Transform:SetPosition(x + getOffsetFrontX(), 0, z + getOffsetRhsZ())
				part.Transform:SetRotation(-90)
			end
		end
	end
	----------------------------------------------------------------------

	local salaaleatoria = math.random(1, 4)

	----------------------entrada da chamber da rainha---------------------------------------------------
	if entradadarainha == true then
		salaaleatoria = 4
		pertodarainha = true
		local part = SpawnPrefab("maze_anthill_queen")
		if part ~= nil then
			part.Transform:SetPosition(x + 3, 0, z + 3)
		end
	end

	if inst.tipodesala == 8 then
		salaaleatoria = 2
	end

	if salaaleatoria == 1 then
		local part = SpawnPrefab("antcombhomecave")
		if part ~= nil then
			part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetLhsZ())
		end

		local part = SpawnPrefab("antcombhomecave")
		if part ~= nil then
			part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetRhsZ())
		end

	end

	if salaaleatoria == 3 then
		local part = SpawnPrefab("antcombhomecave")
		if part ~= nil then
			part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetLhsZ())
		end

		local part = SpawnPrefab("antcombhomecave")
		if part ~= nil then
			part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetLhsZ())
		end

		local part = SpawnPrefab("antchest")
		if part ~= nil then
			part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetLhsZ())
		end

		local part = SpawnPrefab("antchest")
		if part ~= nil then
			part.Transform:SetPosition(x + getOffsetBackX(), 0, z + getOffsetRhsZ())
		end
	end
	-------------------------------------adiciona soldados e lanterna na sala da rainha-------------------
	if saladarainha then
		for i = 1, math.random(2, 4) do
			local part = SpawnPrefab("ant_cave_lantern")
			if part ~= nil then
				part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 5, true), 0,
					z + getlocationoutofcenter(width * 0.65, 5, true))
			end
		end
	end
	-------------------------------------adiciona decoração do chamber-------------------
	if chamber then
		for i = 1, math.random(8, 16) do
			local part = SpawnPrefab("rock_antcave")
			if part ~= nil then
				part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0,
					z + getlocationoutofcenter(width * 0.65, 3, true))
			end
		end

		if math.random() < 0.3 then
			local part = SpawnPrefab("deco_hive_debris")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.65 * math.random() - depth * 0.65 / 2, 0,
					z + width * 0.65 * math.random() - width * 0.65 / 2)
			end
		end

		if math.random() < 0.3 then
			local part = SpawnPrefab("deco_hive_debris")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.65 * math.random() - depth * 0.65 / 2, 0,
					z + width * 0.65 * math.random() - width * 0.65 / 2)
			end
		end

		local drips = math.random(1, 6) - 1
		while drips > 0 do
			local choice = math.random(1, 4)
			if choice == 1 then
				local part = SpawnPrefab("deco_cave_honey_drip_1")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + getlocationoutofcenter(width * 0.65, 3, true))
					part.Transform:SetRotation(-90)
				end
			elseif choice == 2 then
				local part = SpawnPrefab("deco_cave_ceiling_drip_2")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + getlocationoutofcenter(width * 0.65, 3, true))
					part.Transform:SetRotation(-90)
				end
			elseif choice == 3 then
				if math.random() < 0.5 then
					local part = SpawnPrefab("deco_cave_honey_drip_side_1")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z - width / 2)
						part.Transform:SetRotation(-90)
					end
				else
					local part = SpawnPrefab("deco_cave_honey_drip_side_1")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z + width / 2)
						part.Transform:SetRotation(180)
					end
				end
			elseif choice == 4 then
				if math.random() < 0.5 then
					local part = SpawnPrefab("deco_cave_honey_drip_side_2")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z - width / 2)
						part.Transform:SetRotation(-90)
					end
				else
					local part = SpawnPrefab("deco_cave_honey_drip_side_2")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z + width / 2)
						part.Transform:SetRotation(180)
					end
				end
			end

			drips = drips - 1
		end
	end
	--------------adiciona decoração comum-------------------------
	if comum then
		local part = SpawnPrefab("deco_hive_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 2)
			part.Transform:SetRotation(-90)
		end

		local part = SpawnPrefab("deco_hive_cornerbeam")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z + width / 2)
			part.Transform:SetRotation(180)
		end

		local part = SpawnPrefab("deco_hive_pillar_side")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z - width / 2)
			part.Transform:SetRotation(-90)
		end

		local part = SpawnPrefab("deco_hive_pillar_side")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z + width / 2)
			part.Transform:SetRotation(180)
		end

		local part = SpawnPrefab("deco_hive_floor_trim")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z - width / 4)
			part.Transform:SetRotation(-90)
		end

		local part = SpawnPrefab("deco_hive_floor_trim")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z)
			part.Transform:SetRotation(-90)
		end

		local part = SpawnPrefab("deco_hive_floor_trim")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z + width / 4)
			part.Transform:SetRotation(-90)
		end
	end

	----------------------------------------decoração normalmente habilitado com a comum-------------------------
	if defalt then
		if math.random() < 0.5 then
			local part = SpawnPrefab("rock_antcave")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 * 0.65 * math.random(), 0,
					z + getlocationoutofcenter(width * 0.65, 3, true))
			end
		end

		if math.random() < 0.5 then
			local part = SpawnPrefab("rock_antcave")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 * 0.65 * math.random(), 0,
					z + getlocationoutofcenter(width * 0.65, 3, true))
			end
		end

		if math.random() < 0.5 then
			local part = SpawnPrefab("rock_antcave")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 * 0.65 * math.random(), 0,
					z + getlocationoutofcenter(width * 0.65, 3, true))
			end
		end

		if math.random() < 0.3 then
			local part = SpawnPrefab("deco_hive_debris")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.65 * math.random() - depth * 0.65 / 2, 0,
					z + width * 0.65 * math.random() - width * 0.65 / 2)
			end
		end

		if math.random() < 0.3 then
			local part = SpawnPrefab("deco_hive_debris")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.65 * math.random() - depth * 0.65 / 2, 0,
					z + width * 0.65 * math.random() - width * 0.65 / 2)
			end
		end

		local drips = math.random(1, 6) - 1
		while drips > 0 do
			local choice = math.random(1, 4)
			if choice == 1 then
				local part = SpawnPrefab("deco_cave_honey_drip_1")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + getlocationoutofcenter(width * 0.65, 3, true))
					part.Transform:SetRotation(-90)
				end
			elseif choice == 2 then
				local part = SpawnPrefab("deco_cave_ceiling_drip_2")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + getlocationoutofcenter(width * 0.65, 3, true))
					part.Transform:SetRotation(-90)
				end
			elseif choice == 3 then
				if math.random() < 0.5 then
					local part = SpawnPrefab("deco_cave_honey_drip_side_1")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z - width / 2)
						part.Transform:SetRotation(-90)
					end
				else
					local part = SpawnPrefab("deco_cave_honey_drip_side_1")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z + width / 2)
						part.Transform:SetRotation(180)
					end
				end
			elseif choice == 4 then
				if math.random() < 0.5 then
					local part = SpawnPrefab("deco_cave_honey_drip_side_2")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z - width / 2)
						part.Transform:SetRotation(-90)
					end
				else
					local part = SpawnPrefab("deco_cave_honey_drip_side_2")
					if part ~= nil then
						part.Transform:SetPosition(x + getlocationoutofcenter(depth * 0.65, 3, true), 0, z + width / 2)
						part.Transform:SetRotation(180)
					end
				end
			end

			drips = drips - 1
		end
	end
	----------------------------------------Adiciona sala da rainha------

	if saladarainha then
		comum = true

		local part = SpawnPrefab("antqueen")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
		end

		local part = SpawnPrefab("ant_cave_lantern")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z)
		end

		local part = SpawnPrefab("ant_cave_lantern")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z + (depth / 2) - 2)
		end

		local part = SpawnPrefab("ant_cave_lantern")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z + (-depth / 2) + 2)
		end

		local part = SpawnPrefab("ant_cave_lantern")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z + (depth / 2) + 1)
		end

		local part = SpawnPrefab("ant_cave_lantern")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z + (-depth / 2) - 1)
		end

		-- Gross
		local part = SpawnPrefab("throne_wall_large")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z + 2.25)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.2, 0, z + 2.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.9, 0, z + 3)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.6, 0, z + 3.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.3, 0, z + 4)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z + 4.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 0.7, 0, z + 5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 0.4, 0, z + 5.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 0.1, 0, z + 6)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 0.4, 0, z + 6)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z + 1.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3, 0, z + 2)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.75, 0, z + 2.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.5, 0, z + 3)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.25, 0, z + 3.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + 4)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.75, 0, z + 4.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.5, 0, z + 5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.25, 0, z + 5.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1, 0, z + 6)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z + 1)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z + 0.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z - 0.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z - 1)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3.25, 0, z - 1.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 3, 0, z - 2)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.75, 0, z - 2.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.5, 0, z - 3)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.25, 0, z - 3.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z - 4)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.75, 0, z - 4.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.5, 0, z - 5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.25, 0, z - 5.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 1, 0, z - 6)
		end

		local part = SpawnPrefab("throne_wall_large")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z - 2.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 2, 0, z - 3)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.75, 0, z - 3.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z - 4)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.25, 0, z - 4.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z - 5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x + 0.75, 0, z - 5.5)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z - 6)
		end

		local part = SpawnPrefab("throne_wall")
		if part ~= nil then
			part.Transform:SetPosition(x - 0.5, 0, z - 6)
		end
	end

	inst:Remove()
end


local function SpawnPiso6(inst)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(10)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	inst.AnimState:PlayAnimation("idleant") -- or ground_ruins_slab_blue

	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	inst:DoTaskInTime(0.5, function(inst)
		if not GetClosestInstWithTag("pisoanthill", inst, 25) then inst:Remove() end
	end)

	return inst
end

local function SpawnPiso6a()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(10)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	inst.AnimState:PlayAnimation("idleinicioant")

	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	return inst
end

local function CommonRoom(tipodesala)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	inst.AnimState:SetBuild("palace")
	inst.AnimState:SetBank("palace")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	inst.AnimState:SetFinalOffset(2)

	inst.tipodesala = tipodesala

	createroom(inst)

	return inst
end

local function normalroom()
	return CommonRoom(0)
end

local function normalroominicio()
	return CommonRoom(8)
end

local function comumroom()
	return CommonRoom(1)
end

local function chamberroom()
	return CommonRoom(2)
end

local function saladarainharoom()
	return CommonRoom(3)
end

return Prefab("createanthilldefaltroom", normalroom, assets),
	Prefab("createanthilldefaltroominicio", normalroominicio, assets),
	Prefab("createanthillchamberroom", chamberroom, assets),
	Prefab("createanthillcomumroom", comumroom, assets),
	Prefab("createanthillqueenroom", saladarainharoom, assets),

	Prefab("mapaant", SpawnPiso6, assets),
	Prefab("mapainicioant", SpawnPiso6a, assets)
