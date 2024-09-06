local assets =
{
	Asset("ANIM", "anim/octopus_chest.zip"),
	Asset("ANIM", "anim/kraken_chest.zip"),
	Asset("ANIM", "anim/luggage.zip"),
	Asset("ANIM", "anim/treasure_chest_roottrunk.zip"),
}

local function onopen(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PushAnimation("opened", true)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PushAnimation("closed", true)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	end
end

local function oncloseocto(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

		if not inst.components.container:IsEmpty() then
			inst.AnimState:PushAnimation("closed", true)
			return
		else
			inst.AnimState:PushAnimation("sink", false)

			inst:DoTaskInTime(96 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC002/quacken/tentacle_submerge")
			end)

			inst:ListenForEvent("animqueueover", function(inst)
				inst:Remove()
			end)
		end
	end
end

local function oncloseb(inst)
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("lavaarena_creature_teleport_small_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

	local pt = inst:GetPosition()
	local jogadores = TheSim:FindEntities(pt.x, pt.y, pt.z, 70, { "player" })
	for k, player in pairs(jogadores) do
		if player.components.hunger then
			player.components.hunger:DoDelta(500)
		end
		if player.components.sanity then
			player.components.sanity:DoDelta(500)
		end

		if player.components.health then
			player.components.health:DoDelta(500)
		end
	end

	inst:Remove()
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhammered2(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
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

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", true)
end

local function onopenroot(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PushAnimation("open", false)
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/root_trunk/open")
	end
end

local function oncloseroot(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close", false)
		inst.AnimState:PushAnimation("closed", false)
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/root_trunk/close")
	end
end

local function onbuiltroot(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/root_trunk/place")
end

local fns = {
	octopuschest = function(inst, common)
		if not common then
			inst.components.container.onclosefn = oncloseocto
		end
	end,
	luggagechest = function(inst, common)
		if not common then
			inst:AddComponent("vanish_on_sleep")
			inst.components.vanish_on_sleep.duration = 240 + math.random() * 240
		end
	end,
	lavarenachest = function(inst, common)
		if not common then
			inst.components.container.onclosefn = oncloseb

			inst:AddComponent("playerprox")
			inst.components.playerprox:SetDist(4, 7)
			inst.components.playerprox:SetOnPlayerNear(oncloseb)
			inst.components.playerprox:SetOnPlayerFar(onfar)
		end
	end,
	roottrunk = function(inst, common)
		if not common then
			inst.components.container.onopenfn = onopenroot
			inst.components.container.onclosefn = oncloseroot

			inst.components.workable:SetOnFinishCallback(onhammered2)
		end
	end,
	roottrunk_child = function(inst, common)
		if not common then
			inst.components.container.onopenfn = onopenroot
			inst.components.container.onclosefn = oncloseroot
			inst.components.workable:SetOnFinishCallback(onhammered2)
			inst:ListenForEvent("onbuilt", onbuiltroot)

			inst:ListenForEvent("onopen",
				function() if TheWorld.components.roottrunkinventory then TheWorld.components.roottrunkinventory:empty(inst) end end)
			inst:ListenForEvent("onclose",
				function() if TheWorld.components.roottrunkinventory then TheWorld.components.roottrunkinventory:fill(inst) end end)
		end
	end
}

local function MakeChest(name, bank, build, minimap)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		if minimap then
			inst.entity:AddMiniMapEntity()
			inst.MiniMapEntity:SetIcon(minimap)
		end

		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation("closed", true)

		inst:AddTag("structure")
		inst:AddTag("chest")

		inst:SetDeploySmartRadius(0.5) --recipe min_spacing/2

		if fns[name] then
			fns[name](inst, true)
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")

		inst:AddComponent("container")
		inst.components.container:WidgetSetup("treasurechest")
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(2)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)

		inst:ListenForEvent("onbuilt", onbuilt)
		MakeSnowCovered(inst, .01)

		MakeSmallBurnable(inst, nil, nil, true)
		MakeSmallPropagator(inst)

		if fns[name] then
			fns[name](inst, false)
		end

		return inst
	end

	return Prefab(name, fn, assets)
end

return MakeChest("octopuschest", "octopus_chest", "octopus_chest", "kraken_chest.png"),
	MakeChest("krakenchest", "kraken_chest", "kraken_chest", "kraken_chest.png"),
	MakeChest("luggagechest", "luggage", "luggage", "luggage_chest.png"),
	MakeChest("lavarenachest", "chest", "treasure_chest", "luggage_chest.png"),
	MakeChest("roottrunk", "roottrunk", "treasure_chest_roottrunk", "root_chest.png"),
	MakeChest("roottrunk_child", "roottrunk", "treasure_chest_roottrunk", "root_chest_child.png"),
	MakePlacer("roottrunk_child_placer", "roottrunk", "treasure_chest_roottrunk", "closed")
