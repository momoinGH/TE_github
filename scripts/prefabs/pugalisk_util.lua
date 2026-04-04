local function findMoveablePosition(position, start_angle, radius, attempts, check_los)
    local test = function(offset)
        local run_point = position + offset

        local tile = TheWorld.Map:GetTileAtPoint(run_point.x, run_point.y, run_point.z)
        if tile == WORLD_TILES.IMPASSABLE or tile >= GROUND.UNDERGROUND or TheWorld.Map:IsTileOcean(tile) then
            return false
        end

        local ents = TheSim:FindEntities(run_point.x, run_point.y, run_point.z, 2, nil, nil, { "pugalisk", "pugalisk_avoids" })
        if #ents > 0 then
            return false
        end

        local ents = TheSim:FindEntities(run_point.x, run_point.y, run_point.z, 6, { "pugalisk_avoids" })
        if #ents > 0 then
            return false
        end

        if check_los and not TheWorld.Pathfinder:IsClear(position.x, position.y, position.z, run_point.x, run_point.y, run_point.z, { ignorecreep = true }) then
            return false
        end

        return true
    end

    return FindValidPositionByFan(start_angle, radius, attempts, test)
end

local function findDirectionToDive(inst, target)
    local pt = inst:GetPosition()
    local angle = math.random() * TWOPI
    if target then
        angle = target:GetAngleToPoint(pt.x, pt.y, pt.z) * DEGREES - PI
    end
    local offset, endangle = findMoveablePosition(pt, angle, 6, 24, true)
    return endangle
end

local function findsafelocation(pt, angle)
    local finalpt = nil
    local offset = nil
    local range = 6
    while not offset do
        offset = findMoveablePosition(pt, angle * DEGREES, range, 24, true)
        range = range + 1
    end
    if offset then
        pt = pt + offset
        finalpt = pt
    end
    return finalpt
end

local function DetermineAction(inst)
    -- tested each frame when head to see if the head should start moving
    local target = inst.components.combat.target

    local distsq = nil
    if target then
        distsq = inst:GetDistanceSqToInst(target)
    end

    -- 血少了才会凝视攻击
    local wasgazing = inst.wantstogaze
    inst.wantstogaze = nil
    if distsq
        and target
        and target.components.freezable and not target.components.freezable:IsFrozen()
        and distsq > 8 * 8 and distsq < 20 * 20
    then
        local gazechange = 0
        local health = inst.components.health:GetPercent()
        if health < 0.2 then
            gazechange = 0.75
        elseif health < 0.4 then
            gazechange = 0.5
        elseif health < 0.6 then
            gazechange = 0.3
        end

        if wasgazing or math.random() < gazechange then
            inst:PushEvent("stopmove")
            inst.wantstogaze = true
            if inst.sg:HasStateTag("underground") then
                inst:PushEvent("emerge")
            end
        end
    end



    if distsq and distsq < 6 * 6 and target then
        -- 太近了
        if inst.sg:HasStateTag("underground") then
            inst:PushEvent("emerge")
        end
        inst:PushEvent("stopmove")
    elseif not inst.wantstogaze and not inst.wantstotaunt then
        local angle = nil
        inst.movecommited = true

        -- if no target, then direction is random.
        if target then
            angle = findDirectionToDive(inst, target)
        end

        if angle then
            inst.Transform:SetRotation(angle / DEGREES)
            inst.angle = angle
            if inst.sg:HasStateTag("underground") then
                local pos = inst:GetPosition()
                inst.components.multibody:SpawnBody(inst.angle, 0, pos)
            else
                inst.wantstopremove = true
            end
        else
            inst:PushEvent("backup")
        end
    end
end

local function recoverfrombadangle(inst)
    local finalpt = findsafelocation(inst:GetPosition(), inst.Transform:GetRotation())
    inst.Transform:SetPosition(finalpt.x, finalpt.y, finalpt.z)
end

return {
    findsafelocation = findsafelocation,
    DetermineAction = DetermineAction,
    recoverfrombadangle = recoverfrombadangle,
}
