local assets =
{
	Asset("ANIM", "anim/volcano_altar.zip"),
	Asset("ANIM", "anim/volcano_altar_fx.zip"),
}

local prefabs =
{
	"lavaarena_creature_teleport_small_fx",
	"lavaarena_creature_teleport_medium_fx",
	"lavarenachest",
	"quagmire_coin1",
	"quagmire_coin2",
	"quagmire_coin3",
	"quagmire_coin4",
}

local RADIUS = 58 --竞技场的最大半径

local armasdotesouro =
{
	[1] = "healingstaff",
	[2] = "book_fossil",
	[3] = "fireballstaff",
	[4] = "hammer_mjolnir",
	[5] = "blowdart_lava2",
	[6] = "spear_lance",
	[7] = "blowdart_lava",
	[8] = "spear_gungnir",
	[9] = "book_elemental",
	[10] = "lavaarena_armor_hpdamager",
	[11] = "lavaarena_armor_hprecharger",
	[12] = "lavaarena_armor_hppetmastery",
	[13] = "lavaarena_armor_hpextraheavy",
	[14] = "lavaarena_armorextraheavy",
	[15] = "lavaarena_armorheavy",
	[16] = "lavaarena_armormediumrecharger",
	[17] = "lavaarena_armormediumdamager",
	[18] = "lavaarena_armormedium",
	[19] = "lavaarena_armorlightspeed",
	[20] = "lavaarena_armorlight",
	[21] = "lavaarena_lightdamagerhat",
	[22] = "lavaarena_strongdamagerhat",
	[23] = "lavaarena_feathercrownhat",
	[24] = "lavaarena_rechargerhat",
	[25] = "lavaarena_healingflowerhat",
	[26] = "lavaarena_tiaraflowerpetalshat",
	[27] = "lavaarena_eyecirclethat",
	[28] = "lavaarena_crowndamagerhat",
	[29] = "lavaarena_healinggarlandhat",
	[30] = "lavaarena_heavyblade",
}

local battlespider =
{
	[1] = "spiderb",
	[2] = "spiderb1",
	[3] = "spiderb2",
	[4] = "spiderb2",
}

local battlehound =
{
	[1] = "hound",
	[2] = "clayhound",
	[3] = "firehound",
	[4] = "icehound",
}

local battlemerm =
{
	[1] = "merm",
	[2] = "mermb1",
	[3] = "mermb2",
	[4] = "mermb2",
}

local battleknight =
{
	[1] = "knight",
	[2] = "bishop",
	[3] = "knight_nightmare",
	[4] = "bishop_nightmare",
	[5] = "knight",
	[6] = "bishop",
	[7] = "knight_nightmare",
	[8] = "bishop_nightmare",
}

local battleboar =
{
	[1] = "boaron",
	[2] = "snapper",
	[3] = "boaron",
	[4] = "snapper",
	[5] = "peghook",
}

local battlelizard =
{
	[1] = "snapper",
	[2] = "peghook",
	[3] = "turtillus",
	[4] = "trails",
	[5] = "snapper",
	[6] = "peghook",
	[7] = "turtillus",
	[8] = "trails",
}

local battlebossboar =
{
	[1] = "boaron",
	[2] = "snapper",
	[3] = "peghook",
	[4] = "trails",
	[5] = "snapper",
	[6] = "peghook",
	[7] = "turtillus",
	[8] = "trails",
	[9] = "boarrior",
}


local battlerhinocebros =
{
	[1] = "boaron",
	[2] = "boaron",
	[3] = "boaron",
	[4] = "trails",
	[5] = "boaron",
	[6] = "boaron",
	[7] = "boaron",
	[8] = "trails",
	[9] = "rhinodrillbros",
}

local battlebeetletaur =
{
	[1] = "snapper",
	[2] = "snapper",
	[3] = "peghook",
	[4] = "trails",
	[5] = "snapper",
	[6] = "peghook",
	[7] = "peghook",
	[8] = "trails",
	[9] = "beetletaur",
}

local function GiveItem(chest, prefab)
	if not chest.components.container:IsFull() then
		local item = SpawnPrefab(prefab)
		chest.components.container:GiveItem(item)
	end
end

