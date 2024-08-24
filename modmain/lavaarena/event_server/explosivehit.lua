local assets =
{
    Asset("ANIM", "anim/explode.zip"),
}

local function master_postinit(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/explosivehit", {
    master_postinit = master_postinit
}, assets)

