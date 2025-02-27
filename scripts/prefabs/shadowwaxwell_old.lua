-- local assets =
-- {
--     Asset("ANIM", "anim/rowboat_basic.zip"),
--     Asset("ANIM", "anim/waxwell_shadowboat_build.zip"),
-- }

-- local prefabs =
-- {
--     "shadow_despawn",
--     "statue_transition_2",
--     "nightmarefuel",
-- }

-- local brain = require "brains/shadowwaxwellbrain"

-- local function OnWaterChange(inst, onwater)
--     inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/crocodog/emerge")

--     if onwater then
--         local pegabarco = SpawnPrefab("shadowwaxwellboat")
--         inst:AddComponent("driver2")
--         inst.components.driver2:OnMount(pegabarco)
--     else
--         if inst:HasTag("aquatic") and inst.components.driver2 then
--             local barcoinv = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
--             if barcoinv then barcoinv:Remove() end
--             inst.components.driver2.vehicle:Remove()
--             inst:RemoveComponent("rowboatwakespawner")
--             inst:RemoveComponent("driver2")
--             inst:RemoveTag("aquatic")
--             inst.sg:GoToState("idle")
--         end
--     end
-- end

-- local function OnAttacked(inst, data)
--     if data.attacker ~= nil then
--         if data.attacker.components.petleash ~= nil and
--             data.attacker.components.petleash:IsPet(inst) then
--             if inst.components.lootdropper == nil then
--                 inst:AddComponent("lootdropper")
--             end
--             inst.components.lootdropper:SpawnLootPrefab("nightmarefuel", inst:GetPosition())
--             data.attacker.components.petleash:DespawnPet(inst)
--         elseif data.attacker.components.combat ~= nil then
--             inst.components.combat:SuggestTarget(data.attacker)
--         end
--     end
-- end

-- local function retargetfn(inst)
--     --Find things attacking leader
--     local leader = inst.components.follower:GetLeader()
--     return leader ~= nil
--         and FindEntity(
--             leader,
--             TUNING.SHADOWWAXWELL_TARGET_DIST,
--             function(guy)
--                 return guy ~= inst
--                     and (guy.components.combat:TargetIs(leader) or
--                         guy.components.combat:TargetIs(inst))
--                     and inst.components.combat:CanTarget(guy)
--             end,
--             { "_combat" }, -- see entityreplica.lua
--             { "playerghost", "INLIMBO" }
--         )
--         or nil
-- end

-- local function keeptargetfn(inst, target)
--     --Is your leader nearby and your target not dead? Stay on it.
--     --Match KEEP_WORKING_DIST in brain
--     return inst.components.follower:IsNearLeader(14)
--         and inst.components.combat:CanTarget(target)
-- end

-- local function spearfn(inst)
--     inst.components.health:SetMaxHealth(TUNING.SHADOWWAXWELL_LIFE)
--     inst.components.health:StartRegen(TUNING.SHADOWWAXWELL_HEALTH_REGEN, TUNING.SHADOWWAXWELL_HEALTH_REGEN_PERIOD)

--     inst.components.combat:SetDefaultDamage(TUNING.SHADOWWAXWELL_DAMAGE)
--     inst.components.combat:SetAttackPeriod(TUNING.SHADOWWAXWELL_ATTACK_PERIOD)
--     inst.components.combat:SetRetargetFunction(2, retargetfn)  --Look for leader's target.
--     inst.components.combat:SetKeepTargetFunction(keeptargetfn) --Keep attacking while leader is near.

--     return inst
-- end

-- local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
--     return afflicter ~= nil and afflicter:HasTag("quakedebris")
-- end

-- local function OnEntityWake(inst)
--     inst.components.tiletracker:Start()
-- end

-- local function OnEntitySleep(inst)
--     inst.components.tiletracker:Stop()
-- end

-- local function MakeMinion(prefab, tool, hat, master_postinit)
--     local assets =
--     {
--         Asset("ANIM", "anim/waxwell_shadow_mod.zip"),
--         Asset("SOUND", "sound/maxwell.fsb"),
--         Asset("ANIM", "anim/" .. tool .. ".zip"),
--     }

--     local function fn()
--         local inst = CreateEntity()

--         inst.entity:AddTransform()
--         inst.entity:AddAnimState()
--         inst.entity:AddSoundEmitter()
--         inst.entity:AddNetwork()

--         MakeFlyingCharacterPhysics(inst, 1, 0.5)
--         inst.Transform:SetFourFaced(inst)

