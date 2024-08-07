local Utils = require("tropical_utils/utils")
local containers = require("containers")
local cooking = require("cooking")
local params = containers.params

------ 蜜箱
local antchest_preservation = {
	honey = true,
	royal_jelly = true,
	nectar_pod = true,
	pollen_item = true,
	medal_withered_royaljelly = true, --能力勋章凋零蜂王浆
}
local function antchestitemtestfn(container, item, slot)
	return antchest_preservation[item.prefab]
end

params.antchest = deepcopy(params.icebox) -- 野生蜜箱
params.antchest.itemtestfn = antchestitemtestfn

params.honeychest = params.antchest


local function DefaultItemTestFn(container, item, slot)
	return (cooking.IsCookingIngredient(item.prefab) or item:HasTag("preparedfood") or item.prefab == "wetgoop") and
		not container.inst:HasTag("burnt")
end

local function SyrupItemTestFn(container, item, slot)
	return (item.prefab == "syrup" or item.prefab == "quagmire_sap" or item.prefab == "wetgoop") and
		not container.inst:HasTag("burnt")
end

local cookertypes =
{
	large =
	{
		widget =
		{
			slotpos =
			{
				Vector3(0, 64 + 32 + 8 + 4, 0),
				Vector3(0, 32 + 4, 0),
				Vector3(0, -(32 + 4), 0),
				Vector3(0, -(64 + 32 + 8 + 4), 0),
			},
			animbank = "quagmire_ui_pot_1x4",
			animbuild = "quagmire_ui_pot_1x4",
			pos = Vector3(200, 0, 0),
			side_align_tip = 100,
		},
		acceptsstacks = false,
		type = "cooker",
		itemtestfn = DefaultItemTestFn,
	},
	small =
	{
		widget =
		{
			slotpos =
			{
				Vector3(0, 64 + 8, 0),
				Vector3(0, 0, 0),
				Vector3(0, -(64 + 8), 0),
			},
			animbank = "quagmire_ui_pot_1x3",
			animbuild = "quagmire_ui_pot_1x3",
			pos = Vector3(200, 0, 0),
			side_align_tip = 100,
		},
		acceptsstacks = false,
		type = "cooker",
		itemtestfn = DefaultItemTestFn,
	},
	pot_syrup =
	{
		widget =
		{
			slotpos =
			{
				Vector3(0, 64 + 8, 0),
				Vector3(0, 0, 0),
				Vector3(0, -(64 + 8), 0),
			},
			animbank = "quagmire_ui_pot_1x3",
			animbuild = "quagmire_ui_pot_1x3",
			pos = Vector3(200, 0, 0),
			side_align_tip = 100,
		},
		acceptsstacks = false,
		type = "cooker",
		itemtestfn = SyrupItemTestFn,
	},
}
cookertypes.casseroledish = cookertypes.large
cookertypes.casseroledish_small = cookertypes.small
cookertypes.pot = cookertypes.large
cookertypes.pot_small = cookertypes.small
cookertypes.grill = cookertypes.large
cookertypes.grill_small = cookertypes.small
cookertypes.firepit = cookertypes.large -- Hack

-- TODO 为什么要覆盖？
Utils.FnDecorator(containers, "widgetsetup", function(container, prefab, data)
	prefab = prefab or container.inst.prefab
	data = cookertypes[prefab] or data
	return nil, false, { container, prefab, data }
end)


----------------------------------------------------------------------------------------------------


params.mealingstone =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, 64 + 32 + 8 + 4, 0),
			Vector3(0, 32 + 4, 0),
			Vector3(0, -(32 + 4), 0),
			Vector3(0, -(64 + 32 + 8 + 4), 0),
		},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		pos = Vector3(200, 0, 0),
		side_align_tip = 100,
		buttoninfo =
		{
			text = "Grind",
			position = Vector3(0, -165, 0),
		}
	},
	acceptsstacks = false,
	type = "cooker",
}

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS,
	params.mealingstone.widget.slotpos ~= nil and #params.mealingstone.widget.slotpos or 0)

Utils.FnDecorator(containers, "widgetsetup", function(container, prefab, data)
	local pref = prefab or container.inst.prefab
	if pref == "mealingstone" then
		local t = params[pref]

		if t ~= nil then
			for k, v in pairs(t) do
				container[k] = v
			end
			container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
		end
		return nil, true
	end
end)

function params.mealingstone.widget.buttoninfo.fn(inst)
	if inst.components.container ~= nil then
		BufferedAction(inst.components.container.opener, inst, ACTIONS.MEAL):Do()
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.MEAL.code, inst, ACTIONS.MEAL.mod_name)
	end
end

function params.mealingstone.itemtestfn(container, item, slot)
	return (item:HasTag("mealable") and not container.inst:HasTag("pleasetakeitem")) or
		(container.inst:HasTag("pleasetakeitem") and (item:HasTag("mealproduct") or item.prefab == "ash" or item.prefab == "spice_salt" or item.prefab == "quagmire_spotspice_ground" or item.prefab == "quagmire_flour"))
end

function params.mealingstone.widget.buttoninfo.validfn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty() and
		not inst:HasTag("pleasetakeitem")
end

----------------------------------------------------------------------------------------------------
params.armorvortexcloak = {
	widget =
	{
		slotpos = {},
		animbank = "ui_krampusbag_2x5",
		animbuild = "ui_krampusbag_2x5",
		pos = Vector3(-5, -60, 0),
	},
	issidewidget = true,
	type = "pack",
	openlimit = 1,
}
for y = 0, 4 do
	for x = 0, 1 do
		table.insert(params.armorvortexcloak.widget.slotpos, Vector3(75 * x - 162, 75 * y - 186, 0))
	end
