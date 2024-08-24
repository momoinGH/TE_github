local assets =
{
    Asset("ANIM", "anim/lavaarena_boaraudience1.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_1.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_2.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_3.zip"),
    Asset("ANIM", "anim/lavaarena_decor.zip"),
    Asset("ANIM", "anim/lavaarena_banner.zip"),
}

local function stand_postinit(inst)

end

local function spectator_postinit(inst)

end
add_event_server_data("lavaarena", "prefabs/lavaarena_crowdstand", {
    stand_postinit = stand_postinit,
    spectator_postinit = spectator_postinit
}, assets)
