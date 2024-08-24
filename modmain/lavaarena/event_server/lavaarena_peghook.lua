local assets =
{
    Asset("ANIM", "anim/lavaarena_peghook_basic.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
    Asset("ANIM", "anim/gooball_fx.zip"),
    Asset("ANIM", "anim/lavaarena_hits_splash.zip"),
}

local function peghook_postinit(inst)

end
local function projectile_postinit(inst)

end
local function hitfx_postinit(inst)

end
local function dot_postinit(inst)

end
add_event_server_data("lavaarena", "prefabs/lavaarena_peghook", {
    peghook_postinit = peghook_postinit,
    projectile_postinit = projectile_postinit,
    hitfx_postinit = hitfx_postinit,
    dot_postinit = dot_postinit
}, assets)
