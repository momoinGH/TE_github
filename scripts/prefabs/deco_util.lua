local InteriorSpawnerUtils = require("interiorspawnerutils")

local DecoCreator = {}

local assets =
{
    Asset("ANIM", "anim/interior_unique.zip"),      --装饰
    Asset("ANIM", "anim/interior_sconce.zip"),      --墙壁上挂灯，不发光
    Asset("ANIM", "anim/interior_defect.zip"),      --室内墙壁破旧贴纸
    Asset("ANIM", "anim/interior_decor.zip"),       --室内墙壁装饰
    Asset("ANIM", "anim/interior_pillar.zip"),      --墙角柱子
    Asset("ANIM", "anim/ceiling_lights.zip"),       --天花板吊灯
    Asset("ANIM", "anim/containers.zip"),           -- 箱子、包、木桶等一堆小杂物
    Asset("ANIM", "anim/interior_floor_decor.zip"), --室内杂物
    Asset("ANIM", "anim/interior_window.zip"),
    Asset("ANIM", "anim/interior_window_burlap.zip"),
    Asset("ANIM", "anim/interior_window_lightfx.zip"),
    Asset("ANIM", "anim/window_arcane_build.zip"),

    Asset("ANIM", "anim/interior_wall_decals.zip"), --室内装饰
    Asset("ANIM", "anim/interior_wall_decals_hoofspa.zip"),
    Asset("ANIM", "anim/interior_wall_mirror.zip"),
    Asset("ANIM", "anim/interior_chair.zip"),

    Asset("ANIM", "anim/interior_wall_decals_antcave.zip"),
    Asset("ANIM", "anim/interior_wall_decals_antiquities.zip"),
    Asset("ANIM", "anim/interior_wall_decals_arcane.zip"),
    Asset("ANIM", "anim/interior_wall_decals_batcave.zip"),
    Asset("ANIM", "anim/interior_wall_decals_deli.zip"),
    Asset("ANIM", "anim/interior_wall_decals_florist.zip"),
    Asset("ANIM", "anim/interior_wall_decals_mayorsoffice.zip"),
    Asset("ANIM", "anim/interior_wall_decals_palace.zip"),
    Asset("ANIM", "anim/interior_wall_decals_ruins.zip"),
    Asset("ANIM", "anim/interior_wall_decals_ruins_blue.zip"),
    Asset("ANIM", "anim/interior_wall_decals_accademia.zip"), --装饰，好像和其他动画文件有些重复的
    Asset("ANIM", "anim/interior_wall_decals_millinery.zip"),
    Asset("ANIM", "anim/interior_wall_decals_weapons.zip"),

    Asset("ANIM", "anim/interior_wallornament.zip"), --壁画

    Asset("ANIM", "anim/window_mayorsoffice.zip"),   --窗户
    Asset("ANIM", "anim/window_palace.zip"),         --窗户
    Asset("ANIM", "anim/window_palace_stainglass.zip"),

    Asset("ANIM", "anim/interior_plant.zip"),     --盆栽
    Asset("ANIM", "anim/interior_table.zip"),
    Asset("ANIM", "anim/interior_floorlamp.zip"), --室内路灯

    Asset("ANIM", "anim/interior_window_small.zip"),
    Asset("ANIM", "anim/interior_window_large.zip"),
    Asset("ANIM", "anim/interior_window_tall.zip"),
    Asset("ANIM", "anim/interior_window_greenhouse.zip"),
    Asset("ANIM", "anim/interior_window_greenhouse_build.zip"),

    Asset("ANIM", "anim/window_weapons_build.zip"),

    Asset("ANIM", "anim/pig_ruins_well.zip"), --泉
    Asset("ANIM", "anim/ceiling_decor.zip"),  --天花板装饰
    Asset("ANIM", "anim/light_dust_fx.zip"),
}

local LIGHTS =
{
    SUNBEAM =
    {
        intensity = 0.9,
        color     = { 197 / 255, 197 / 255, 50 / 255 },
        falloff   = 0.5,
        radius    = 2,
    },

    SMALL =
    {
        intensity = 0.75,
        color     = { 97 / 255, 197 / 255, 50 / 255 },
        falloff   = 0.7,
        radius    = 1,
    },

    MED =
    {
        intensity = 0.9,
        color     = { 197 / 255, 197 / 255, 50 / 255 },
        falloff   = 0.5,
        radius    = 3,
    },

    SMALL_YELLOW =
    {
        intensity = 0.75,
        color     = { 197 / 255, 197 / 255, 50 / 255 },
        falloff   = 0.7,
        radius    = 1,
    },
    FESTIVETREE =
    {
        intensity = 0.9,
        color     = { 197 / 255, 197 / 255, 50 / 255 },
        falloff   = 0.5,
        radius    = 3,
    },
    --照原版来的话就太暗了
    GENERAL = {
        intensity = 0.75,
        color     = { 197 / 255, 197 / 255, 50 / 255 },
        falloff   = 0.85,
        radius    = 2.5,
    }
}

