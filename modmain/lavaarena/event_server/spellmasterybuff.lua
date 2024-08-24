local assets =
{
    Asset("ANIM", "anim/lavaarena_arcane_orb.zip"),
}
local function buff_postinit(inst)

end

local function orbs_postinit(inst)
    
end

add_event_server_data("lavaarena", "prefabs/spellmasterybuff", {
    buff_postinit = buff_postinit,
    orbs_postinit = orbs_postinit
}, assets)
