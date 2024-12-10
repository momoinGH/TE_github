local assets =
{
    Asset("ANIM", "anim/turf_quagmire.zip"),
}

local prefabs =
{
    "gridplacer",
}

local function make_turf(tile, data)
    local function ondeploy(inst, pt, deployer)
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
        end

        local map = TheWorld.Map
        local original_tile_type = map:GetTileAtPoint(pt:Get())
        local x, y = map:GetTileCoordsAtPoint(pt:Get())
        if x ~= nil and y ~= nil then
            map:SetTile(x, y, tile)
            map:RebuildLayer(original_tile_type, x, y)
            map:RebuildLayer(tile, x, y)
        end

        local minimap = TheWorld.minimap.MiniMap
        minimap:RebuildLayer(original_tile_type, x, y)
        minimap:RebuildLayer(tile, x, y)

        inst.components.stackable:Get():Remove()
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)

        inst.AnimState:SetBank("turf_quagmire")
        inst.AnimState:SetBuild("turf_quagmire")
        inst.AnimState:PlayAnimation(data.anim)

        inst.tile = tile

        inst:AddTag("groundtile")
        inst:AddTag("molebait")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst.components.inventoryitem.atlasname = data.invent
        inst:AddComponent("bait")

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
        MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.TURF)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetUseGridPlacer(true)

        ---------------------
        return inst
    end

    return Prefab("turf_" .. data.name, fn, assets, prefabs)
end

local ret = {}

table.insert(ret,
    make_turf(GROUND.QUAGMIRE_GATEWAY or GROUND.MARSH,
        { name = "quagmire_gateway", anim = "quagmire_gateway" })) --place a marsh tile, if the swamp generation is disabled
table.insert(ret,
    make_turf(GROUND.QUAGMIRE_CITYSTONE or GROUND.MARSH,
        { name = "quagmire_citystone", anim = "quagmire_citystone" })) --place a marsh tile, if the swamp generation is disabled
table.insert(ret,
    make_turf(GROUND.QUAGMIRE_PARKFIELD or GROUND.MARSH,
        { name = "quagmire_parkfield", anim = "quagmire_parkfield" })) --place a marsh tile, if the swamp generation is disabled
table.insert(ret,
    make_turf(GROUND.QUAGMIRE_PARKSTONE or GROUND.MARSH,
        { name = "quagmire_parkstone", anim = "quagmire_parkstone" })) --place a marsh tile, if the swamp generation is disabled
table.insert(ret,
    make_turf(GROUND.QUAGMIRE_PEATFOREST or GROUND.MARSH,
        { name = "quagmire_peatforest", anim = "quagmire_peatforest" })) --place a marsh tile, if the swamp generation is disabled

return unpack(ret)