local prefabs =
{
    "swinglightobject",
    "deco_roomglow",
    "deco_wood_cornerbeam_placer",
}

local function OnPhaseChange(inst)
    if TheWorld.state.isday then
        inst.AnimState:PlayAnimation("to_day")
        inst.AnimState:PushAnimation("day_loop", true)
    elseif TheWorld.state.isnight then
        inst.AnimState:PlayAnimation("to_night")
        inst.AnimState:PushAnimation("night_loop", true)
    elseif TheWorld.state.isdusk then
        inst.AnimState:PlayAnimation("to_dusk")
        inst.AnimState:PushAnimation("dusk_loop", true)
    end
end

local function swapColor(inst, light)
    if inst.iswhite then
        inst.iswhite = false
        inst.isred = true
        inst.components.lighttweener:StartTween(light, Lerp(0, 3, 1), nil, nil, { 240 / 255, 100 / 255, 100 / 255 }, 0.2,
            swapColor)
    elseif inst.isred then
        inst.isred = false
        inst.isgreen = true
        inst.components.lighttweener:StartTween(light, Lerp(0, 3, 1), nil, nil, { 240 / 255, 230 / 255, 100 / 255 }, 0.2,
            swapColor)
    else
        inst.isgreen = false
        inst.iswhite = true
        inst.components.lighttweener:StartTween(light, Lerp(0, 3, 1), nil, nil, { 100 / 255, 240 / 255, 100 / 255 }, 0.2,
            swapColor)
    end
end

local function mirror_blink_idle(inst)
    if inst.isneer then
        inst.AnimState:PlayAnimation("shadow_blink")
        inst.AnimState:PushAnimation("shadow_idle", true)
    end
    inst.blink_task = inst:DoTaskInTime(10 + (math.random() * 50), mirror_blink_idle)
end

local function mirror_OnNear(inst)
    inst.AnimState:PlayAnimation("shadow_in")
    inst.AnimState:PushAnimation("shadow_idle", true)

    inst.blink_task = inst:DoTaskInTime(10 + (math.random() * 50), mirror_blink_idle)
    inst.isneer = true
end

local function mirror_OnFar(inst)
    if inst.isneer then
        inst.AnimState:PlayAnimation("shadow_out")
        inst.AnimState:PushAnimation("idle", true)
        inst.isneer = nil
        if inst.blink_task then
            inst.blink_task:Cancel()
            inst.blink_task = nil
        end
    end
end

local function updateartworkable(inst, instant)
    local workleft = inst.components.workable.workleft
    local animlevel = workleft / TUNING.TROPICAL_DECO_RUINS_BEAM_WORK
    if animlevel <= 0 then
        if not instant then
            inst.AnimState:PlayAnimation("pillar_front_crumble")
            inst.AnimState:PushAnimation("pillar_front_crumble_idle")
        else
            inst.AnimState:PlayAnimation("pillar_front_crumble_idle")
        end
    elseif animlevel < 1 / 3 then
        inst.AnimState:PlayAnimation("pillar_front_break_2")
    elseif animlevel < 2 / 3 then
        inst.AnimState:PlayAnimation("pillar_front_break_1")
    end
    if workleft <= 0 then
        inst.components.workable:SetWorkable(false)
    end
end

local function OnWorkCallback(inst, worker, workleft)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")

    updateartworkable(inst)

    -- 在洞穴敲击石柱会导致地震
    -- if TheWorld.components.quaker_interior then
    --     if workleft <= 0 then
    --         TheWorld.components.quaker_interior:ForceQuake("cavein")
    --         print("QUAKE: CAVE IN!!!")
    --     else
    --         TheWorld.components.quaker_interior:ForceQuake("pillarshake")
    --         print("QUAKE: pillar!!!")
    --     end
    -- end
end

local function OnRemove(inst)
    if inst.swinglight then
        inst.swinglight:Remove()
    end
    if inst.dust then
        inst.dust:Remove()
    end
end

