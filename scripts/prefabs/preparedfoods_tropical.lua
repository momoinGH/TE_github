
local prefabs =
{
    "spoiled_food",
}

local function MakePreparedFood(data)
	local foodassets =
	{
		Asset("ANIM", "anim/cook_pot_food.zip"),
		Asset("INV_IMAGE", data.name),
	}

	if data.overridebuild then
        table.insert(foodassets, Asset("ANIM", "anim/"..data.overridebuild..".zip"))
        -- table.insert(foodassets, Asset("ATLAS", "images/inventoryimages/"..data.basename..".xml")) -- 独立贴图用这个
        -- table.insert(foodassets, Asset("IMAGE", "images/inventoryimages/"..data.basename..".tex"))
	end

	local spicename = data.spice ~= nil and string.lower(data.spice) or nil
    if spicename ~= nil then
        table.insert(foodassets, Asset("ANIM", "anim/spices.zip"))
        table.insert(foodassets, Asset("ANIM", "anim/plate_food.zip"))
        table.insert(foodassets, Asset("INV_IMAGE", spicename.."_over"))
    end

    local foodprefabs = prefabs
    if data.prefabs ~= nil then
        foodprefabs = shallowcopy(prefabs)
        for i, v in ipairs(data.prefabs) do
            if not table.contains(foodprefabs, v) then
                table.insert(foodprefabs, v)
            end
        end
    end

    local function DisplayNameFn(inst)
        return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

		local food_symbol_build = nil
        if spicename ~= nil then
            inst.AnimState:SetBuild("plate_food")
            inst.AnimState:SetBank("plate_food")
            inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

            inst:AddTag("spicedfood")

            inst.inv_image_bg = { image = (data.basename or data.name)..".tex" }
            inst.inv_image_bg.atlas = GetInventoryItemAtlas(inst.inv_image_bg.image)

			food_symbol_build = data.overridebuild or "cook_pot_food"
        else
			inst.AnimState:SetBuild(data.overridebuild or "cook_pot_food")
			inst.AnimState:SetBank("cook_pot_food")
        end

        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_food", data.overridebuild or "cook_pot_food", data.basename or data.name)
        inst.scrapbook_overridedata = {"swap_food", data.overridebuild or "cook_pot_food", data.basename or data.name}

        inst:AddTag("preparedfood")

        if data.tags ~= nil then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        if data.basename ~= nil then
            inst:SetPrefabNameOverride(data.basename)
            if data.spice ~= nil then
                inst.displaynamefn = DisplayNameFn
            end
        end

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst.food_symbol_build = food_symbol_build or data.overridebuild
		inst.food_basename = data.basename

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        inst.components.edible.nochill = data.nochill or nil
        inst.components.edible.spice = data.spice
        inst.components.edible:SetOnEatenFn(data.oneatenfn)

        inst:AddComponent("inspectable")
        inst.wet_prefix = data.wet_prefix

        inst:AddComponent("inventoryitem")
		if data.OnPutInInventory then
			inst:ListenForEvent("onputininventory", data.OnPutInInventory)
		end

        if spicename ~= nil then
            inst.components.inventoryitem:ChangeImageName(spicename.."_over")
        elseif data.basename ~= nil then
            -- inst.components.inventoryitem.imagename = data.basename
            inst.components.inventoryitem.atlasname = data.atlasname --暂时用的食谱大图，真大图就不合适了
            -- inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.basename..".xml" -- 独立贴图才用这个
            inst.components.inventoryitem:ChangeImageName(data.basename)
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        if data.perishtime ~= nil and data.perishtime > 0 then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(data.perishtime)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = "spoiled_food"
        end

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        ------------------------------------------------

        return inst
    end
    
    return Prefab(data.name, fn, foodassets, foodprefabs)
end

local prefs = {}

-- for k, v in pairs(require("preparedfoods_tropical")) do -- 移除prefab后用这个
--     table.insert(prefs, MakePreparedFood(v))
-- end

for k, v in pairs(require("preparedfoods_sw")) do
    table.insert(prefs, MakePreparedFood(v))
end

for k, v in pairs(require("spicedfoods")) do
    if v.mod and v.mod == true then
        v.official = false
        table.insert(prefs, MakePreparedFood(v))
    end
end

return unpack(prefs)
