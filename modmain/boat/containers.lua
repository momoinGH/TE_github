local params = require("containers").params

table.insert(Assets, Asset("ATLAS", "images/barco.xml"))


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

local function BoatItemTestFn(container, item, slot)
    if not slot then return true end
    local slotitem = container:GetItemInSlot(slot)
    if slot == 1 then
        return not slotitem and item:HasTag("shipwrecked_boat_tail")
    elseif slot == 2 then
        return not slotitem and item:HasTag("shipwrecked_boat_head")
    else
        if not slotitem then return true end
        if slotitem.prefab ~= item.prefab then return false end
        return slotitem.components.stackable and not slotitem.components.stackable:IsFull()
    end
end

params.cargoboat = {
    widget =
    {
        slotpos =
        {
            Vector3(-80, 45, 0),  --船舵
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
        pos = Vector3(106, 40, 0),
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
    itemtestfn = BoatItemTestFn,
}

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
        pos = Vector3(106, 40, 0),
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
    itemtestfn = BoatItemTestFn,
}

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
        pos = Vector3(106, 40, 0),
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
    itemtestfn = BoatItemTestFn
}

params.armouredboat = params.rowboat
params.corkboat = params.rowboat
params.shadowboat = params.rowboat


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
        pos = Vector3(106, 40, 0),
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
    itemtestfn = BoatItemTestFn,
}

params.woodlegsboatamigo = params.woodlegsboat

params.trawlnetdropped = params.treasurechest