end

----------------------------------------------------------------------------------------------------

params.trawlnetdropped = params.treasurechest



----------------------------------------------------------------------------------------------------

local SMELTER_PREFABS = {
	iron = true,
	goldnugget = true,
	gold_dust = true,
	flint = true,
	nitre = true,
	dubloon = true,
	obsidian = true,
	magnifying_glass = true,
	goldpan = true,
	ballpein_hammer = true,
	shears = true,
	candlehat = true,
}

params.smelter = {
	widget =
	{
		slotpos =
		{
			Vector3(0, -135, 0),
			Vector3(0, -60, 0),
			Vector3(0, 15, 0),
			Vector3(0, 90, 0),
		},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(80, 80, 0),
		--	isboat = true,
	},
	issidewidget = false,
	type = "cookpot",
}

function params.smelter.itemtestfn(container, item, slot)
	return item:HasTag("iron") or SMELTER_PREFABS[item.prefab]
end

----------------------------------------------------------------------------------------------------
params.corkchest = {
	widget =
	{
		slotpos =
		{
			Vector3(0, -135, 0),
			Vector3(0, -60, 0),
			Vector3(0, 15, 0),
			Vector3(0, 90, 0),
		},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(80, 80, 0),
		--	isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

----------------------------------------------------------------------------------------------------

params.thatchpack = {
	widget =
	{
		slotpos =
		{
			Vector3(0, -135, 0),
			Vector3(0, -60, 0),
			Vector3(0, 15, 0),
			Vector3(0, 90, 0),
		},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(-60, -60, 0),
		--	isboat = true,
	},
	issidewidget = true,
	type = "pack",
}
----------------------------------------------------------------------------------------------------
local function BoatItemTestFn(container, item, slot)
	if slot == 1 then
		return item:HasTag("sail") or item.prefab == "trawlnet"
	elseif slot == 2 then
		return CARGOBOAT_SLOT2_PREFABS[item.prefab]
	else
		return slot ~= nil --如果是Shift+左键的话没有slot，因为不知道会加到哪个槽里，拒绝添加
	end
end

local shipwrecked_boat_slotbg =
{
	-- for 1st slot
	{
		atlas = "images/barco.xml",
		image = "barco.tex",
	},
	-- for 2nd
	{
		atlas = "images/barco.xml",
		image = "luz.tex",
	},
	-- and so on
}

----------------------------------------------------------------------------------------------------
params.rowboat = {
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
		},

		slotbg = shipwrecked_boat_slotbg,

		animbank = "boat_hud_row",
		animbuild = "boat_hud_row",
		pos = Vector3(440, -300 + GetModConfigData("boatlefthud"), 0),
	},
	type = "chest",
}

params.rowboat.itemtestfn = BoatItemTestFn

----------------------------------------------------------------------------------------------------
params.armouredboat = params.rowboat
params.armouredboat.itemtestfn = BoatItemTestFn
----------------------------------------------------------------------------------------------------
params.corkboat = params.rowboat
params.corkboat.itemtestfn = BoatItemTestFn
----------------------------------------------------------------------------------------------------
params.shadowwaxwellboat = params.rowboat
params.shadowwaxwellboat.itemtestfn = BoatItemTestFn
----------------------------------------------------------------------------------------------------
local CARGOBOAT_SLOT2_PREFABS = {
	tarlamp = true,
	boat_lantern = true,
	boat_torch = true,
	quackeringram = true,
	boatcannon = true,
	woodlegs_boatcannon = true,
}

local function BoatItemTestFn(container, item, slot)
	if slot == 1 then
		return item:HasTag("sail") or item.prefab == "trawlnet"
	elseif slot == 2 then
		return CARGOBOAT_SLOT2_PREFABS[item.prefab]
	else
		return slot ~= nil --如果是Shift+左键的话没有slot，因为不知道会加到哪个槽里，拒绝添加
	end
end

params.cargoboat = {
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0), --船舵
			Vector3(-155, 45, 0), --灯
			Vector3(-250, 45, 0),
			Vector3(-330, 45, 0),
			Vector3(-410, 45, 0),
			Vector3(-490, 45, 0),
			Vector3(-570, 45, 0),
			Vector3(-650, 45, 0),
		},

		slotbg = shipwrecked_boat_slotbg,

		animbank = "boat_hud_cargo",
		animbuild = "boat_hud_cargo",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, -300 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	issidewidget = false,
	type = "chest",
}

params.cargoboat.itemtestfn = BoatItemTestFn
----------------------------------------------------------------------------------------------------
params.encrustedboat = {
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
			Vector3(-250, 45, 0),
			Vector3(-330, 45, 0),
		},
		slotbg = shipwrecked_boat_slotbg,
		animbank = "boat_hud_encrusted",
		animbuild = "boat_hud_encrusted",
		pos = Vector3(440, -300 + GetModConfigData("boatlefthud"), 0),
	},
	type = "chest",
}

params.encrustedboat.itemtestfn = BoatItemTestFn
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
params.woodlegsboat = {
	widget =
	{
		slotpos =
		{
			Vector3(-80, 45, 0),
			Vector3(-155, 45, 0),
			Vector3(-300, 45, 0),
		},

		slotbg = shipwrecked_boat_slotbg,

		animbank = "boat_hud_encrusted",
		animbuild = "boat_hud_encrusted",
		bgimage = nil,
		bgatlas = nil,
		pos = Vector3(440, -300 + GetModConfigData("boatlefthud"), 0),
	},
	issidewidget = false,
	type = "chest",
}

params.woodlegsboat.itemtestfn = BoatItemTestFn

----------------------------------------------------------------------------------------------------
