local assets =
{
    Asset("ANIM", "anim/lavaarena_firestaff_meteor.zip"),
    Asset("ANIM", "anim/lavaarena_fire_fx.zip"),
}


local function Attack(inst)
    local pos = inst:GetPosition()
    SpawnPrefab("lavaarena_meteor_splash").Transform:SetPosition(pos:Get())
    SpawnPrefab("lavaarena_meteor_splashbase").Transform:SetPosition(pos:Get())

    if inst.owner and inst.owner:IsValid() then
        local radius = 4.1
        for _, v in ipairs(GetPlayerAttackTarget(inst.owner, radius, nil, pos, true, 1)) do
            local vpos = v:GetPosition()
            if v.components.combat then
                local damage = 200 + math.sqrt(distsq(vpos, pos)) / radius * 50
                local weapon = inst.owner.components.inventory and inst.owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                v.components.combat:GetAttacked(inst.owner, damage, weapon)
                SpawnPrefab("lavaarena_meteor_splashhit"):SetTarget(v)
            elseif v.components.workable then
                v.components.workable:Destroy(inst.owner)
            end
        end
    end

    inst:Remove()
end

local function meteor_postinit(inst)
    inst.owner = nil

    inst:ListenForEvent("animover", Attack)
    -- inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + FRAMES * 3, Attack)
    inst.persists = false
end

local function splash_postinit(inst)
    inst.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/meteor_strike")
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

local function SetTarget(inst, target)
    inst.Transform:SetPosition(target.Transform:GetWorldPosition())
    if target:HasTag("largecreature") then
        inst.AnimState:SetScale(1.3, 1.3)
    end
end

local function splashhit_postinit(inst)
    inst.SetTarget = SetTarget
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/lavaarena_meteor", {
    meteor_postinit = meteor_postinit,
    splash_postinit = splash_postinit,
    splashhit_postinit = splashhit_postinit
}, assets)
