local pinecone_assets =
{
    Asset("ANIM", "anim/sugarwoodtree_cone.zip"),
}

local pinecone_prefabs =
{
    "quagmire_sugarwoodtree_small",
}
local function growtree(inst)
    local tree = SpawnPrefab("cottontree_small")
    if tree then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
    end
end

local function stopgrowing(inst)
    inst.components.timer:StopTimer("grow")
end

startgrowing = function(inst) -- this was forward declared
    if not inst.components.timer:TimerExists("grow") then
        local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
        inst.components.timer:StartTimer("grow", growtime)
    end
end

local function ontimerdone(inst, data)
    if data.name == "grow" then
        growtree(inst)
    end
end

local function digup(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function sapling_fn(build, anim, growprefab, tag, fireproof, overrideloot)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank(build)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim)

        inst:AddTag(tag)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.growprefab = growprefab
        inst.StartGrowing = startgrowing

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", ontimerdone)
        startgrowing(inst)

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(overrideloot or { "twigs" })

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(digup)
        inst.components.workable:SetWorkLeft(1)

        if not fireproof then
            MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
            inst:ListenForEvent("onignite", stopgrowing)
            inst:ListenForEvent("onextinguish", startgrowing)
            MakeSmallPropagator(inst)

            MakeHauntableIgnite(inst)
        else
            MakeHauntableWork(inst)
        end

        return inst
    end
    return fn
end

return Prefab("cottontree_sapling",
    sapling_fn("sugarwoodtree_cone", "idle_planted", "quagmire_sugarwoodtree_small", "sugarwood", true), pinecone_assets,
    pinecone_prefabs)
