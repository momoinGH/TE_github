local InteriorSpawnerUtils = require("interiorspawnerutils")
local function OnSave(inst, data)
	data.entrada = inst.entrada
end


local function OnLoad(inst, data)
	if data == nil then return end
	if data.entrada then inst.entrada = data.entrada end
end

local function OnActivateByOther(inst, source, doer)
	--	if not inst.sg:HasStateTag("open") then
	--		inst.sg:GoToState("opening")
	--	end
	if doer ~= nil and doer.Physics ~= nil then
		doer.Physics:CollidesWith(COLLISION.WORLD)
	end
end

local function PlayTravelSound(inst, doer)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
end

local function OnActivate(inst, doer)
	if doer:HasTag("player") then
		if doer.components.talker ~= nil then
			doer.components.talker:ShutUp()
		end
	else
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
	end
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

	--    inst.AnimState:SetBuild("palace")
	--    inst.AnimState:SetBank("palace")
	--    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	inst.AnimState:SetFinalOffset(2)

	inst.Transform:SetEightFaced()

	inst.MiniMapEntity:SetIcon("minimap_volcano_entrance.tex")




	inst:SetDeployExtraSpacing(2.5)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
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

	inst:AddComponent("inventory")

	inst:AddComponent("trader")
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = OnAccept
	inst.components.trader.deleteitemonaccept = false


	--		if inst.components.teleporter.targetTeleporter ~= nil then
	--		inst:RemoveEventCallback("onbuilt", OnBuilt)
	--		return
	--	end
	if inst.entrada == nil then
		local x = 0
		local y = 0
		local z = 0
		if TheWorld.components.contador then TheWorld.components.contador:Increment(1) end
		local numerounico = TheWorld.components.contador.count

		x = TheWorld.components.contador:GetX()
		y = 0
		z = TheWorld.components.contador:GetZ()

		inst.exit = SpawnPrefab("house_city_exit_door")
		inst.exit.initData = { anim = "idle_basic" }
		InteriorSpawnerUtils.InitHouseInteriorPrefab(inst.exit, inst.exit.initData)
		inst.exit.Transform:SetPosition(x + 5.2, 0, z + 0.5)
		---------------------------cria a parede inicio------------------------------------------------------------------	
		local tipodemuro = "wall_invisible"
		---------------------------cria a parede inicio -------------------------------------
		---------------------------parade dos aposento------------------------------------------------------------------	
		local y = 0

		x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
		inst.Transform:SetPosition(x, 0, z)

		local POS = {}
		for x = -5.5, 5.5 do
			for z = -8.5, 8.5 do
				if x == -5.5 or x == 5.5 or z == -8.5 or z == 8.5 then
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
		local part = SpawnPrefab("interior_wall_upholstered")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.8, 0, z)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		---------------------------------itens de dentro----------------------------
		local part = SpawnPrefab("shelves_midcentury")
		if part ~= nil then
			part.Transform:SetPosition(x - 4.5, 0, z + 4)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("musac")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_roomglow")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pigman_hunter_shopkeep")
		if part ~= nil then
			part.Transform:SetPosition(x - 3, 0, z)
			part.sg:GoToState("desk_pre")
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shield_axes")
		if part ~= nil then
			part.Transform:SetPosition(x - 15 / 2, 0, z)
			part.Transform:SetRotation(90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("rug_porcupuss")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z - 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("rug_fur")
		if part ~= nil then
			part.Transform:SetPosition(x + 2, 0, z + 4)
			part.Transform:SetRotation(90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("rug_catcoon")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + 4)
			part.Transform:SetRotation(90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_weapon_beam1")
		if part ~= nil then
			part.Transform:SetPosition(x - 5, 0, z + 15 / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_weapon_beam1")
		if part ~= nil then
			part.Transform:SetPosition(x - 5, 0, z - 15 / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_weapon_beam2")
		if part ~= nil then
			part.Transform:SetPosition(x + 4.7, 0, z + 15 / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_weapon_beam2")
		if part ~= nil then
			part.Transform:SetPosition(x + 4.7, 0, z - 15 / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("window_square_weapons_backwall")
		if part ~= nil then
			part.Transform:SetPosition(x + 1, 0, z - 15 / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("swinging_light_basic_metal")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z - 4.5)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		--[[
	local part = SpawnPrefab("swinging_light_basic_metal")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z +3)
	part.Transform:SetRotation(-90)
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	
]]
		local part = SpawnPrefab("swinging_light_basic_metal")
		if part ~= nil then
			part.Transform:SetPosition(x + 3, 0, z + 6.5)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_antiquities_beefalo_side")
		if part ~= nil then
			part.Transform:SetPosition(x - 2, 0, z + 15 / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end


		local part = SpawnPrefab("closed_chest")
		if part ~= nil then
			part.Transform:SetPosition(x + 4.5, 0, z - (15 / 2) + 1.5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_displaycase")
		if part ~= nil then
			part.Transform:SetPosition(x - 4, 0, z - 5.5)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_displaycase")
		if part ~= nil then
			part.Transform:SetPosition(x - 4, 0, z - 4)
			--	part.Transform:SetRotation(90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.5, 0, z - 2)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 0.5, 0, z - 2.5)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 1.5, 0, z - 5)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x - 1.5, 0, z - 5.5)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z + 3.5)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 3.5, 0, z + 2.5)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("shop_buyer")
		if part ~= nil then
			part.Transform:SetPosition(x + 2.5, 0, z + 5.5)
			part.startAnim = "idle_cablespool"
			part.AnimState:PlayAnimation("idle_cablespool")
			part.shoptype = "pig_shop_weapons"
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		------------------------portoes trancados--------------------------------
		local part = SpawnPrefab("interior_floor_herringbone")
		if part ~= nil then
			part.Transform:SetPosition(x - 2.7, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
		----------------------------criature dentro das jaulas-------------------------------------------------------------

		if inst.caverna == nil then
			inst.caverna = 1
		end


		--------------------------------------------cria o piso e itens fim -------------------------------------------------------	










		inst:DoTaskInTime(1, function(inst)
			local portaentrada = SpawnPrefab("pig_shop_weapons")
			local a, b, c = inst.Transform:GetWorldPosition()
			portaentrada.Transform:SetPosition(a, b, c)
			portaentrada.components.teleporter.targetTeleporter = inst.exit
			inst.exit.components.teleporter.targetTeleporter = portaentrada

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

return Prefab("pig_shop_weapons_entrance", entrance)
