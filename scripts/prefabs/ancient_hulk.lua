local FIRE_DETECTOR_RANGE = 15
local easing = require("easing")
local brain = require("brains/ancient_hulkbrain")

local assets =
{
    Asset("ANIM", "anim/metal_hulk_build.zip"),
    Asset("ANIM", "anim/metal_hulk_basic.zip"),
    Asset("ANIM", "anim/metal_hulk_attacks.zip"),
    Asset("ANIM", "anim/metal_hulk_actions.zip"),
    Asset("ANIM", "anim/metal_hulk_barrier.zip"),
    Asset("ANIM", "anim/metal_hulk_explode.zip"),
    Asset("ANIM", "anim/metal_hulk_bomb.zip"),
    Asset("ANIM", "anim/metal_hulk_projectile.zip"),

    Asset("ANIM", "anim/laser_explode_sm.zip"),
    Asset("ANIM", "anim/smoke_aoe.zip"),
    Asset("ANIM", "anim/laser_explosion.zip"),
    --Asset("ANIM", "anim/ground_chunks_breaking.zip"),
    Asset("ANIM", "anim/ground_chunks_breaking_brown.zip"),

    --Asset("SOUND", "sound/bearger.fsb"),
}

local prefabs =
{
    "groundpound_fx",
    "groundpoundring_fx",
    "ancient_robots_assembly",
    "rock_basalt",
    "living_artifact",
    "ancient_hulk_orb_small",
    "living_artifact_blueprint",
    "ancient_hulk_marker"
}

SetSharedLootTable('ancient_hulk', {
    { 'infused_iron', 1.0 },
    { 'infused_iron', 1.0 },
    { 'infused_iron', 1.0 },
    { 'infused_iron', 1.0 },
    { 'infused_iron', 1.0 },
    { 'infused_iron', 1.0 },
    { 'infused_iron', 0.25 },

    { 'living_artifact_blueprint', 1 },

    { 'iron', 1.0 },
    { 'iron', 1.0 },
    { 'iron', 0.75 },
    { 'iron', 0.25 },
    { 'iron', 0.25 },
    { 'iron', 0.25 },

    { 'gears', 1.0 },
    { 'gears', 1.0 },
    { 'gears', 0.75 },
    { 'gears', 0.30 },
})

local DAMAGE_CANT_TAGS = { "DECOR", "INLIMBO", "laser" }
local DAMAGE_ONEOF_TAGS = { "_combat", "pickable", "NPC_workable", "CHOP_workable", "HAMMER_workable", "MINE_workable", "DIG_workable" }

local INTENSITY = .75
local function SetLightValue(inst, val1, val2, time)
    print("LIGHT VALUE", val1, val2, time)
    inst.components.fader:StopAll()
    if val1 and val2 and time then
        inst.Light:Enable(true)
        inst.components.fader:Fade(val1, val2, time, function(v) inst.Light:SetIntensity(v) end)
        --[[
        if inst.Light ~= nil then
            inst.Light:Enable(true)
            inst.Light:SetIntensity(.6 * val)
            inst.Light:SetRadius(5 * val)
            inst.Light:SetFalloff(3 * val)
        end
        ]]
    else
        inst.Light:Enable(false)
    end
end

local function setfires(x, y, z, rad)
    for _,v in ipairs(TheSim:FindEntities(x, y, z, rad, nil, DAMAGE_CANT_TAGS)) do
         if v.components.burnable then
              local vx, vy, vz = v.Transform:GetWorldPosition()
              if not TheWorld.Map:IsOceanAtPoint(vx, vy, vz, false) then
                   v.components.burnable:Ignite()
              end
         end
         -- TODO: cook raw food?
    end
end

