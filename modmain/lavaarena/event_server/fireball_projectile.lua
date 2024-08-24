local assets = {
    Asset("ANIM", "anim/fireball_2_fx.zip"),
    Asset("ANIM", "anim/deer_fire_charge.zip"),
    Asset("ANIM", "anim/lavaarena_heal_projectile.zip"),
    Asset("ANIM", "anim/gooball_fx.zip"),
}

local function OnHit(inst)
    SpawnPrefab(inst.hitfx).Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function projectile_postinit(inst, speed, hitfx)
    inst.hitfx = hitfx

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(speed)
    inst.components.projectile:SetHoming(true)
    inst.components.projectile:SetHitDist(0.5)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetStimuli(function() return "fire" end)

    inst.persists = false
end

local function hit_postinit(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/fireball_projectile", {
    projectile_postinit = projectile_postinit,
    fireballhit_postinit = hit_postinit,
    blossomhit_postinit = hit_postinit,
    gooballhit_postinit = hit_postinit
}, assets)
