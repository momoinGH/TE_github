local assets =
{
    Asset("ANIM", "anim/lavaarena_item_pickup_fx.zip"),
}

local function Kill(inst)
    inst.AnimState:PlayAnimation("loop")
    inst.AnimState:PushAnimation("pst", false)
    inst:ListenForEvent("animqueueover", inst.Remove)
end

local function master_postinit(inst)
    inst:Show()
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:PushAnimation("loop")
    -- 该用什么音效呢？
    
    inst.Kill = Kill
    inst.persists = false
end
add_event_server_data("lavaarena", "prefabs/lavaarena_lootbeacon", {
    master_postinit = master_postinit
}, assets)