local function applydamagetoent(inst, ent, targets, rad, hit)
    local x, y, z = inst.Transform:GetWorldPosition()
    if hit then
        targets = {}
    end
    if not rad then
        rad = 0
    end
    local v = ent
    if not targets[v] and v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) and not v:HasTag("laser_immune") then
        local vradius = 0
        if v.Physics then
            vradius = v.Physics:GetRadius()
        end

        local range = rad + vradius
        if hit or v:GetDistanceSqToPoint(Vector3(x, y, z)) < range * range then
            local isworkable = false
            if v.components.workable ~= nil then
                local work_action = v.components.workable:GetWorkAction()
                --V2C: nil action for campfires
                isworkable =
                    (work_action == nil and v:HasTag("campfire")) or

                    (work_action == ACTIONS.CHOP or
                        work_action == ACTIONS.HAMMER or
                        work_action == ACTIONS.MINE or
                        work_action == ACTIONS.DIG or
                        work_action == ACTIONS.BLANK
                    )
            end
            if isworkable then
                targets[v] = true
                v:DoTaskInTime(0.6, function()
                    if v.components.workable then
                        v.components.workable:Destroy(inst)
                        local vx, vy, vz = v.Transform:GetWorldPosition()
                        v:DoTaskInTime(0.3, function() setfires(vx, vy, vz, 1) end)
                    end
                end)
                if v:IsValid() and v:HasTag("stump") then
                    -- v:Remove()
                end
            elseif v.components.pickable ~= nil
                and v.components.pickable:CanBePicked()
                and not v:HasTag("intense") then
                targets[v] = true
                local num = v.components.pickable.numtoharvest or 1
                local product = v.components.pickable.product
                local x1, y1, z1 = v.Transform:GetWorldPosition()
                v.components.pickable:Pick(inst) -- only calling this to trigger callbacks on the object
                if product ~= nil and num > 0 then
                    for i = 1, num do
                        local loot = SpawnPrefab(product)
                        loot.Transform:SetPosition(x1, 0, z1)
                        targets[loot] = true
                    end
                end
            elseif v.components.health then
                inst.components.combat:DoAttack(v)
                if v:IsValid() then
                    if not v.components.health or not v.components.health:IsDead() then
                        if v.components.freezable ~= nil then
                            if v.components.freezable:IsFrozen() then
                                v.components.freezable:Unfreeze()
                            elseif v.components.freezable.coldness > 0 then
                                v.components.freezable:AddColdness(-2)
                            end
                        end
                        if v.components.temperature ~= nil then
                            local maxtemp = math.min(v.components.temperature:GetMax(), 10)
                            local curtemp = v.components.temperature:GetCurrent()
                            if maxtemp > curtemp then
                                v.components.temperature:DoDelta(math.min(10, maxtemp - curtemp))
                            end
                        end
                    end
                end
            end
            if v:IsValid() and v.AnimState then
                SpawnPrefab("laserhit"):SetTarget(v)
            end
        end
    end
    return targets
end

local function DoDamage(inst, ent, rad)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = ent and {ent} or TheSim:FindEntities(x, 0, z, rad, nil, DAMAGE_CANT_TAGS, DAMAGE_ONEOF_TAGS)
    local rad = rad or 0
    local targets = {}
    local attacker = inst.components.projectile and inst.components.projectile.attacker or
                     inst.components.complexprojectile and inst.components.complexprojectile.attacker

    for _,v in ipairs(ents) do
         if not targets[v] and v:IsValid() and not v:IsInLimbo() and not v:HasTag("laser_immune") and
              not (v.components.health and v.components.health:IsDead()) and attacker then

              local vx, vy, vz = v.Transform:GetWorldPosition()
              local range = rad + v:GetPhysicsRadius(0)
              if ent or v:GetDistanceSqToPoint(Vector3(x,y,z)) < range * range then
                   local isworkable = false
                   if v.components.workable then
                        local work_action = v.components.workable:GetWorkAction()
                        isworkable = ( not work_action and v:HasTag("NPC_workable")) or
                                     ( v.components.workable:CanBeWorked() and
                                     ( work_action == ACTIONS.CHOP or
                                       work_action == ACTIONS.HAMMER or
                                       work_action == ACTIONS.MINE or
                                     ( work_action == ACTIONS.DIG and
                                       not v.components.spawner and
                                       not v.components.childspawner )))
                   end

                   if isworkable then
                        targets[v] = true
                        v:DoTaskInTime(0, function() v.components.workable:Destroy(attacker) end)
                   elseif v.components.pickable and v.components.pickable:CanBePicked() and not v:HasTag("intense") then
                        targets[v] = true
                        local num = v.components.pickable.numtoharvest or 1
                        local product = v.components.pickable.product
                        v:DoTaskInTime(0, function()
                             v.components.pickable:Pick()
                             if product and num > 0 then
                                  for i = 1, num do
                                       local loot = SpawnPrefab(product)
                                       loot.Transform:SetPosition(vx, 0, vz)
                                       targets[loot] = true
                                       Launch(loot, attacker, 0.2)
                                  end
                             end
                        end)
                   elseif v.components.health then
                        targets[v] = true
                        if v.components.combat and attacker.components.combat and attacker.components.combat:CanTarget(v) then
                             local dmg = inst.components.combat.defaultdamage
                             v.components.combat:GetAttacked(attacker, dmg)
                        end
                        if v:IsValid() and not v.components.health:IsDead() then
                             if v.components.freezable then
                                  if v.components.freezable:IsFrozen() then
                                       v.components.freezable:Unfreeze()
                                  elseif v.components.freezable.coldness > 0 then
                                       v.components.freezable:AddColdness(-2)
                                  end
                             end
                             if v.components.temperature then
                                  local maxtemp = v.components.temperature:GetMax()
                                  local curtemp = v.components.temperature:GetCurrent()
                                  if maxtemp > curtemp then
                                       v.components.temperature:DoDelta(math.min(10, maxtemp - curtemp))
                                  end
                             end
                        end
                   end

                   if v:IsValid() then
                        SpawnPrefab("laserhit"):SetTarget(v)
                   end
              end
         end
    end
end

