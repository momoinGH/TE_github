local assets =
{
	Asset("ANIM", "anim/wallhamletpig.zip"),
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
	Asset("ANIM", "anim/interior_wall_decals_ruins.zip"),
	Asset("ANIM", "anim/interior_wall_decals_ruins_cracks_fake.zip"),

	Asset("ANIM", "anim/maparuina.zip"),
}

local northexitopen = nil
local southexitopen = nil
local eastexitopen = nil
local westexitopen = nil


local function makechoice(list)
	local item = nil
	local total = 0
	for i = 1, #list do
		total = total + list[i][2]
	end

	local choice = math.random(1, total)
	total = 0
	local last = 0
	local top = 0
	--    print("-------------")
	for i = 1, #list do
		top = top + list[i][2]
		--     print("CHECK",last,top,choice)
		if choice > last and choice <= top then
			--        print("CHECK TRUE")
			item = list[i][1]
			break
		end
		last = top
	end
	assert(item)
	return item
end

local function createroom(inst)
	--------------------------------------------------inicio da criacao---------------------------------------

	local x = 0
	local y = 0
	local z = 0
	if TheWorld.components.contador then TheWorld.components.contador:Increment(1) end
	local numerounico = TheWorld.components.contador.count

	x = TheWorld.components.contador:GetX()
	y = 0
	z = TheWorld.components.contador:GetZ()

	---------------------------cria a parede inicio------------------------------------------------------------------	
	local tipodemuro = "wall_tigerpond"
	---------------------------parade dos aposento------------------------------------------------------------------	
	local y = 0

	x, z = math.floor(x) + 0.5, math.floor(z) + 0.5 --matching with normal walls
	inst.Transform:SetPosition(x, 0, z)

	local POS = {}
	for x = -8, 9 do
		for z = -12.5, 12.5 do
			if x == -8 or x == 9 or z == -12.5 or z == 12.5 then
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



	----------------parede---------------------------------------------
	local roomcolor = inst.roomcolor
	local part = SpawnPrefab("interior_wall_pig_ruins")
	if part ~= nil then
		part.Transform:SetPosition(x - 1, 0, z)
		part.Transform:SetRotation(0)
		if part.components.health ~= nil then
			part.components.health:SetPercent(1)
		end
	end

	------------------------piso--------------------------------
	if roomcolor == "_blue" then
		local part = SpawnPrefab("interior_floor_ground_ruins_slab_blue")
		if part ~= nil then
			part.Transform:SetPosition(x - 4, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	else
		local part = SpawnPrefab("interior_floor_ground_ruins_slab")
		if part ~= nil then
			part.Transform:SetPosition(x - 4, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	---------------------------------itens de dentro----------------------------
	local depth = 16
	local width = 24

	local roomtypes =
	{
		[1] = "grownover",
		[2] = "storeroom",
		[3] = "smalltreasure",
		[4] = "snakes!",
		[5] = "speartraps!",
		[6] = "darts!",
		[7] = "lightfires",
	}
	local roomtype = roomtypes[math.random(1, 7)]
	if roomtype == "lightfires" and math.random() < 0.5 then
		roomtype = nil
	end

	local sentido = 0
	local advancedtraps = true
	local nopressureplates = false
	local deepruins = nil
	local numexits = 1
	local fountain = false
	local roompheromonestone = false --RUINS_3 vira true
	local criaturas = false
	if numexits == 1 then criaturas = true end
	if numexits ~= 1 and math.random() < 0.3 then criaturas = true end

	if inst.tipodesala == 1 then roomtype = "treasure" end
	if inst.tipodesala == 2 then roompheromonestone = true end
	if inst.tipodesala == 3 then roomtype = "doortrap" end
	if inst.tipodesala == 8 then roomtype = "smalltreasure" end
	if inst.tipodesala == 9 then roomtype = "secret" end

	local function getspawnlocation(widthrange, depthrange)
		local setwidth = width * widthrange * math.random() - width * widthrange / 2
		local setdepth = depth * depthrange * math.random() - depth * depthrange / 2
		local place = true
		if fountain then
			-- filters out thigns that would place where the fountain is
			if math.abs(setwidth * setwidth) + math.abs(setdepth * setdepth) < 4 * 4 then
				place = false
			end
		end
		if place == true then
			return setwidth, setdepth
		end
	end

	local function addroomcolumn(a, b)
		if math.random() < 0.2 then
			local part = SpawnPrefab("deco_ruins_beam_room_broken" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local part = SpawnPrefab("deco_ruins_beam_room" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end

	local function addgoldstatue(a, b)
		if math.random() < 0.5 then
			local part = SpawnPrefab("pig_ruins_pig")
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local part = SpawnPrefab("pig_ruins_ant")
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end

	local function addrelicstatue(a, b, tags)
		if math.random() < 0.5 then
			local part = SpawnPrefab("pig_ruins_idol")
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				if tags then part:AddTag(tags) end
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local part = SpawnPrefab("pig_ruins_plaque")
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				if tags then part:AddTag(tags) end
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end

	local function spawnspeartrapset(depth, width, offsetx, offsetz, tags, nocenter, full, scale, pluspattern)
		local scaledist = 15
		if scale then
			scaledist = scale
		end

		if pluspattern then
			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / scaledist + offsetx, 0, z + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + offsetx, 0, z - width / scaledist + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + offsetx, 0, z + width / scaledist + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / scaledist - offsetx, 0, z + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / scaledist + offsetx, 0, z - width / scaledist + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / scaledist + offsetx, 0, z + width / scaledist + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			if not nocenter then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + offsetx, 0, z + offsetz)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / scaledist + offsetx, 0, z - width / scaledist + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / scaledist + offsetx, 0, z + width / scaledist + offsetz)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			if full then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / scaledist + offsetx, 0, z + offsetz)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / scaledist + offsetx, 0, z + offsetz)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + offsetx, 0, z - width / scaledist + offsetz)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + offsetx, 0, z + width / scaledist + offsetz)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
	end
	----------------------------------------tipos de salas inicio------------------------------------------------------------------
	if criaturas then
		local teste = math.random(1, 4)
		--[[
if teste == 1 then
	local part = SpawnPrefab("bat")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end

	local part = SpawnPrefab("bat")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end

end
if teste == 2 then
	local part = SpawnPrefab("bat")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end

	local part = SpawnPrefab("bat")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end
	
	local part = SpawnPrefab("bat")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end
end

if teste == 3 then
	local part = SpawnPrefab("scorpion")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end

	local part = SpawnPrefab("scorpion")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	
end

if teste == 4 then
	local part = SpawnPrefab("scorpion")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end
end

if teste == 5 then
	local part = SpawnPrefab("pig_ghost")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z)
	part.AnimState:PlayAnimation("north_closed")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end

end
]]
	end

	if roompheromonestone then
		local part = SpawnPrefab("pheromonestone")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	if math.random() < 0 then --Estranho parece que nunca vai acontecer
		if northexitopen then
			local part = SpawnPrefab("wallcrack_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z)
				part.AnimState:PlayAnimation("north_closed")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif westexitopen then
			local part = SpawnPrefab("wallcrack_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - width / 2)
				part.AnimState:PlayAnimation("east_closed")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif eastexitopen then
			local part = SpawnPrefab("wallcrack_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + width / 2)
				part.AnimState:PlayAnimation("west_closed")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end

	if roomtype ~= "darts!" and roomtype ~= "speartraps!" and roomtype ~= "treasure" and roomtype ~= "smalltreasure" and roomtype ~= "secret" and roomtype ~= "aporkalypse" then
		local feature = math.random(8)
		if feature == 1 then
			addroomcolumn(-depth / 6, -width / 6)
			addroomcolumn(depth / 6, width / 6)
			addroomcolumn(depth / 6, -width / 6)
			addroomcolumn(-depth / 6, width / 6)
			widepilars = true
		elseif feature == 2 then
			if roomtype ~= "doortrap" and not roompheromonestone then
				local part = SpawnPrefab("deco_ruins_fountain")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
				fountain = true
			end
			if math.random() < 0.5 then
				addroomcolumn(-depth / 6, width / 3)
				addroomcolumn(depth / 6, -width / 3)
				widepilars = true
			else
				addroomcolumn(-depth / 4, width / 4)
				addroomcolumn(-depth / 4, -width / 4)
				addroomcolumn(depth / 4, -width / 4)
				addroomcolumn(depth / 4, width / 4)
				pilars = true
			end
		elseif feature == 3 then
			addroomcolumn(-depth / 4, width / 6)
			addroomcolumn(0, width / 6)
			addroomcolumn(depth / 4, width / 6)
			addroomcolumn(-depth / 4, -width / 6)
			addroomcolumn(0, -width / 6)
			addroomcolumn(depth / 4, -width / 6)
			pilars = true
		end
	end

	if roomtype == "snakes!" then
		--for i=1,math.random(3,6) do
		--	local part = SpawnPrefab("snake_amphibious")
		--	if part ~= nil then
		--	part.Transform:SetPosition(x +depth*0.8 * math.random() - depth*0.8/2, 0, z +width*0.8 * math.random() - width*0.8/2)
		--	if part.components.health ~= nil then
		--	part.components.health:SetPercent(1)
		--	end
		--	end
		--end
	end

	if roomtype == "storeroom" then
		for i = 1, math.random(4) + 4 do
			local part = SpawnPrefab("smashingpot")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.8 * math.random() - depth * 0.8 / 2, 0,
					z + width * 0.8 * math.random() - width * 0.8 / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			local setwidth, setdepth = getspawnlocation(0.8, 0.8)
			if setwidth and setdepth then
				local part = SpawnPrefab("smashingpot")
				if part ~= nil then
					part.Transform:SetPosition(x + setdepth, 0, z + setwidth)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
	end

	if roomtype == "doortrap" then
		local setups = { "default", "default", "default", "hor", "vert" }


		if deepruins then
			if northexitopen or southexitopen then
				table.insert(setups, "longhor")
			end
			if eastexitopen or westexitopen then
				table.insert(setups, "longvert")
			end
		end
		local dado = math.random(1, #setups)

		if setups[dado] == "default" then
			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 + 3 + (math.random() * 2 - 1), 0, z + (math.random() * 2 - 1))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2 - 3 + (math.random() * 2 - 1), 0, z + (math.random() * 2 - 1))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + (math.random() * 2 - 1), 0, z + (math.random() * 2 - 1))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + (math.random() * 2 - 1), 0, z + width / 2 - 3 + (math.random() * 2 - 1))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + (math.random() * 2 - 1), 0, z - width / 2 + 3 + (math.random() * 2 - 1))
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif setups[dado] == "hor" then
			local unit = 1.5
			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + 1 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - 1 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - 2 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + 2 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + 3 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - 3 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif setups[dado] == "longvert" then
			local unit = 1.5
			local dir = {}
			if eastexitopen then
				table.insert(dir, 1)
			end
			if westexitopen then
				table.insert(dir, -1)
			end
			dir = dir[math.random(1, #dir)]
			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 1 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 1 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 2 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 2 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 3 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 3 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 4 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 4 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 5 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 5 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 6 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 6 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z + 7 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4.5 * dir, 0, z - 7 * unit)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif setups[dado] == "vert" then
			local unit = 1.5
			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 1 * unit, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 2 * unit, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 3 * unit, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 1 * unit, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 2 * unit, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 3 * unit, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif setups[dado] == "longhor" then
			local unit = 1.5
			local dir = {}
			if northexitopen then
				table.insert(dir, -1)
			end
			if southexitopen then
				table.insert(dir, 1)
			end
			dir = dir[math.random(1, #dir)]
			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 1 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 2 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 3 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 4 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + 5 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 1 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 2 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 3 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 4 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - 5 * unit, 0, z + width / 4.5 * dir)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end


	--------------------------
	if roomtype == "treasure" or roomtype == "secret" then
		if inst.treasuretype == "aporkalypse_clock" then
			local part = SpawnPrefab("aporkalypse_clock")
			if part ~= nil then
				part.Transform:SetPosition(x - 1, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			------------------------	
		elseif inst.treasuretype == "endswell" then
			local part = SpawnPrefab("deco_ruins_endswell")
			if part ~= nil then
				part.Transform:SetPosition(x - 1, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			-----------------------------------------------------	
		elseif inst.treasuretype == "oincpile" then
			local part = SpawnPrefab("oincpile52")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 7, 0, z - width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("oincpile49")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 7, 0, z - width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("oincpile46")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 7, 0, z + width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("oincpile42")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 7, 0, z + width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end


			local part = SpawnPrefab("oincpile52")
			if part ~= nil then
				part.Transform:SetPosition(x - 5, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("oincpile52")
			if part ~= nil then
				part.Transform:SetPosition(x + 5, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("oincpile52")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end


			-------------------------------------------
		elseif inst.treasuretype == "secret" then
			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 7, 0, z - width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 7, 0, z - width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 7, 0, z + width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 7, 0, z + width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			--------------------------------------
		elseif inst.treasuretype == "rarerelic" then
			local roomcolor = "_blue"

			local relic = "pig_ruins_truffle"
			if inst.relicsow then
				relic = "pig_ruins_sow"
			end

			--if not southexitopen then
			local part = SpawnPrefab(relic)
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				part:AddTag("trggerdarttraps")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 - 2, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			--[[	
elseif notnorthexitopen then
	local part = SpawnPrefab(relic)
	if part ~= nil then
	part.Transform:SetPosition(x +depth/2-2, 0, z)
	part:AddTag("trggerdarttraps")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	
	
	local part = SpawnPrefab("pig_ruins_light_beam")
	if part ~= nil then
	part.Transform:SetPosition(x +depth/2-2, 0, z)
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	
elseif not eastexitopen then
	local part = SpawnPrefab(relic)
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z +width/2-2)
	part:AddTag("trggerdarttraps")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	

	local part = SpawnPrefab("pig_ruins_light_beam")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z +width/2-2)
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end		
elseif not westexitopen then
	local part = SpawnPrefab(relic)
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z -width/2+2)
	part:AddTag("trggerdarttraps")
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end	
	
	local part = SpawnPrefab("pig_ruins_light_beam")
	if part ~= nil then
	part.Transform:SetPosition(x, 0, z -width/2-2)
	if part.components.health ~= nil then
	part.components.health:SetPercent(1)
	end
	end
end
]]

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 4, 0, z + width / 4)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 4, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 4, 0, z - width / 4)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z + width / 4)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z - width / 4)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 4, 0, z + width / 4)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 40, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 40, 0, z - width / 4)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 8, 0, z - width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 8, 0, z + width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 8, 0, z - width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.6 then
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 8, 0, z + width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end


			local function add4plates(a, b)
				if math.random() < 0.5 then
					local part = SpawnPrefab("pig_ruins_pressure_plate")
					if part ~= nil then
						part.Transform:SetPosition(x + a + depth / 18, 0, z + b - width / 18)
						part:AddTag("trap_dart")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end

				if math.random() < 0.5 then
					local part = SpawnPrefab("pig_ruins_pressure_plate")
					if part ~= nil then
						part.Transform:SetPosition(x + a - depth / 18, 0, z + b - width / 18)
						part:AddTag("trap_dart")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end

				if math.random() < 0.5 then
					local part = SpawnPrefab("pig_ruins_pressure_plate")
					if part ~= nil then
						part.Transform:SetPosition(x + a - depth / 18, 0, z + b + width / 18)
						part:AddTag("trap_dart")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end

				if math.random() < 0.5 then
					local part = SpawnPrefab("pig_ruins_pressure_plate")
					if part ~= nil then
						part.Transform:SetPosition(x + a + depth / 18, 0, z + b + width / 18)
						part:AddTag("trap_dart")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end
			end

			add4plates(depth / 4, width / 4)
			add4plates(depth / 4, 0)
			add4plates(depth / 4, -width / 4)

			add4plates(0, width / 4)
			add4plates(0, 0)
			add4plates(0, -width / 4)

			add4plates(-depth / 4, width / 4)
			add4plates(-depth / 4, 0)
			add4plates(-depth / 4, -width / 4)

			local part = SpawnPrefab("pig_ruins_pigman_relief_dart" .. math.random(4) .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 3)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 + 2, 0, z - width / 3)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if northexitopen then
				local part = SpawnPrefab("pig_ruins_pigman_relief_dart" .. math.random(4) .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2 + 2, 0, z)
					part:AddTag("trap_dart")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_dart" .. math.random(4) .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 3)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2 + 2, 0, z + width / 3)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_leftside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 4, 0, z - width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 4, 0, z - width / 2 + 2)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if westexitopen then
				local part = SpawnPrefab("pig_ruins_pigman_relief_leftside_dart" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z - width / 2)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z - width / 2 + 2)
					part:AddTag("trap_dart")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_leftside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4, 0, z - width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4, 0, z - width / 2 + 2)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_rightside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 4, 0, z + width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 4, 0, z + width / 2 - 2)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if eastexitopen then
				local part = SpawnPrefab("pig_ruins_pigman_relief_rightside_dart" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z + width / 2)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z + width / 2 - 2)
					part:AddTag("trap_dart")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_rightside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4, 0, z + width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4, 0, z + width / 2 - 2)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2 - 2, 0, z + width / 3)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2 - 2, 0, z)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2 - 2, 0, z - width / 3)
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local setups = { "darts n relics", "spears n relics", "relics n dust" }
			local sorte = math.random(1, 3)
			if sorte == 3 then
				addgoldstatue(-depth / 3, -width / 3)
				addgoldstatue(depth / 3, width / 3)
				addrelicstatue(0, 0)
				addgoldstatue(depth / 3, -width / 3)
				addgoldstatue(-depth / 3, width / 3)
			elseif sorte == 2 then
				addrelicstatue(0, -width / 4)
				addrelicstatue(0, 0)
				addrelicstatue(0, width / 4)
				spawnspeartrapset(depth, width, 0, -width / 4, nil, true, true, 12)
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z - width / 4)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
				spawnspeartrapset(depth, width, 0, 0, nil, true, true, 12)
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
				spawnspeartrapset(depth, width, 0, width / 4, nil, true, true, 12)
				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z + width / 4)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			elseif sorte == 1 then
				addrelicstatue(0, -width / 3 + 1, "trggerdarttraps")
				addrelicstatue(depth / 4 - 1, 0, "trggerdarttraps")
				addrelicstatue(0, width / 3 - 1, "trggerdarttraps")
				roomtype = "darts!"
				nopressureplates = true
			end
		end
	end
	--------------------------------------------------------------------------------
	if roomtype == "smalltreasure" then
		local smalldado = math.random(1, 4)
		if inst.tipodesala == 8 then


		elseif smalldado == 1 then
			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + width / 7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif smalldado == 2 then
			local part = SpawnPrefab("shelves_ruins")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif smalldado == 3 then
			addgoldstatue(0, -width / 6)
			addgoldstatue(0, width / 6)
		else
			addrelicstatue(0, 0)
		end
	end

	if roomtype == "grownover" then
		for i = 1, math.random(10) + 5 do
			local part = SpawnPrefab("grass")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.8 * math.random() - depth * 0.8 / 2, 0,
					z + width * 0.8 * math.random() - width * 0.8 / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			local setwidth, setdepth = getspawnlocation(0.8, 0.8)
			if setwidth and setdepth then
				local part = SpawnPrefab("grass")
				if part ~= nil then
					part.Transform:SetPosition(x + setdepth, 0, z + setwidth)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
		for i = 1, math.random(4) + 5 do
			local part = SpawnPrefab("sapling")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.8 * math.random() - depth * 0.8 / 2, 0,
					z + width * 0.8 * math.random() - width * 0.8 / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			local setwidth, setdepth = getspawnlocation(0.8, 0.8)
			if setwidth and setdepth then
				local part = SpawnPrefab("sapling")
				if part ~= nil then
					part.Transform:SetPosition(x + setdepth, 0, z + setwidth)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
		for i = 1, math.random(10) + 10 do
			local part = SpawnPrefab("deep_jungle_fern_noise_plant")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.8 * math.random() - depth * 0.8 / 2, 0,
					z + width * 0.8 * math.random() - width * 0.8 / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			local setwidth, setdepth = getspawnlocation(0.8, 0.8)
			if setwidth and setdepth then
				local part = SpawnPrefab("deep_jungle_fern_noise_plant")
				if part ~= nil then
					part.Transform:SetPosition(x + setdepth, 0, z + setwidth)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
		local part = SpawnPrefab("lightrays")
		if part ~= nil then
			part.Transform:SetPosition(x, 0, z)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	if math.random() < 0.8 or roomtype == "lightfires" or roomtype == "darts!" then
		local part = SpawnPrefab("deco_ruins_cornerbeam" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_ruins_cornerbeam" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_ruins_cornerbeam" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z - width / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_ruins_cornerbeam" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	else
		local part = SpawnPrefab("deco_ruins_cornerbeam_heavy")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_ruins_cornerbeam_heavy" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_ruins_beam_heavy" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z - width / 2)
			part.Transform:SetRotation(-90)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("deco_ruins_beam_heavy" .. roomcolor)
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2, 0, z + width / 2)
			part.Transform:SetRotation(180)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	local prop = "deco_ruins_beam" .. roomcolor
	if math.random() < 0.2 then
		prop = "deco_ruins_beam_broken" .. roomcolor
	end

	local part = SpawnPrefab(prop)
	if part ~= nil then
		part.Transform:SetPosition(x - depth / 2, 0, z - width / 6)
		part.Transform:SetRotation(-90)
		if part.components.health ~= nil then
			part.components.health:SetPercent(1)
		end
	end

	local part = SpawnPrefab(prop)
	if part ~= nil then
		part.Transform:SetPosition(x - depth / 2, 0, z + width / 6)
		part.Transform:SetRotation(-90)
		if part.components.health ~= nil then
			part.components.health:SetPercent(1)
		end
	end


	---------------------------------------sentido--------------------------------------------	

	-------cima-----------	
	if sentido == 1 then
		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 2 + 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 3 + 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 3 - 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 + 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 + 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 3 + 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 3 - 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_north")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2, 0, z - width / 2 - 0.75)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	-------esquerda-----------	
	if sentido == 2 then
		local part = SpawnPrefab("pig_ruins_wall_vines_east")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2 + 0.75, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_east")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 3 - 0.75, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_east")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 6 - 0.75, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_east")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 6 + 0.75, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_east")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 3 - 0.75, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_east")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2 - 0.75, 0, z - width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	-------direita-----------	
	if sentido == 3 then
		local part = SpawnPrefab("pig_ruins_wall_vines_west")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 2 + 0.75, 0, z + width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_west")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 3 - 0.75, 0, z + width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_west")
		if part ~= nil then
			part.Transform:SetPosition(x - depth / 6 - 0.75, 0, z + width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_west")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 6 + 0.75, 0, z + width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_west")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 3 + 0.75, 0, z + width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end

		local part = SpawnPrefab("pig_ruins_wall_vines_west")
		if part ~= nil then
			part.Transform:SetPosition(x + depth / 2 - 0.75, 0, z + width / 2)
			if part.components.health ~= nil then
				part.components.health:SetPercent(1)
			end
		end
	end

	--------------------------spear traps-----------------------------

	if roomtype == "speartraps!" then
		local speartraps = { "spottraps", "walltrap", "wavetrap", "bait", "litfloor" }
		if deepruins and numexits > 1 then
			table.insert(speartraps, "litfloor")
		end
		if speartraps[math.random(1, 5)] == "spottraps" then
			if math.random() < 0.3 then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3, 0, z - width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3, 0, z - width / 3)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			elseif math.random() < 0.5 then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z - width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z - width / 3)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			else
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3, 0, z - width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3, 0, z - width / 3)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.3 then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3, 0, z + width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3, 0, z + width / 3)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			elseif math.random() < 0.5 then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z + width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z + width / 3)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			else
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3, 0, z + width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3, 0, z + width / 3)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if math.random() < 0.3 then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3, 0, z)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			elseif math.random() < 0.5 then
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			else
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3, 0, z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_light_beam")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3, 0, z)
					part:AddTag("localtrap")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		elseif speartraps[math.random(1, 5)] == "bait" then
			local baits = {
				{ "goldnugget", 5 },
				{ "rocks",      20 },
				{ "flint",      20 },
				{ "redgem",     1 },
				{ "relic_1",    1 },
				{ "relic_2",    1 },
				{ "relic_3",    1 },
				{ "boneshard",  5 },
				{ "meat_dried", 5 },
			}

			local offsets = { { -depth / 5, -width / 5 },
				{ depth / 5,  -width / 5 },
				{ -depth / 5, width / 5 },
				{ depth / 5,  width / 5 } }

			for i = 1, math.random(1, 3) do
				local rand = 1

				rand = math.random(1, #offsets)
				local choicex = offsets[rand][1]
				local choicez = offsets[rand][2]
				table.remove(offsets, rand)

				local loot = makechoice(deepcopy(baits))

				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + choicex, 0, z + choicez)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_pressure_plate")
				if part ~= nil then
					part.Transform:SetPosition(x + choicex, 0, z + choicez)
					part:AddTag("trap_spear")
					part:AddTag("localtrap")
					part:AddTag("reversetrigger")
					part:AddTag("startdown")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab(loot)
				if part ~= nil then
					part.Transform:SetPosition(x + choicex, 0, z + choicez)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		elseif speartraps[math.random(1, 5)] == "walltrap" then
			local angle = 0
			local traps = 14
			local anglestep = (TWOPI) / traps
			local radius = 4
			for i = 1, traps do
				local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + offset.x, 0, z + offset.z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
				angle = angle + anglestep
			end

			angle = 0
			traps = 24
			anglestep = (TWOPI) / traps
			radius = 5
			for i = 1, traps do
				local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
				local part = SpawnPrefab("pig_ruins_spear_trap")
				if part ~= nil then
					part.Transform:SetPosition(x + offset.x, 0, z + offset.z)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
				angle = angle + anglestep
			end
			local part = SpawnPrefab("relic_1")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		elseif speartraps[math.random(1, 5)] == "wavetrap" then
			if math.random() < 0.2 then
				local function setrandomspearsets(xmod, ymod, plus)
					local scaledist = 15
					if plus then
						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x - depth / scaledist + xmod, 0, z + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x + xmod, 0, z + width / scaledist + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x + depth / scaledist + xmod, 0, z + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x + xmod, 0, z - width / scaledist + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					else
						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x - depth / scaledist + xmod, 0, z - width / scaledist + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x - depth / scaledist + xmod, 0, z + width / scaledist + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x + depth / scaledist + xmod, 0, z - width / scaledist + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_spear_trap")
						if part ~= nil then
							part.Transform:SetPosition(x + depth / scaledist + xmod, 0, z + width / scaledist + ymod)
							local marca = math.random(1, 3)
							if marca == 1 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_3")
							elseif marca == 2 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_6")
							elseif marca == 3 then
								part:AddTag("timed")
								part:AddTag("up_3")
								part:AddTag("down_6")
								part:AddTag("delay_9")
							end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					end
				end

				setrandomspearsets(0, -width / 4)
				setrandomspearsets(0, 0, true)
				setrandomspearsets(0, width / 4)

				setrandomspearsets(-depth / 4, -width / 4, true)
				setrandomspearsets(-depth / 4, 0)
				setrandomspearsets(-depth / 4, width / 4, true)

				setrandomspearsets(depth / 4, -width / 4, true)
				setrandomspearsets(depth / 4, 0)
				setrandomspearsets(depth / 4, width / 4, true)
			else
				if math.random() < 0.5 then
					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x, 0, z - width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_3")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x, 0, z)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_6")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_9")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 4, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_3")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 4, 0, z)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_6")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 4, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_9")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x + depth / 4, 0, z - width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_3")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x + depth / 4, 0, z)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_6")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x + depth / 4, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_9")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				else
					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x, 0, z - width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_6")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x, 0, z)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_6")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_6")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 4, 0, z - width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_9")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 4, 0, z)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_9")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 4, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_9")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x + depth / 4, 0, z - width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_3")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x + depth / 4, 0, z)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_3")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end

					local part = SpawnPrefab("pig_ruins_spear_trap")
					if part ~= nil then
						part.Transform:SetPosition(x + depth / 4, 0, z + width / 4)
						part:AddTag("timed")
						part:AddTag("up_3")
						part:AddTag("down_6")
						part:AddTag("delay_3")
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end
			end
		elseif speartraps[math.random(1, 5)] == "litfloor" then
			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.7, 0, z - width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.5, 0, z - width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z - width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z - width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z - width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z - width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.7, 0, z - width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.5, 0, z - width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			--
			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.5, 0, z - width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.5, 0, z - width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z - width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z - width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			part:AddTag("localtrap")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z - width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z - width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z - width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.5, 0, z - width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.5, 0, z - width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.5, 0, z + width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.5, 0, z + width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z + width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z + width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x, 0, z + width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z + width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z + width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.5, 0, z + width / 6)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.5, 0, z + width / 6)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.7, 0, z + width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 2.5, 0, z + width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z + width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6, 0, z + width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z + width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6, 0, z + width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_spear_trap")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.7, 0, z + width / 2.7)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_light_beam")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2.5, 0, z + width / 2.5)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	elseif roomtype == "darts!" then
		-------------------------
		if advancedtraps and math.random() < 0.3 then
			local dardonovo = math.random(1, 4)

			if dardonovo == 1 then
				local part = SpawnPrefab("pig_ruins_dart_statue")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 8, 0, z + width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
			if dardonovo == 2 then
				local part = SpawnPrefab("pig_ruins_dart_statue")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 8, 0, z - width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
			if dardonovo == 3 then
				local part = SpawnPrefab("pig_ruins_dart_statue")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 8, 0, z + width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
			if dardonovo == 4 then
				local part = SpawnPrefab("pig_ruins_dart_statue")
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 8, 0, z - width / 8)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
			-----------------------------
		else
			local part = SpawnPrefab("pig_ruins_pigman_relief_dart" .. math.random(4) .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 3)
				part:AddTag("localtrap")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if northexitopen then
				local part = SpawnPrefab("pig_ruins_pigman_relief_dart" .. math.random(4) .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z - width / 3)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_dart" .. math.random(4) .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 3)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_leftside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 4 + (math.random() * 1 - 0.5), 0, z - width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if westexitopen then
				local part = SpawnPrefab("pig_ruins_pigman_relief_leftside_dart" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x + (math.random() * 1 - 0.5), 0, z - width / 2)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_leftside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4 + (math.random() * 1 - 0.5), 0, z - width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_rightside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 4 + (math.random() * 1 - 0.5), 0, z + width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if eastexitopen then
				local part = SpawnPrefab("pig_ruins_pigman_relief_rightside_dart" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x + (math.random() * 1 - 0.5), 0, z + width / 2)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pigman_relief_rightside_dart" .. roomcolor)
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 4 + (math.random() * 1 - 0.5), 0, z + width / 2)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
		-- if the treasure room wants dart traps, then the plates get turned off.

		if not nopressureplates then
			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6 * 2 + (math.random() * 2 - 1), 0, z + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + (math.random(2) - 1), 0, z + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			if southexitopen then
				local part = SpawnPrefab("pig_ruins_pressure_plate")
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 6 * 2 + (math.random() * 2 - 1), 0,
						z + (math.random() * 2 - 1))
					part:AddTag("trap_dart")
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6 * 2 + (math.random() * 2 - 1), 0,
					z - width / 6 * 2 + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + (math.random() * 2 - 1), 0, z - width / 6 * 2 + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 6 * 2 + (math.random() * 2 - 1), 0,
					z + width / 6 * 2 + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6 * 2 + (math.random() * 2 - 1), 0,
					z - width / 6 * 2 + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + (math.random() * 2 - 1), 0, z + width / 6 * 2 + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("pig_ruins_pressure_plate")
			if part ~= nil then
				part.Transform:SetPosition(x + depth / 6 * 2 + (math.random() * 2 - 1), 0,
					z + width / 6 * 2 + (math.random() * 2 - 1))
				part:AddTag("trap_dart")
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	else
		local wallrelief = math.random()
		if wallrelief < 0.6 and roomtype ~= "lightfires" then
			if math.random() < 0.8 then
				local part = SpawnPrefab("deco_ruins_pigman_relief" .. math.random(3) .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 * 2)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			else
				local part = SpawnPrefab("deco_ruins_crack_roots" .. math.random(4))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 * 2)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if northexitopen then
				if math.random() < 0.8 then
					if math.random() < 0.1 then
						local part = SpawnPrefab("deco_ruins_pigqueen_relief" .. roomcolor)
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z - width / 18)
							part.Transform:SetRotation(-90)
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("deco_ruins_pigking_relief" .. roomcolor)
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z + width / 18)
							part.Transform:SetRotation(-90)
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					else
						local part = SpawnPrefab("deco_ruins_pigman_relief" .. math.random(3) .. roomcolor)
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z)
							part.Transform:SetRotation(-90)
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					end
				else
					local part = SpawnPrefab("deco_ruins_crack_roots" .. math.random(4))
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 2, 0, z)
						part.Transform:SetRotation(-90)
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end
			end
			if math.random() < 0.8 then
				local part = SpawnPrefab("deco_ruins_pigman_relief" .. math.random(3) .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 * 2)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			else
				local part = SpawnPrefab("deco_ruins_crack_roots" .. math.random(4))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 * 2)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		else
			if math.random() < 0.5 or roomtype == "lightfires" then
				local tags = nil
				if roomtype == "lightfires" then
					tags = "something"
					if northexitopen then
						local part = SpawnPrefab("deco_ruins_writing1")
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z)
							part.Transform:SetRotation(-90)
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end

						local part = SpawnPrefab("pig_ruins_torch_wall" .. roomcolor)
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 * 2)
							part.Transform:SetRotation(-90)
							if roomtype == "lightfires" then part:AddTag("something") end
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					else
						local part = SpawnPrefab("deco_ruins_writing1")
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 * 2)
							part.Transform:SetRotation(-90)
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					end
					local part = SpawnPrefab("pig_ruins_torch_wall" .. roomcolor)
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 * 2)
						part.Transform:SetRotation(-90)
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				else
					local part = SpawnPrefab("pig_ruins_torch_wall" .. roomcolor)
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 * 2)
						part.Transform:SetRotation(-90)
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
					if northexitopen then
						local part = SpawnPrefab("pig_ruins_torch_wall" .. roomcolor)
						if part ~= nil then
							part.Transform:SetPosition(x - depth / 2, 0, z)
							part.Transform:SetRotation(-90)
							if part.components.health ~= nil then
								part.components.health:SetPercent(1)
							end
						end
					end
					local part = SpawnPrefab("pig_ruins_torch_wall" .. roomcolor)
					if part ~= nil then
						part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 * 2)
						part.Transform:SetRotation(-90)
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end
				local part = SpawnPrefab("pig_ruins_torch_sidewall" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3 - 0.5, 0, z - width / 2)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
				if westexitopen then
					local part = SpawnPrefab("pig_ruins_torch_sidewall" .. roomcolor)
					if part ~= nil then
						part.Transform:SetPosition(x - 0.5, 0, z - width / 2)
						part.Transform:SetRotation(-90)
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end
				local part = SpawnPrefab("pig_ruins_torch_sidewall" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3 - 0.5, 0, z - width / 2)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("pig_ruins_torch_sidewall" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 3 - 0.5, 0, z + width / 2)
					part.Transform:SetRotation(180)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				if eastexitopen then
					local part = SpawnPrefab("pig_ruins_torch_sidewall" .. roomcolor)
					if part ~= nil then
						part.Transform:SetPosition(x - 0.5, 0, z + width / 2)
						part.Transform:SetRotation(180)
						if part.components.health ~= nil then
							part.components.health:SetPercent(1)
						end
					end
				end

				local part = SpawnPrefab("pig_ruins_torch_sidewall" .. roomcolor)
				if part ~= nil then
					part.Transform:SetPosition(x + depth / 3 - 0.5, 0, z + width / 2)
					part.Transform:SetRotation(180)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
	end

	local hangingroots = math.random()
	if hangingroots < 0.3 and not roomtype == "lightfires" then
		local function jostle()
			return math.random() - 0.5
		end

		local num = math.random(1, 3)
		if num == 1 then
			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - width / 12 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end

		if num == 2 then
			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - width / 12 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - width / 12 * 2 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end

		if num == 3 then
			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - width / 12 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - width / 12 * 2 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 6 - width / 12 * 3 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end


		if northexitopen then
			local num = math.random(1, 3)
			if num == 1 then
				local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + width / 12 + jostle())
					if math.random() < 0.5 then part.Transform:SetRotation(180) end
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if num == 2 then
				local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + width / 12 + jostle())
					if math.random() < 0.5 then part.Transform:SetRotation(180) end
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + jostle())
					if math.random() < 0.5 then part.Transform:SetRotation(180) end
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end

			if num == 3 then
				local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + width / 12 + jostle())
					if math.random() < 0.5 then part.Transform:SetRotation(180) end
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z + jostle())
					if math.random() < 0.5 then part.Transform:SetRotation(180) end
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end

				local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
				if part ~= nil then
					part.Transform:SetPosition(x - depth / 2, 0, z - width / 12 + jostle())
					if math.random() < 0.5 then part.Transform:SetRotation(180) end
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end

		local num = math.random(1, 3)

		if num == 1 then
			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 + width / 12 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end

		if num == 2 then
			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 + width / 12 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 + width / 12 * 2 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end

		if num == 3 then
			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 + width / 12 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 + width / 12 * 2 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end

			local part = SpawnPrefab("deco_ruins_roots" .. math.random(3))
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 6 + width / 12 * 3 + jostle())
				if math.random() < 0.5 then part.Transform:SetRotation(180) end
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end
	if math.random() < 0.1 and roomtype ~= "lightfires" then
		if math.random() < 0.5 then
			local part = SpawnPrefab("deco_ruins_corner_tree")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z + width / 2)
				part.Transform:SetRotation(180)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local part = SpawnPrefab("deco_ruins_corner_tree")
			if part ~= nil then
				part.Transform:SetPosition(x - depth / 2, 0, z - width / 2)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end

	if roomtype ~= "secret" and roomtype ~= "aporkalypse" and math.random() < 0.25 then
		for i = 1, math.random(2) + 1 do
			local part = SpawnPrefab("smashingpot")
			if part ~= nil then
				part.Transform:SetPosition(x + depth * 0.8 * math.random() - depth * 0.8 / 2, 0,
					z + width * 0.8 * math.random() - width * 0.8 / 2)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		end
	end


	local function addroomcolumn(a, b)
		if math.random() < 0.2 then
			local part = SpawnPrefab("deco_ruins_beam_room_broken")
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
		else
			local part = SpawnPrefab("deco_ruins_beam_room")
			if part ~= nil then
				part.Transform:SetPosition(x + a, 0, z + b)
				part.Transform:SetRotation(-90)
				if part.components.health ~= nil then
					part.components.health:SetPercent(1)
				end
			end
			local setwidth, setdepth = getspawnlocation(0.8, 0.8)
			if setwidth and setdepth then
				local part = SpawnPrefab("smashingpot")
				if part ~= nil then
					part.Transform:SetPosition(x + setdepth, 0, z + setwidth)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
		end
	end

	if roomtype ~= "darts!" and roomtype ~= "speartraps!" and roomtype ~= "treasure" and roomtype ~= "smalltreasure" and roomtype ~= "secret" and roomtype ~= "aporkalypse" then
		local feature = math.random(3)
		if feature == 1 then
			addroomcolumn(-depth / 6, -width / 6)
			addroomcolumn(depth / 6, width / 6)
			addroomcolumn(depth / 6, -width / 6)
			addroomcolumn(-depth / 6, width / 6)
		elseif feature == 2 then
			if roomtype ~= "doortrap" and not roompheromonestone then
				local part = SpawnPrefab("deco_ruins_fountain")
				if part ~= nil then
					part.Transform:SetPosition(x, 0, z)
					part.Transform:SetRotation(-90)
					if part.components.health ~= nil then
						part.components.health:SetPercent(1)
					end
				end
			end
			if math.random() < 0.5 then
				addroomcolumn(-depth / 6, width / 3)
				addroomcolumn(depth / 6, -width / 3)
			else
				addroomcolumn(-depth / 4, width / 4)
				addroomcolumn(-depth / 4, -width / 4)
				addroomcolumn(depth / 4, -width / 4)
				addroomcolumn(depth / 4, width / 4)
			end
		elseif feature == 3 then
			addroomcolumn(-depth / 4, width / 6)
			addroomcolumn(0, width / 6)
			addroomcolumn(depth / 4, width / 6)
			addroomcolumn(-depth / 4, -width / 6)
			addroomcolumn(0, -width / 6)
			addroomcolumn(depth / 4, -width / 6)
		end
	end


	---------------------------------------------fim create room----------------------------------------------------
	inst:Remove()
