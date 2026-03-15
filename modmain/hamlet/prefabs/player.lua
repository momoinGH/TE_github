AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.infestable == nil then
        inst:AddComponent("infestable") --虫子感染
    end
    if inst.components.shopper == nil then
        inst:AddComponent("shopper") --购买商品
    end
end)
