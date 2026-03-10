local function get_oinc_cost(recipe)
    for _, v in ipairs(recipe.ingredients) do
        if v.type == "oinc" then
            return v.amount
        end
    end
end

AddComponentPostInit("builder", function(self)
    -- 对于配方的nounlock，如果我加上就会被分类到”模组物品“下，建筑可以正常建造，如果不加，被分类到“翻新”，但是无法正常建造，不过对于物品加不加都可以正常获得
    -- 这里在建造前添加到配方中，使KnowsRecipe方法返回true，可以正常建造，其实我这里不知道该怎么写，只好覆盖了原方法，都是因为这个不支持placer
    Hooks.FnDecorator(self, "MakeRecipeAtPoint", function(self, recipe)
        if not self:KnowsRecipe(recipe) and recipe.level.HOME and recipe.level.HOME == 2 then
            self:AddRecipe(recipe.name)
        end
    end)

    Hooks.FnDecorator(self, "HasIngredients", function(self, recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if not (recipe and get_oinc_cost(recipe)) then
            return
        end

        if self.freebuildmode then
            return { true }, true
        end
        for i, v in ipairs(recipe.ingredients) do
            local amount = math.max(1, RoundBiasedUp(v.amount * self.ingredientmod))
            if v.type == "oinc" then
                if self.inst.components.inventory:GetMoney() < amount then
                    return { false }, true
                end
            else
                if not self.inst.components.inventory:Has(v.type, amount, true) then
                    return { false }, true
                end
            end
        end
        for i, v in ipairs(recipe.character_ingredients) do
            if not self:HasCharacterIngredient(v) then
                return { false }, true
            end
        end
        for i, v in ipairs(recipe.tech_ingredients) do
            if not self:HasTechIngredient(v) then
                return { false }, true
            end
        end
        return { true }, true
    end)

    --- 对消耗呼噜币的扣除
    Hooks.FnDecorator(self, "RemoveIngredients", function(self, ingredients, recname, ...)
        local recipe = GetValidRecipe(recname)
        if self.freebuildmode or not recipe then return end

        -- 自己扣除呼噜币
        for i, v in ipairs(recipe.ingredients) do
            if v.type == "oinc" then
                self.inst.components.inventory:PayMoney(v.amount)
            end
        end

        --移除呼噜币的扣除
        local newIngredients = {}
        for item, ents in pairs(ingredients) do
            if item ~= "oinc" then
                newIngredients[item] = ents
            end
        end
        return nil, false, { self, newIngredients, recname, ... }
    end)

    -- 对呼噜币进行换算，也许修改HasIngredients也行，不过应该没这个简单
    local oldHas = self.Has
    function self:Has(item, amount, ...)
        if not TUNING.OINCS[item] then
            return oldHas(self, item, amount, ...)
        end

        local all = 0
        for name, val in pairs(TUNING.OINCS) do
            local _, count = oldHas(self, name, 1, ...)
            all = all + count * val
        end

        local need = TUNING.OINCS[item] * amount
        if all >= need then
            return true, math.floor(all / TUNING.OINCS[item])
        else
            return false, all
        end
    end
end)
