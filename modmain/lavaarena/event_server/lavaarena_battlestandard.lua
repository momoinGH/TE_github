local assets =
{
    Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
    Asset("ANIM", "anim/lavaarena_battlestandard_attack_build.zip"),
    Asset("ANIM", "anim/lavaarena_battlestandard_heal_build.zip"),
}
local function OnBannerDeath(inst)
    inst.AnimState:PlayAnimation("break", false)
    inst:ListenForEvent("animover", inst.Remove)
end

local function Kill(inst)
    inst.components.health:Kill()
end

local function OnFlagRemove(_, prefab, debuffprefab)
    if #TheWorld.components.tro_tempentitytracker:GetEnts(prefab) <= 0 then --该类型的战旗一个也没有了
        for _, v in ipairs(TheWorld.components.lavaarenamobtracker:GetAllMobs()) do
            v:RemoveDebuff(debuffprefab)
        end
    end
end

local TARGET_MUST_TAGS = { "monster", "hostile", "_combat", "_health" }
local function AddBuff(inst)
    for _, v in ipairs(TheWorld.components.lavaarenamobtracker:GetAllMobs()) do
        if v:HasTags(TARGET_MUST_TAGS) then
            v:AddDebuff(inst.debuffprefab, inst.debuffprefab)
        end
    end
end

local function battlestandard_postinit(inst)
    inst:ListenForEvent("onremove", function(inst)
        TheWorld:DoTaskInTime(0, OnFlagRemove, inst.prefab, inst.debuffprefab)
    end)
    inst:DoTaskInTime(0, AddBuff)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

    inst:AddComponent("combat")
    inst:AddComponent("inspectable")

    inst:DoTaskInTime(10, Kill)
    inst.persists = false

    inst:ListenForEvent("death", OnBannerDeath)
end

----------------------------------------------------------------------------------------------------

local function Heal(inst)
    if inst.owner and not IsEntityDeadOrGhost(inst.owner, true) then
        inst.owner.components.health:DoDelta(10)
    end
end

local function OnAttached(inst, target, followsymbol, followoffset, data)
    if not target.components.health or not target.components.combat then
        inst:DoTaskInTime(0, function() inst.components.debuff:Stop() end)
        return
    end

    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function() inst.components.debuff:Stop() end, target)

    if inst.buffid == "shield" then
        target.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.5)
    elseif inst.buffid == "damager" then
        target.components.combat.externaldamagemultipliers:SetModifier(inst, 1.5)
    elseif inst.buffid == "heal" then
        inst.owner = target
        inst:DoPeriodicTask(1, Heal)
    end
end

-- 上下线不需要保存，因为上线会根据地图的旗帜重新添加buff
local function createbuff(buffid)
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false
    inst.buffid = buffid

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(inst.Remove)

    return inst
end

add_event_server_data("lavaarena", "prefabs/lavaarena_battlestandard", {
    battlestandard_postinit = battlestandard_postinit,
    createbuff = createbuff,
}, assets)