local EXPLODE_CANT_TAGS = {"INLIMBO", "outofreach", "DECOR"}

local function WaterExplode(position, rad)
     local x, y, z = position:Get()
     local ent = TheSim:FindEntities(x, y, z, rad, nil, EXPLODE_CANT_TAGS)
     for _,v in ipairs(ent) do
          if v:IsOnOcean(false) and v.components.oceanfishable then
               local projectile = v.components.oceanfishable:MakeProjectile()
               local ae_cp = projectile.components.complexprojectile
               if ae_cp then
                    ae_cp:SetHorizontalSpeed(16)
                    ae_cp:SetGravity(-30)
                    ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
                    ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))

                    local pos = v:GetPosition()
                    local launch_position = pos + (pos - position):Normalize() * 8
                    ae_cp:Launch(launch_position, projectile, ae_cp.owningweapon)
               end
          end
     end
end
---------------------------------------------------------------------------------------

local function color(x, y, tiles, islands, value)
    tiles[y][x] = false
    islands[y][x] = value
end

local function check_validity(x, y, w, h, tiles, stack)
    if x >= 1 and y >= 1 and x <= w and y <= h and tiles[y][x] then
        stack[#stack + 1] = { x = x, y = y }
    end
end

local function floodfill(x, y, w, h, tiles, islands, value)
    --    Queue q
    local q = {}
    --    q.push((x,y))
    q[#q + 1] = { x = x, y = y }
    --    while (q is not empty)
    while #q > 0 do
        --       (x1,y1) = q.pop()
        local el = q[#q]
        table.remove(q)
        local x1, y1 = el.x, el.y
        --       color(x1,y1)         -- islandmap[x,y] = color
        --print("Color",x1,y1)
        color(x1, y1, tiles, islands, value)

        check_validity(x1 + 1, y1, w, h, tiles, q)
        check_validity(x1 - 1, y1, w, h, tiles, q)
        check_validity(x1, y1 + 1, w, h, tiles, q)
        check_validity(x1, y1 - 1, w, h, tiles, q)
        -- diagonals
        check_validity(x1 - 1, y1 - 1, w, h, tiles, q)
        check_validity(x1 - 1, y1 + 1, w, h, tiles, q)
        check_validity(x1 + 1, y1 - 1, w, h, tiles, q)
        check_validity(x1 + 1, y1 + 1, w, h, tiles, q)

        --            q.push(x1,y1-1)
    end
end

local function dofloodfillfromcoord(x, y, w, h, tiles, islands)
    local index = 3
    local rescan = true
    local val = tiles[y][x]
    if val then
        floodfill(x, y, w, h, tiles, islands, index)
        index = index + 1
    end
end


---------------------------------------------------------------------------------------

local function dropparts(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local tamanhodomapa = (TheWorld.Map:GetSize()) * 2 - 2
    local map = TheWorld.Map
    local numerodeitens = 2

    repeat
        x = math.random(x - 80, x + 80)
        z = math.random(z - 80, z + 80)
        local curr = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z))
        local curr1 = map:GetTile(map:GetTileCoordsAtPoint(x - 4, 0, z))
        local curr2 = map:GetTile(map:GetTileCoordsAtPoint(x + 4, 0, z))
        local curr3 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z - 4))
        local curr4 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z + 4))
        -------------------coloca os itens------------------------
        if
            (curr == GROUND.FIELDS and curr1 == GROUND.FIELDS and curr2 == GROUND.FIELDS and curr3 == GROUND.FIELDS and curr4 == GROUND.FIELDS)
            or (curr == GROUND.DEEPRAINFOREST and curr1 == GROUND.DEEPRAINFOREST and curr2 == GROUND.DEEPRAINFOREST and curr3 == GROUND.DEEPRAINFOREST and curr4 == GROUND.DEEPRAINFOREST)
            or (curr == GROUND.RAINFOREST and curr1 == GROUND.RAINFOREST and curr2 == GROUND.RAINFOREST and curr3 == GROUND.RAINFOREST and curr4 == GROUND.RAINFOREST)
            or (curr == GROUND.PAINTED and curr1 == GROUND.PAINTED and curr2 == GROUND.PAINTED and curr3 == GROUND.PAINTED and curr4 == GROUND.PAINTED)
            or (curr == GROUND.DIRT and curr1 == GROUND.DIRT and curr2 == GROUND.DIRT and curr3 == GROUND.DIRT and curr4 == GROUND.DIRT)
            or (curr == GROUND.DIRT and curr1 == GROUND.DIRT and curr2 == GROUND.DIRT and curr3 == GROUND.DIRT and curr4 == GROUND.DIRT)
            or (curr == GROUND.GASRAINFOREST and curr1 == GROUND.GASRAINFOREST and curr2 == GROUND.GASRAINFOREST and curr3 == GROUND.GASRAINFOREST and curr4 == GROUND.GASRAINFOREST)
            or (curr == GROUND.PLAINS and curr1 == GROUND.PLAINS and curr2 == GROUND.PLAINS and curr3 == GROUND.PLAINS and curr4 == GROUND.PLAINS)
        then
            local partprop = SpawnPrefab("ancient_robot_claw")
            partprop.spawntask:Cancel()
            partprop.spawntask = nil
            partprop.spawned = true
            partprop:AddTag("dormant")
            partprop.sg:GoToState("idle_dormant")
            inst.DoDamage(partprop, 5)
            partprop.Transform:SetPosition(x, 0, z)
            numerodeitens = numerodeitens - 1
        end
        -----------------------------------------------------------
    until
        numerodeitens <= 0

    local x, y, z = inst.Transform:GetWorldPosition()
    local tamanhodomapa = (TheWorld.Map:GetSize()) * 2 - 2
    local map = TheWorld.Map
    local numerodeitens = 2

    repeat
        x = math.random(x - 80, x + 80)
        z = math.random(z - 80, z + 80)
        local curr = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z))
        local curr1 = map:GetTile(map:GetTileCoordsAtPoint(x - 4, 0, z))
        local curr2 = map:GetTile(map:GetTileCoordsAtPoint(x + 4, 0, z))
        local curr3 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z - 4))
        local curr4 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z + 4))
        -------------------coloca os itens------------------------
        if
            (curr == GROUND.FIELDS and curr1 == GROUND.FIELDS and curr2 == GROUND.FIELDS and curr3 == GROUND.FIELDS and curr4 == GROUND.FIELDS)
            or (curr == GROUND.DEEPRAINFOREST and curr1 == GROUND.DEEPRAINFOREST and curr2 == GROUND.DEEPRAINFOREST and curr3 == GROUND.DEEPRAINFOREST and curr4 == GROUND.DEEPRAINFOREST)
            or (curr == GROUND.RAINFOREST and curr1 == GROUND.RAINFOREST and curr2 == GROUND.RAINFOREST and curr3 == GROUND.RAINFOREST and curr4 == GROUND.RAINFOREST)
            or (curr == GROUND.PAINTED and curr1 == GROUND.PAINTED and curr2 == GROUND.PAINTED and curr3 == GROUND.PAINTED and curr4 == GROUND.PAINTED)
            or (curr == GROUND.DIRT and curr1 == GROUND.DIRT and curr2 == GROUND.DIRT and curr3 == GROUND.DIRT and curr4 == GROUND.DIRT)
            or (curr == GROUND.DIRT and curr1 == GROUND.DIRT and curr2 == GROUND.DIRT and curr3 == GROUND.DIRT and curr4 == GROUND.DIRT)
            or (curr == GROUND.GASRAINFOREST and curr1 == GROUND.GASRAINFOREST and curr2 == GROUND.GASRAINFOREST and curr3 == GROUND.GASRAINFOREST and curr4 == GROUND.GASRAINFOREST)
            or (curr == GROUND.PLAINS and curr1 == GROUND.PLAINS and curr2 == GROUND.PLAINS and curr3 == GROUND.PLAINS and curr4 == GROUND.PLAINS)
        then
            local partprop = SpawnPrefab("ancient_robot_leg")
            partprop.spawntask:Cancel()
            partprop.spawntask = nil
            partprop.spawned = true
            partprop:AddTag("dormant")
            partprop.sg:GoToState("idle_dormant")
            inst.DoDamage(partprop, 5)
            partprop.Transform:SetPosition(x, 0, z)
            numerodeitens = numerodeitens - 1
        end
        -----------------------------------------------------------
    until
        numerodeitens <= 0

    local x, y, z = inst.Transform:GetWorldPosition()
    local tamanhodomapa = (TheWorld.Map:GetSize()) * 2 - 2
    local map = TheWorld.Map
    local numerodeitens = 1

    repeat
        x = math.random(x - 80, x + 80)
        z = math.random(z - 80, z + 80)
        local curr = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z))
        local curr1 = map:GetTile(map:GetTileCoordsAtPoint(x - 4, 0, z))
        local curr2 = map:GetTile(map:GetTileCoordsAtPoint(x + 4, 0, z))
        local curr3 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z - 4))
        local curr4 = map:GetTile(map:GetTileCoordsAtPoint(x, 0, z + 4))
        -------------------coloca os itens------------------------
        if
            (curr == GROUND.FIELDS and curr1 == GROUND.FIELDS and curr2 == GROUND.FIELDS and curr3 == GROUND.FIELDS and curr4 == GROUND.FIELDS)
            or (curr == GROUND.DEEPRAINFOREST and curr1 == GROUND.DEEPRAINFOREST and curr2 == GROUND.DEEPRAINFOREST and curr3 == GROUND.DEEPRAINFOREST and curr4 == GROUND.DEEPRAINFOREST)
            or (curr == GROUND.RAINFOREST and curr1 == GROUND.RAINFOREST and curr2 == GROUND.RAINFOREST and curr3 == GROUND.RAINFOREST and curr4 == GROUND.RAINFOREST)
            or (curr == GROUND.PAINTED and curr1 == GROUND.PAINTED and curr2 == GROUND.PAINTED and curr3 == GROUND.PAINTED and curr4 == GROUND.PAINTED)
            or (curr == GROUND.DIRT and curr1 == GROUND.DIRT and curr2 == GROUND.DIRT and curr3 == GROUND.DIRT and curr4 == GROUND.DIRT)
            or (curr == GROUND.DIRT and curr1 == GROUND.DIRT and curr2 == GROUND.DIRT and curr3 == GROUND.DIRT and curr4 == GROUND.DIRT)
            or (curr == GROUND.GASRAINFOREST and curr1 == GROUND.GASRAINFOREST and curr2 == GROUND.GASRAINFOREST and curr3 == GROUND.GASRAINFOREST and curr4 == GROUND.GASRAINFOREST)
            or (curr == GROUND.PLAINS and curr1 == GROUND.PLAINS and curr2 == GROUND.PLAINS and curr3 == GROUND.PLAINS and curr4 == GROUND.PLAINS)
        then
            local partprop = SpawnPrefab("ancient_robot_ribs")
            partprop.spawntask:Cancel()
            partprop.spawntask = nil
            partprop.spawned = true
            partprop:AddTag("dormant")
            partprop.sg:GoToState("idle_dormant")
            inst.DoDamage(partprop, 5)
            partprop.Transform:SetPosition(x, 0, z)
            numerodeitens = numerodeitens - 1
        end
        -----------------------------------------------------------
    until
        numerodeitens <= 0
