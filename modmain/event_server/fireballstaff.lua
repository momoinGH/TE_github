local function fireballstaff_postinit(inst)

end

local function castfx_postinit(inst)

end

add_event_server_data("lavaarena", "prefabs/fireballstaff", {
    fireballstaff_postinit = fireballstaff_postinit,
    castfx_postinit = castfx_postinit
})
