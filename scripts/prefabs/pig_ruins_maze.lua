local function fn()
        local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    return inst
end

return Prefab("maze_pig_ruins_entrance", fn),
    Prefab("maze_pig_ruins_entrance2", fn),
    Prefab("maze_pig_ruins_entrance3", fn),
    Prefab("maze_pig_ruins_entrance4", fn),
    Prefab("maze_pig_ruins_entrance5", fn),
    Prefab("maze_pig_ruins_entrance6", fn),
    Prefab("maze_pig_ruins_entrance_small", fn),
    Prefab("maze_cave_roc_entrance", fn),
    Prefab("maze_anthill", fn),
    Prefab("maze_anthillentradarainha", fn),
    Prefab("maze_anthill_queen", fn)