end

local function CalcSanityAura(inst, observer)
    return inst.components.combat.target and -TUNING.SANITYAURA_HUGE or -TUNING.SANITYAURA_LARGE
end

local TARGET_DIST = 30
local ATTACK_MUST_TAGS = { "_health", "_combat" }
local function RetargetFn(inst)
    return FindEntity(inst, TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, ATTACK_MUST_TAGS)
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function OnCollide(inst, other)
    if other == nil then return end

    local isworkable = false
    if other.components.workable ~= nil then
        local work_action = other.components.workable:GetWorkAction()
        --V2C: nil action for campfires
        isworkable =
            (work_action == nil and other:HasTag("campfire")) or
            (work_action == ACTIONS.CHOP or
                work_action == ACTIONS.HAMMER or
                work_action == ACTIONS.MINE or
                work_action == ACTIONS.DIG
            )
    end
    if isworkable then
        other:DoTaskInTime(0.6, function()
            if other.components.workable and inst:IsValid() then
                other.components.workable:Destroy(inst)
            end
        end)
    elseif other.components.pickable ~= nil
        and other.components.pickable:CanBePicked()
        and not other:HasTag("intense")
    then
        local num = other.components.pickable.numtoharvest or 1
        local product = other.components.pickable.product
        local x1, y1, z1 = other.Transform:GetWorldPosition()
        other.components.pickable:Pick(inst) -- only calling this to trigger callbacks on the object
        if product ~= nil and num > 0 then
            for i = 1, num do
                local loot = SpawnPrefab(product)
                loot.Transform:SetPosition(x1, 0, z1)
            end
        end
    end
    -- may want to do some charging damage?
