AddClassPostConstruct("components/builder_replica", function(self)
    Utils.FnDecorator(self, "KnowsRecipe", function(self, recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if recipe and self.inst.replica.inventory:EquipHasTag("brainjelly") then
            return { true }, true
        end
    end)
end)
