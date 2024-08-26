local Constructor = require("tropical_utils/constructor")

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function OnPlayerNear(inst)
    inst.components.talker:Say("回去战斗！")
end

local function Init(inst)
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, 1)

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker.ontalk = ontalk
    inst.components.talker:MakeChatter()

    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 12)
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)

    inst.persists = false --下线竞技场就结束了，不需要保存
end

-- 熔炉竞技场开始后，生成一个猪人把门口堵了
return Constructor.CopyPrefab("lavaarena_spectatorblocker", "lavaarena_spectator", { init = Init })