end

local function LaunchProjectile(inst, targetpos)
    local x, y, z = inst.Transform:GetWorldPosition()

    local projectile = SpawnPrefab("ancient_hulk_mine")

    projectile.primed = false
    projectile.AnimState:PlayAnimation("spin_loop", true)
    projectile.Transform:SetPosition(x, 1, z)

    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local dx = targetpos.x - x
    local dz = targetpos.z - z
    local rangesq = dx * dx + dz * dz
    local maxrange = FIRE_DETECTOR_RANGE
    local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:SetGravity(-25)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
    projectile.owner = inst
end


local function ShootProjectile(inst, targetpos)
    local x, y, z = inst.Transform:GetWorldPosition()

    local projectile = SpawnPrefab("ancient_hulk_orb")

    projectile.primed = false
    projectile.AnimState:PlayAnimation("spin_loop", true)

    local pt = inst.shotspawn:GetPosition()
    projectile.Transform:SetPosition(pt.x, pt.y, pt.z)
    --projectile.Transform:SetPosition(x, 4, z)

    -- inst.shotspawn:Remove()
    -- inst.shotspawn = nil

    local speed = 60 --  easing.linear(rangesq, 15, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:SetGravity(-25)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
    projectile.owner = inst
end

local function spawnbarrier(inst, pt)
    local angle = 0
    local radius = 13
    local number = 32
    for i = 1, number do
        local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
        local newpt = pt + offset
        local tile = TheWorld.Map:GetTileAtPoint(newpt.x, newpt.y, newpt.z)

        if tile ~= GROUND.IMPASSABLE and tile ~= GROUND.OCEAN_WATERLOG and tile ~= GROUND.INVALID and tile ~= GROUND.OCEAN_COASTAL and tile ~= GROUND.OCEAN_COASTAL_SHORE and tile ~= GROUND.OCEAN_SWELL and tile ~= GROUND.OCEAN_ROUGH and tile ~= GROUND.OCEAN_BRINEPOOL and tile ~= GROUND.OCEAN_BRINEPOOL_SHORE and tile ~= GROUND.OCEAN_HAZARDOUS then
            TheWorld:DoTaskInTime(math.random() * 0.3, function()
                local rock = SpawnPrefab("rock_basalt")
                rock.AnimState:PlayAnimation("emerge")
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/hulk_metal_robot/rock")
                rock.AnimState:PushAnimation("full")

                rock.Transform:SetPosition(newpt.x, newpt.y, newpt.z)
            end)
        end
        angle = angle + (PI * 2 / number)
    end
end

local function checkforAttacks(inst)
    -- mine
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, { "ancient_hulk_mine" })
    if #ents < 2 then
        inst.wantstomine = true
    else
        inst.wantstomine = nil
    end
    -- lob
    if inst.orbs > 0 then
        if inst.components.combat.target and inst.components.combat.target:IsValid() then
            local dist = inst:GetDistanceSqToInst(inst.components.combat.target)
            if dist > 10 * 10 and dist < 25 * 25 then
                inst.wantstolob = true
            else
                inst.wantstolob = nil
            end
        end
    else
        inst.orbtime = inst.orbtime - 1
        if inst.orbtime <= 0 then
            inst.orbtime = nil
            inst.orbs = 2
        end
    end

    -- teleport
    if inst.components.combat.target and inst.components.combat.target:IsValid() then
        local dist = inst:GetDistanceSqToInst(inst.components.combat.target)
        if dist < 6 * 6 then
            if not inst.teleporttime then
                inst.teleporttime = 0
            end
            inst.teleporttime = inst.teleporttime + 1
            if inst.teleporttime > 5 then
                inst.wantstoteleport = true
            end
        else
            inst.teleporttime = nil
        end
    end

    -- spin
    if inst.components.combat.target and inst.components.combat.target:IsValid() and inst.components.health:GetPercent() < 0.5 then
        if not inst.spintime or inst.spintime <= 0 then
            local dist = inst:GetDistanceSqToInst(inst.components.combat.target)
            if dist < 6 * 6 then
                inst.wantstospin = true
            else
                inst.wantstospin = nil
            end
        else
            inst.spintime = inst.spintime - 1
        end
    end

    -- barrier?
    if inst.components.combat.target and inst.components.combat.target:IsValid() and inst.components.health:GetPercent() < 0.3 then
        if not inst.barriertime or inst.barriertime <= 0 then
            local dist = inst:GetDistanceSqToInst(inst.components.combat.target)
            if dist < 6 * 6 then
                inst.wantstobarrier = true
            else
                inst.wantstobarrier = nil
            end
        else
            inst.barriertime = inst.barriertime - 1
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(6, 3.5)

    inst.Transform:SetSixFaced()

    MakeCharacterPhysics(inst, 1000, 1.5)

    inst.AnimState:SetBank("metal_hulk")
    inst.AnimState:SetBuild("metal_hulk_build")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:AddOverrideBuild("laser_explode_sm")
    inst.AnimState:AddOverrideBuild("smoke_aoe")
    inst.AnimState:AddOverrideBuild("laser_explosion")
    inst.AnimState:AddOverrideBuild("ground_chunks_breaking")

    ------------------------------------------

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("ancient_hulk")
    inst:AddTag("laser_immune")
    inst:AddTag("mech")

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(3)
    inst.Light:SetColour(1, 0.3, 0.3)
    inst.Light:Enable(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.orbs = 2

    inst:AddComponent("fader")

    inst.Physics:SetCollisionCallback(OnCollide)
    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ANCIENT_HULK_HEALTH)
    inst.components.health.destroytime = 5
    inst.components.health.fire_damage_scale = 0

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HULK_DAMAGE)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(TUNING.ANCIENT_HULK_ATTACK_RANGE, TUNING.ANCIENT_HULK_MELEE_RANGE)
    inst.components.combat:SetAreaDamage(5.5, 0.8)
    --    inst.components.combat.hiteffectsymbol = "segment01"
    inst.components.combat:SetAttackPeriod(TUNING.BEARGER_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    --inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/bearger/hurt")

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("ancient_hulk")

    ------------------------------------------

    inst:AddComponent("inspectable")

    ------------------------------------------

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 3
    inst.components.groundpounder.numRings = 3
    inst.components.groundpounder.groundpoundfx = "groundpound_fx_hulk"

    ------------------------------------------	

    inst.LaunchProjectile = LaunchProjectile
    inst.ShootProjectile = ShootProjectile
    inst.DoDamage = DoDamage
    inst.spawnbarrier = spawnbarrier
    inst.dropparts = dropparts
    inst.SetLightValue = SetLightValue

    inst:DoPeriodicTask(1, checkforAttacks)

    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.BEARGER_CALM_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.BEARGER_RUN_SPEED
    inst.components.locomotor:SetShouldRun(true)

    inst:SetStateGraph("SGancient_hulk")
    inst:SetBrain(brain)

    inst.shotspawn = SpawnPrefab("ancient_hulk_marker")
    inst.shotspawn.entity:AddFollower():FollowSymbol(inst.GUID, "hand01", 0, 0, 0)

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

local function OnHit(inst, dist)
    inst.AnimState:PlayAnimation("land")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/metal_robot/ribs/step_wires")
    inst.AnimState:PushAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/hulk_metal_robot/rust")
    inst:ListenForEvent("animover", function()
        if inst.AnimState:IsCurrentAnimation("open") then
            inst.primed = true
            inst.AnimState:PlayAnimation("green_loop", true)
        end
    end)
end

local function onnearmine(inst, ents)
    if inst.primed then
        inst.SetLightValue(inst, 0, 0.75, 0.2)
        inst.AnimState:PlayAnimation("red_loop", true)
        --start beep
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/hulk_metal_robot/active_LP", "boom_loop")
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/metal_robot/electro")
        inst:DoTaskInTime(0.8, function()
            --explode, end beep
            inst.SoundEmitter:KillSound("boom_loop")
            --            local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
            --            if player then
            --                player.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.5, 0.03, 2, SHAKE_DIST)
            --            end
            inst:Hide()
            local ring = SpawnPrefab("laser_ring")
            ring.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:DoTaskInTime(0.3, function()
                DoDamage(inst, 3.5)
                inst:Remove()
            end)

            local explosion = SpawnPrefab("laser_explosion")
            explosion.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/metal_robot/smash")
        end)
    end
