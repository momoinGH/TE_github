local Utils = require("tropical_utils/utils")

function RoundBiasedUp(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

AddComponentPostInit("builder", function(self)
    --- 对消耗呼噜币的扣除
    Utils.FnDecorator(self, "RemoveIngredients", function(self, ingredients, recname, ...)
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

    -- 装备智慧帽时解锁所有配方
    Utils.FnDecorator(self, "KnowsRecipe", function(self, recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if recipe and self.inst.components.inventory:EquipHasTag("brainjelly") then
            return { true }, true
        end
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

----------------------------------------------------------------------------------------------------
AddClassPostConstruct("components/builder_replica", function(self)
    Utils.FnDecorator(self, "KnowsRecipe", function(self, recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if recipe and self.inst.replica.inventory:EquipHasTag("brainjelly") then
            return { true }, true
        end
    end)

    local oldHas = self.Has
    function self:Has(item, amount, ...)
        if not TUNING.OINCS[item] or self.inst.components.inventory or not self.classified then --主机交给主机组件判断
            return oldHas(self, item, amount, ...)
        end

        local all = 0
        for key, val in pairs(TUNING.OINCS) do
            local _, count = oldHas(self, key, 1, ...)
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
