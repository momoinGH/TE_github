local Utils = require("tropical_utils/utils")
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