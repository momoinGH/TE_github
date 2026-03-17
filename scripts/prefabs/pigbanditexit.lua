local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.persists = false
    return inst
end

return Prefab("pigbanditexit", fn)
