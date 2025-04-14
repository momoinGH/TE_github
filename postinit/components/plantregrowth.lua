local regrowthfunc = function()
    return TUNING.EVERGREEN_REGROWTH_TIME_MULT
end

local plants = { "jungletree", "palmtree", "tree_mamgrove", "tubertree", "teatree", "rainforesttree", "clawpalmtree" }

AddComponentPostInit("plantregrowth", function(self)
    for i, v in ipairs(plants) do
        self.TimeMultipliers[v] = regrowthfunc
    end
end)

for i, v in ipairs(plants) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag(v)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("plantregrowth")
        inst.components.plantregrowth:SetRegrowthRate(TUNING.EVERGREEN_REGROWTH.OFFSPRING_TIME)
        -- inst.components.plantregrowth:SetProduct(v)
        inst.components.plantregrowth:SetSearchTag(v)
    end)
end

AddComponentPostInit("plantregrowth", function(self)
    self.TimeMultipliers["mushtree_yellow"] = function()
        return TUNING.MUSHTREE_REGROWTH_TIME_MULT * ((not TheWorld.state.autumn and 0) or 1)
    end
end)