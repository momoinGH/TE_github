local assets =
{
    Asset("ANIM", "anim/lavaarena_attack_buff_effect.zip"),
    Asset("ANIM", "anim/lavaarena_attack_buff_effect2.zip"),
}

local function master_postinit(inst, offset)

end

add_event_server_data("lavaarena", "prefabs/wathgrithr_bloodlustbuff", {
    master_postinit = master_postinit,
}, assets)
