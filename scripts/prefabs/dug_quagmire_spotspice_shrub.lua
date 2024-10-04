--require "prefabutil"

local WAXED_PLANTS = require "prefabs/waxed_plant_common"

local function make_plantable(data)
    local bank = data.bank or data.name
    local assets =
    {
        Asset("ANIM", "anim/dug_quagmire_spotspice_shrub.zip"),
    }

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab(data.name)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            tree.components.pickable:OnTransplant()
            tree.components.pickable:MakeEmpty()
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                --V2C: WHY?!! because many of the plantables don't
                --     have SoundEmitter, and we don't want to add
                --     one just for this sound!
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        --inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("dug_quagmire_spotspice_shrub")
        inst.AnimState:SetBuild("dug_quagmire_spotspice_shrub")
        inst.AnimState:PlayAnimation("dropped")
		inst.scrapbook_anim = "dropped"
        inst.AnimState:SetScale(1.5, 1.5, 1.5)

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end
            inst.scrapbook_specialinfo = "PLANTABLE"

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = data.inspectoverride or ("dug_"..data.name)

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/inventory_quagmire.xml"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end

        ---------------------
        return inst
    end

    return Prefab("dug_quagmire_spotspice_shrub", fn, assets)
end

local plantables =
{
    {
        name = "quagmire_spiceshrub",
        anim = "empty",
		inspectoverride = "dug_berrybush",
		floater = {"med", 0.2, 0.95},
        --bank = "dug_quagmire_spotspice_shrub",
        --build = "dug_quagmire_spotspice_shrub",
        --prefabbank = "quagmire_spotspiceshrub",
        --prefabbuild = "quagmire_spotspiceshrub",
        --prefabanim = "idle",
    },
}
--[[
local prefabs = {}
for i, v in ipairs(plantables) do
    table.insert(prefabs, make_plantable(v))
    table.insert(prefabs, MakePlacer("dug_"..v.name.."_placer", v.prefabbank or v.name, v.prefabbuild or v.name, v.prefabanim or "idle"))
end]]

local prefabs = {}

for _, data in ipairs(plantables) do
    table.insert(prefabs, make_plantable(data))
    table.insert(prefabs, MakePlacer("dug_"..data.name.."_placer", data.bank or data.name, data.build or data.name, data.anim or "idle"))

    table.insert(prefabs, WAXED_PLANTS.CreateDugWaxedPlant(data))
end

return unpack(prefabs)
