local assets =
{
    Asset("ANIM", "anim/lavaarena_rhino_buff_effect.zip"),
}
local function master_postinit(inst)
    inst.AnimState:PushAnimation("idle", false)
    inst.AnimState:PushAnimation("out", false)
    inst.persists = false
    inst:ListenForEvent("animqueueover", inst.Remove)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_rhinobuff", {
    master_postinit = master_postinit,
}, assets)
