local function GetTreeStage(inst)
    return string.sub(inst.anims.idle, 6)
end

local function PushSway(inst, monster, monsterpost, skippre)
    if monster then
        inst.sg:GoToState("gnash_pre", { push = true, skippre = skippre })
    else
        if monsterpost then
            if inst.sg:HasStateTag("gnash") then
                inst.sg:GoToState("gnash_pst")
            else
                inst.sg:GoToState("gnash_idle")
            end
        else
            if inst.monster then
                inst.sg:GoToState("gnash_idle")
            else
                local stage = GetTreeStage(inst)
                local sway1 = "sway1_loop_" .. stage
                local sway2 = "sway2_loop_" .. stage
                if stage == "monster" then
                    sway1 = "sway_loop_agro"
                    sway2 = "sway_loop_agro"
                end
                if math.random() > .5 then
                    inst.AnimState:PushAnimation(sway1, true)
                else
                    inst.AnimState:PushAnimation(sway2, true)
                end
            end
        end
    end
end

local function OnGustAnimDone(inst)
    if inst:HasTag("stump") or inst:HasTag("burnt") then
        inst:RemoveEventCallback("animover", OnGustAnimDone)
        return
    end
    if inst.components.blowinwindgust and inst.components.blowinwindgust:IsGusting() then
        local anim = math.random(1, 2)
        inst.AnimState:PlayAnimation(inst.anims["blown" .. tostring(anim)], false)
    else
        inst:DoTaskInTime(math.random() / 2, function(inst)
            if not inst:HasTag("stump") and not inst:HasTag("burnt") then
                local stage = GetTreeStage(inst)
                inst.AnimState:PlayAnimation("blown_pst_" .. stage, false)
                PushSway(inst)
            end
            inst:RemoveEventCallback("animover", OnGustAnimDone)
        end)
    end
end

local function OnGustStart(inst, windspeed)
    if inst:HasTag("stump") or inst:HasTag("burnt") then
        return
    end
    inst:DoTaskInTime(math.random() / 2, function(inst)
        if inst:HasTag("stump") or inst:HasTag("burnt") then
            return
        end
        local stage = GetTreeStage(inst)
        inst.AnimState:PlayAnimation("blown_pre_" .. stage, false)
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/wind_tree_creak")
        inst:ListenForEvent("animover", OnGustAnimDone)
    end)
end

local function OnGustFall(inst)
    if inst.components.workable then
        inst.components.workable:Destroy(TheWorld)
    end
end


-- 要加这个得把单机那几个风吹的bank拿过来
-- for _, v in ipairs({
--     "deciduoustree",
--     "deciduoustree_normal",
--     "deciduoustree_tall",
--     "deciduoustree_short",
--     "deciduoustree_burnt",
--     "deciduoustree_stump"
-- }) do
--     AddPrefabPostInit(v, function(inst)
--         if not TheWorld.ismastersim then return end

--         inst:AddComponent("blowinwindgust")
--         inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
--         inst.components.blowinwindgust:SetDestroyChance(0.01)
--         inst.components.blowinwindgust:SetGustStartFn(OnGustStart)
--         inst.components.blowinwindgust:SetDestroyFn(OnGustFall)
--         inst.components.blowinwindgust:Start()
--     end)
-- end


-- for _, v in ipairs({
--     "evergreen",
--     "evergreen_normal",
--     "evergreen_tall",
--     "evergreen_short",
--     "evergreen_sparse",
--     "evergreen_sparse_normal",
--     "evergreen_sparse_tall",
--     "evergreen_sparse_short",
--     "evergreen_burnt",
--     "evergreen_stump"
-- }) do
--     AddPrefabPostInit(v, function(inst)
--         if not TheWorld.ismastersim then return end

--         inst:AddComponent("blowinwindgust")
--         inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
--         inst.components.blowinwindgust:SetDestroyChance(0.01)
--         inst.components.blowinwindgust:SetGustStartFn(OnGustStart)
--         inst.components.blowinwindgust:SetDestroyFn(OnGustFall)
--         inst.components.blowinwindgust:Start()
--     end)
-- end

for _, v in ipairs({
    "jungletree",
    "jungletree_normal",
    "jungletree_tall",
    "jungletree_short",
    "jungletree_burnt",
    "jungletree_stump",
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:AddComponent("blowinwindgust")
        inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
        inst.components.blowinwindgust:SetDestroyChance(0.01)
        inst.components.blowinwindgust:SetGustStartFn(OnGustStart)
        inst.components.blowinwindgust:SetDestroyFn(OnGustFall)
        inst.components.blowinwindgust:Start()
    end)
end


for _, v in ipairs({
    "mangrovetree",
    "mangrovetree_normal",
    "mangrovetree_tall",
    "mangrovetree_short",
    "mangrovetree_burnt",
    "mangrovetree_stump",
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:AddComponent("blowinwindgust")
        inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
        inst.components.blowinwindgust:SetDestroyChance(0.01)
        inst.components.blowinwindgust:SetGustStartFn(OnGustStart)
        inst.components.blowinwindgust:SetDestroyFn(OnGustFall)
        inst.components.blowinwindgust:Start()
    end)
end