end

local function minefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst, 75, 0.5)

    --inst.Physics:SetCollisionCallback(OnMineCollide)

    inst.AnimState:SetBank("metal_hulk_mine")
    inst.AnimState:SetBuild("metal_hulk_bomb")
    inst.AnimState:PlayAnimation("green_loop", true)

    inst:AddTag("ancient_hulk_mine")

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 0.3, 0.3)
    inst.Light:Enable(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.primed = true

    inst:AddComponent("fader")

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnHit)
    inst.components.complexprojectile.yOffset = 2.5

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HULK_MINE_DAMAGE)
    --inst.components.combat.playerdamagepercent = .5

    inst.SetLightValue = SetLightValue

    inst:AddComponent("playerprox")
    inst.components.playerprox.period = 0.01
    inst.components.playerprox:SetDist(3.5, 5)
    inst.components.playerprox:SetOnPlayerNear(onnearmine)

    return inst
end

local function OnHitOrb(inst, dist)
    ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.4, 0.03, 1.5, inst, 40)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/hulk_metal_robot/smash_2")
    inst.AnimState:PlayAnimation("impact")

    local endtime = inst.AnimState:GetCurrentAnimationLength()
    inst:DoTaskInTime(endtime, inst.Remove)

    local x, y, z = inst.Transform:GetWorldPosition()
    local radius = 3.5
    inst:DoTaskInTime(0.2, function() DoDamage(inst, nil, radius) end)
    inst:DoTaskInTime(0.3, function() setfires(x, y, z, radius) end)

    if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
         local fx = SpawnPrefab("crab_king_waterspout")
         fx.Transform:SetPosition(x, y, z)
         -- Wave
         local pos = Vector3(x, y, z)
         local rad = 0
         local num = 10
         local speed = 6
         local idle = 1.5
         inst:DoTaskInTime(0.1, function()
              SpawnAttackWaves(pos, nil, rad, num, 360, speed, nil, idle, nil)
              WaterExplode(pos, radius)
         end)
    else
         inst:DoTaskInTime(0, function()
              local ring = SpawnPrefab("laser_ring")
              ring.Transform:SetPosition(x, y, z)
         end)
    end
