local assets =
{
    Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),
}

local function master_postinit(inst, radius, hasanim, hassound)
    inst:Show()
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end
add_event_server_data("lavaarena", "prefabs/lavaarena_groundlifts", {
    master_postinit = master_postinit
}, assets)
