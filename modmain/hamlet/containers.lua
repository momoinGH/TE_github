table.insert(Assets, Asset("ANIM", "anim/ui_honeychest_7x.zip"))
table.insert(Assets, Asset("ATLAS", "images/ui/honeychest.xml"))


local containers = require("containers")
local params = containers.params

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

------ 蜜箱
local function antchestitemtestfn(container, item, slot)
    return ANTCHEST_PRESERVATION[item.prefab]
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
        animbank = "ui_chest_3x3",
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