local function smash(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end

    local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    collapse_fx:SetMaterial("wood")

    inst:Remove()
end

local function setPlayerUncraftable(inst)
    if not inst.SoundEmitter then
        inst.entity:AddSoundEmitter()
    end

    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end

    if not inst.components.workable then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(smash)
    end

    inst:RemoveTag("NOCLICK")
end

local function OnBuilt(inst)
    inst:AddTag("playercrafted")
    setPlayerUncraftable(inst) --我需要提前初始化，因为其他的预制体可能在onbuilt事件回调中使用
    inst.onbuilt = true

    --翻新时移除旧的对象
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst:HasTag("cornerpost") then
        for i, ent in ipairs(TheSim:FindEntities(x, y, z, 1, { "cornerpost" })) do
            if ent ~= inst then
                smash(ent)
            end
        end
    end

    if inst:HasTag("centerlight") then
        for i, ent in ipairs(TheSim:FindEntities(x, y, z, 1, { "centerlight" })) do
            if ent ~= inst then
                smash(ent)
            end
        end
    end

    if inst:HasTag("wallsection") then
        for i, ent in ipairs(TheSim:FindEntities(x, y, z, 1, { "wallsection" })) do
            if ent ~= inst and not (ent:HasTag("interior_door") and not ent.doorcanberemoved) then
                smash(ent)
            end
        end
    end
end

local function OnSave(inst, data)
    local burnable = inst.components.burnable
    if (burnable and burnable:IsBurning()) or inst:HasTag("burnt") then
        data.burnt = true
    end

    data.onbuilt = inst.onbuilt

    local references = {}

    if inst.sunraysspawned then
        data.sunraysspawned = inst.sunraysspawned
        if inst.swinglight then
            data.swinglight = inst.swinglight.GUID
            table.insert(references, data.swinglight)
        end
    end

    if inst.dust then
        data.dust = inst.dust.GUID
        table.insert(references, data.dust)
    end

    return #references > 0 and references or nil
end

local function OnLoad(inst, data)
    if not data then return end

    if data.burnt then
        inst.components.burnable.onburnt(inst)
    end

    inst.sunraysspawned = data.sunraysspawned or inst.sunraysspawned

    if data.setbackground then
        inst.setbackground = data.setbackground
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetSortOrder(data.setbackground)
    end

    if data.onbuilt then
        inst.onbuilt = data.onbuilt
        inst:AddTag("playercrafted")
    end
end

local function LoadPostPass(inst, ents, data)
    if not data then return end

    if data.swinglight then
        local swinglight = ents[data.swinglight]
        inst.swinglight = swinglight and swinglight.entity
    end
    if data.dust then
        local dust = ents[data.dust]
        inst.dust = dust and dust.entity
    end
end

function decofn(build, bank, animframe, data, name)
    data = data or {}

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBuild(build)
        inst.AnimState:SetBank(bank)
        inst.AnimState:PlayAnimation(animframe, data.loopanim)
        -- inst.Transform:SetRotation(-90)

        if data.scale then
            inst.AnimState:SetScale(data.scale.x, data.scale.y, data.scale.z)
        end

        if data.decal then
            -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
        else
            inst.Transform:SetTwoFaced()
        end

        if data.loopanim then
            inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
        end

        if not data.curtains then
            inst.AnimState:Hide("curtain")
        end

        if data.bloom then
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end

        if data.physics then
            if data.physics == "sofa_physics" then
                -- MakeInteriorPhysics(inst, 1.3, 1, 0.2) --已经不支持矩形的碰撞盒了
                MakeObstaclePhysics(inst, 1.3, 1)
            elseif data.physics == "sofa_physics_vert" then
                MakeObstaclePhysics(inst, 0.2, 1)
            elseif data.physics == "chair_physics_small" then
                MakeObstaclePhysics(inst, .5)
            elseif data.physics == "chair_physics" then
                MakeObstaclePhysics(inst, 1, 1)
            elseif data.physics == "desk_physics" then
                MakeObstaclePhysics(inst, 2, 1)
            elseif data.physics == "tree_physics" then
                inst:AddTag("blocker")
                inst.entity:AddPhysics()
                inst.Physics:SetMass(0)
                inst.Physics:SetCapsule(4.7, 4.0)
                inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.ITEMS)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GROUND)
            elseif data.physics == "pond_physics" then
                inst:AddTag("blocker")
                inst.entity:AddPhysics()
                inst.Physics:SetMass(0)
                inst.Physics:SetCapsule(1.6, 4.0)
                inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.ITEMS)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GROUND)
            elseif data.physics == "big_post_physics" then
                MakeObstaclePhysics(inst, 0.75)
            elseif data.physics == "post_physics" then
                MakeObstaclePhysics(inst, .25)
            end
        end

        if data.light then
            if not data.followlight then
                inst.entity:AddLight()
                inst.Light:SetIntensity(data.light.intensity)
                inst.Light:SetColour(data.light.color[1], data.light.color[2], data.light.color[3])
                inst.Light:SetFalloff(data.light.falloff)
                inst.Light:SetRadius(data.light.radius)
                inst.Light:Enable(true)
                inst:AddComponent("fader")
            end

            if data.blink then
                inst:AddComponent("lighttweener")
                swapColor(inst, inst.Light)
            end
        end

        if data.minimapicon then
            inst.entity:AddMiniMapEntity()
            inst.MiniMapEntity:SetIcon(data.minimapicon)
        end

        if data.background then
            inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
            inst.AnimState:SetSortOrder(data.background)
            inst.setbackground = data.background
        end

        if data.workable then
            inst.entity:AddSoundEmitter()
        end

        if data.adjustanim then
            inst.AnimState:PlayAnimation(animframe .. "_side")
        end

        if data.tags then
            for i, tag in ipairs(data.tags) do
                inst:AddTag(tag)
            end
        end

        if data.commonInit then
            data.commonInit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        if STRINGS.NAMES[string.upper(name)] or data.workable or data.prefabname then
            inst:AddComponent("inspectable")
        end

        inst:AddComponent("tropical_saveanim")

        if data.dayevents then
            inst:WatchWorldState("phase", OnPhaseChange)
            OnPhaseChange(inst)
        end

        if data.light and data.followlight then
            inst:DoTaskInTime(0, function()
                if not inst.sunraysspawned then
                    inst.swinglight = SpawnPrefab("swinglightobject")
                    inst.swinglight:setLightType(data.followlight)
                    if data.windowlight then
                        inst.swinglight:setListenEvents()
                    end
                    local follower = inst.swinglight.entity:AddFollower()
                    follower:FollowSymbol(inst.GUID, "light_circle", 0, 0, 0)
                    inst.swinglight.followobject = { GUID = inst.GUID, symbol = "light_circle", x = 0, y = 0, z = 0 }
                    inst.sunraysspawned = true
                end
            end)
        end

        if data.mirror then
            inst:AddComponent("playerprox")
            inst.components.playerprox:SetOnPlayerNear(mirror_OnNear)
            inst.components.playerprox:SetOnPlayerFar(mirror_OnFar)
            inst.components.playerprox:SetDist(2, 2.1)
        end

        if data.workable then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(TUNING.TROPICAL_DECO_RUINS_BEAM_WORK)
            inst.components.workable:SetMaxWork(TUNING.TROPICAL_DECO_RUINS_BEAM_WORK)
            inst.components.workable.savestate = true --应该保存吗？
            inst.components.workable:SetOnWorkCallback(OnWorkCallback)
            inst.updateworkableart = true
        end

        if data.prefabname then
            inst:SetPrefabName(data.prefabname)
        end

        -- 一些奇怪的猪的涂鸦，可以点火，暂时不知道这是什么预制体，可能是遗迹中的什么物品
        if data.prefabname == "pig_latin_1" then
            inst:AddTag("pig_writing_1")
            TheWorld:ListenForEvent("doorused", function(world, data)
                if inst:HasTag("INTERIOR_LIMBO") then return end

                inst:DoTaskInTime(1, function()
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local closedoors = false
                    for _, torch in ipairs(TheSim:FindEntities(x, y, z, 50, { "wall_torch" }, { "INTERIOR_LIMBO" })) do
                        if not torch.components.cooker then
                            closedoors = true
                        end
                    end

                    if closedoors then
                        for _, ent in ipairs(TheSim:FindEntities(x, y, z, 50, { "lockable_door" }, { "INTERIOR_LIMBO" })) do
                            if ent ~= data.door then
                                ent:PushEvent("close")
                            end
                        end
                    end
                end)
            end)

            inst:ListenForEvent("fire_lit", function()
                local opendoors = true
                local x, y, z = inst.Transform:GetWorldPosition()
                for i, torch in ipairs(TheSim:FindEntities(x, y, z, 50, { "wall_torch" }, { "INTERIOR_LIMBO" })) do
                    if not torch.components.cooker then
                        opendoors = false
                    end
                end

                if opendoors then
                    for i, ent in ipairs(TheSim:FindEntities(x, y, z, 50, nil, { "INTERIOR_LIMBO" })) do
                        if ent:HasTag("lockable_door") then
                            ent:PushEvent("open")
                        end
                    end
                end
            end)
        end

        inst:ListenForEvent("onremove", OnRemove)

        inst:DoTaskInTime(0, function()
            if inst:HasTag("playercrafted") then
                setPlayerUncraftable(inst)
            end

            if inst.updateworkableart then
                updateartworkable(inst, true)
            end
        end)

        if data.onbuilt then
            inst:ListenForEvent("onbuilt", OnBuilt)
        end

        if data.masterInit then
            data.masterInit(inst)
        end

        if data.persists == false then
            inst.persists = false
        else
            inst.OnSave = OnSave
            inst.OnLoad = OnLoad
            inst.LoadPostPass = LoadPostPass
        end

        return inst
    end
    return fn
end

function DecoCreator:Create(name, build, bank, anim, data)
    return Prefab(name, decofn(build, bank, anim, data, name), assets, prefabs)
end

function DecoCreator:GetLights()
    return LIGHTS
end

return DecoCreator