--         inst.AnimState:SetBank("wilson")
--         inst.AnimState:SetBuild("waxwell_shadow_mod")
--         inst.AnimState:PlayAnimation("idle")
--         inst.AnimState:SetMultColour(0, 0, 0, .5)

--         if tool ~= nil then
--             inst.AnimState:OverrideSymbol("swap_object", tool, tool)
--             inst.AnimState:Hide("ARM_normal")
--         else
--             inst.AnimState:Hide("ARM_carry")
--         end

--         if hat ~= nil then
--             inst.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
--             inst.AnimState:Hide("HAIR_NOHAT")
--             inst.AnimState:Hide("HAIR")
--         else
--             inst.AnimState:Hide("HAT")
--             inst.AnimState:Hide("HAIR_HAT")
--         end

--         inst:AddTag("scarytoprey")
--         inst:AddTag("shadowminion")
--         inst:AddTag("NOBLOCK")

--         inst:SetPrefabNameOverride("shadowwaxwell")

--         inst.entity:SetPristine()

--         if not TheWorld.ismastersim then
--             return inst
--         end

--         inst:AddComponent("locomotor")
--         inst.components.locomotor.runspeed = TUNING.SHADOWWAXWELL_SPEED
--         inst.components.locomotor.pathcaps = { ignorecreep = true }
--         inst.components.locomotor:SetSlowMultiplier(.6)

--         inst:AddComponent("health")
--         inst.components.health:SetMaxHealth(1)
--         inst.components.health.nofadeout = true
--         inst.components.health.redirect = nodebrisdmg

--         inst:AddComponent("combat")
--         inst.components.combat.hiteffectsymbol = "torso"
--         inst.components.combat:SetRange(2)

--         inst:AddComponent("follower")
--         inst.components.follower:KeepLeaderOnAttacked()
--         inst.components.follower.keepdeadleader = true

--         inst:SetBrain(brain)
--         inst:SetStateGraph("SGshadowwaxwell")

--         inst:ListenForEvent("attacked", OnAttacked)

--         if master_postinit ~= nil then
--             master_postinit(inst)
--         end
--         inst:AddComponent("inventory")
--         inst:AddComponent("tiletracker")
--         inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)



--         inst.OnEntityWake = OnEntityWake
--         inst.OnEntitySleep = OnEntitySleep


--         return inst
--     end

--     return Prefab(prefab, fn, assets, prefabs)
-- end

-- --------------------------------------------------------------------------

-- local function NoHoles(pt)
--     return not TheWorld.Map:IsPointNearHole(pt)
-- end

-- local function onbuilt(inst, builder)
--     local theta = math.random() * TWOPI
--     local pt = builder:GetPosition()
--     local radius = math.random(3, 6)
--     local offset = FindWalkableOffset(pt, theta, radius, 12, true, true, NoHoles)
--     if offset ~= nil then
--         pt.x = pt.x + offset.x
--         pt.z = pt.z + offset.z
--     end
--     builder.components.petleash:SpawnPetAt(pt.x, 0, pt.z, inst.pettype)
--     inst:Remove()
-- end

-- local function MakeBuilder(prefab)
--     --These shadows are summoned this way because petleash needs to
--     --be the component that summons the pets, not the builder.
--     local function fn()
--         local inst = CreateEntity()

--         inst.entity:AddTransform()

--         inst:AddTag("CLASSIFIED")

--         --[[Non-networked entity]]
--         inst.persists = false

--         --Auto-remove if not spawned by builder
--         inst:DoTaskInTime(0, inst.Remove)

--         if not TheWorld.ismastersim then
--             return inst
--         end

--         inst.pettype = prefab
--         inst.OnBuiltFn = onbuilt
--         return inst
--     end

--     return Prefab(prefab .. "_builder", fn, nil, { prefab })
-- end

-- --------------------------------------------------------------------------

-- return MakeMinion("shadowlumber", "swap_axe"),
--     MakeMinion("shadowminer", "swap_pickaxe"),
--     MakeMinion("shadowdigger", "swap_shovel"),
--     MakeMinion("shadowmower", "swap_machete"),
--     MakeMinion("shadowduelist", "swap_nightmaresword_shadow", nil, spearfn),
--     MakeBuilder("shadowlumber"),
--     MakeBuilder("shadowminer"),
--     MakeBuilder("shadowdigger"),
--     MakeBuilder("shadowduelist"),
--     MakeBuilder("shadowmower")
