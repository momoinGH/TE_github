local function Setup(inst, attacker, target)
    inst.Transform:SetPosition(target.Transform:GetWorldPosition())
    inst.variation:set(math.random(3))
end

local function firehits_master_postinit(inst)
    inst.Setup = Setup

    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/firehits", {
    master_postinit = firehits_master_postinit,
})
