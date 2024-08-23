local function Spell(inst, doer, pos)
    doer:PushEvent("combat_leap", { targetpos = pos, weapon = inst })
end

local function OnLeapt(inst, doer, startingpos, targetpos)
    local x, y, z = targetpos:Get()
    SpawnPrefab("hammer_mjolnir_crackle").Transform:SetPosition(x, y, z)
    SpawnPrefab("hammer_mjolnir_cracklebase").Transform:SetPosition(x, y, z)
    inst.components.rechargeable:Discharge(18)
end

local function hammer_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_hammer_mjolnir",  20, "weaponsparks")

    inst.components.aoespell:SetSpellFn(Spell)

    inst:AddComponent("aoeweapon_leap")
    inst.components.aoeweapon_leap:SetOnLeaptFn(OnLeapt)
    inst.components.aoeweapon_leap:SetStimuli("explosive")
end

local function crackle_postinit(inst)
    inst.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/hammer")
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

local function cracklehit_postinit(inst)
    if inst.SoundEmitter then
        inst.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/electric")
    end
    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/hammer_mjolnir", {
    hammer_postinit = hammer_postinit,
    crackle_postinit = crackle_postinit,
    cracklehit_postinit = cracklehit_postinit
})
