local names = { "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10" }

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end


return {
    master_postinit = function(inst)
        inst.animname = names[math.random(#names)]
        inst.AnimState:PlayAnimation(inst.animname)

        inst:AddComponent("inspectable")

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp("foliage", 10)
        inst.components.pickable.remove_when_picked = true
        inst.components.pickable.quickpick = true

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        MakeHauntableIgnite(inst)

        --------SaveLoad
        inst.OnSave = onsave
        inst.OnLoad = onload
    end
}
