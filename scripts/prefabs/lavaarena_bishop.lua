local clockwork_common = require "prefabs/clockwork_common"
local RuinsRespawner = require "prefabs/ruinsrespawner"

local assets =
{
    Asset("ANIM", "anim/bishop.zip"),
    Asset("ANIM", "anim/bishop_build.zip"),
    Asset("ANIM", "anim/bishop_nightmare.zip"),
	Asset("ANIM", "anim/bishop_attack.zip"), --for shot fx
    Asset("SOUND", "sound/chess.fsb"),
    Asset("SCRIPT", "scripts/prefabs/clockwork_common.lua"),
    Asset("SCRIPT", "scripts/prefabs/ruinsrespawner.lua"),

	Asset("ANIM", "anim/bishopboat.zip"),
    Asset("ANIM", "anim/bishopboat_build.zip"),
    Asset("ANIM", "anim/bishopboat_death.zip"),
}

local assets_reticule =
{
	Asset("ANIM", "anim/bishop.zip"),
}

local prefabs =
{
	"bishop_targeting_fx",
    "gears",
	"bishop_charge2_fx",
    "purplegem",
}

local prefabs_nightmare =
{
	"bishop_targeting_fx",
    "gears",
	"bishop_charge2_fx",
    "purplegem",
    "nightmarefuel",
    "thulecite_pieces",
    "bishop_nightmare_ruinsrespawner_inst",
}

local brain = require "brains/bishopbrain"

SetSharedLootTable("bishop",
{
    {"gears",       1.0},
    {"gears",       1.0},
    {"purplegem",   1.0},
})

SetSharedLootTable("bishop_nightmare",
{
    {"purplegem",         1.0},
    {"nightmarefuel",     0.6},
    {"thulecite_pieces",  0.5},
})

SetSharedLootTable("bishopb",
{
})

local function Retarget(inst)
    return clockwork_common.Retarget(inst, TUNING.BISHOP_TARGET_DIST)
end

local function GetSavedRnd(inst, id)
	local rnd = inst.rnds[id]
	if rnd == nil then
		rnd = math.random()
		inst.rnds[id] = rnd
	end
	return rnd
end

local function CreateShotSegFx(frame, scale)
	local inst = CreateEntity()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	--[[Non-networked entity]]
	--inst.entity:SetCanSleep(false)
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("bishop_attack")
	inst.AnimState:SetBuild("bishop_attack")
	inst.AnimState:PlayAnimation("shot_fx", true)
	inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetScale(math.random() < 0.5 and -scale or scale, math.random() < 0.5 and -scale or scale)
	inst.AnimState:SetFrame(frame)

	inst.rnds = {}

	return inst
end

local function DoClearShotFx(inst)
	for i = 1, #inst._fx do
		inst._fx[i]:Remove()
		inst._fx[i] = nil
	end
end

local function UpdateShotFx(inst)
	if inst.AnimState:IsCurrentAnimation("atk2_pst") then
		local frame = inst.AnimState:GetCurrentAnimationFrame()
		if frame < 5 then
			local x, y, z, success = inst.AnimState:GetSymbolPosition("shot_marker")
			if success then
				local dx = inst.shotx:value() - x
				local dy = -y
				local dz = inst.shotz:value() - z
				local len = math.sqrt(dx * dx + dz * dz)
				local num = math.ceil(len / 1.3) + 1 --add one for end point
				if #inst._fx < num then
					local animnumframes = 19
					local frame = math.random(animnumframes) - 1
					for i = #inst._fx + 1, num do
						local scale = i == 1 and 1.5 + math.random() * 0.2 or 0.85 + math.random() * 0.3
						inst._fx[i] = CreateShotSegFx(frame, scale)
						frame = frame + math.random(2, 3)
						if frame >= animnumframes then
							frame = frame - animnumframes
						end
					end
				elseif #inst._fx > num then
					for i = num + 1, #inst._fx do
						inst._fx[i]:Remove()
						inst._fx[i] = nil
					end
				end
				num = num - 1 --we added one earlier for the end point
				dx = dx / num
				dy = dy / num
				dz = dz / num
				num = num + 1
				for i, v in ipairs(inst._fx) do
					if i == 1 then
						v.Transform:SetPosition(x, y + 0.5, z)
					elseif i < num then
						v.Transform:SetPosition(x, y + GetSavedRnd(v, "y"), z)
					else
						v.Transform:SetPosition(x, y, z)
					end
					x = x + dx
					y = y + dy
					z = z + dz
				end
				return
			end
		elseif frame < 9 then
			local alpha =
				(frame == 5 and 0.5) or
				(frame == 6 and 0.1) or
				(frame == 7 and 0.3) or
				0.1
			for i, v in ipairs(inst._fx) do
				v.AnimState:SetMultColour(1, 1, 1, GetSavedRnd(v, frame) * alpha)
			end
			return
		end
	end

	DoClearShotFx(inst)
	inst.components.updatelooper:RemovePostUpdateFn(UpdateShotFx)
end

local function OnShowShotDirty(inst)
	DoClearShotFx(inst)
	if inst.showshot:value() then
		inst.components.updatelooper:AddPostUpdateFn(UpdateShotFx)
	else
		inst.components.updatelooper:RemovePostUpdateFn(UpdateShotFx)
	end
end

