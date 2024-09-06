local ZERO_DISTANCE = 10
local ZERO_DISTSQ = ZERO_DISTANCE * ZERO_DISTANCE

local UPDATE_SPAWNLIGHT_ONEOF_TAGS = { "HASHEATER", "spawnlight" }
local UPDATE_NOSPAWNLIGHT_MUST_TAGS = { "HASHEATER" }
local function OnUpdate(self, dt, applyhealthdelta)
    self.externalheaterpower = 0
    self.delta = 0
    self.rate = 0

    if self.settemp ~= nil or
        self.inst.is_teleporting or
        (self.inst.components.health ~= nil and self.inst.components.health:IsInvincible()) then
        return
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()

    -- Can override range, e.g. in special containers
    local mintemp = self.mintemp
    local maxtemp = self.maxtemp

    local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
    local inside_pocket_container = owner ~= nil and owner:HasTag("pocketdimension_container")

    local ambient_temperature = inside_pocket_container and TheWorld.state.temperature or GetTemperatureAtXZ(x, z)

    --###
    if self.inst:HasTag("heatrock") then
        local ex, ey, ez = self.inst.Transform:GetWorldPosition()
        local map = TheWorld.Map
        local posicao = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez))
        local posicao1 = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez + 5))
        local posicao2 = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez - 5))
        local posicao3 = map:GetTile(map:GetTileCoordsAtPoint(ex + 5, ey, ez))
        local posicao4 = map:GetTile(map:GetTileCoordsAtPoint(ex - 5, ey, ez))

        if posicao == (GROUND.ANTFLOOR)
            or posicao1 == (GROUND.ANTFLOOR)
            or posicao2 == (GROUND.ANTFLOOR)
            or posicao3 == (GROUND.ANTFLOOR)
            or posicao4 == (GROUND.ANTFLOOR)
            or posicao == (GROUND.WATER_MANGROVE)
            or posicao1 == (GROUND.WATER_MANGROVE)
            or posicao2 == (GROUND.WATER_MANGROVE)
            or posicao3 == (GROUND.WATER_MANGROVE)
            or posicao4 == (GROUND.WATER_MANGROVE)
        then
            ambient_temperature = -20
        end
    end
    ------------------------------caverna congelada---------------------------------------------
    --[[	
	if TheWorld:HasTag("cave") then
	local ex, ey, ez = self.inst.Transform:GetWorldPosition()	
	local map = TheWorld.Map
	local posicao = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez))
	local posicao1 = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez+5))
	local posicao2 = map:GetTile(map:GetTileCoordsAtPoint(ex, ey, ez-5))
	local posicao3 = map:GetTile(map:GetTileCoordsAtPoint(ex+5, ey, ez))
	local posicao4 = map:GetTile(map:GetTileCoordsAtPoint(ex-5, ey, ez))	
	
	if posicao == (GROUND.ANTFLOOR) or posicao1 == (GROUND.ANTFLOOR) or posicao2 == (GROUND.ANTFLOOR) or posicao3 == (GROUND.ANTFLOOR) or posicao4 == (GROUND.ANTFLOOR) or
	posicao == (GROUND.WATER_MANGROVE) or posicao1 == (GROUND.WATER_MANGROVE) or posicao2 == (GROUND.WATER_MANGROVE) or posicao3 == (GROUND.WATER_MANGROVE) or posicao4 == (GROUND.WATER_MANGROVE) then
	ambient_temperature = -20
	end
	end
]]
    ------------------------------------------frost------------------------------------------------------------	
    if self.inst.components.areaaware and self.inst.components.areaaware:CurrentlyInTag("frost") then
        ambient_temperature = -20
    elseif TheWorld.state.iswinter and TUNING.tropical.only_shipwrecked or
        TheWorld.state.iswinter and self.inst and self.inst.components.areaaware and self.inst.components.areaaware:CurrentlyInTag("tropical") or
        TheWorld.state.iswinter and self.inst and self.inst.components.areaaware and self.inst.components.areaaware:CurrentlyInTag("hamlet")
    then
        -----------------------------------------------mais quente no inverno ------------------------------
        ambient_temperature = TheWorld.state.temperature + 40
        if self.inst.components.moisture and self.inst:HasTag("player") and TheWorld.state.issnowing then
            self.inst.components.moisture.hamletzone = true
        end
        if self.inst.components.moisture and self.inst:HasTag("player") and not TheWorld.state.issnowing then
            self.inst.components.moisture.hamletzone = false
        end
    else
        if self.inst.components.moisture and self.inst:HasTag("player") then
            self.inst.components.moisture.hamletzone = false
        end
    end
    ---------------------------------------frio no verão ------------------------------	
    if TheWorld.state.issummer and TUNING.tropical.only_hamlet or
        TheWorld.state.issummer and self.inst and self.inst.components.areaaware and self.inst.components.areaaware:CurrentlyInTag("hamlet") then
        ambient_temperature = TheWorld.state.temperature - 30
    end
    if TheWorld.state.issummer and TUNING.tropical.only_shipwrecked or
        TheWorld.state.issummer and self.inst and self.inst.components.areaaware and self.inst.components.areaaware:CurrentlyInTag("tropical") then
        ambient_temperature = TheWorld.state.temperature - 10
    end
    ----------------------ajusta temperatura da casa---------------------------
    if self.inst and self.inst:HasTag("player") then
        local interior = GetClosestInstWithTag("interior_center", self.inst, 15)
        if interior and TheWorld.state.iswinter then
            ambient_temperature = TheWorld.state.temperature + 40
        elseif interior and TheWorld.state.issummer then
            ambient_temperature = TheWorld.state.temperature - 30
        end
    end

    ------------------------------------------------------------------------------------------------------------------------------	
    --###

    if owner ~= nil and owner:HasTag("fridge") and not owner:HasTag("nocool") then
        -- Inside a fridge, excluding icepack ("nocool")
        -- Don't cool it below freezing unless ambient temperature is below freezing
        mintemp = math.max(mintemp, math.min(0, ambient_temperature))
        self.rate = owner:HasTag("lowcool") and -.5 * TUNING.WARM_DEGREES_PER_SEC or -TUNING.WARM_DEGREES_PER_SEC
    else
        local sleepingbag_ambient_temp = self.inst.sleepingbag ~= nil and
            self.inst.sleepingbag.components.sleepingbag.ambient_temp
        if sleepingbag_ambient_temp then
            ambient_temperature = sleepingbag_ambient_temp
        end

        local ents
        if not inside_pocket_container then
            -- Prepare to figure out the temperature where we are standing
            ents = self.usespawnlight and
                TheSim:FindEntities(x, y, z, ZERO_DISTANCE, nil, self.ignoreheatertags, UPDATE_SPAWNLIGHT_ONEOF_TAGS) or
                TheSim:FindEntities(x, y, z, ZERO_DISTANCE, UPDATE_NOSPAWNLIGHT_MUST_TAGS, self.ignoreheatertags)
            if self.usespawnlight and #ents > 0 then
                for i, v in ipairs(ents) do
                    if v.components.heater == nil and v:HasTag("spawnlight") then
                        ambient_temperature = math.clamp(ambient_temperature, 10, TUNING.OVERHEAT_TEMP - 20)
                        table.remove(ents, i)
                        break
                    end
                end
            end
        end

        if self.sheltered_level > 1 then
            ambient_temperature = math.min(ambient_temperature, self.overheattemp - 5)
        end

        self.delta = (ambient_temperature + self.totalmodifiers + self:GetMoisturePenalty()) - self.current
        --print(self.delta + self.current, "initial target")

        if self.inst.components.inventory ~= nil then
            for k, v in pairs(self.inst.components.inventory.equipslots) do
                if v.components.heater ~= nil then
                    local heat = v.components.heater:GetEquippedHeat()
                    if heat ~= nil and
                        ((heat > self.current and v.components.heater:IsExothermic()) or
                            (heat < self.current and v.components.heater:IsEndothermic())) then
                        self.delta = self.delta + heat - self.current
                    end
                end
            end
            for k, v in pairs(self.inst.components.inventory.itemslots) do
                if v.components.heater ~= nil then
                    local heat, carriedmult = v.components.heater:GetCarriedHeat()
                    if heat ~= nil and
                        ((heat > self.current and v.components.heater:IsExothermic()) or
                            (heat < self.current and v.components.heater:IsEndothermic())) then
                        self.delta = self.delta + (heat - self.current) * carriedmult
                    end
                end
            end
            local overflow = self.inst.components.inventory:GetOverflowContainer()
            if overflow ~= nil then
                for k, v in pairs(overflow.slots) do
                    if v.components.heater ~= nil then
                        local heat, carriedmult = v.components.heater:GetCarriedHeat()
                        if heat ~= nil and
                            ((heat > self.current and v.components.heater:IsExothermic()) or
                                (heat < self.current and v.components.heater:IsEndothermic())) then
                            self.delta = self.delta + (heat - self.current) * carriedmult
                        end
                    end
                end
            end
        end

        --print(self.delta + self.current, "after carried/equipped")

        -- Recently eaten temperatured food is inherently equipped heat/cold
        if self.bellytemperaturedelta ~= nil and (
                (self.bellytemperaturedelta > 0 and self.current < TUNING.HOT_FOOD_WARMING_THRESHOLD) or
                (self.bellytemperaturedelta < 0 and self.current > TUNING.COLD_FOOD_CHILLING_THRESHOLD)
            ) then
            self.delta = self.delta + self.bellytemperaturedelta
        end

        --print(self.delta + self.current, "after belly")

        -- If very hot (basically only when have overheating screen effect showing) and under shelter, cool slightly
        if self.sheltered and self.current > TUNING.TREE_SHADE_COOLING_THRESHOLD then
            self.delta = self.delta - (self.current - TUNING.TREE_SHADE_COOLER)
        end

        local heat_factor_penalty = TUNING.WET_HEAT_FACTOR_PENALTY -- Cache.
        --print(self.delta + self.current, "after shelter")
        if not inside_pocket_container then
            for i, v in ipairs(ents) do
                if v ~= self.inst and
                    not v:IsInLimbo() and
                    v.components.heater ~= nil and
                    (v.components.heater:IsExothermic() or v.components.heater:IsEndothermic()) then
                    local heat = v.components.heater:GetHeat(self.inst)
                    if heat ~= nil then
                        local heatfactor, dsqtoinst
                        if v.components.heater:ShouldFalloff() then
                            -- This produces a gentle falloff from 1 to zero.
                            dsqtoinst = self.inst:GetDistanceSqToInst(v)
                            heatfactor = 1 - dsqtoinst / ZERO_DISTSQ
                        else
                            heatfactor = 1
                        end
                        local radius_cutoff = v.components.heater:GetHeatRadiusCutoff()
                        if radius_cutoff then
                            dsqtoinst = dsqtoinst or self.inst:GetDistanceSqToInst(v)
                            if dsqtoinst > radius_cutoff * radius_cutoff then
                                heatfactor = 0
                            end
                        end

                        if heatfactor > 0 then
                            if self.inst:GetIsWet() then -- NOTES(JBK): Leave this in the loop because the entity could go out of IsWet status in this loop.
                                if heat > 0 then
                                    heatfactor = heatfactor * heat_factor_penalty
                                elseif heat_factor_penalty ~= 0 then -- In case of mods setting the tuning to 0.
                                    heatfactor = heatfactor / heat_factor_penalty
                                end
                            end

                            if v.components.heater:IsExothermic() then
                                -- heating heatfactor is relative to 0 (freezing)
                                local warmingtemp = heat * heatfactor
                                if warmingtemp > self.current then
                                    self.delta = self.delta + warmingtemp - self.current
                                end
                                self.externalheaterpower = self.externalheaterpower + heatfactor
                            else --if v.components.heater:IsEndothermic() then
                                -- cooling heatfactor is relative to overheattemp
                                local coolingtemp = (heat - self.overheattemp) * heatfactor + self.overheattemp
                                if coolingtemp < self.current then
                                    self.delta = self.delta + coolingtemp - self.current
                                end
                            end
                        end
                    end
                end
            end
        end

        --print(self.delta + self.current, "after heaters")

        -- Winter insulation only affects you when it's cold out, summer insulation only helps when it's warm
        if ambient_temperature >= TUNING.STARTING_TEMP then
            -- it's warm out
            if self.delta > 0 then
                -- If the player is heating up, defend using insulation.
                local winterInsulation, summerInsulation = self:GetInsulation()
                self.rate = math.min(self.delta, TUNING.SEG_TIME / (TUNING.SEG_TIME + summerInsulation))
            else
                -- If they are cooling, do it at full speed, and faster if they're overheated
                self.rate = math.max(self.delta,
                    self.current >= self.overheattemp and -TUNING.THAW_DEGREES_PER_SEC or -TUNING.WARM_DEGREES_PER_SEC)
            end
            -- it's cold out
        elseif self.delta < 0 then
            -- If the player is cooling, defend using insulation.
            local winterInsulation, summerInsulation = self:GetInsulation()
            self.rate = math.max(self.delta, -TUNING.SEG_TIME / (TUNING.SEG_TIME + winterInsulation))
        else
            -- If they are heating up, do it at full speed, and faster if they're freezing
            self.rate = math.min(self.delta,
                self.current <= 0 and TUNING.THAW_DEGREES_PER_SEC or TUNING.WARM_DEGREES_PER_SEC)
        end

        --print(self.delta + self.current, "after insulation")
        --print(self.rate, "final rate\n\n")
    end

    self:SetTemperature(math.clamp(self.current + self.rate * dt, mintemp, maxtemp))

    --applyhealthdelta nil defaults to true
    if applyhealthdelta ~= false and self.inst.components.health ~= nil then
        if self.current < 0 then
            self.inst.components.health:DoDelta(-self.hurtrate * dt, true, "cold")
        elseif self.current > self.overheattemp then
            self.inst.components.health:DoDelta(-(self.overheathurtrate or self.hurtrate) * dt, true, "hot")
        end
    end
end

AddComponentPostInit("temperature", function(self)
    self.OnUpdate = OnUpdate
end)
