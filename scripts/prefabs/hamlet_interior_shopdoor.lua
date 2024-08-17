local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {

}

local function common(anim)
    local inst = InteriorSpawnerUtils.MakeBaseDoor("pig_shop_doormats", "pig_shop_doormats", anim, true, true, nil, "dontstarve_DLC003/common/objects/store/door_close")

    inst:AddTag("hamlet_houseexit")

    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    if not TheWorld.ismastersim then
        return inst
    end
end

local function pig_shop_giftshop_door_fn()
    local inst = common("idle_giftshop")
    inst:AddTag("guard_entrance")
    return inst
end

return Prefab("pig_shop_giftshop_door", pig_shop_giftshop_door_fn, assets)
