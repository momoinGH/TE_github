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
}
local function antchestitemtestfn(container, item, slot)
	return antchest_preservation[item.prefab]
end

params.antchest = deepcopy(params.icebox) -- 野生蜜箱
params.antchest.itemtestfn = antchestitemtestfn

local hcpos = {
	x = 0,
	y = 0,
	r = 87,
	angle = 4
} -- 中心坐标 [x, y] | 半径 r | 起始角 angle(pi / 3 rad)
local hcbg = {
	image = "honeychest_slot.tex",
	atlas = resolvefilepath("images/ui/honeychest.xml")
}
params.honeychest = {
	widget = {
		slotpos = { Vector3(hcpos.x, hcpos.y + hcpos.r, 0) },
		slotbg = { hcbg },
		animbank = "ui_honeychest_7x",
		animbuild = "ui_honeychest_7x",
		pos = Vector3(hcpos.x, hcpos.y + 200, 0),
		side_align_tip = 300 - hcpos.r
		-- bottom_align_tip = 0,
	},
	type = "chest",
	openlimit = 1,
	itemtestfn = antchestitemtestfn
}
for line = 1, 0, -1 do
	for rad = hcpos.angle, hcpos.angle - 2, -1 do
		table.insert(params.honeychest.widget.slotpos, Vector3(hcpos.x + hcpos.r * math.sin(rad * PI / 3),
			hcpos.y + hcpos.r * line + hcpos.r * math.cos(rad * PI / 3), 0))
		table.insert(params.honeychest.widget.slotbg, hcbg)
	end
end

----------------------------------------------------------------------------------------------------

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



params.casseroledish = cookertypes.large
params.casseroledish_small = cookertypes.small
params.pot = cookertypes.large
params.pot_small = cookertypes.small
params.grill = cookertypes.large
params.grill_small = cookertypes.small
params.firepit = cookertypes.large -- Hack


----------------------------------------------------------------------------------------------------



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
params.corkchest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		pos = Vector3(80, 80, 0),
	},
	type = "chest",
}
for i = 3, 0, -1 do
	table.insert(params.corkchest.widget.slotpos, Vector3(0, 75 * i - 135, 0))
end

----------------------------------------------------------------------------------------------------
params.smelter = deepcopy(params.cookpot)
params.smelter.widget.buttoninfo.text = STRINGS.ACTIONS.SMELT

local smelting = require("smelting")
function params.smelter.itemtestfn(container, item, slot)
	return smelting.isAttribute(item.prefab)
end

function params.smelter.widget.buttoninfo.fn(inst, doer)
	if inst.components.container ~= nil then
		BufferedAction(doer, inst, ACTIONS.SMELT):Do()
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.SMELT.code, inst, ACTIONS.SMELT.mod_name)
	end
end

----------------------------------------------------------------------------------------------------
params.thatchpack = deepcopy(params.corkchest)
params.thatchpack.issidewidget = true
----------------------------------------------------------------------------------------------------
local function BoatItemTestFn(container, item, slot)
	if slot == 1 then
		return item:HasTag("shipwrecked_boat_tail")
	elseif slot == 2 then
		return item:HasTag("shipwrecked_boat_head")
	else
		return true
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
	usespecificslotsforitems = true,
	type = "chest",
	itemtestfn = BoatItemTestFn
}

----------------------------------------------------------------------------------------------------
params.armouredboat = params.rowboat
----------------------------------------------------------------------------------------------------
params.corkboat = params.rowboat
----------------------------------------------------------------------------------------------------
params.shadowwaxwellboat = params.rowboat
----------------------------------------------------------------------------------------------------
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
		pos = Vector3(440, -300 + GetModConfigData("boatlefthud"), 0),
		isboat = true,
	},
	usespecificslotsforitems = true,
	type = "chest",
	itemtestfn = BoatItemTestFn,
}

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
	usespecificslotsforitems = true,
	type = "chest",
	itemtestfn = BoatItemTestFn,
}


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
		pos = Vector3(440, -300 + GetModConfigData("boatlefthud"), 0),
	},
	usespecificslotsforitems = true,
	type = "chest",
	itemtestfn = BoatItemTestFn,
}

----------------------------------------------------------------------------------------------------

params.woodlegsboatamigo = params.woodlegsboat

----------------------------------------------------------------------------------------------------

params.trawlnetdropped = params.treasurechest
----------------------------------------------------------------------------------------------------

params.armorvoidcloak = params.piggyback

----------------------------------------------------------------------------------------------------
-- 一个不可见的容器
params.shop_buyer = {
	widget =
	{
		slotpos = { Vector3(0, 0, 0), },
	},
	type = "chest",
}
