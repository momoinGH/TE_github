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

local VOLCANOSTAFF_USES = 5
local VOLCANOSTAFF_FIRERAIN_COUNT = 8
local VOLCANOSTAFF_FIRERAIN_RADIUS = 5
local VOLCANOSTAFF_FIRERAIN_DELAY = 0.5

local function createeruption(staff, target, pos)
    staff.components.finiteuses:Use(1)

    local delay = 0.0
    for i = 1, VOLCANOSTAFF_FIRERAIN_COUNT, 1 do
        local x, y, z = VOLCANOSTAFF_FIRERAIN_RADIUS * UnitRand() + pos.x, pos.y,
            VOLCANOSTAFF_FIRERAIN_RADIUS * UnitRand() + pos.z
        staff:DoTaskInTime(delay, function(inst)
            local firerain = SpawnPrefab("firerain")
            firerain.Transform:SetPosition(x, y, z)
            firerain:StartStep()
        end)
        delay = delay + VOLCANOSTAFF_FIRERAIN_DELAY
    end

    --    TheWorld.components.volcanomanager:StartStaffEffect(VOLCANOSTAFF_ASH_TIMER)
end

---------COMMON FUNCTIONS---------

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onunequip_skinned(inst, owner)
    if inst:GetSkinBuild() ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    onunequip(inst, owner)
end

local function commonfn(colour, tags, hasskin)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("tornado_stick")
    inst.AnimState:SetBuild("staffobsidian")
    inst.AnimState:PlayAnimation("idle")

    if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    inst:AddComponent("tradable")

    inst:AddComponent("equippable")


    inst.components.equippable:SetOnEquip(function(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_staffobsidian", "swap_tornado_stick")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(onunequip)


    return inst
end


---------COLOUR SPECIFIC CONSTRUCTIONS---------
local function volcanostaff()
    local inst = commonfn("volcanostaff")

    inst:AddTag("nosteal")
    inst.fxcolour = { 223 / 255, 208 / 255, 69 / 255 }
    inst.castsound = "dontstarve/common/staffteleport"

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createeruption)
    --   inst.components.spellcaster:SetSpellTestFn(cancreateeruption)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = function()
        return Vector3(ThePlayer.entity:LocalToWorldSpace(5, 0, 0))
    end
    inst.components.reticule.ease = true

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetMaxUses(VOLCANOSTAFF_USES)
    inst.components.finiteuses:SetUses(VOLCANOSTAFF_USES)
    inst:AddTag("nopunch")

    return inst
end

return Prefab("volcanostaff", volcanostaff, assets, prefabs)