local function SpawnChest(inst)
	local chest = SpawnPrefab("lavarenachest")
	GiveItem(chest, armasdotesouro[math.random(#armasdotesouro)])
	for i = 1, 6 do
		GiveItem(chest, "quagmire_coin1")
	end
	for i = 1, 2 do
		GiveItem(chest, math.random() > 0.5 and "quagmire_coin1" or "quagmire_coin2")
	end

	local pos = inst:GetPosition()
	chest.Transform:SetPosition(pos.x + 3, 0, pos.z + 3)

	SpawnPrefab("lavaarena_creature_teleport_small_fx").Transform:SetPosition(pos.x + 3, 0, pos.z + 3)

	inst.arenaativa = 0
end

--------------acaba o combate se jogadores morreram-----------------
local function ClearState(inst)
	inst.enemy_count = 0
	inst.wave = 0
	inst.contadorspider = 0
	inst.arenaativa = 0

	for _, v in ipairs(TheWorld.components.lavaarenamobtracker:GetAllMobs()) do
		SpawnPrefab("lavaarena_creature_teleport_small_fx").Transform:SetPosition(v.Transform:GetWorldPosition())
		v:Remove()
	end
	if inst.blocker then
		SpawnPrefab("small_puff").Transform:SetPosition(inst.blocker.Transform:GetWorldPosition())
		inst.blocker:Remove()
		inst.blocker = nil
	end

	inst.components.trader:Enable()
	inst.AnimState:PlayAnimation("open", false)
	inst.AnimState:PushAnimation("idle_open", true)
end

local function AcceptTest(inst, item)
	return item:HasTag("lavaarena_tribute")
end

local function OnAccept(inst, giver, item)
	for _, player in ipairs(AllPlayers) do
		if not player:HasTag("playerghost") and inst:GetDistanceSqToInst(player) <= RADIUS * RADIUS then
			if player.components.hunger then
				player.components.hunger:SetPercent(1)
			end
			if player.components.sanity then
				player.components.sanity:SetPercent(1)
			end

			if player.components.health then
				player.components.health:SetPercent(1)
			end
		end
	end

	inst.AnimState:PlayAnimation("unappeased", false)
	inst.AnimState:PushAnimation("close", false)
	inst.AnimState:PushAnimation("idle_close", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_addpart", "teleportato_addpart")

	-- 把路堵死
	local a, b, c = inst.Transform:GetWorldPosition()
	local pig = SpawnPrefab("lavaarena_spectatorblocker")
	pig.Transform:SetPosition(a, b, c - 32)
	pig:ForceFacePoint(a, b, c)
	inst.blocker = pig
	local fx = SpawnPrefab("lavaarena_creature_teleport_small_fx")
	fx.Transform:SetPosition(a, b, c - 32)

	inst.enemy_count = item.enemy_count
	inst.arenaativa = item.arenaativa
end

local function OnRefuse(inst, giver, item)
	giver:DoTaskInTime(0.5, function()
		if giver.components.talker then
			giver.components.talker:Say("只有在战斗大师那里购买的祭品才能放进去。")
		end
	end)
end

local function SpawnEnemy(pos, list)
	local fxs = {}
	for _, v in ipairs(type(list) == "table" and list or { list }) do
		local ent = SpawnPrefab(v)
		TheWorld.components.lavaarenamobtracker:StartTracking(ent)
		ent.persists = false

		local aparece = math.random(4)
		local offx, offz = 0, 0
		if aparece == 1 then
			offx = -29
		elseif aparece == 2 then
			offz = -25
		elseif aparece == 3 then
			offz = 28
		elseif aparece == 4 then
			offx = 29
		end

		ent.Transform:SetPosition(pos.x + offx, 0, pos.z + offz)
		if not fxs[aparece] then
			SpawnPrefab("lavaarena_portal_player_fx").Transform:SetPosition(pos.x + offx, 0, pos.z + offz)
			fxs[aparece] = true
		end
	end
end

local function Update(inst)
	if inst.arenaativa == 0 then return end

	local current = TheWorld.components.lavaarenamobtracker:GetNumMobs()
	local all = inst.enemy_count + current
	local pt = inst:GetPosition()

	if all > 0 then
		inst.components.trader:Disable()
		inst.components.talker:Say("Enemies Left " .. all .. "")
	else
		--结束
		SpawnChest(inst)
		ClearState(inst)
		return
	end

	if inst.enemy_count <= 0 then
		return
	end

	-- 生成怪物

	local enemys
	if inst.arenaativa == 1 then
		inst.wave = inst.enemy_count > 16 and 1
			or inst.enemy_count > 7 and 2
			or inst.enemy_count > 1 and 3
			or 4
		enemys = battlespider
	elseif inst.arenaativa == 2 then
		inst.wave = inst.enemy_count > 21 and 1
			or inst.enemy_count > 14 and 2
			or inst.enemy_count > 7 and 3
			or 4
		enemys = battlehound
	elseif inst.arenaativa == 3 then
		inst.wave = inst.enemy_count > 11 and 1
			or inst.enemy_count > 5 and 2
			or inst.enemy_count > 1 and 3
			or 4

		enemys = battlemerm
	elseif inst.arenaativa == 4 then
		inst.wave = inst.enemy_count > 16 and 1
			or inst.enemy_count > 14 and 2
			or inst.enemy_count > 6 and 3
			or inst.enemy_count > 2 and 4
			or 5

		enemys = battleboar
	elseif inst.arenaativa == 5 then
		inst.wave = inst.enemy_count > 20 and 1
			or inst.enemy_count > 18 and 2
			or inst.enemy_count > 14 and 3
			or inst.enemy_count > 12 and 4
			or inst.enemy_count > 8 and 5
			or inst.enemy_count > 6 and 6
			or inst.enemy_count > 2 and 7
			or 8

		enemys = battleknight
	elseif inst.arenaativa == 6 then
		inst.wave = inst.enemy_count > 20 and 1
			or inst.enemy_count > 18 and 2
			or inst.enemy_count > 14 and 3
			or inst.enemy_count > 13 and 4
			or inst.enemy_count > 8 and 5
			or inst.enemy_count > 6 and 6
			or inst.enemy_count > 1 and 7
			or 8
		enemys = battlelizard
	elseif inst.arenaativa == 7 then
		inst.wave = inst.enemy_count > 20 and 1
			or inst.enemy_count > 18 and 2
			or inst.enemy_count > 14 and 3
			or inst.enemy_count > 13 and 4
			or inst.enemy_count > 8 and 5
			or inst.enemy_count > 6 and 6
			or inst.enemy_count > 2 and 7
			or inst.enemy_count > 1 and 8
			or 9
		enemys = battlebossboar
	elseif inst.arenaativa == 8 then
		inst.wave = inst.enemy_count > 20 and 1
			or inst.enemy_count > 18 and 2
			or inst.enemy_count > 14 and 3
			or inst.enemy_count > 13 and 4
			or inst.enemy_count > 8 and 5
			or inst.enemy_count > 6 and 6
			or inst.enemy_count > 2 and 7
			or inst.enemy_count > 1 and 8
			or 9
		enemys = battlerhinocebros
	elseif inst.arenaativa == 9 then
		inst.wave = inst.enemy_count > 20 and 1
			or inst.enemy_count > 18 and 2
			or inst.enemy_count > 14 and 3
			or inst.enemy_count > 13 and 4
			or inst.enemy_count > 8 and 5
			or inst.enemy_count > 6 and 6
			or inst.enemy_count > 2 and 7
			or inst.enemy_count > 1 and 8
			or 9
		enemys = battlebeetletaur
	end

	inst.contadorspider = inst.contadorspider + 1 --计时器
	if inst.contadorspider > 20 and current < 6 then
		for i = 1, 3 do
			SpawnEnemy(pt, enemys[inst.wave])
			inst.enemy_count = inst.enemy_count - 1
		end
		inst.contadorspider = 0
	end
end

local function OnActivate(inst, doer)
	ClearState(inst)
	return true
end

local function OnPlayerNear(inst)
	inst.Light:SetRadius(RADIUS)
	inst.Light:SetIntensity(1)
end

local function OnPlayerFar(inst)
	inst:DoTaskInTime(2, function()
		if not inst.components.playerprox:IsPlayerClose() then
			inst.Light:SetRadius(5)
			inst.Light:SetIntensity(.2)
			ClearState(inst)
		end
	end)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("volcano_altar_fx")
	inst.AnimState:SetBuild("volcano_altar_fx")
	inst.AnimState:PlayAnimation("idle_open", true)

	MakeObstaclePhysics(inst, 1.1)

	inst.MiniMapEntity:SetPriority(5)
	inst.MiniMapEntity:SetIcon("teleportato_base.png")
	inst.MiniMapEntity:SetPriority(1)

	inst.Light:SetIntensity(.2)
	inst.Light:SetFalloff(0.4)
	inst.Light:SetRadius(58) --竞技场的最大半径
	inst.Light:SetColour(249 / 255, 130 / 255, 117 / 255)
	inst.Light:Enable(true)

	inst:AddTag("recipientedosmobs")
	inst:AddTag("resurrector")

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -400, 0)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.enemy_count = 0 --需要生成的敌人数量
	inst.wave = 0        --波数
	inst.contadorspider = 0 --计时器
	inst.arenaativa = 0  --关卡

	inst.blocker = nil

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(32, 58)
	inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
	inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(AcceptTest)
	inst.components.trader:SetOnAccept(OnAccept)
	inst.components.trader:SetOnRefuse(OnRefuse)

	inst:AddComponent("inspectable")

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	inst.components.hauntable:SetOnHauntFn(OnActivate)

	inst:DoPeriodicTask(0.5, Update)

	return inst
end

return Prefab("lavaarena_center", fn, assets, prefabs)