end

local function SpawnPiso3(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(2)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	inst.AnimState:PlayAnimation("idle") -- or ground_ruins_slab_blue
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	inst:DoTaskInTime(0.5, function(inst)
		local piso = GetClosestInstWithTag("pisodaruina", inst, 25)
		if not piso then inst:Remove() end
	end)



	return inst
end

local function SpawnPiso3a(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(2)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	inst.AnimState:PlayAnimation("idleinicio")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	return inst
end

local function SpawnPiso5(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD)
	inst.AnimState:SetSortOrder(-2)
	inst.AnimState:PlayAnimation("setalado")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	return inst
end

local function SpawnPiso4(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD)
	inst.AnimState:SetSortOrder(-2)
	inst.AnimState:PlayAnimation("setacima")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	return inst
end



local function SpawnPiso7(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(2)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	inst.AnimState:PlayAnimation("idlevamp") -- or ground_ruins_slab_blue
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	inst:DoTaskInTime(0.5, function(inst)
		local piso = GetClosestInstWithTag("pisodaruina", inst, 25)
		if not piso then inst:Remove() end
	end)



	return inst
end

local function SpawnPiso7a(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("maparuina")
	inst.AnimState:SetBuild("maparuina")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(2)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	inst.AnimState:PlayAnimation("idleiniciovamp")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	return inst
end

local function normalroom()
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

	inst.tipodesala = 0


	inst.roomcolor = ""
	if math.random() < 0.3 then
		inst.roomcolor = "_blue"
	end
	createroom(inst)
	return inst
end

local function normalroominicio()
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

	inst.tipodesala = 8


	inst.roomcolor = ""
	if math.random() < 0.3 then inst.roomcolor = "_blue" end
	createroom(inst)
	return inst
end

local function treasureroom()
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

	inst.tipodesala = 1


	inst.roomcolor = ""
	if math.random() < 0.3 then inst.roomcolor = "_blue" end
	createroom(inst)
	return inst
end

local function oincpileroom()
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

	inst.tipodesala = 9
	inst.treasuretype = "oincpile"


	inst.roomcolor = ""
	if math.random() < 0.3 then inst.roomcolor = "_blue" end
	createroom(inst)
	return inst
end

local function treasureroom1()
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

	inst.tipodesala = 9
	inst.treasuretype = "secret"


	inst.roomcolor = ""
	if math.random() < 0.3 then inst.roomcolor = "_blue" end
	createroom(inst)
	return inst
end

local function treasureroom2()
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

	inst.tipodesala = 1
	inst.treasuretype = "rarerelic"
	inst.relicsow = nil
	inst.roomcolor = "_blue"



	createroom(inst)
	return inst
end

local function treasureroom3()
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

	inst.tipodesala = 1
	inst.treasuretype = "rarerelic"
	inst.relicsow = true
	inst.roomcolor = "_blue"



	createroom(inst)
	return inst
end

local function treasureroom4()
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

	inst.tipodesala = 9
	inst.treasuretype = "aporkalypse_clock"
	inst.roomcolor = "_blue"



	createroom(inst)
	return inst
end

local function treasureroom5()
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

	inst.tipodesala = 1
	inst.treasuretype = "endswell"
	inst.roomcolor = "_blue"



	createroom(inst)
	return inst
end

local function pheromonestoneroom()
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

	inst.tipodesala = 2


	inst.roomcolor = ""
	if math.random() < 0.3 then inst.roomcolor = "_blue" end
	createroom(inst)
	return inst
end

local function doortraproom()
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

	inst.tipodesala = 3


	inst.roomcolor = ""
	if math.random() < 0.3 then inst.roomcolor = "_blue" end
	createroom(inst)
	return inst
end

return
-- TODO 不需要
	Prefab("mapa", SpawnPiso3, assets),
	Prefab("mapainicio", SpawnPiso3a, assets),
	Prefab("mapavamp", SpawnPiso7, assets),
	Prefab("mapainiciovamp", SpawnPiso7a, assets),
	Prefab("setalado", SpawnPiso4, assets),
	Prefab("setacima", SpawnPiso5, assets),

	Prefab("createroom", normalroom, assets),
	Prefab("createroominicio", normalroominicio, assets),
	Prefab("createtreasureroom", treasureroom, assets),
	Prefab("createoincpileroom", oincpileroom, assets),
	Prefab("createpheromonestoneroom", pheromonestoneroom, assets),
	Prefab("createdoortraproom", doortraproom, assets),
	Prefab("createtreasuresecret", treasureroom1, assets),
	Prefab("createtreasurerelictruffle", treasureroom2, assets), --ruins 1
	Prefab("createtreasurerelicsow", treasureroom3, assets),  --ruins 2
	Prefab("createtreasureaporkalypse", treasureroom4, assets), --ruins 5
	Prefab("createtreasureendswell", treasureroom5, assets)   --ruins 5
