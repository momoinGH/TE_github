AddComponentPostInit("builder", function(self)
    -- 装备智慧帽时解锁所有配方
    Utils.FnDecorator(self, "KnowsRecipe", function(self, recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if recipe and self.inst.components.inventory:EquipHasTag("brainjelly") then
            return { true }, true
        end
    end)
end)
