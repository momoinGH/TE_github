local assets =
{
    Asset("ANIM", "anim/staff_obsidian.zip"),
    Asset("ANIM", "anim/swap_staff_obsidian.zip"),
    Asset("ANIM", "anim/staffs1.zip"),
    Asset("ANIM", "anim/swap_obsidi.zip"),
}

local prefabs =
{
    "firerain",
    "gaze_beam2",
}

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


local function spawngaze(inst, pos, target)
    local rotation = pos
    local beam = SpawnPrefab("gaze_beam2")
    local pt = inst:GetPosition()
    local angle = rotation * DEGREES
    inst.radius = inst.radius + 3
    beam.Transform:SetScale(0.2 + 0.053 * inst.radius, 0.2 + 0.053 * inst.radius, 0.2 + 0.053 * inst.radius)
    local offset = Vector3(inst.radius * math.cos(angle), 0, -inst.radius * math.sin(angle))
    local newpt = pt + offset

    beam.Transform:SetPosition(newpt.x, newpt.y, newpt.z)
    beam.host = inst.components.inventoryitem:GetGrandOwner()
    beam.Transform:SetRotation(rotation)
end


local function spawntornado(inst, target, pos)
    inst.components.finiteuses:Use(1)
    local x, y, z = target.Transform:GetWorldPosition()
    local pos1 = inst:GetAngleToPoint(x, y, z)
    inst.radius = 0
    inst.SoundEmitter:PlaySound(" dontstarve_DLC003/creatures/boss/pugalisk/gaze_LP", "gazor")
    inst:DoTaskInTime(0.2, function() spawngaze(inst, pos1, target) end)
    inst:DoTaskInTime(0.5, function() spawngaze(inst, pos1, target) end)
    inst:DoTaskInTime(0.7, function() spawngaze(inst, pos1, target) end)
    inst:DoTaskInTime(0.9, function() spawngaze(inst, pos1, target) end)
    inst:DoTaskInTime(1.0, function() spawngaze(inst, pos1, target) end)
end


local function bone()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    anim:SetBank("staffs1")
    anim:SetBuild("staffs1")
    anim:PlayAnimation("bonestaff")

    inst:AddTag("nopunch")
    inst:AddTag("nosteal")
    inst:AddTag("quickcast")
    inst.fxcolour = { 223 / 255, 208 / 255, 69 / 255 }
    inst.spelltype = "SCIENCE"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.TORNADOSTAFF_USES * 3)
    inst.components.finiteuses:SetUses(TUNING.TORNADOSTAFF_USES * 3)
    inst.components.finiteuses:SetOnFinished(inst.Remove)


    --    inst:AddComponent("spellcaster")
    --    inst.components.spellcaster:SetSpellFn(creategaze)
    --    inst.components.spellcaster.canuseonpoint = true
    --    inst.components.spellcaster.canusefrominventory = false
    --	inst.components.spellcaster.quickcast = true
    --	inst.components.spellcaster.canuseonpoint_water = true	

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster:SetSpellFn(spawntornado)
    inst.components.spellcaster.castingstate = "castspell_tornado"

    MakeHauntableLaunch(inst)

    inst:AddTag("show_spoilage")

    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(function(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_obsidi", "bonestaff")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("common/inventory/bonestaff", bone, assets, prefabs)