end

local function orbfn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst, 75, 0.5)

    inst.AnimState:SetBank("metal_hulk_projectile")
    inst.AnimState:SetBuild("metal_hulk_projectile")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst:AddTag("ancient_hulk_orb")
    inst:AddTag("projectile")
    inst:AddTag("laser")

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 0.3, 0.3)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fader")

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnHitOrb)
    inst.components.complexprojectile:SetHorizontalSpeed(TUNING.ANCIENT_HULK_SPEED)
    inst.components.complexprojectile:SetGravity(-1)
    inst.components.complexprojectile.usehigharc = false
    inst.components.complexprojectile.yOffset = 2.5

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HULK_MINE_DAMAGE)
    inst.components.combat.playerdamagepercent = 0.5

    inst.SetLightValue = SetLightValue

    inst.persists = false

    return inst
end


local function OnCollideartefato(inst, dist)
    --    local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
    --    if player then
    --        player.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.4, 0.03, 1.5, SHAKE_DIST)
    --    end
    inst.AnimState:PlayAnimation("impact")
    inst:ListenForEvent("animover", function()
        if inst.AnimState:IsCurrentAnimation("impact") then
            inst:Remove()
        end
    end)
    local ring = SpawnPrefab("laser_ring")
    ring.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:DoTaskInTime(0.3, function() DoDamage(inst, 3.5) end)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/metal_robot/smash")
