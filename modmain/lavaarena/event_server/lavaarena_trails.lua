local assets =
{
    Asset("ANIM", "anim/lavaarena_trails_basic.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}
local function master_postinit(inst)

end

add_event_server_data("lavaarena", "prefabs/lavaarena_trails", {
    master_postinit = master_postinit,
}, assets)
