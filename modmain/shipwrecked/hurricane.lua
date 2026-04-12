--给草追加单机的刮风动画
table.insert(Assets, Asset("ANIM", "anim/grass_blown.zip"))
table.insert(Assets, Asset("ANIM", "anim/sapling_blown.zip"))

----------------------------------------------------------------------------------------------------

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("tro_hurricane")   --海难飓风季
    inst:AddComponent("tro_hailmanager") --冰雹
end)
----------------------------------------------------------------------------------------------------
-- 地面刮风特效的生成
AddComponentPostInit("worldwind", function(self)
    self.windfx_spawn_rate = 0
    self.windfx_spawn_pre_sec = 16

    Hooks.FnDecorator(self, "OnUpdate", nil, function(retTab, self, dt)
        local sm = TheWorld.components.tro_hurricane
        local windspeed = sm and sm:GetHurricaneWindSpeed() or 0
        if windspeed > 0.01 and sm:IsHurricaneStorm() then
            self.windfx_spawn_rate = self.windfx_spawn_rate + self.windfx_spawn_pre_sec * dt
            if self.windfx_spawn_rate > 1.0 then
                local spawn_pos = {}
                for _, v in ipairs(AllPlayers) do
                    local px, py, pz = v.Transform:GetWorldPosition()
                    local can_spawn = true
                    for _, pos in ipairs(spawn_pos) do
                        if distsq(pos.x, pos.z, px, pz) < 256 then
                            can_spawn = false --玩家挤在一起的时候只生成一个
                            break
                        end
                    end
                    if can_spawn then
                        local dx, dz = 16 * UnitRand(), 16 * UnitRand()
                        local x, y, z = px + dx, py, pz + dz
                        local angle = self:GetWindAngle()
                        self:SpawnWindSwirl(x, y, z, windspeed, angle)
                        table.insert(spawn_pos, { x = x, y = y, z = z })
                    end
                end

                self.windfx_spawn_rate = self.windfx_spawn_rate - 1.0
            end
        end
    end)

    function self:SpawnWindSwirl(x, y, z, speed, angle)
        local swirl = SpawnPrefab("windswirl")
        swirl.Transform:SetPosition(x, y, z)
        swirl.Transform:SetRotation(angle + 180)
        swirl.AnimState:SetMultColour(1, 1, 1, math.clamp(speed, 0.0, 1.0))
        --swirl.Physics:SetMotorVel(speed, 0, 0)
    end
end)


----------------------------------------------------------------------------------------------------
local function ongustpick(inst)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
        inst.components.pickable:Pick(inst)
    end
end

-- 针对可采集的植物，添加刮风处理，播放刮风动画
function _G.MakePickableBlowInWindGust(inst, wind_speed, destroy_chance, done_anim)
    inst.tro_hurricane_done_anim = done_anim or "idle"

    local function onblownpstdone(inst)
        if inst.components.pickable and
            inst.components.pickable:CanBePicked() and
            (
                inst.AnimState:IsCurrentAnimation("blown_pst") or
                inst.AnimState:IsCurrentAnimation("blown_loop") or
                inst.AnimState:IsCurrentAnimation("blown_pre")
            )
        then
            inst.AnimState:PlayAnimation(inst.tro_hurricane_done_anim, true)
        end
        inst:RemoveEventCallback("animover", onblownpstdone)
    end

    local function ongustanimdone(inst)
        if inst.components.pickable and inst.components.pickable:CanBePicked() then
            if inst.components.blowinwindgust:IsGusting() then
                local anim = math.random(1, 2)
                inst.AnimState:PlayAnimation("blown_loop" .. anim, false)
            else
                inst:DoTaskInTime(math.random() / 2, function(inst)
                    inst:RemoveEventCallback("animover", ongustanimdone)

                    -- This may not be true anymore
                    if inst.components.pickable and inst.components.pickable:CanBePicked() then
                        inst.AnimState:PlayAnimation("blown_pst", false)
                        -- changed this from a push animation to an animover listen event so that it can be interrupted if necessary, and that a check can be made at the end to know if it should go to idle at that time.
                        --inst.AnimState:PushAnimation("idle", true)
                        inst:ListenForEvent("animover", onblownpstdone)
                    end
                end)
            end
        else
            inst:RemoveEventCallback("animover", ongustanimdone)
        end
    end
    local function onguststart(inst)
        inst:DoTaskInTime(math.random() / 2, function(inst)
            if inst.components.pickable and inst.components.pickable:CanBePicked() then
                inst.AnimState:PlayAnimation("blown_pre", false)
                inst:ListenForEvent("animover", ongustanimdone)
            end
        end)
    end


    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
    inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
    inst.components.blowinwindgust:SetGustStartFn(onguststart)
    inst.components.blowinwindgust:SetGustEndFn(onblownpstdone)
    inst.components.blowinwindgust:SetDestroyFn(ongustpick)
    inst.components.blowinwindgust:Start()
