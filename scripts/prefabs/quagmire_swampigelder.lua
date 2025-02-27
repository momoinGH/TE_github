local assets =
{
    Asset("ANIM", "anim/quagmire_elderswampig.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

--[[
idle
sleep_pre
sleep_loop
sleep_pst


local sounds =
{
	wake = "dontstarve/quagmire/creature/swamppig_elder/sleep_out",
	trade = "dontstarve/quagmire/creature/swamppig_elder/talk",
	sleep = "dontstarve/quagmire/creature/swamppig_elder/sleep_in",
}]]

local function onnear(inst)
    if not inst.AnimState:IsCurrentAnimation("sleep_pst") and not inst.AnimState:IsCurrentAnimation("idle") then
        --inst.SoundEmitter:PlaySound(inst.sounds.wake)

        local strid = math.random(#STRINGS.ELDERPIG_TALK_GREETING)
        inst.components.talker:Say(STRINGS.ELDERPIG_TALK_GREETING[strid])
        inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/swamppig_elder/sleep_out")
        inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/swamppig_elder/talk")
        inst.AnimState:PlayAnimation("sleep_pst")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function onfar(inst)
    --inst.SoundEmitter:PlaySound(inst.sounds.sleep)

    local strid = math.random(#STRINGS.ELDERPIG_TALK_FARWELL)
    inst.components.talker:Say(STRINGS.ELDERPIG_TALK_FARWELL[strid])
    inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/swamppig_elder/sleep_in")
    inst.AnimState:PlayAnimation("sleep_pre")
    inst.AnimState:PushAnimation("sleep_loop", true)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("pigelder.png")
    inst.MiniMapEntity:SetPriority(1)

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.3, 1.3, 1.3)

    MakeObstaclePhysics(inst, 2, .5)

    inst.MiniMapEntity:SetPriority(1)

    inst.DynamicShadow:SetSize(10, 5)

    inst:AddTag("character")
    inst:AddTag("king")
    inst.AnimState:SetBank("quagmire_elderswampig")
    inst.AnimState:SetBuild("quagmire_elderswampig")
    inst.AnimState:PlayAnimation("sleep_loop", true)

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -600, 0)
    inst.components.talker:MakeChatter()



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("store")

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(8, 9)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetOnPlayerNear(onnear)

    inst.sounds = sounds

    return inst
end

return Prefab("quagmire_swampigelder", fn, assets, prefabs)
