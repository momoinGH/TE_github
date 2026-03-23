local assets =
{
    Asset("ANIM", "anim/monkey_projectile.zip"),
    Asset("ANIM", "anim/swap_poop.zip"),
}

local prefabs =
{
    "flies",
    "poopcloud",
    "gridplacer_farmablesoil",
}

local function FuelTaken(inst, taker)
    local fx = taker.components.burnable ~= nil and taker.components.burnable.fxchildren[1] or nil
    local x, y, z
    if fx ~= nil and fx:IsValid() then
        x, y, z = fx.Transform:GetWorldPosition()
    else
        x, y, z = taker.Transform:GetWorldPosition()
    end
    SpawnPrefab("poopcloud").Transform:SetPosition(x, y + 1, z)
end

local function OnHitPoop(inst, attacker, target)
    local other = SpawnPrefab("poop_splat")
    local pt = inst:GetPosition()
    other.Transform:SetPosition(pt:Get())
    inst.SoundEmitter:PlaySound("dontstarve/creatures/monkey/poopsplat")
    if target and target:HasTag("bird") then
        target:DoTaskInTime(0.1, function(target) target.sg:GoToState("stunned") end)
    end
    inst:Remove()
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_poop", "swap_poop")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onthrown(inst, attacker, target)
    --	if attacker and attacker.prefab == "wilbur" then
    inst.AnimState:SetBank("monkey_projectile")
    inst.AnimState:SetBuild("monkey_projectile")
    inst.AnimState:PlayAnimation("idle", true)
    inst.components.weapon:SetDamage(10)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --	else
    --    local x, y, z = inst.Transform:GetWorldPosition()	
    --	local merda = SpawnPrefab("poop")
    --	merda.Transform:SetPosition(x, y , z)
    --    inst:Remove()
    --	end
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("monkey_projectile")
    inst.AnimState:SetBuild("monkey_projectile")
    inst.AnimState:PlayAnimation("idle", false)

    MakeInventoryFloatable(inst)

    inst:AddTag("thrown")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:PushAnimation("idle", false)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.equipstack = true

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile.hitdist = 0.5
    inst.components.projectile:SetOnHitFn(OnHitPoop)
    inst.components.projectile:SetOnThrownFn(onthrown)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    inst.components.fuel:SetOnTakenFn(FuelTaken)

    return inst
end

return Prefab("wilbur_poop", fn1, assets, prefabs)
