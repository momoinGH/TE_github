local Utils = require("tropical_utils/utils")

--渡渡鸟数量控制
_G.SEABEACH_AMOUNT = {
    doydoy = 0,
}

EQUIPSLOTS.BARCO = "barco" --TODO 待删

-- TODO 定义新的FUELTYPE最好给图鉴一个图片
-- FUELTYPE_SUBICON_LOOKUP
FUELTYPE.TAR = "TAR"
FUELTYPE.REPARODEBARCO = "REPARODEBARCO"
FUELTYPE.LIVINGARTIFACT = "LIVINGARTIFACT"
FUELTYPE.ANCIENT_REMNANT = "ANCIENT_REMNANT" -- Runar: 在modmain太炸裂了
FUELTYPE.CORK = "CORK"

MATERIALS.SANDBAG = "sandbag"
MATERIALS.LIMESTONE = "limestone"
MATERIALS.ENFORCEDLIMESTONE = "enforcedlimestone"

TOOLACTIONS["HACK"] = true
TOOLACTIONS["SHEAR"] = true
TOOLACTIONS["PAN"] = true
TOOLACTIONS["INVESTIGATEGLASS"] = true


Utils.FnDecorator(GLOBAL, "PlayFootstep", function(inst)
    local boat = inst:GetCurrentPlatform()
    return nil, boat and boat:HasTag("shipwrecked_boat") --海难小船时不播放走路音效
end)

--- 掉落一个物品，ReplacePrefab的强化
GLOBAL.TropicalDropItem = function(inst, item, isremove)
    local product
    if isremove then
        product = ReplacePrefab(inst, item)
    else
        product = SpawnPrefab(item)
        product.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    if product.components.inventoryitem then
        product.components.inventoryitem:OnDropped()
    end
end


GLOBAL.AddComponentIfNot = function(inst, name)
    if not inst.components[name] then
        inst:AddComponent(name)
    end
end
