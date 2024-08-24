local assets =
{
    Asset("ANIM", "anim/lavaarena_portal.zip"),
    Asset("ANIM", "anim/lavaarena_keyhole.zip"),
    Asset("ANIM", "anim/lavaarena_portal_fx.zip"),
}

local function master_postinit(inst)
    
end

add_event_server_data("lavaarena", "prefabs/lavaarena_portal", {
    master_postinit = master_postinit,
}, assets)
