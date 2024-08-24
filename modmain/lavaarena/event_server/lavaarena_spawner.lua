local assets =
{
    Asset("ANIM", "anim/lavaarena_spawner.zip"),
    Asset("ANIM", "anim/lavaarena_spawndecor.zip"),
}
local function master_postinit(inst)

end

add_event_server_data("lavaarena", "prefabs/lavaarena_spawner", {
    master_postinit = master_postinit,
}, assets)
