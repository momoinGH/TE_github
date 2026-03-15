local assets =
{
    Asset("ANIM", "anim/hail.zip"),
}

local names = { "variant1", "variant2", "variant3" }

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function onperish(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        local stacksize = inst.components.stackable:StackSize()
        if owner.components.moisture ~= nil then
            owner.components.moisture:DoDelta(2 * stacksize)
        elseif owner.components.inventoryitem ~= nil then
            owner.components.inventoryitem:AddMoisture(4 * stacksize)
        end
        inst:Remove()
    else
        local stacksize = inst.components.stackable:StackSize()
        local x, y, z = inst.Transform:GetWorldPosition()
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(x, y, z,
            stacksize * TUNING.ICE_MELT_GROUND_MOISTURE_AMOUNT)

        inst.persists = false
        inst.components.inventoryitem.canbepickedup = false
        inst.AnimState:PlayAnimation("melt")
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function onfiremelt(inst)
    inst.components.perishable.frozenfiremult = true
end

local function onstopfiremelt(inst)
    inst.components.perishable.frozenfiremult = false
end

local function playfallsound(inst)
    local ice_fall_sound =
    {
        [WORLD_TILES.BEACH] = "dontstarve_DLC002/common/ice_fall_beach",
        [WORLD_TILES.JUNGLE] = "dontstarve_DLC002/common/ice_fall_jungle",
        [WORLD_TILES.TIDALMARSH] = "dontstarve_DLC002/common/ice_fall_marsh",
        [WORLD_TILES.MAGMAFIELD] = "dontstarve_DLC002/common/ice_fall_rocks",
        [WORLD_TILES.MEADOW] = "dontstarve_DLC002/common/ice_fall_grass",
        [WORLD_TILES.VOLCANO] = "dontstarve_DLC002/common/ice_fall_rocks",
        [WORLD_TILES.ASH] = "dontstarve_DLC002/common/ice_fall_rocks",
    }

    local tile = inst:GetCurrentTileType()
    if ice_fall_sound[tile] ~= nil then
        inst.SoundEmitter:PlaySound(ice_fall_sound[tile])
    end
end

local function onhitground_hail(inst)
    MakeInventoryPhysics(inst)
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

    if ground == WORLD_TILES.OCEAN_COASTAL or
        ground == WORLD_TILES.OCEAN_COASTAL_SHORE or
        ground == WORLD_TILES.OCEAN_SWELL or
        ground == WORLD_TILES.OCEAN_ROUGH or
        ground == WORLD_TILES.OCEAN_BRINEPOOL or
        ground == WORLD_TILES.OCEAN_BRINEPOOL_SHORE or
        ground == WORLD_TILES.OCEAN_WATERLOG or
        ground == WORLD_TILES.OCEAN_HAZARDOUS then
        inst:Remove()
        local bolha = SpawnPrefab("frogsplash")
        bolha.Transform:SetPosition(x, y, z)
    else
        playfallsound(inst)
    end
end

local function hailfn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()
    --inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.AnimState:SetBank("hail")
    inst.AnimState:SetBuild("hail")
    inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)

    --MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("smotherer")

    inst:AddTag("frozen")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 8
    inst.components.edible.degrades_with_spoilage = false
    inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF * 1.5

    inst:ListenForEvent("firemelt", onfiremelt)
    inst:ListenForEvent("stopfiremelt", onstopfiremelt)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetOnPickupFn(onstopfiremelt)

    inst:DoTaskInTime(1.4, onhitground_hail)
    inst.OnSave = onsave
    inst.OnLoad = onload
    MakeHauntableLaunchAndSmash(inst)
    inst:AddComponent("bait")
    inst:AddTag("molebait")
    return inst
end

return Prefab("hail_ice", hailfn, assets)