end

function _G.MakeHackableBlowInWindGust(inst, wind_speed, destroy_chance)
    local function onblownpstdone(inst)
        if inst.components.hackable and
            inst.components.hackable:CanBeHacked() and
            (
                inst.AnimState:IsCurrentAnimation("blown_pst") or
                inst.AnimState:IsCurrentAnimation("blown_loop") or
                inst.AnimState:IsCurrentAnimation("blown_pre")
            )
        then
            inst.AnimState:PlayAnimation("idle", true)
        end
        inst:RemoveEventCallback("animover", onblownpstdone)
    end

    local function ongustanimdone(inst)
        if inst.components.hackable and inst.components.hackable:CanBeHacked() then
            if inst.components.blowinwindgust:IsGusting() then
                local anim = math.random(1, 2)
                inst.AnimState:PlayAnimation("blown_loop" .. anim, false)
            else
                inst:DoTaskInTime(math.random() / 2, function(inst)
                    inst:RemoveEventCallback("animover", ongustanimdone)

                    -- This may not be true anymore
                    if inst.components.hackable and inst.components.hackable:CanBeHacked() then
                        inst.AnimState:PlayAnimation("blown_pst", false)
                        -- changed this from a push animation to an animover listen event so that it can be interrupted if necessary, and that a check can be made at the end to know if it should go to idle at that time.
                        --inst.AnimState:PushAnimation("idle", true)
                        inst:ListenForEvent("animover", onblownpstdone)
                    end
                end)
            end
        else
            inst:RemoveEventCallback("animover", ongustanimdone)
        end
    end

    local function onguststart(inst, windspeed)
        inst:DoTaskInTime(math.random() / 2, function(inst)
            if inst.components.hackable and inst.components.hackable:CanBeHacked() then
                inst.AnimState:PlayAnimation("blown_pre", false)
                inst:ListenForEvent("animover", ongustanimdone)
            end
        end)
    end

    local function ongusthack(inst)
        if inst.components.lootdropper and inst.components.hackable and inst.components.hackable:CanBeHacked() then
            inst.components.hackable:MakeEmpty()
            inst.components.lootdropper:SpawnLootPrefab(inst.components.hackable.product)
        end
    end

    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
    inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
    inst.components.blowinwindgust:SetGustStartFn(onguststart)
    inst.components.blowinwindgust:SetGustEndFn(onblownpstdone)
    inst.components.blowinwindgust:SetDestroyFn(ongusthack)
    inst.components.blowinwindgust:Start()
end

----------------------------------------------------------------------------------------------------

AddPrefabPostInit("grass", function(inst)
    if not TheWorld.ismastersim then return end
    MakePickableBlowInWindGust(inst, 0.2, 0.01)
end)
AddPrefabPostInit("sapling", function(inst)
    MakePickableBlowInWindGust(inst, 0.2, 0.1, "sway")
end)

for _, v in ipairs({
    "berrybush",
    "berrybush_snake",
    "berrybush2",
    "berrybush2_snake",
    "coffeebush"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:AddComponent("blowinwindgust")
        inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.BERRYBUSH_WINDBLOWN_SPEED)
        inst.components.blowinwindgust:SetDestroyChance(TUNING.BERRYBUSH_WINDBLOWN_FALL_CHANCE)
        inst.components.blowinwindgust:SetDestroyFn(ongustpick)
        inst.components.blowinwindgust:Start()
    end)
end

AddPrefabPostInit("reeds", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
    inst.components.blowinwindgust:SetDestroyChance(0.1)
    inst.components.blowinwindgust:SetDestroyFn(ongustpick)
    inst.components.blowinwindgust:Start()
end)


modimport "modmain/shipwrecked/prefabs/hurricane_tree.lua"
