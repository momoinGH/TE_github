local containers = require("containers")
local cooking = require("cooking")
local params = containers.params

----------------------------------------------------------------------------------------------------

local function DefaultItemTestFn(container, item, slot)
    return (cooking.IsCookingIngredient(item.prefab) or item:HasTag("preparedfood") or item.prefab == "wetgoop") and
        not container.inst:HasTag("burnt")
end

local function SyrupItemTestFn(container, item, slot)
    return (item.prefab == "quagmire_syrup" or item.prefab == "quagmire_sap" or item.prefab == "wetgoop") and
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
params.quagmire_pot_small = cookertypes.small
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
params.thatchpack = deepcopy(params.corkchest)
params.thatchpack.widget.pos = Vector3(-60, -60, 0)
params.thatchpack.issidewidget = true
params.thatchpack.type = "pack"
params.thatchpack.openlimit = 1
----------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------
-- 箱子
params.octopuschest = params.treasurechest
params.krakenchest = params.treasurechest
params.luggagechest = params.treasurechest
params.lavarenachest = params.treasurechest
params.roottrunk = params.shadowchester
params.roottrunk_child = params.shadowchester
