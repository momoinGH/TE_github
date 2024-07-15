require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/ant_chest.zip"),
	Asset("ANIM", "anim/ant_chest_honey_build.zip"),
	Asset("ANIM", "anim/ant_chest_nectar_build.zip"),

	Asset("ANIM", "anim/honey_chest.zip"),
	Asset("ANIM", "anim/honey_chest_honey_build.zip"),
}

local prefabs =
{
	"collapse_small",
	"lavaarena_creature_teleport_small_fx",
}

local loot =
{
    "chitin",
    "chitin",
	"chitin",
	"beeswax",
    "honey",
	"honey",
    "rocks",
	--"flint",
}

local function onopen(inst) 
	if not inst:HasTag("burnt") then
			inst.AnimState:PushAnimation("open", false)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close", true)
			inst.AnimState:PushAnimation("closed", true)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

	end
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")	
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", true)
		if inst.components.container then 
			inst.components.container:DropEverything() 
			inst.components.container:Close()
		end
	end
end

local function setworkable(inst)
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(loot)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
end

local function setworkable1(inst)
	inst:AddComponent("lootdropper")
	--inst.components.lootdropper:SetLoot(loot)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
end

local function onbuilt(inst)
--	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("close")
	inst.AnimState:PushAnimation("closed")
	-- if inst.prefab == "honeychest" then
	-- 	inst.honeyWasLoaded = true
	-- end
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
	if inst.honeyWasLoaded then
		data.honeyWasLoaded = inst.honeyWasLoaded
	end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
	if data and data.honeyWasLoaded then
		inst.honeyWasLoaded = data.honeyWasLoaded
	end
end

local function LoadHoneyFirstTime(inst)
    if not inst.honeyWasLoaded then
        inst.honeyWasLoaded = true
        if inst.components.container then
            for i = 1, 9 do
                local single1 = SpawnPrefab("honey")
                inst.components.container:GiveItem(single1, i)
            end
        end
    end
end

local function RefreshAntChestBuild(inst)
    local container = inst.components.container
	local prefix = ""
	if inst.prefab == "antchest" then
		prefix = "ant_chest"
	else
		prefix = "honey_chest"
	end
    local containsHoney = false
    local containsNectar = false

    for _, v in ipairs(container.slots) do
        if v.prefab == "nectar_pod" then
            containsNectar = true
        else
            containsHoney = true
        end
    end

    if containsHoney == true then
        inst.AnimState:SetBuild(prefix.."_honey_build")
        -- inst.MiniMapEntity:SetIcon(prefix.."_honey.png")
    elseif containsNectar == true then
        inst.AnimState:SetBuild(prefix.."_nectar_build")
        -- inst.MiniMapEntity:SetIcon(prefix.."_nectar.png")
    else
        inst.AnimState:SetBuild(prefix)
        -- inst.MiniMapEntity:SetIcon(prefix..".png")
    end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)

	inst.MiniMapEntity:SetIcon("ant_chest.png")
	
	inst.AnimState:SetBank("ant_chest")
	inst.AnimState:SetBuild("ant_chest_honey_build")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
    inst:AddTag("chest")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("antchest") 
		end
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("antchest")
	inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

	setworkable(inst)
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)

	MakeSnowCovered(inst, .01)	

	MakeSmallBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	
	inst:ListenForEvent("itemget", function() RefreshAntChestBuild(inst) end)
	inst:ListenForEvent("itemlose", function() RefreshAntChestBuild(inst) end)
	inst:DoTaskInTime(0.01, function() LoadHoneyFirstTime(inst) end)	
	
		inst.OnSave = onsave 
		inst.OnLoad = onload	
	
	
	return inst
end

local function fn1(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)

	inst.MiniMapEntity:SetIcon("honey_chest.png")
	
	inst.AnimState:SetBank("honey_chest")
	inst.AnimState:SetBuild("honey_chest")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
    inst:AddTag("chest")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("antchest") 
		end
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("antchest")
	inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

	setworkable1(inst)
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)

	inst:ListenForEvent( "onbuilt", onbuilt)

    -- local upgradeable = inst:AddComponent("upgradeable")
    -- upgradeable.upgradetype = UPGRADETYPES.CHEST
    -- upgradeable:SetOnUpgradeFn(OnUpgrade)

	MakeSnowCovered(inst, .01)	

	MakeSmallBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	
	inst:ListenForEvent("itemget", function() RefreshAntChestBuild(inst) end)
	inst:ListenForEvent("itemlose", function() RefreshAntChestBuild(inst) end)
	
		inst.OnSave = onsave 
		inst.OnLoad = onload	
	
	
	return inst
end

return 	Prefab("common/antchest", fn, assets),
		Prefab("common/honeychest", fn1, assets),

	    MakePlacer("common/honeychest_placer", "honey_chest", "honey_chest", "closed")