local function StartShotFx(inst, pos)
	inst.shotx:set(pos.x)
	inst.shotz:set(pos.z)
	inst.showshot:set(true)

	if not TheNet:IsDedicated() then
		OnShowShotDirty(inst)
	end
end

local function OnRemoveEntity(inst)
	if inst.targetingfx then
		inst.targetingfx:Remove()
	end
	DoClearShotFx(inst)
end

local function MakeBishop(name, common_postinit, master_postinit, _assets, _prefabs)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddDynamicShadow()
		inst.entity:AddNetwork()

		MakeCharacterPhysics(inst, 50, 0.5)

		inst.DynamicShadow:SetSize(1.5, 0.75)
		inst.Transform:SetFourFaced()

		inst.AnimState:SetBank("bishop")
		--inst.AnimState:SetSymbolBloom("fx_glow")
		inst.AnimState:SetSymbolBloom("fx_elec_eye")
		inst.AnimState:SetSymbolLightOverride("fx_glow", 1)
		inst.AnimState:SetSymbolLightOverride("fx_elec_eye", 1)

		inst:AddTag("bishop")
		inst:AddTag("chess")
		inst:AddTag("hostile")
		inst:AddTag("monster")
		inst:AddTag("Arena")

		inst.shotx = net_float(inst.GUID, "bishop.shotx")
		inst.shotz = net_float(inst.GUID, "bishop.shotz")
		inst.showshot = net_bool(inst.GUID, "bishop.showshot", "showshotdirty")

		inst._fx = {}
		inst:AddComponent("updatelooper")

		if common_postinit then
			common_postinit(inst)
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			inst:ListenForEvent("showshotdirty", OnShowShotDirty)

			return inst
		end

		inst.override_combat_fx_size = "med"
		inst.kind = "" --for sound paths *unused?*
		inst.soundpath = "dontstarve/creatures/bishop/"
		inst.effortsound = "dontstarve/creatures/bishop/idle"

		inst:AddComponent("combat")
		inst.components.combat.hiteffectsymbol = "waist"
		inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)
		inst.components.combat:SetDefaultDamage(TUNING.BISHOP_DAMAGE)
		inst.components.combat:SetRetargetFunction(3, Retarget)
		inst.components.combat:SetKeepTargetFunction(clockwork_common.KeepTarget)
		inst.components.combat:SetRange(TUNING.BISHOP_ATTACK_DIST)

		inst:AddComponent("follower")

		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(TUNING.BISHOP_HEALTH)

		inst:AddComponent("inspectable")
		inst:AddComponent("knownlocations")

		inst:AddComponent("locomotor")
		inst.components.locomotor.walkspeed = TUNING.BISHOP_WALK_SPEED
	    -- boat hopping setup
    	inst.components.locomotor:SetAllowPlatformHopping(true)

		inst:AddComponent("embarker")
		inst:AddComponent("drownable")
		inst:AddComponent("lootdropper")

		inst:AddComponent("sleeper")
		inst.components.sleeper:SetWakeTest(clockwork_common.ShouldWake)
		inst.components.sleeper:SetSleepTest(clockwork_common.ShouldSleep)
		inst.components.sleeper:SetResistance(3)

		MakeMediumBurnableCharacter(inst, "waist")
		MakeMediumFreezableCharacter(inst, "waist")
		MakeHauntablePanic(inst)

		inst:SetStateGraph("SGbishop")
		inst:SetBrain(brain)

		inst:ListenForEvent("attacked", clockwork_common.OnAttacked)
		inst:ListenForEvent("newcombattarget", clockwork_common.OnNewCombatTarget)

		clockwork_common.InitHomePosition(inst)
		clockwork_common.MakeBefriendable(inst)

		inst.StartShotFx = StartShotFx
		inst.OnRemoveEntity = OnRemoveEntity

		if master_postinit then
			master_postinit(inst)
		end

		return inst
	end

	return Prefab(name, fn, _assets, _prefabs)
end

--------------------------------------------------------------------------

local function normal_common_postinit(inst)
	inst.AnimState:SetBuild("bishop_build")
end

local function normal_master_postinit(inst)
	inst.components.lootdropper:SetChanceLootTable("bishopb")

	clockwork_common.MakeHealthRegen(inst)
end

--------------------------------------------------------------------------

local function nightmare_common_postinit(inst)
	inst.AnimState:SetBuild("bishop_nightmare")

	inst:AddTag("cavedweller")
	inst:AddTag("shadow_aligned")
	inst:AddTag("Arena")
end

local function nightmare_master_postinit(inst)
	inst.kind = "_nightmare"
	inst.soundpath = "dontstarve/creatures/bishop_nightmare/"
	inst.effortsound = "dontstarve/creatures/bishop_nightmare/rattle"

	inst:AddComponent("acidinfusible")
	inst.components.acidinfusible:SetFXLevel(3)
	inst.components.acidinfusible:SetMultipliers(TUNING.ACID_INFUSION_MULT.WEAKER)

	inst.components.lootdropper:SetChanceLootTable("bishopb")
end


return MakeBishop("bishopb", normal_common_postinit, normal_master_postinit, assets, prefabs),
	MakeBishop("bishop_nightmareb", nightmare_common_postinit, nightmare_master_postinit, assets, prefabs_nightmare)
	--RuinsRespawner.Inst("bishop_nightmare", onruinsrespawn), RuinsRespawner.WorldGen("bishop_nightmare", onruinsrespawn),
	--Prefab("bishop_targeting_fx", reticulefn, assets_reticule)
