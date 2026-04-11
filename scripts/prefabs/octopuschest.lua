local MakeChest = require("prefabs/tro_treasurechest_defs")

local assets = {
    Asset("ANIM", "anim/octopus_chest.zip"),
}

local function OnClose(inst)
    inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound(inst.closesound)

    if not inst.components.container:IsEmpty() then
        inst.AnimState:PushAnimation("closed", true)
        return
    else
        inst.components.container.canbeopened = false
        inst.AnimState:PushAnimation("sink", false)
        inst.persists = false
        inst:DoTaskInTime(96 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/quacken/tentacle_submerge")
        end)
        inst:ListenForEvent("animqueueover", inst.Remove)
    end
end

return MakeChest("octopuschest", {
    assets = assets,
    bank = "octopus_chest",
    build = "octopus_chest",
    minimap = "kraken_chest.png",
}, function(inst)
    MakeInventoryPhysics(inst)
end, function(inst)
    inst.components.container.onclosefn = OnClose

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.nobounce = true
end)
