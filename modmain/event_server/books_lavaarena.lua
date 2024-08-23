local function fossil_postinit(inst)

end

local function elemental_postinit(inst)

end

add_event_server_data("lavaarena", "prefabs/books_lavaarena", {
    fossil_postinit = fossil_postinit,
    elemental_postinit = elemental_postinit
})
