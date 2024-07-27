local containers = require("containers")
local params = containers.params

------ 蜜箱 >>>>>>
local antchest_preservation = { --[["bee", "killerbee",]] "honey", "royal_jelly", --[["honeycomb", "beeswax",]]
	"nectar_pod", "pollen_item", "medal_withered_royaljelly", }
local function antchestitemtestfn(container, item, slot)
	for _, v in ipairs(antchest_preservation) do if item.prefab == v then return true end end
	return false
end

params.antchest = deepcopy(params.icebox) -- 野生蜜箱
params.antchest.itemtestfn = antchestitemtestfn

local hcpos = { x = 0, y = 0, r = 87, angle = 4 } -- 中心坐标 [x, y] | 半径 r | 起始角 angle(pi / 3 rad)
local hcbg = { image = "honeychest_slot.tex", atlas = resolvefilepath("images/ui/honeychest.xml") }
params.honeychest =                               -- 建造蜜箱
{
	widget =
	{
		slotpos = { Vector3(hcpos.x, hcpos.y + hcpos.r, 0) },
		slotbg = { hcbg },
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		bgimage = "honeychest.tex",
		bgatlas = "images/ui/honeychest.xml",
		pos = Vector3(hcpos.x, hcpos.y + 200, 0),
		side_align_tip = 300 - hcpos.r,
		-- bottom_align_tip = 0,
	},
	-- issidewidget = false,
	type = "chest",
	openlimit = 1,
	itemtestfn = antchestitemtestfn,
}
for line = 1, 0, -1 do
	for rad = hcpos.angle, hcpos.angle - 2, -1 do
		table.insert(params.honeychest.widget.slotpos,
			Vector3(hcpos.x + hcpos.r * math.sin(rad * math.pi / 3),
				hcpos.y + hcpos.r * line + hcpos.r * math.cos(rad * math.pi / 3), 0))
		table.insert(params.honeychest.widget.slotbg, hcbg)
	end
end
------ <<<<<<
