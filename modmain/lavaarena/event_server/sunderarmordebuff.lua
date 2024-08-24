local assets =
{
    Asset("ANIM", "anim/lavaarena_sunder_armor.zip"),
}
local function master_postinit(inst)

end

add_event_server_data("lavaarena", "prefabs/sunderarmordebuff", {
    master_postinit = master_postinit,
}, assets)
