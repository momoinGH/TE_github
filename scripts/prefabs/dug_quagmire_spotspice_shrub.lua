--require "prefabutil"

-- local WAXED_PLANTS = require "prefabs/waxed_plant_common"

local function make_plantable(data)
    local name = "dug_" .. data.name

    local assets =
    {
        Asset("ANIM", "anim/" .. name .. ".zip"),
    }

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnAt(data.name, pt)
        if tree ~= nil then
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

        inst.AnimState:SetBank(data.prefabbank or name)
        inst.AnimState:SetBuild(data.prefabbuild or name)
        inst.AnimState:PlayAnimation(data.prefabanim or "idle")
		inst.scrapbook_anim = data.prefabanim
        inst.AnimState:SetScale(data.prefabscale, data.prefabscale, data.prefabscale)

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
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM -- := 10

        inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = data.inspectoverride or (name)

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = data.atlas
        inst.components.inventoryitem.imagename = data.image

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable.ondeploy = ondeploy
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end

        ---------------------
        return inst
    end

    return Prefab(name, fn, assets)
end

local plantables =
{
    {
        -- should be des' name
        name = "quagmire_spotspice_shrub",
		inspectoverride = "dug_berrybush",
		floater = { "med", .2, .95 },
        -- for placer
        bank = "quagmire_spiceshrub",
        build = "quagmire_spiceshrub",
        -- anim = "idle",
        -- for prefab
        prefabbank = "dug_quagmire_spotspice_shrub",
        prefabbuild = "dug_quagmire_spotspice_shrub",
        prefabanim = "dropped",
        prefabscale = 1.5,
        -- inventoryitem
        atlas = "images/inventoryimages/inventory_quagmire.xml",
        -- image = "",
    },
}

local prefabs = {}

for _, data in ipairs(plantables) do
    table.insert(prefabs, make_plantable(data))
    table.insert(prefabs, MakePlacer("dug_" .. data.name .. "_placer", data.bank or data.name, data.build or data.name, data.anim or "idle"))
    -- unable to be waxed
    -- table.insert(prefabs, WAXED_PLANTS.CreateDugWaxedPlant(data))
end

return unpack(prefabs)
