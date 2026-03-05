local assets1 =
{
    Asset("ANIM", "anim/pig_coin.zip"),
}

local assets10 = {
    Asset("ANIM", "anim/pig_coin_silver.zip"),
}

local assets100 = {
    Asset("ANIM", "anim/pig_coin_jade.zip"),
}

local function shine(inst)
    inst.task = nil
    if inst.entity:IsAwake() then
        inst:DoTaskInTime(4 + math.random() * 5, shine)
    end
end

local function onwake(inst)
    inst.task = inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function GetOincAllValue(inst)
    return GetStackSize(inst) * inst.oinc_value
end

local function MakeOinc(name, value, build, assets)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddPhysics()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)

        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst.AnimState:SetBank("coin")
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("molebait")
        inst:AddTag("oinc")

        inst.oinc_value = value
        inst.GetOincAllValue = GetOincAllValue

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("bait")

        inst:AddComponent("tradable")

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
        inst.components.edible.hungervalue = 1

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst.OnEntityWake = onwake

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeOinc("oinc", 1, "pig_coin", assets1),
    MakeOinc("oinc10", 10, "pig_coin_silver", assets10),
    MakeOinc("oinc100", 100, "pig_coin_jade", assets100)
