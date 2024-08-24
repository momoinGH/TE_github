local assets =
{
    Asset("ANIM", "anim/boarlord.zip"),
    Asset("ANIM", "anim/lavaarena_boarlord_dialogue.zip"),
}

local function master_postinit(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("store")
end

add_event_server_data("lavaarena", "prefabs/lavaarena_boarlord", {
    master_postinit = master_postinit,
}, assets)
