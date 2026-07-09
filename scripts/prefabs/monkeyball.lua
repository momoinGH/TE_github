local assets =
{
    Asset("ANIM", "anim/monkey_ball.zip"),
    Asset("ANIM", "anim/swap_monkeyball.zip"),
}

local prefabs =
{
}

local MONKEYBALL_USES = 10

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_monkeyball", "swap_monkeyball")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


local function onputininventory(inst)
    inst.claimed = true
    inst.Physics:SetFriction(.1)
end

local function onthrown(inst, thrower, pt)
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --self.inst.Physics:CollidesWith(COLLISION.WORLD)
    --inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    --inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    --targetPos, attacker, owningweapon
    inst.Physics:SetFriction(.2)
    inst.Transform:SetFourFaced()

    inst.AnimState:PlayAnimation("throw", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/coconade_throw")
end

local function onhitground(inst)
    inst.components.finiteuses:Use(1)
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)

    if inst:IsOnOcean() then
        inst.AnimState:PlayAnimation("idle_water", true)
    else
        inst.AnimState:PlayAnimation("idle", true)
    end
end

local function oncollision(inst, other)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/monkey_ball/bounce")
end

local function onfinished(inst)
    inst:Remove()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("monkeyball")
    inst.AnimState:SetBuild("monkey_ball")
    inst.AnimState:PlayAnimation("idle")

    MakeSmallBurnable(inst)
    MakeInventoryPhysics(inst)
    --	MakeInventoryFloatable(inst, "idle_water", "idle")

    --	inst.components.floatable:SetOnHitLandFn(onhitground)
    --	inst.components.floatable:SetOnHitWaterFn(onhitground)

    inst:AddTag("thrown")
    inst:AddTag("projectile")
    inst:AddTag("monkeybait")
    MakeInventoryFloatable(inst)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)
    inst.components.inventoryitem.bouncesound = "dontstarve_DLC002/common/monkey_ball/bounce"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(MONKEYBALL_USES)
    inst.components.finiteuses:SetUses(MONKEYBALL_USES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(20)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 3, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(onhitground)

    inst.Physics:SetCollisionCallback(oncollision)

    return inst
end

return Prefab("monkeyball", fn, assets, prefabs)
