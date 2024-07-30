local prefabs =
{
}

local assets =
{
    Asset("ANIM", "anim/ant_cave_lantern.zip"),
}

local HONEY_LANTERN_MINE = 6

local function OnWorked(inst, worker, workleft)
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        inst.components.lootdropper:DropLoot(inst:GetPosition())
        inst:Remove()
    else
        if workleft < HONEY_LANTERN_MINE * (1 / 3) then
            inst.AnimState:PlayAnimation("break")
        elseif workleft < HONEY_LANTERN_MINE * (2 / 3) then
            inst.AnimState:PlayAnimation("hit")
        else
            inst.AnimState:PlayAnimation("idle")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetRadius(2.5)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:Enable(true)

    inst.MiniMapEntity:SetIcon("ant_cave_lantern.png")

    inst.AnimState:SetBank("ant_cave_lantern")
    inst.AnimState:SetBuild("ant_cave_lantern")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    ---------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "honey", "honey", "honey" })

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(HONEY_LANTERN_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)

    inst:ListenForEvent("beginaporkalypse", function() inst.Light:Enable(false) end, TheWorld)
    inst:ListenForEvent("endaporkalypse", function() inst.Light:Enable(true) end, TheWorld)
    --    inst:ListenForEvent("exitlimbo", function(inst) inst.Light:Enable(not GetAporkalypse():IsActive()) end)

    return inst
end

return Prefab("anthill/items/ant_cave_lantern", fn, assets, prefabs)
