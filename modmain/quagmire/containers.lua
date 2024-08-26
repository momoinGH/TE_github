local Utils = require("tropical_utils/utils")
local containers = require("containers")
local params = containers.params

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
