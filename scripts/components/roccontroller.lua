local SCREEN_DIST = 50
local HEAD_ATTACK_DIST = 1.5
local SCALERATE = 1 / (30 * 2) -- 2 seconds to go from 0 to 1

local HEADDIST = 17
local HEADDIST_TARGET = 15
local BODY_DIST_TOLLERANCE = 2

local TAILDIST = 13

local ROC_LEGDSIT = 6
local LEGDIST = ROC_LEGDSIT
local LEG_WALKDIST = 4
local LEG_WALKDIST_BIG = 6
local LAND_PROX = 15

local function IsValidEnt(ent)
    return ent ~= nil and ent:IsValid()
end

local function HasStateTag(ent, tag)
    return ent ~= nil and ent.sg ~= nil and ent.sg:HasStateTag(tag)
end

local function PushEvent(ent, event)
    if IsValidEnt(ent) then
        ent:PushEvent(event)
    end
end

local function GetSavedEntity(ents, guid)
    local data = guid ~= nil and ents ~= nil and ents[guid] or nil
    return data ~= nil and data.entity or nil
end

-- 大鹏鸟
local RocController = Class(function(self, inst)
    self.inst = inst
    self.speed = 10
    self.stages = 3
    self.startscale = 0.35

    self.head_vel = 0
    self.head_acc = 3
    self.head_vel_max = 6
    self.body_vel = { x = 0, z = 0 }
    self.body_acc = 0.3
    self.body_dec = 1
    self.body_vel_max = 10 --6

    self.tail_vel = { x = 0, z = 0 }
    self.tail_acc = 3
    self.tail_dec = 6
    self.tail_vel_max = self.speed

    self.turn_threshold = 20

    self.dungtime = 3

    self.angular_body_acc = 5

    self.inst.sounddistance = 0
end)

function RocController:Setup(speed, scale, stages)
    if speed then
        self.speed = speed
    end
    if scale then
        self.startscale = scale
    end
    if stages then
        self.stages = stages
    end

    self.inst:ListenForEvent("liftoff", function()
        if self.busy or self.liftoff then
            return
        end

        self.busy = true
        local head = self.head
        if not IsValidEnt(head) then
            self.busy = false
            self:doliftoff()
            return
        end

        head:PushEvent("taunt")

        head:ListenForEvent("animover", function()
            if IsValidEnt(head) and head.AnimState:IsCurrentAnimation("taunt") then
                self.busy = false
                self:doliftoff()
            end
        end)
    end, self.inst)

    self:setscale(self.startscale)

    self.inst:DoTaskInTime(0, function()
        if not self.landed or self.liftoff then
            self.inst:PushEvent("fly")
        end
    end)

    --self.inst:DoPeriodicTask(30+(math.random()*30), function() self:CheckScale() end )
    self:CheckScale()
    self.inst:DoPeriodicTask(1, function() self:CheckScale() end)
end

function RocController:Start()
    self.inst:StartUpdatingComponent(self)
end

function RocController:Stop()
    self.inst:StopUpdatingComponent(self)
end

function RocController:CheckScale()
    --	print("CHECKING SCALE",self.inst.Transform:GetScale())
    if self.stages > 0 and self.inst.Transform:GetScale() ~= 1 then
        local delta = (1 - self.startscale) / self.stages

        self.scaleup = {
            targetscale = math.min(self.inst.Transform:GetScale() + delta, 1)
        }
    end
end

function RocController:setscale(scale)
    scale = scale or self.startscale
    self.inst.Transform:SetScale(scale, scale, scale)
    if self.scalefn then
        self.scalefn(self.inst, scale)
    end
    self.inst.sounddistance = self.startscale ~= 1 and Remap(scale, self.startscale, 1, 0, 1) or 1
end

