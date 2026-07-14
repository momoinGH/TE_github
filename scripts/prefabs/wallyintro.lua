local assets =
{
    Asset("ANIM", "anim/parrot_pirate.zip"), --这个鹦鹉动画还挺多的
}
local function onhammered(inst)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
    end
end

local function TakeOff(inst)
    local bird = SpawnPrefab("wallyintro_bird")
    bird.Transform:SetPosition(inst:GetPosition():Get())
    bird.Transform:SetRotation(inst.Transform:GetRotation())
    bird.AnimState:PlayAnimation("takeoff_diagonal_pre")
    bird.animoverfn = function()
        bird:RemoveEventCallback("animover", bird.animoverfn)

        bird.AnimState:PlayAnimation("takeoff_diagonal_loop", true)

        bird:DoTaskInTime(2, function() bird:Remove() end)

        bird:DoPeriodicTask(7 * FRAMES, function()
            bird.SoundEmitter:PlaySound("dontstarve/birds/flyin")
        end)
    end

    bird:ListenForEvent("animover", bird.animoverfn)

    local mast = SpawnPrefab("wallyintro_shipmast")
    mast.Transform:SetPosition(inst:GetPosition():Get())
    mast.Transform:SetRotation(inst.Transform:GetRotation())

    inst:Remove()
end

local PlayPecks = nil
PlayPecks = function(inst)
    inst:RemoveEventCallback("animover", PlayPecks)
    local peckfn = function()
        if inst then
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/parrot/peck")
        end
    end
    inst:DoTaskInTime(6 * FRAMES, peckfn)
    inst:DoTaskInTime(11 * FRAMES, peckfn)
end

local SPEECH =
{
    NULL_SPEECH =
    {
        voice = "dontstarve/maxwell/talk_LP",
        appearanim = "idle_peck",
        idleanim = "idle",
        --dialogpreanim = "dialog_pre",
        dialoganim = "speak",
        --dialogpostanim = "dialog_pst",
        disappearanim = TakeOff,
        disableplayer = true,
        skippable = true,
        {
            string = "There is no speech number.", --The string maxwell will say
            wait = 2,                              --The time this segment will last for
            anim = nil,                            --If there's a different animation, the animation maxwell will play
            sound = nil,                           --if there's an extra sound, the sound that will play
        },
        {
            string = nil,
            wait = 0.5,
            anim = "smoke",
            sound = "dontstarve/common/destroy_metal",
        },
        {
            string = "Go set one.",
            wait = 2,
            anim = nil,
            sound = nil,
        },
        {
            string = "Goodbye",
            wait = 1,
            anim = nil,
            sound = "dontstarve/common/destroy_metal",
        },

    },

    SHIPWRECKED_1 =
    {
        voice = "dontstarve_DLC002/creatures/parrot/chirp",
        idleanim = "idle",
        dialoganim = "speak",
        disappearanim = TakeOff,
        disableplayer = true,
        skippable = true,
        {
            string = nil,
            wait = 1,
            anim = "idle",
            pushanim = true,
            sound = nil,
        },
        {
            string = STRINGS.WALLY_SANDBOXINTROS.ONE,
            wait = 1,
            anim = nil,
            sound = nil,
        },
        {
            string = nil,
            wait = 3,
            anim = "idle_peck",
            pushanim = true,
            sectionfn = function(inst)
                inst:ListenForEvent("animover", PlayPecks)
            end,
        },
        {
            string = STRINGS.WALLY_SANDBOXINTROS.TWO,
            wait = 0.5,
            anim = nil,
            sound = nil,
        },
    },
}

local function AbleToAcceptTest(inst, item, giver)
    return not inst:HasTag("burnt")
end

local function AcceptTest(inst, item, giver)
    return false --现在啥功能都没有
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.AnimState:IsCurrentAnimation("idle") then
        inst.AnimState:PlayAnimation("accept_pre")
        inst.AnimState:PushAnimation("accept", false)
        inst.AnimState:PushAnimation("accept_post", false)
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function OnRefuseItem(inst, giver, item)
    inst.AnimState:PlayAnimation("reject")
    inst.AnimState:PushAnimation("idle", true)
end

local function wallyintro_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.Transform:SetTwoFaced()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("parrot_pirate")
    inst.AnimState:SetBuild("parrot_pirate")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("notarget")
    inst:AddTag("wallyintro")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 40
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -550, 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "log" })

    inst:AddComponent("maxwelltalker")
    inst.components.maxwelltalker.speeches = SPEECH
    inst.components.maxwelltalker.cleartrees = true

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    MakeMediumBurnable(inst, nil, nil, true)

    local function OnBurntUp(inst, data)

    end

    inst:ListenForEvent("burntup", OnBurntUp)

    return inst
end

local function bird_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("takeoff_diagonal_pre")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "wallyintro"

    inst.displaynamefn = function(inst) return STRINGS.NAMES["WALLYINTRO"] end

    inst.persists = false

    return inst
end

----------------------------------------------------------------------------------------------------

local function MakeDebris(name, data, common_post, master_post)
    assert(data.anim)

    local function fn()
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        if data.collision then
            MakeObstaclePhysics(inst, 0.1)
        end
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        inst.AnimState:SetBank("parrot_pirate")
        inst.AnimState:SetBuild("parrot_pirate")
        inst.AnimState:PlayAnimation(data.anim)

        inst:SetPrefabNameOverride("wallyintro_debris")

        if common_post then
            common_post(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(data.work_left or 1)
        inst.components.workable:SetOnFinishCallback(onhammered)

        inst:AddComponent("lootdropper")
        if data.loot then
            inst.components.lootdropper:SetLoot(data.loot)
        end

        inst:AddComponent("inspectable")

        if master_post then
            master_post(inst)
        end

        return inst
    end
    return Prefab(name, fn, assets)
end

return Prefab("wallyintro", wallyintro_fn, assets),
    Prefab("wallyintro_bird", bird_fn, assets),
    MakeDebris("wallyintro_debris_1", { anim = "debris_1", loot = { "boards" } }),
    MakeDebris("wallyintro_debris_2", { anim = "debris_2", loot = { "log", "log", "log" } }),
    MakeDebris("wallyintro_debris_3", { anim = "debris_3", loot = { "boards", "boatrepairkit" } }),
    MakeDebris("wallyintro_shipmast", { anim = "idle_empty", loot = { "log", "log", "log", "boatrepairkit", work_left = 4, collision = true } },
        nil, function(inst)
            inst.components.workable:SetOnWorkCallback(function(inst)
                inst.AnimState:PlayAnimation("hit")
                inst.AnimState:PushAnimation("idle_empty")
            end)
        end)
