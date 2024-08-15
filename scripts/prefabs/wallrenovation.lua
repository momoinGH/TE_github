local function SpawnPiso2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst:AddTag("prototyper")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("prototyper")
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.HOME_TWO

    return inst
end

--原型机组件并不提供范围的变量，只能修改builder的方法查找半径，我不喜欢覆盖的做法
return Prefab("wallrenovation", SpawnPiso2)
