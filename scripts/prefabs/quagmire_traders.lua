local assets =
{
    Asset("ANIM", "anim/merm_trader1_build.zip"),
    Asset("ANIM", "anim/merm_trader2_build.zip"),
    Asset("ANIM", "anim/quagmire_swampig_build.zip"),
}

local brain = require "brains/goatbrain"

local prefabs =
{
    "meat",
}

local sounds =
{
    talk = "dontstarve/quagmire/creature/goat_kid/talk",
    trade = "dontstarve/quagmire/creature/goat_kid/item_sold",
}

local function ontalk(inst)
    inst.SoundEmitter:PlaySound(inst.sounds.talk)

    local strid = math.random(#STRINGS.BILLY_GREETING)

    inst.components.talker:Say(STRINGS.BILLY_GREETING[strid])
end

local function ontrade(inst)
    inst.SoundEmitter:PlaySound(inst.sounds.trade)

    local strid = math.random(#STRINGS.GOATKID_TALK_TRADE)

    inst.components.talker:Say(STRINGS.GOATKID_TALK_TRADE[strid])
end

local function MakeMermTrader(name, data, common_post, master_post)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        if data.minimap then
            inst.entity:AddMiniMapEntity()
            inst.MiniMapEntity:SetIcon(data.minimap)
        end

        MakeObstaclePhysics(inst, 0.2)

        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("pigman")
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("idle_loop", true)
        -- inst.AnimState:OverrideSymbol("swap_hat", "hat_top", "swap_hat")
        -- inst.AnimState:OverrideSymbol("pig_arm", "merm_trader2_build", "pig_arm")
        -- inst.AnimState:OverrideSymbol("pig_torso", "merm_trader2_build", "pig_torso")

        inst.DynamicShadow:SetSize(1.5, .75)

        inst:AddTag("character")
        inst:AddTag("merm")

        inst:AddComponent("talker")
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0, -400, 0)
        inst.components.talker:MakeChatter()

        if common_post then
            common_post(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.sounds = sounds

        inst:AddComponent("inspectable")
        inst:AddComponent("locomotor")

        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = data.trees

        inst:SetStateGraph("SGmermtrader")
        inst:SetBrain(brain)

        if master_post then
            master_post(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeMermTrader("quagmire_trader_merm", {
        minimap = "summy.png",
        build = "merm_trader1_build",
        trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_TRADER_MERM
    }),
    MakeMermTrader("quagmire_trader_merm2", {
        minimap = "pipton.png",
        build = "merm_trader2_build",
        trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_TRADER_MERM2
    })
