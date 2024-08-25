local assets =
{
    Asset("ANIM", "anim/lavaarena_sunder_armor.zip"),
}

local targets = {
    boarilla = "helmet",
    boarrior = "head",
    crocommander = "shell",
    pitpig = "helmet",
    scorpeon = "head",
    snortoise = "body"
}

local function SetTarget(inst, target)
    inst.owner = target
    if targets[target.prefab] then
        inst.Follower:FollowSymbol(target.GUID, targets[target.prefab], -20, -150, 1)
    else
        inst:Remove()
    end
end

local function master_postinit(inst)
    inst.AnimState:PushAnimation("loop", false)
    inst.AnimState:PushAnimation("pst", false)
    inst.SetTarget = SetTarget

    inst:ListenForEvent("animqueueover", inst.Remove)
    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/sunderarmordebuff", {
    master_postinit = master_postinit,
}, assets)