function RocController:doliftoff()
    if self.liftoff then
        return
    end

    if self.inst.bodyparts ~= nil then
        for i, part in ipairs(self.inst.bodyparts) do
            PushEvent(part, "exit")
        end
    end

    self.inst.bodyparts = nil
    self.head = nil
    self.tail = nil
    self.leg1 = nil
    self.leg2 = nil
    self.liftoff = true
    self.landed = nil
    self.currentleg = nil
    self.busy = false

    self.inst:PushEvent("takeoff")
end

function RocController:Spawnbodyparts()
    if self.inst.bodyparts ~= nil then
        return
    end
    self.inst.bodyparts = {}

    local angle = self.inst.Transform:GetRotation() * DEGREES
    local pos = Vector3(self.inst.Transform:GetWorldPosition())

    local offset = nil

    offset = Vector3(LEGDIST * math.cos(angle + (PI / 2)), 0, -LEGDIST * math.sin(angle + (PI / 2)))
    local leg1 = SpawnPrefab("roc_leg")
    leg1.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
    leg1.Transform:SetRotation(self.inst.Transform:GetRotation())
    if leg1.sg ~= nil then
        leg1.sg:GoToState("enter")
    end
    leg1.body = self.inst
    leg1.legoffsetdir = PI / 2
    table.insert(self.inst.bodyparts, leg1)
    self.leg1 = leg1
    self.currentleg = self.leg1

    offset = Vector3(LEGDIST * math.cos(angle - (PI / 2)), 0, -LEGDIST * math.sin(angle - (PI / 2)))
    local leg2 = SpawnPrefab("roc_leg")
    leg2.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
    leg2.Transform:SetRotation(self.inst.Transform:GetRotation())
    if leg2.sg ~= nil then
        leg2.sg:GoToState("enter")
    end
    leg2.body = self.inst
    leg2.legoffsetdir = -PI / 2
    table.insert(self.inst.bodyparts, leg2)
    self.leg2 = leg2

    self.inst:DoTaskInTime(0.5, function()
        if not IsValidEnt(self.inst) or self.inst.bodyparts == nil or IsValidEnt(self.head) then
            return
        end

        offset = Vector3(HEADDIST * math.cos(angle), 0, -HEADDIST * math.sin(angle))
        local head = SpawnPrefab("roc_head")
        head.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
        head.Transform:SetRotation(self.inst.Transform:GetRotation())
        if head.sg ~= nil then
            head.sg:GoToState("enter")
        end
        head.body = self.inst
        table.insert(self.inst.bodyparts, head)
        self.head = head
        head.controller = self
    end)

    offset = Vector3(TAILDIST * math.cos(angle - PI), 0, -TAILDIST * math.sin(angle - PI))
    local tail = SpawnPrefab("roc_tail")
    tail.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
    tail.Transform:SetRotation(self.inst.Transform:GetRotation())
    if tail.sg ~= nil then
        tail.sg:GoToState("enter")
    end
    tail.body = self.inst
    self.tail = tail
    table.insert(self.inst.bodyparts, tail)
end

function RocController:EatSomething(food)
    if IsValidEnt(food) then
        food:Remove()
    end
end

