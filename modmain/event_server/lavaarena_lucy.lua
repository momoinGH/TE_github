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

local ATTACK_MUST_TAGS = { "_combat" }
local ATTACK_CANT_TAGS = { "player", "companion" }
local function OnUpdate(inst)
    local dt = 0.15
    local self = inst.components.complexprojectile

    local attacker = inst.projectileowner
    if attacker:IsValid() and attacker.components.combat then
        attacker.components.combat.ignorehitrange = true
        local pos = inst:GetPosition()
        for _, v in ipairs(TheSim:FindEntities(pos.x, pos.y, pos.z, 3, ATTACK_MUST_TAGS, ATTACK_CANT_TAGS)) do
            if v.entity:IsVisible() and attacker.components.combat:CanTarget(v) then
                if v:GetPhysicsRadius(0) + 1 > distsq(pos, v:GetPosition()) then
                    self:Hit(v)
                    attacker.components.combat.ignorehitrange = false
                    return true
                end
            end
        end
        attacker.components.combat.ignorehitrange = false
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
})
