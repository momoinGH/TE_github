require "prefabutil"

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    fx:SetMaterial("stone")
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.prefab == "quagmire_park_angel" then
        inst.AnimState:PushAnimation("angel")
    elseif inst.prefab == "quagmire_park_angel2" then
        inst.AnimState:PushAnimation("angel2")
    elseif inst.prefab == "quagmire_park_urn" then
        inst.AnimState:PushAnimation("urn")
    elseif inst.prefab == "quagmire_park_obelisk" then
        inst.AnimState:PushAnimation("obelisk")
    else
        inst.AnimState:PushAnimation("idle")
    end
end

local function onbuilt(inst)
    if inst.prefab == "quagmire_park_angel" then
        inst.AnimState:PushAnimation("angel")
    elseif inst.prefab == "quagmire_park_angel2" then
        inst.AnimState:PushAnimation("angel2")
    elseif inst.prefab == "quagmire_park_urn" then
        inst.AnimState:PushAnimation("urn")
    elseif inst.prefab == "quagmire_park_obelisk" then
        inst.AnimState:PushAnimation("obelisk")
    else
        inst.AnimState:PushAnimation("idle")
    end
end


local function MakeStatue(name, build_bank, anim, save_rotation, physics_rad)
    local assets =
    {
        Asset("ANIM", "anim/" .. build_bank .. ".zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
	    inst.entity:AddSoundEmitter()
		
        inst.AnimState:SetBank(build_bank)
        inst.AnimState:SetBuild(build_bank)
        inst.AnimState:PlayAnimation(anim or "idle")

        if physics_rad ~= 0 then
            MakeObstaclePhysics(inst, physics_rad or .5)
        end

        if save_rotation then
            inst.Transform:SetTwoFaced()
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")
        
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(6)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:ListenForEvent("onbuilt", onbuilt)
		
		MakeHauntableWork(inst)

        if save_rotation then
            inst:AddComponent("savedrotation")
        end

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeStatue("quagmire_altar_statue1", "quagmire_altar_statue1", "idle", true),
       MakeStatue("quagmire_altar_statue2", "quagmire_altar_statue2", "idle", true),
       MakeStatue("quagmire_altar_queen", "quagmire_altar_queen", "idle", false, 1),
       MakeStatue("quagmire_altar_bollard", "quagmire_bollard", "idle", false, 0.25),
       MakeStatue("quagmire_altar_ivy", "quagmire_ivy_topiary", "idle", false, .33),
	   
       MakeStatue("quagmire_park_fountain", "quagmire_birdbath", "idle", true),
       MakeStatue("quagmire_park_angel", "quagmire_cemetery", "angel", true),
       MakeStatue("quagmire_park_angel2", "quagmire_cemetery", "angel2", true),
       MakeStatue("quagmire_park_urn", "quagmire_cemetery", "urn", true),
       MakeStatue("quagmire_park_obelisk", "quagmire_cemetery", "obelisk", true),
	
       MakeStatue("quagmire_merm_cart1", "quagmire_mermcart", "idle1", false, 1.5),
       MakeStatue("quagmire_merm_cart2", "quagmire_mermcart", "idle2", false),
	   
	   MakePlacer("quagmire_altar_statue1_placer", "quagmire_altar_statue1", "quagmire_altar_statue1", "idle"),
       MakePlacer("quagmire_altar_statue2_placer", "quagmire_altar_statue2", "quagmire_altar_statue2", "idle"),
       MakePlacer("quagmire_altar_queen_placer", "quagmire_altar_queen", "quagmire_altar_queen", "idle"),
	   MakePlacer("quagmire_altar_bollard_placer", "quagmire_altar_bollard", "quagmire_altar_bollard", "idle"),
	   MakePlacer("quagmire_altar_ivy_placer", "quagmire_ivy_topiary", "quagmire_ivy_topiary", "idle"),
	   
	   MakePlacer("quagmire_park_fountain_placer", "quagmire_birdbath", "quagmire_birdbath", "idle"),
	   MakePlacer("quagmire_park_angel_placer", "quagmire_cemetery", "quagmire_cemetery", "angel"),
	   MakePlacer("quagmire_park_angel2_placer", "quagmire_cemetery", "quagmire_cemetery", "angel2"),
	   MakePlacer("quagmire_park_urn_placer", "quagmire_cemetery", "quagmire_cemetery", "urn"),
	   MakePlacer("quagmire_park_obelisk_placer", "quagmire_cemetery", "quagmire_cemetery", "obelisk")