local Utils = require("tropical_utils/utils")

function RoundBiasedUp(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

local TechTree = require("techtree")
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


    local function GiveOrDropItem(self, recipe, item, pt)
        if recipe.dropitem then
            local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
            local r = item:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
            item.Transform:SetPosition(pt.x + r * math.cos(angle), pt.y, pt.z - r * math.sin(angle))
            item.components.inventoryitem:OnDropped()
        else
            self.inst.components.inventory:GiveItem(item, nil, pt)
        end
    end

    function self:DoBuild(recname, pt, rotation, skin)
        local recipe = GetValidRecipe(recname)
        if recipe ~= nil and (self:IsBuildBuffered(recname) or self:HasIngredients(recipe)) then
            if recipe.placer ~= nil and
                self.inst.components.rider ~= nil and
                self.inst.components.rider:IsRiding() then
                return false, "MOUNTED"
            elseif recipe.level.ORPHANAGE > 0 and (
                    self.inst.components.petleash == nil or
                    self.inst.components.petleash:IsFull() or
                    self.inst.components.petleash:HasPetWithTag("critter")
                ) then
                return false, "HASPET"
            elseif recipe.manufactured and (
                    self.current_prototyper == nil or
                    not self.current_prototyper:IsValid() or
                    self.current_prototyper.components.prototyper == nil or
                    not CanPrototypeRecipe(recipe.level, self.current_prototyper.components.prototyper.trees)
                ) then
                -- manufacturing stations requires the current active protyper in order to work
                return false
            end

            if recipe.canbuild ~= nil then
                local success, msg = recipe.canbuild(recipe, self.inst, pt, rotation)
                if not success then
                    return false, msg
                end
            end

            local is_buffered_build = self.buffered_builds[recname] ~= nil
            if is_buffered_build then
                self.buffered_builds[recname] = nil
                self.inst.replica.builder:SetIsBuildBuffered(recname, false)
            end

            if self.inst:HasTag("hungrybuilder") and not self.inst.sg:HasStateTag("slowaction") then
                local t = GetTime()
                if self.last_hungry_build == nil or t > self.last_hungry_build + TUNING.HUNGRY_BUILDER_RESET_TIME then
                    self.inst.components.hunger:DoDelta(TUNING.HUNGRY_BUILDER_DELTA)
                    self.inst:PushEvent("hungrybuild")
                end
                self.last_hungry_build = t
            end

            self.inst:PushEvent("refreshcrafting")

            if recipe.manufactured then
                local materials = self:GetIngredients(recname)
                self:RemoveIngredients(materials, recname)
                -- its up to the prototyper to implement onactivate and handle spawning the prefab
                return true
            end

            if self.inst and self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("brainjelly") then
                if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses then
                    self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses:Use(1)
                end
            end

            local prod = SpawnPrefab(recipe.product, recipe.chooseskin or skin, nil, self.inst.userid) or nil
            if prod ~= nil then
                pt = pt or self.inst:GetPosition()

                if prod.components.inventoryitem ~= nil then
                    if self.inst.components.inventory ~= nil then
                        local materials = self:GetIngredients(recname)

                        local wetlevel = self:GetIngredientWetness(materials)
                        if wetlevel > 0 and prod.components.inventoryitem ~= nil then
                            prod.components.inventoryitem:InheritMoisture(wetlevel, self.inst:GetIsWet())
                        end

                        if prod.onPreBuilt ~= nil then
                            prod:onPreBuilt(self.inst, materials, recipe)
                        end

                        self:RemoveIngredients(materials, recname)

                        --self.inst.components.inventory:GiveItem(prod)
                        self.inst:PushEvent("builditem",
                            { item = prod, recipe = recipe, skin = skin, prototyper = self.current_prototyper })
                        if self.current_prototyper ~= nil and self.current_prototyper:IsValid() then
                            self.current_prototyper:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin }) -- added this back for the gorge.
                        end
                        ProfileStatsAdd("build_" .. prod.prefab)

                        if prod.components.equippable ~= nil
                            and not recipe.dropitem
                            and self.inst.components.inventory:GetEquippedItem(prod.components.equippable.equipslot) == nil
                            and not prod.components.equippable:IsRestricted(self.inst) then
                            if recipe.numtogive <= 1 then
                                --The item is equippable. Equip it.
                                self.inst.components.inventory:Equip(prod)
                            elseif prod.components.stackable ~= nil then
                                --The item is stackable. Just increase the stack size of the original item.
                                prod.components.stackable:SetStackSize(recipe.numtogive)
                                self.inst.components.inventory:Equip(prod)
                            else
                                --We still need to equip the original product that was spawned, so do that.
                                self.inst.components.inventory:Equip(prod)
                                --Now spawn in the rest of the items and give them to the player.
                                for i = 2, recipe.numtogive do
                                    local addt_prod = SpawnPrefab(recipe.product)
                                    self.inst.components.inventory:GiveItem(addt_prod, nil, pt)
                                end
                            end
                        elseif recipe.numtogive <= 1 then
                            --Only the original item is being received.
                            GiveOrDropItem(self, recipe, prod, pt)
                        elseif prod.components.stackable ~= nil then
                            --The item is stackable. Just increase the stack size of the original item.
                            prod.components.stackable:SetStackSize(recipe.numtogive)
                            GiveOrDropItem(self, recipe, prod, pt)
                        else
                            --We still need to give the player the original product that was spawned, so do that.
                            GiveOrDropItem(self, recipe, prod, pt)
                            --Now spawn in the rest of the items and give them to the player.
                            for i = 2, recipe.numtogive do
                                local addt_prod = SpawnPrefab(recipe.product)
                                GiveOrDropItem(self, recipe, addt_prod, pt)
                            end
                        end

                        NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

                        if self.onBuild ~= nil then
                            self.onBuild(self.inst, prod)
                        end
                        prod:OnBuilt(self.inst)

                        return true
                    else
                        prod:Remove()
                        prod = nil
                    end
                else
                    if not is_buffered_build then -- items that have intermediate build items (like statues)
                        local materials = self:GetIngredients(recname)
                        self:RemoveIngredients(materials, recname)
                    end

                    local spawn_pos = pt

                    -- If a non-inventoryitem recipe specifies dropitem, position the created object
                    -- away from the builder so that they don't overlap.
                    if recipe.dropitem then
                        local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
                        local r = prod:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
                        spawn_pos = Vector3(
                            spawn_pos.x + r * math.cos(angle),
                            spawn_pos.y,
                            spawn_pos.z - r * math.sin(angle)
                        )
                    end

                    prod.Transform:SetPosition(spawn_pos:Get())
                    --V2C: or 0 check added for backward compatibility with mods that
                    --     have not been updated to support placement rotation yet
                    prod.Transform:SetRotation(rotation or 0)
                    self.inst:PushEvent("buildstructure", { item = prod, recipe = recipe, skin = skin })
                    prod:PushEvent("onbuilt", { builder = self.inst, pos = pt })
                    ProfileStatsAdd("build_" .. prod.prefab)
                    NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

                    if self.onBuild ~= nil then
                        self.onBuild(self.inst, prod)
                    end

                    prod:OnBuilt(self.inst)

                    return true
                end
            end
        end
    end

    function self:KnowsRecipe(recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if recipe == nil then
            return false
        end
        if self.freebuildmode or self.inst:HasTag("brainjelly") then
            return true
        elseif recipe.builder_tag ~= nil and not self.inst:HasTag(recipe.builder_tag) then -- builder_tag cehck is require due to character swapping
            return false
        elseif self.station_recipes[recipe.name] or table.contains(self.recipes, recipe.name) then
            return true
        end

        local has_tech = true
        for i, v in ipairs(TechTree.AVAILABLE_TECH) do
            if recipe.level[v] > (self[string.lower(v) .. "_bonus"] or 0) then
                return false
            end
        end
        return true
    end

    function self:HasIngredients(recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end
        if recipe ~= nil then
            if self.freebuildmode then
                return true
            end
            for i, v in ipairs(recipe.ingredients) do
                if v.type == "oinc" then
                    if self.inst.components.inventory:GetMoney() >= v.amount then
                        return true
                    end
                end

                if not self.inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self.ingredientmod)), true) then
                    return false
                end
            end
            for i, v in ipairs(recipe.character_ingredients) do
                if not self:HasCharacterIngredient(v) then
                    return false
                end
            end
            for i, v in ipairs(recipe.tech_ingredients) do
                if not self:HasTechIngredient(v) then
                    return false
                end
            end
            return true
        end

        return false
    end

    function self:MakeRecipeAtPoint(recipe, pt, rot, skin)
        ----------------------------------------------------------
        if recipe.product == "sprinkler1" and (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then
            return
                self:MakeRecipe(recipe, pt, rot, skin)
        end
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end                         --adicionado por vagner
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end                         --adicionado por vagner
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and TheWorld:HasTag("cave")) then return false end        --adicionado por vagner
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and TheWorld:HasTag("cave")) then return false end   --adicionado por vagner
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and TheWorld:HasTag("cave")) then return false end      --adicionado por vagner
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and TheWorld:HasTag("cave")) then return false end --adicionado por vagner
        if (TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and TheWorld:HasTag("cave")) then return false end  --adicionado por vagner
        if recipe.placer ~= nil and
            --        self:KnowsRecipe(recipe.name) and
            self:IsBuildBuffered(recipe.name) and
            TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot) then
            self:MakeRecipe(recipe, pt, rot, skin)
        end
    end
end)
