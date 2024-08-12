local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("interior_center")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    return inst
end

-- 这是虚空小房子的中心点，每个小房子中心位置必有该对象
-- 用对象表示中心点的好处是主客机都能查找到该对象
-- 也可以添加一些网络变量表示各种属性，比如房子的半径
return Prefab("interior_center", fn)