end

local function OnCollidesmall(inst, other)
    applydamagetoent(inst, other, nil, nil, true)

    local explosion = SpawnPrefab("laser_explosion")
    explosion.Transform:SetPosition(inst.Transform:GetWorldPosition())
    explosion.Transform:SetScale(0.4, 0.4, 0.4)

    -- DANY SOUND          inst.SoundEmitter:PlaySound( smallexplosion )
    inst:Remove()
end

local function orbsmallfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, 0.5)

    -- Don't collide with the land edge
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:SetCollisionCallback(OnCollidesmall)

    inst.AnimState:SetBank("metal_hulk_projectile")
    inst.AnimState:SetBuild("metal_hulk_projectile")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Transform:SetScale(0.5, 0.5, 0.5)

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 0.3, 0.3)
    inst.Light:Enable(true)

    inst:AddTag("projectile")
    inst:AddTag("laser")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.collide = OnCollidesmall

    inst:AddComponent("fader")

    inst:AddComponent("locomotor")

     inst:AddComponent("projectile")
     inst.components.projectile:SetSpeed(TUNING.ANCIENT_HULK_SPEED)
     inst.components.projectile:SetHoming(false)
     inst.components.projectile.hitdist = 0.5

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HULK_MINE_DAMAGE / 3)
    inst.components.combat.playerdamagepercent = 0.5

    inst.Physics:SetMotorVelOverride(60, 0, 0)

    inst:DoTaskInTime(2, inst.Remove)

    inst.SetLightValue = SetLightValue

    inst.persists = false

    return inst
end

local function orbartefatofn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, 0.5)

    -- Don't collide with the land edge
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst.Physics:SetCollisionCallback(OnCollideartefato)

    inst.AnimState:SetBank("metal_hulk_projectile")
    inst.AnimState:SetBuild("metal_hulk_projectile")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 0.3, 0.3)
    inst.Light:Enable(true)

    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fader")

    inst:AddComponent("locomotor")

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HULK_MINE_DAMAGE)
    inst.components.combat.playerdamagepercent = 0.5

    inst.Physics:SetMotorVelOverride(60, 0, 0)

    inst:DoTaskInTime(2, inst.Remove)

    inst.SetLightValue = SetLightValue

    inst.persists = false

    return inst
end

local function OnCollidecharge(inst, other)
    inst.Physics:SetMotorVelOverride(0, 0, 0)
    --    local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
    --    if player then
    --        player.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.4, 0.03, 1.5, SHAKE_DIST)
    --    end
    inst.AnimState:PlayAnimation("impact")
    inst:ListenForEvent("animover", function()
        if inst.AnimState:IsCurrentAnimation("impact") then
            inst:Remove()
        end
    end)
    local ring = SpawnPrefab("laser_ring")
    ring.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:DoTaskInTime(0.3, function() DoDamage(inst, 3.5) end)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/metal_robot/smash")
end

local function orbchargefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, 0.5)

    inst.Physics:SetCollisionCallback(OnCollidecharge)

    inst.AnimState:SetBank("metal_hulk_projectile")
    inst.AnimState:SetBuild("metal_hulk_projectile")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 0.3, 0.3)
    inst.Light:Enable(true)

    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fader")

    inst:AddComponent("locomotor")

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HULK_MINE_DAMAGE)
    inst.components.combat.playerdamagepercent = 0.5

    inst.Physics:SetMotorVelOverride(40, 0, 0)

    inst:DoTaskInTime(2, inst.Remove)

    inst.SetLightValue = SetLightValue

    inst.persists = false

    return inst
end

local function markerfn()
    local inst = CreateEntity()

    -- 铁巨人标记，这个有动画吗？
    if not TheWorld.ismastersim then
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end

    inst.entity:AddTransform()
    inst.entity:Hide()
    inst.persists = false
    inst:AddTag("CLASSIFIED")
    return inst
end


return Prefab("ancient_hulk", fn, assets, prefabs),
    Prefab("ancient_hulk_mine", minefn, assets, prefabs),
    Prefab("ancient_hulk_orb", orbfn, assets, prefabs),
    Prefab("ancient_hulk_orb_small", orbsmallfn, assets, prefabs),
    Prefab("ancient_hulk_orb_charge", orbchargefn, assets, prefabs),
    Prefab("ancient_hulk_marker", markerfn, assets, prefabs),
    Prefab("ancient_hulk_orb_artefato", orbartefatofn, assets, prefabs)
