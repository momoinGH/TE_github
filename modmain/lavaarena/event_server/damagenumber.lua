local function Setup(inst, target, damage, large)
    inst.target:set(target)
    inst.damage:set(damage)
    large = large or false
    inst.large:set_local(large)
    inst.large:set(large)
end

local function master_postinit(inst)
    inst.Setup = Setup

    inst:DoTaskInTime(3, inst.Remove)
    inst.persists = false
end

--- 客机伤害数值显示动画
add_event_server_data("lavaarena", "prefabs/damagenumber", {
    master_postinit = master_postinit
})