function RocController:GetTarget()
    if not IsValidEnt(self.target) or self.target:HasTag("player") then
        -- look for items..
        local pos = Vector3(self.inst.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, { "structure" })

        local sorted = {}
        if #ents > 0 then
            for i, ent in ipairs(ents) do
                if IsValidEnt(ent) and IsValidEnt(self.head) then
                    local x, y, z = ent.Transform:GetWorldPosition()
                    local ground = TheWorld

                    local tile = ground.Map:GetTileAtPoint(x, y, z)

                    if tile ~= WORLD_TILES.FOUNDATION and tile ~= WORLD_TILES.COBBLEROAD and tile ~= WORLD_TILES.LILYPOND then --  tile ~= WORLD_TILES.FIELDS and
                        table.insert(sorted, { ent, ent:GetDistanceSqToInst(self.head) })
                    end
                end
            end
            if #sorted > 0 then
                table.sort(sorted, function(a, b) return a[2] > b[2] end)
                self.target = sorted[#sorted][1]
            end
        end
        -- look for structures..
        -- look for player		
    end

    if IsValidEnt(self.target) then
        return self.target
    end

    self.target = GetClosestInstWithTag("player", self.inst, 40)
    return self.target
end

function RocController:OnUpdate(dt)
    if self.inst:IsAsleep() then
        return
    end

    local function getanglepointtopoint(x1, z1, x2, z2)
        local dz = z1 - z2
        local dx = x2 - x1
        local angle = math.atan2(dz, dx) / DEGREES
        return angle
    end

    local player = GetClosestInstWithTag("player", self.inst, 100)
    if player == nil then
        player = self.inst
    end
    local px, py, pz = player.Transform:GetWorldPosition()
    local onvalidtiles = player:IsInHamletArea()

    -- 检查是否可以落地
    local disttoplayer = self.inst:GetDistanceSqToInst(player)
    if disttoplayer > SCREEN_DIST * SCREEN_DIST then
        -- has landed and is flying again, should leave now
        if self.liftoff and not self.inst.teleporting then
            self.inst:Remove()
            return
        elseif not self.landed then
            self.inst.Transform:SetRotation(self.inst:GetAngleToPoint(px, py, pz))
        end
    end

    if TheWorld.state.isnight and not self.landed then
        self.inst:Remove()
        return
    end

    if self.scaleup then
        local currentscale = self.inst.Transform:GetScale()
        if currentscale ~= self.scaleup.targetscale then
            local setscale = math.min(currentscale + (SCALERATE * dt), self.scaleup.targetscale)
            self:setscale(setscale)
        else
            self.scaleup = nil
        end
    end



    if self.inst.Transform:GetScale() == 1 and not self.landed and not self.liftoff then
        if disttoplayer < LAND_PROX * LAND_PROX and onvalidtiles then
            self.landed = true
            self.inst:PushEvent("land")
        end
    end

    local dungok = true

    if not self.landed and onvalidtiles and dungok then
        local cx, cy, cz = self.inst.Transform:GetWorldPosition()
        if self.dungtime > 0 then
            self.dungtime = math.max(self.dungtime - dt, 0)
        else
            local pos = Vector3(self.inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 50, { "dungpile" })
            if #ents < 2 then
                self.inst:DoTaskInTime(1 + Remap(self.inst.Transform:GetScale(), 0.35, 1, 2, 0), function()
                    if not IsValidEnt(self.inst) then
                        return
                    end

                    local crap = SpawnPrefab("dungpile")
                    if crap ~= nil then
                        crap.Transform:SetPosition(cx, cy, cz)
                        if crap.fall ~= nil then
                            crap.fall(crap)
                        end
                    end
                end)
            end
            self.dungtime = math.random() * 10 + 2
        end
    end

    if not self.busy then
        if self.landed and IsValidEnt(self.head) and IsValidEnt(self.tail) and IsValidEnt(self.leg1) and IsValidEnt(self.leg2) then
            if onvalidtiles and not TheWorld.state.isnight then
                local target = self:GetTarget() or self.inst
                -- HEAD
                if not HasStateTag(self.head, "busy") then
                    local targetpos = Vector3(target.Transform:GetWorldPosition())
                    local headdistsq = self.head:GetDistanceSqToInst(target)
                    if headdistsq > HEAD_ATTACK_DIST * HEAD_ATTACK_DIST then
                        self.head_vel = math.min(self.head_vel + (self.head_acc * dt), self.head_vel_max)
                    else
                        if IsValidEnt(self.target) and (self.target:HasTag("_inventoryitem") or self.target:HasTag("player")) then
                            if self.target:HasTag("player") and not HasStateTag(self.target, "cower") then
                                self.target:PushEvent("cower")
                            end
                            if headdistsq < 0.2 then
                                self.head:PushEvent("gobble")
                            end
                        else
                            self.head:PushEvent("bash")
                        end
                        self.head_vel = math.max(self.head_vel - (self.head_acc * dt), 0)
                    end
                    local HEAD_VEL = self.head_vel * dt

                    local angle = self.head:GetAngleToPoint(targetpos) * DEGREES
                    local offset = Vector3(HEAD_VEL * math.cos(angle), 0, -HEAD_VEL * math.sin(angle))
                    local pos = Vector3(self.head.Transform:GetWorldPosition())
                    self.head.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
                end

                -- BODY
                local pos = Vector3(self.inst.Transform:GetWorldPosition())
                local BOD_VEL_MAX = self.speed
                local BOD_ACC_MAX = 0.5 --5
                local targetpos = Vector3(self.head.Transform:GetWorldPosition())
                local angle = self.head:GetAngleToPoint(pos) * DEGREES
                local offset = Vector3(1 * math.cos(angle), 0, -1 * math.sin(angle))
                offset.x = offset.x * HEADDIST_TARGET
                offset.z = offset.z * HEADDIST_TARGET
                targetpos = targetpos + Vector3(offset.x, 0, offset.z)

                local bodistsq = self.inst:GetDistanceSqToPoint(targetpos)

                if bodistsq > BODY_DIST_TOLLERANCE * BODY_DIST_TOLLERANCE then
                    local cpbv = pos + Vector3(self.body_vel.x, 0, self.body_vel.z)
                    local angle = getanglepointtopoint(cpbv.x, cpbv.z, targetpos.x, targetpos.z) * DEGREES
                    local offset = Vector3(BOD_ACC_MAX * math.cos(angle), 0, -BOD_ACC_MAX * math.sin(angle))
                    local cpbvtv = cpbv + Vector3(offset.x, 0, offset.z)
                    local finalangle = self.inst:GetAngleToPoint(cpbvtv) * DEGREES
                    local finalvel = math.min(BOD_VEL_MAX, math.sqrt(self.inst:GetDistanceSqToPoint(cpbvtv)))
                    self.body_vel = Vector3(finalvel * math.cos(finalangle), 0, -finalvel * math.sin(finalangle))
                else
                    local angle = self.inst:GetAngleToPoint(targetpos) * DEGREES
                    local vel = math.max(
                        math.sqrt((self.body_vel.x * self.body_vel.x) + (self.body_vel.z * self.body_vel.z)) -
                        (BOD_ACC_MAX * dt), 0)
                    self.body_vel = Vector3(vel * math.cos(angle), 0, -vel * math.sin(angle))
                end
                self.inst.Transform:SetPosition(pos.x + (self.body_vel.x * dt), 0, pos.z + (self.body_vel.z * dt))

                --TAIL
                local angle = (self.inst.Transform:GetRotation() * DEGREES) + PI
                local tailtarget = Vector3(TAILDIST * math.cos(angle), 0, -TAILDIST * math.sin(angle))
                tailtarget = Vector3(self.inst.Transform:GetWorldPosition()) + tailtarget
                local taildistsq = self.tail:GetDistanceSqToPoint(tailtarget)
                local pos = Vector3(self.tail.Transform:GetWorldPosition())
                local TAIL_VEL_MAX = self.speed
                local TAIL_ACC_MAX = 0.3 --5

                if taildistsq > 1 * 1 then
                    local cpbv = pos + Vector3(self.tail_vel.x, 0, self.tail_vel.z)
                    local angle = getanglepointtopoint(cpbv.x, cpbv.z, tailtarget.x, tailtarget.z) * DEGREES
                    local offset = Vector3(TAIL_ACC_MAX * math.cos(angle), 0, -TAIL_ACC_MAX * math.sin(angle))
                    local cpbvtv = cpbv + Vector3(offset.x, 0, offset.z)
                    local finalangle = self.tail:GetAngleToPoint(cpbvtv) * DEGREES
                    local finalvel = math.min(TAIL_VEL_MAX, math.sqrt(self.tail:GetDistanceSqToPoint(cpbvtv)))
                    self.tail_vel = Vector3(finalvel * math.cos(finalangle), 0, -finalvel * math.sin(finalangle))
                else
                    local angle = self.tail:GetAngleToPoint(tailtarget) * DEGREES
                    local vel = math.max(
                        math.sqrt((self.tail_vel.x * self.tail_vel.x) + (self.tail_vel.z * self.tail_vel.z)) -
                        (TAIL_ACC_MAX * dt), 0)
                    self.tail_vel = Vector3(vel * math.cos(angle), 0, -vel * math.sin(angle))
                end
                self.tail.Transform:SetPosition(pos.x + (self.tail_vel.x * dt), 0, pos.z + (self.tail_vel.z * dt))

                -- set rotations
                local headpos = Vector3(self.head.Transform:GetWorldPosition())

                -- body rotation has velocity.
                local body_angular_vel_max = 36 / 3
                if not self.body_angle_vel then
                    self.body_angle_vel = 0
                end

                local targetAngle = self.inst:GetAngleToPoint(headpos)
                local currentAngle = self.inst.Transform:GetRotation()

                if math.abs(anglediff(currentAngle, targetAngle)) < 20 then
                    if self.body_angle_vel > 0 then
                        self.body_angle_vel = math.max(0, self.body_angle_vel - (self.angular_body_acc * dt))
                    elseif self.body_angle_vel < 0 then
                        self.body_angle_vel = math.min(0, self.body_angle_vel + (self.angular_body_acc * dt))
                    end
                else
                    if targetAngle > currentAngle then
                        if targetAngle - currentAngle < 180 then
                            self.body_angle_vel = math.min(body_angular_vel_max,
                                self.body_angle_vel + (self.angular_body_acc * dt))
                        else
                            self.body_angle_vel = math.max(-body_angular_vel_max,
                                self.body_angle_vel - (self.angular_body_acc * dt))
                        end
                    else
                        if currentAngle - targetAngle < 180 then
                            self.body_angle_vel = math.max(-body_angular_vel_max,
                                self.body_angle_vel - (self.angular_body_acc * dt))
                        else
                            self.body_angle_vel = math.min(body_angular_vel_max,
                                self.body_angle_vel + (self.angular_body_acc * dt))
                        end
                    end
                end

                --print("self.body_angle_vel",self.body_angle_vel)
                currentAngle = currentAngle + (self.body_angle_vel * dt)
                self.inst.Transform:SetRotation(currentAngle)

                if not HasStateTag(self.head, "busy") then
                    local targetpos = Vector3(target.Transform:GetWorldPosition())
                    local angle = self.head:GetAngleToPoint(targetpos.x, targetpos.y, targetpos.z)
                    self.head.Transform:SetRotation(angle)
                end

                --self.head.Transform:SetRotation(self.inst.Transform:GetRotation())	
                self.tail.Transform:SetRotation(self.inst.Transform:GetRotation())

                -- LEGS
                if self.currentleg == nil or not IsValidEnt(self.currentleg) then
                    self.currentleg = self.leg1
                end

                if not HasStateTag(self.leg1, "walking") and not HasStateTag(self.leg2, "walking") then
                    local legdir = PI / 2
                    if self.currentleg == self.leg2 then
                        legdir = legdir * -1
                    end

                    local angle = self.inst.Transform:GetRotation() * DEGREES

                    local currentlegtargetpos = Vector3(self.inst.Transform:GetWorldPosition()) +
                        Vector3(LEGDIST * math.cos(angle + legdir), 0, -LEGDIST * math.sin(angle + legdir))
                    local legdistsq = self.currentleg:GetDistanceSqToPoint(currentlegtargetpos)
                    local anglediff = anglediff(self.currentleg.Transform:GetRotation(),
                        self.inst.Transform:GetRotation())
                    if legdistsq > LEG_WALKDIST * LEG_WALKDIST or anglediff > self.turn_threshold then
                        if legdistsq < LEG_WALKDIST_BIG * LEG_WALKDIST_BIG or (anglediff > self.turn_threshold and legdistsq <= LEG_WALKDIST_BIG * LEG_WALKDIST_BIG) then
                            self.currentleg:PushEvent("walkfast")
                        else
                            self.currentleg:PushEvent("walk")
                        end

                        if self.currentleg == self.leg1 then
                            self.currentleg = self.leg2
                        else
                            self.currentleg = self.leg1
                        end
                    end
                end
            else
                self.inst:PushEvent("liftoff")
            end
            -- move tail to point in position like head.
        end
    end
end

function RocController:OnEntitySleep()
    self:Stop()
end

function RocController:OnEntityWake()
    self:Start()
end

function RocController:FadeInFinished()
    -- Last step in transition
    local player = self.grabbedplayer
    if IsValidEnt(player) then
        if player.components.health ~= nil then
            player.components.health:SetInvincible(false)
        end
        if player.components.playercontroller ~= nil then
            player.components.playercontroller:Enable(true)
        end
    end
    self.grabbedplayer = nil
    self.inst.teleporting = nil
end

function RocController:FadeOutFinished()
    self.inst:DoTaskInTime(2, function()
        local player = self.grabbedplayer
        if not IsValidEnt(player) then
            self.inst.teleporting = nil
            return
        end

        for k, v in pairs(Ents) do
            if v:HasTag("roc_nest") then
                local pt = Vector3(v.Transform:GetWorldPosition())
                player.Transform:SetPosition(pt.x, pt.y, pt.z)
                if player.components.sanity ~= nil then
                    player.components.sanity:DoDelta(-TUNING.SANITY_MED)
                end
                self.inst.Transform:SetPosition(pt.x, pt.y, pt.z)
                player:Show()
                if player.HUD ~= nil then
                    player.HUD:Show()
                end
                player:PushEvent("wakeup")
                if player.DynamicShadow ~= nil then
                    player.DynamicShadow:Enable(true)
                end
                if player.ScreenFade ~= nil then
                    player:ScreenFade(true, 2)
                    self.inst:DoTaskInTime(2, function() self:FadeInFinished() end)
                else
                    self:FadeInFinished()
                end
                break
            end
        end
    end)
end

function RocController:teleport()
    local player = self.grabbedplayer
    if IsValidEnt(player) and player.ScreenFade ~= nil then
        player:ScreenFade(false, 2)
        self.inst:DoTaskInTime(2, function() self:FadeOutFinished() end)
    else
        self:FadeOutFinished()
    end
end

function RocController:playergrabbed(player)
    player = player or self.target
    if not IsValidEnt(player) or not IsValidEnt(self.head) then
        return
    end

    self.grabbedplayer = player
    player:PushEvent("grabbed")
    self.head:AddChild(player)
    self.head:AddTag("HasPlayer")
    player.Transform:SetRotation(self.head.Transform:GetRotation())
    player.AnimState:SetFinalOffset(-10)

    player.Transform:SetPosition(0, 0, 0)

    if player.components.health ~= nil then
        player.components.health:SetInvincible(true)
    end
    if player.components.playercontroller ~= nil then
        player.components.playercontroller:Enable(false)
    end
    if player.HUD ~= nil then
        player.HUD:Hide()
    end
    if player.DynamicShadow ~= nil then
        player.DynamicShadow:Enable(false)
    end

    self.inst:DoTaskInTime(2.5, function() self:teleport() end)
    self.inst.teleporting = true
end

function RocController:UnchildPlayer(inst)
    if not inst then
        inst = self.head
    end
    local player = self.grabbedplayer
    if IsValidEnt(inst) and IsValidEnt(player) then
        inst:RemoveChild(player)
        player.Transform:SetPosition(inst.Transform:GetWorldPosition())
        player:Hide()
        inst:RemoveTag("HasPlayer")
    end
end

function RocController:OnSave()
    local refs = {}
    local data = {}

    data.head_vel = self.head_vel

    data.body_vel_x = self.body_vel.x
    data.body_vel_z = self.body_vel.z

    data.tail_vel_x = self.tail_vel.x
    data.tail_vel_z = self.tail_vel.z

    data.dungtime = self.dungtime

    if IsValidEnt(self.currentleg) then
        data.currentleg = self.currentleg.GUID
    end
    if self.scaleup then
        data.scaleup = self.scaleup.targetscale
    end
    if self.landed then
        data.landed = self.landed
    end
    if self.liftoff then
        data.liftoff = self.liftoff
    end

    data.scale = self.inst.Transform:GetScale()

    if IsValidEnt(self.head) then
        data.head = self.head.GUID
        table.insert(refs, self.head.GUID)
    end
    if IsValidEnt(self.tail) then
        data.tail = self.tail.GUID
        table.insert(refs, self.tail.GUID)
    end
    if IsValidEnt(self.leg1) then
        data.leg1 = self.leg1.GUID
        table.insert(refs, self.leg1.GUID)
    end
    if IsValidEnt(self.leg2) then
        data.leg2 = self.leg2.GUID
        table.insert(refs, self.leg2.GUID)
    end

    return data, refs
end

function RocController:OnLoad(data)
    if data == nil then
        return
    end

    self.head_vel = data.head_vel or self.head_vel
    self.body_vel = { x = data.body_vel_x or self.body_vel.x, z = data.body_vel_z or self.body_vel.z }
    self.tail_vel = { x = data.tail_vel_x or self.tail_vel.x, z = data.tail_vel_z or self.tail_vel.z }
    self.dungtime = data.dungtime or self.dungtime

    if data.currentleg then
        self.currentleg = data.currentleg
    end
    if data.scaleup then
        self.scaleup = { targetscale = data.scaleup }
    end
    if data.landed then
        self.landed = data.landed
    end
    if data.liftoff then
        self.liftoff = data.liftoff
    end

    self:setscale(data.scale or self.inst.Transform:GetScale())
end

function RocController:LoadPostPass(ents, data)
    if data == nil then
        return
    end

    self.inst.bodyparts = {}

    if data.currentleg then
        self.currentleg = GetSavedEntity(ents, data.currentleg)
    end

    if data.head then
        self.head = GetSavedEntity(ents, data.head)
        if IsValidEnt(self.head) then
            self.head.body = self.inst
            self.head.controller = self
            table.insert(self.inst.bodyparts, self.head)
        end
    end

    if data.tail then
        self.tail = GetSavedEntity(ents, data.tail)
        if IsValidEnt(self.tail) then
            self.tail.body = self.inst
            table.insert(self.inst.bodyparts, self.tail)
        end
    end

    if data.leg1 then
        self.leg1 = GetSavedEntity(ents, data.leg1)
        if IsValidEnt(self.leg1) then
            self.leg1.body = self.inst
            self.leg1.legoffsetdir = PI / 2
            table.insert(self.inst.bodyparts, self.leg1)
        end
    end

    if data.leg2 then
        self.leg2 = GetSavedEntity(ents, data.leg2)
        if IsValidEnt(self.leg2) then
            self.leg2.body = self.inst
            self.leg2.legoffsetdir = -PI / 2
            table.insert(self.inst.bodyparts, self.leg2)
        end
    end

    if self.currentleg == nil or not IsValidEnt(self.currentleg) then
        self.currentleg = self.leg1
    end
end

return RocController
