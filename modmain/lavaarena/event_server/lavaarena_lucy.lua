local assets =
{
    Asset("ANIM", "anim/swap_lucy_axe.zip"),
    Asset("ANIM", "anim/lavaarena_lucy.zip"),
    Asset("INV_IMAGE", "lucy"),
    Asset("ANIM", "anim/lavaarena_lucy.zip"),
}

local function OnLaunch(inst, attacker, targetPos)
    attacker.components.inventory:RemoveItem(inst)
    inst.Transform:SetPosition(attacker.Transform:GetWorldPosition())

    inst:AddTag("NOCLICK")
    -- inst.Physics:ClearCollisionMask()
    inst.components.inventoryitem.canbepickedup = false
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.projectileowner = attacker
end

local function Return(inst)
    if inst.projectileowner:IsValid() and inst.projectileowner.components.inventory then
        inst.projectileowner.components.inventory:Equip(inst)
    end
end

local function OnHit(inst, attacker, target)
    inst:RemoveTag("NOCLICK")
    inst.components.inventoryitem.canbepickedup = true
    inst:RemoveComponent("complexprojectile")

    inst.AnimState:PlayAnimation("bounce")
    inst.AnimState:PushAnimation("idle")

    if target then
        SpawnPrefab("weaponsparks_piercing"):Setup(attacker, target, inst)

        if target.components.combat then
            target.components.combat:SetTarget(attacker)
            target.components.combat:GetAttacked(attacker, 30, inst, nil, { lavaarena_strong = 1 })
        end
    end

    if target or attacker.prefab == "woodie" then
        local time = inst.AnimState:GetCurrentAnimationLength()
        inst:DoTaskInTime(time, Return)
    end
end

local function OnUpdate(inst)
    local dt = 0.15
    local self = inst.components.complexprojectile

    local attacker = inst.projectileowner
    if attacker:IsValid() and attacker.components.combat then
        local pos = inst:GetPosition()
        for _, v in ipairs(GetPlayerAttackTarget(attacker, 3, function(v)
            return v:GetPhysicsRadius(0) + 1 > distsq(pos, v:GetPosition())
        end, pos, true)) do
            self:Hit(v)
            return true
        end
    end

    inst.Physics:SetMotorVel(self.velocity:Get())
    self.velocity.x = self.velocity.x + (self.gravity * dt)
    if self.velocity.x < 0 then
        self:Hit() --落空
    end

    return true
end

local function Spell(inst, doer, pos)
    inst:AddComponent("complexprojectile") --不能一直添加，会影响普攻
    inst.components.complexprojectile:SetHorizontalSpeed(35)
    inst.components.complexprojectile.usehigharc = false
    inst.components.complexprojectile:SetOnLaunch(OnLaunch)
    inst.components.complexprojectile:SetOnHit(OnHit)
    inst.components.complexprojectile:SetOnUpdate(OnUpdate)
    inst.components.complexprojectile:Launch(pos, doer, inst)

    inst.components.rechargeable:Discharge(18)
end

local function master_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_lucy_axe", 20, "weaponsparks")

    inst.components.inventoryitem.imagename = "lucy"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 2)

    inst.components.aoespell:SetSpellFn(Spell)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_lucy", {
    master_postinit = master_postinit,
}, assets)
