local assets =
{
	Asset("ANIM", "anim/pisolavarena.zip"),
	Asset("ANIM", "anim/quagmire_park_fence.zip"),
}

local BASEMENT_SHADE = 0.5
local TAMANHODOMAPA = 1

local function OnSave(inst, data)
	data.entrada = inst.entrada
end


local function OnLoad(inst, data)
	if data == nil then return end
	if data.entrada then inst.entrada = data.entrada end
end

local function DoShineFlick(inst)
	inst.AnimState:SetHaunted(true)
end

local function OnActivateByOther(inst, source, doer)
	if doer ~= nil and doer.Physics ~= nil then
		doer.Physics:CollidesWith(COLLISION.WORLD)
	end
end

local function PlayTravelSound(inst, doer)
	inst.SoundEmitter:PlaySound("dontstarve/cave/rope_down")
end


local function OnMouseOver(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	inst.highlightchildren = TheSim:FindEntities(x, y, z, 0, { "DECOR" })
end

local function OnActivate(inst, doer)
	if doer:HasTag("player") then
		if doer.components.talker ~= nil then
			doer.components.talker:ShutUp()
		end
	else
		inst.SoundEmitter:PlaySound("dontstarve/cave/rope_up")
	end
end

local function OnNearEntrance(inst, chain)

end

local function OnFarEntrance(inst, chain)

end

local function OnAccept(inst, giver, item)
	inst.components.inventory:DropItem(item)
	inst.components.teleporter:Activate(item)
end


local function entrance()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	inst.AnimState:SetBuild("lavaarena_portal")
	inst.AnimState:SetBank("lavaarena_portal")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	inst.AnimState:SetFinalOffset(2)

	inst.Transform:SetEightFaced()

	inst.MiniMapEntity:SetIcon("minimap_volcano_entrance.tex")
	inst:SetDeployExtraSpacing(2.5)

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("mouseover", OnMouseOver)
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		DoShineFlick(inst)

		return inst
	end


	inst:AddComponent("inspectable")
	--    inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("teleporter")
	inst.components.teleporter.onActivate = OnActivate
	inst.components.teleporter.onActivateByOther = OnActivateByOther
	inst.components.teleporter.offset = 0
	inst.components.teleporter.travelcameratime = 0.6
	inst.components.teleporter.travelarrivetime = 0.5

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(4, 5)
	inst.components.playerprox.onnear = OnNearEntrance
	inst.components.playerprox.onfar = OnFarEntrance

	inst:AddComponent("inventory")

	inst:AddComponent("trader")
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = OnAccept
	inst.components.trader.deleteitemonaccept = false

	if inst.entrada == nil then
		--	local tries = 0
		local basement_position = nil
		--	while true do	
		local x = -1600
		local z = -1800

		basement_position = { x, 0, z }

		inst.exit = SpawnPrefab("lavaarena_portal")
		inst.exit.Transform:SetPosition(unpack(basement_position))

		---------------------------cria a parede inicio------------------------------------------------------------------	
		local y = 0

		x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
		inst.Transform:SetPosition(x, 0, z)

		--tamanho do mapa	
		local POS = {}
		--multiplo de 27 + metade dele	
		for x = -27 * TAMANHODOMAPA - 13, 27 * TAMANHODOMAPA + 13 do
			for z = -27 * TAMANHODOMAPA - 13, 27 * TAMANHODOMAPA + 13 do
				if x == 27 * TAMANHODOMAPA + 13 or x == -27 * TAMANHODOMAPA - 13 or z == 27 * TAMANHODOMAPA + 13 or z == -27 * TAMANHODOMAPA - 13 then
					table.insert(POS, { x = x, z = z })
				end
			end
		end


		local count = 0
		for _, v in pairs(POS) do
			count = count + 1
			local part = SpawnPrefab("grade")
			part.Transform:SetPosition(x + v.x, 0, z + v.z)
		end


		-----------------------------------cercados internos---------------------------------------------------------------
		---------------------------cria a parede inicio------------------------------------------------------------------	
		local y = 0

		x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
		inst.Transform:SetPosition(x, 0, z)

		--tamanho do mapa	
		local POS = {}
		--multiplo de 27 + metade dele	
		for x = -27 * TAMANHODOMAPA - 13, 27 * TAMANHODOMAPA + 13 do
			for z = -27 * TAMANHODOMAPA - 13, 27 * TAMANHODOMAPA + 13 do
				if (x == -10 and z ~= 0 and z ~= -2 and z ~= 2 and z ~= -1 and z ~= 1) or (x == 10 and z ~= 0) then
					table.insert(POS, { x = x, z = z })
				end

			end
		end

		local count = 0
		for _, v in pairs(POS) do
			count = count + 1
			local part = SpawnPrefab("grade")
			part.Transform:SetPosition(x + v.x, 0, z + v.z)
		end

		------------------------portoes trancados--------------------------------
		local part = SpawnPrefab("teleportato_sw_base")
		if part ~= nil then
			part.Transform:SetPosition(x + 20, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_teambanner")
		if part ~= nil then
			part.Transform:SetPosition(x - 10, 0, z + 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end


		local part = SpawnPrefab("quagmire_park_gate")
		if part ~= nil then
			part.Transform:SetPosition(x + 10, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("quagmire_key_park")
		if part ~= nil then
			part.Transform:SetPosition(x + 8, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_teambanner")
		if part ~= nil then
			part.Transform:SetPosition(x - 10, 0, z - 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_center")
		if part ~= nil then
			part.Transform:SetPosition(x - 20, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spawner")
		if part ~= nil then
			part.Transform:SetPosition(x - 27 * TAMANHODOMAPA - 8, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spawner")
		if part ~= nil then
			part.Transform:SetPosition(x - 27 * TAMANHODOMAPA - 8, 0, z - 27 * TAMANHODOMAPA - 8)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spawner")
		if part ~= nil then
			part.Transform:SetPosition(x - 27 * TAMANHODOMAPA - 8, 0, z + 27 * TAMANHODOMAPA + 8)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spawner")
		if part ~= nil then
			part.Transform:SetPosition(x - 15, 0, z + 27 * TAMANHODOMAPA + 8)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spawner")
		if part ~= nil then
			part.Transform:SetPosition(x - 15, 0, z - 27 * TAMANHODOMAPA - 8)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_boarlord")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z - 15)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spectator3")
		if part ~= nil then
			part.Transform:SetPosition(x + 25, 0, z - 10)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spectator4")
		if part ~= nil then
			part.Transform:SetPosition(x + 25, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spectator2")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z + 23)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("lavaarena_spectator1")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z + 10)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		local POS = {}
		local POS1 = {}
		local POS2 = {}
		local POS3 = {}
		local POS4 = {}




		for x = -27 * TAMANHODOMAPA, 27 * TAMANHODOMAPA do
			for z = -27 * TAMANHODOMAPA, 27 * TAMANHODOMAPA do
				-- adiciona na tabela POS multiplos de 27 que e o tamanho do mapa
				if math.fmod(x, 27) == 0 and math.fmod(z, 27) == 0 then
					table.insert(POS, { x = x, z = z })
				end			
			end
		end

		local count = 0
		for _, v in pairs(POS) do
			count = count + 1
			if x < -10 then
				local part = SpawnPrefab("pisolavarena1")
				part.Transform:SetPosition(x + v.x, 0, z + v.z)
			else
				local part = SpawnPrefab("pisogorge1")
				part.Transform:SetPosition(x + v.x, 0, z + v.z)
			end
			print("x")
		end

		for _, v in pairs(POS1) do
			local part = SpawnPrefab("flamegeyser")
			if part ~= nil then
				part.Transform:SetPosition(x + v.x + math.random(-13, 13), 0, z + v.z + math.random(-13, 13))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end

		for _, v in pairs(POS2) do
			local part = SpawnPrefab("dragoonden")
			if part ~= nil then
				part.Transform:SetPosition(x + v.x + math.random(-13, 13), 0, z + v.z + math.random(-13, 13))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end


		for _, v in pairs(POS3) do
			local part = SpawnPrefab("volcano_shrub")
			if part ~= nil then
				part.Transform:SetPosition(x + v.x + math.random(-13, 13), 0, z + v.z + math.random(-13, 13))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end

		for _, v in pairs(POS4) do
			local part = SpawnPrefab("skeleton")
			if part ~= nil then
				part.Transform:SetPosition(x + v.x + math.random(-13, 13), 0, z + v.z + math.random(-13, 13))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end


		if inst.caverna == nil then

			inst.caverna = 1
		end

		inst:DoTaskInTime(1, function(inst)
			local portaentrada = SpawnPrefab("lavaarena_portal")
			local a, b, c = inst.Transform:GetWorldPosition()
			portaentrada.Transform:SetPosition(a, b, c)
			portaentrada.components.teleporter.targetTeleporter = inst.exit
			inst.exit.components.teleporter.targetTeleporter = portaentrada


			local portaentrada = SpawnPrefab("beaverhead")
			portaentrada.Transform:SetPosition(a, b, c - 6)
			local portaentrada = SpawnPrefab("beaverhead")
			portaentrada.Transform:SetPosition(a, b, c + 6)
			local portaentrada = SpawnPrefab("beaverhead")
			portaentrada.Transform:SetPosition(a + 6, b, c)
			local portaentrada = SpawnPrefab("beaverhead")
			portaentrada.Transform:SetPosition(a - 6, b, c)

			inst:Remove()
		end)

		inst.entrada = 1
	end

	inst.components.teleporter.targetTeleporter = inst.exit
	inst.exit.components.teleporter.targetTeleporter = inst
	inst:ListenForEvent("starttravelsound", PlayTravelSound)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

local function SpawnPiso1(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pisolavarena")
	inst.AnimState:SetBuild("pisolavarena")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(5)
	inst.AnimState:OverrideShade(BASEMENT_SHADE)

	--tamanho do chao
	inst.AnimState:SetScale(8, 8)
	inst.AnimState:PlayAnimation("piso1")
	inst:AddTag("NOCLICK")

	return inst
end

local function SpawnPiso2(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pisolavarena")
	inst.AnimState:SetBuild("pisolavarena")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(5)
	inst.AnimState:OverrideShade(BASEMENT_SHADE)

	--tamanho do chao
	inst.AnimState:SetScale(8, 8)
	inst.AnimState:PlayAnimation("piso2")
	inst:AddTag("NOCLICK")

	return inst
end

local function SpawnPiso3(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pisolavarena")
	inst.AnimState:SetBuild("pisolavarena")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(5)
	inst.AnimState:OverrideShade(BASEMENT_SHADE)

	--tamanho do chao
	inst.AnimState:SetScale(4, 4)
	inst.AnimState:PlayAnimation("piso3")
	inst:AddTag("NOCLICK")

	return inst
end

local function SpawnPiso4(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pisolavarena")
	inst.AnimState:SetBuild("pisolavarena")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(5)
	inst.AnimState:OverrideShade(BASEMENT_SHADE)

	--tamanho do chao
	inst.AnimState:SetScale(8, 8)
	inst.AnimState:PlayAnimation("piso4")

	inst:AddTag("NOCLICK")

	return inst
end

local function wall_common()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.Transform:SetEightFaced()

	inst:AddTag("blocker")
	local phys = inst.entity:AddPhysics()
	phys:SetMass(0)
	phys:SetCollisionGroup(COLLISION.WORLD)
	phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.ITEMS)
	phys:CollidesWith(COLLISION.CHARACTERS)
	phys:CollidesWith(COLLISION.GIANTS)
	phys:CollidesWith(COLLISION.FLYERS)
	phys:SetCapsule(0.5, 50)

	inst.AnimState:SetBank("quagmire_park_fence")
	inst.AnimState:SetBuild("quagmire_park_fence")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("NOCLICK")


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	return inst
end

local function wall_common2()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.Transform:SetEightFaced()

	inst:AddTag("blocker")
	local phys = inst.entity:AddPhysics()
	phys:SetMass(0)
	phys:SetCollisionGroup(COLLISION.WORLD)
	phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.ITEMS)
	phys:CollidesWith(COLLISION.CHARACTERS)
	phys:CollidesWith(COLLISION.GIANTS)
	phys:CollidesWith(COLLISION.FLYERS)
	phys:SetCapsule(0.5, 50)

	inst.AnimState:SetBank("quagmire_park_fence")
	inst.AnimState:SetBuild("quagmire_park_fence")
	inst.AnimState:PlayAnimation("idle_short")

	inst:AddTag("NOCLICK")


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	return inst
end
-- TODO 重写
return Prefab("lavaarena_entrance", entrance),
	Prefab("pisolavarena1", SpawnPiso1, assets),
	Prefab("pisolavarena2", SpawnPiso2, assets),
	Prefab("pisogorge1", SpawnPiso3, assets),
	Prefab("pisogorge2", SpawnPiso4, assets),
	Prefab("grade", wall_common, assets),
	Prefab("gradepequena", wall_common2, assets)
