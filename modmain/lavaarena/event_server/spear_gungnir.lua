local assets =
{
    Asset("ANIM", "anim/spear_gungnir.zip"),
    Asset("ANIM", "anim/swap_spear_gungnir.zip"),
    Asset("ANIM", "anim/lavaarena_staff_smoke_fx.zip"),
}

local function Spell(inst, doer, pos)
    doer:PushEvent("combat_lunge", { targetpos = pos, weapon = inst })
end

-- 生成火焰路径
local function OnLunged(inst, doer, startingpos, targetpos)
    for k = 0, 10 do
        doer:DoTaskInTime(FRAMES * math.ceil(1 + k / 3.5), function()
            local l = (targetpos - startingpos):GetNormalized() * k * 0.6;
            local x, y, z = (startingpos + l):Get()
            SpawnPrefab("spear_gungnir_lungefx").Transform:SetPosition(x, y, z)
        end)
    end

    inst.components.rechargeable:Discharge(12)
end

local function master_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_spear_gungnir", 25, "weaponsparks")

    inst.components.aoespell:SetSpellFn(Spell)

    inst:AddComponent("aoeweapon_lunge")
    inst.components.aoeweapon_lunge:SetStimuli("explosive")
    inst.components.aoeweapon_lunge:SetOnLungedFn(OnLunged)
end

add_event_server_data("lavaarena", "prefabs/spear_gungnir", {
    master_postinit = master_postinit,
}, assets)
