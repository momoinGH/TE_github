local assets =
{
    Asset("ANIM", "anim/lavaarena_item_pickup_fx.zip"),
}
local function master_postinit(inst, radius, hasanim, hassound)

end
add_event_server_data("lavaarena", "prefabs/lavaarena_lootbeacon", {
    master_postinit = master_postinit
}, assets)
