local assets =
{
    Asset("ANIM", "anim/player_house_kits.zip"),
}

local function common(name, housebank, housebuild)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBuild("player_house_kits")
    inst.AnimState:SetBank("house_kit")
    inst.AnimState:PlayAnimation(name)

    inst:AddTag("decoradordecasa")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.housebank = housebank
    inst.housebuild = housebuild
    inst.houseminimap = "player_house_" .. name
    inst.housename = "playerhouse_" .. name

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "player_house_" .. name

    return inst
end

local function player_house_cottage_craft_fn()
    return common("cottage", "playerhouse_small", "player_small_house1_cottage_build")
end

local function player_house_villa_craft_fn()
    return common("villa", "playerhouse_large", "player_large_house1_villa_build")
end

local function player_house_manor_craft_fn()
    return common("manor", "playerhouse_large", "player_large_house1_manor_build")
end

local function player_house_tudor_craft_fn()
    return common("tudor", "playerhouse_small", "player_small_house1_tudor_build")
end

local function player_house_gothic_craft_fn()
    return common("gothic", "playerhouse_small", "player_small_house1_gothic_build")
end

local function player_house_brick_craft_fn()
    return common("brick", "playerhouse_small", "player_small_house1_brick_build")
end

local function player_house_turret_craft_fn()
    return common("turret", "playerhouse_small", "player_small_house1_turret_build")
end

return Prefab("player_house_cottage_craft", player_house_cottage_craft_fn, assets),
    Prefab("player_house_villa_craft", player_house_villa_craft_fn, assets),
    Prefab("player_house_manor_craft", player_house_manor_craft_fn, assets),
    Prefab("player_house_tudor_craft", player_house_tudor_craft_fn, assets),
    Prefab("player_house_gothic_craft", player_house_gothic_craft_fn, assets),
    Prefab("player_house_brick_craft", player_house_brick_craft_fn, assets),
    Prefab("player_house_turret_craft", player_house_turret_craft_fn, assets)
