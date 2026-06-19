local MakeChest = require("prefabs/tro_treasurechest_defs")

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

local function onhammered2(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
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

return
    MakeChest("krakenchest", {
        bank = "kraken_chest",
        build = "kraken_chest",
        minimap = "kraken_chest.png",
    }),
    MakeChest("luggagechest", {
        bank = "luggage",
        build = "luggage",
        minimap = "luggage_chest.png",
    }, nil, function(inst)
        inst.persists = false --海上旅行箱不保存
    end),
    MakeChest("lavarenachest", {
        bank = "chest",
        build = "treasure_chest",
        minimap = "luggage_chest.png",
        workable = true,
    }, nil, function(inst)
        inst.components.container.onclosefn = oncloseb

        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(4, 7)
        inst.components.playerprox:SetOnPlayerNear(oncloseb)
        -- inst.components.playerprox:SetOnPlayerFar(onfar)
    end),
    MakeChest("roottrunk", {
        bank = "roottrunk",
        build = "treasure_chest_roottrunk",
        minimap = "root_chest.png",
        workable = true,
    }, nil, function(inst)
        inst.components.container.onopenfn = onopenroot
        inst.components.container.onclosefn = oncloseroot
        inst.components.workable:SetOnFinishCallback(onhammered2)
    end),
    MakeChest("roottrunk_child", {
        bank = "roottrunk",
        build = "treasure_chest_roottrunk",
        minimap = "root_chest_child.png",
        workable = true,
        burnable = true
    }, nil, function(inst)
        inst.components.container.onopenfn = onopenroot
        inst.components.container.onclosefn = oncloseroot
        inst.components.workable:SetOnFinishCallback(onhammered2)
        inst:ListenForEvent("onbuilt", onbuiltroot)

        inst:ListenForEvent("onopen", function() if TheWorld.components.roottrunkinventory then TheWorld.components.roottrunkinventory:empty(inst) end end)
        inst:ListenForEvent("onclose", function() if TheWorld.components.roottrunkinventory then TheWorld.components.roottrunkinventory:fill(inst) end end)
    end),
    MakePlacer("roottrunk_child_placer", "roottrunk", "treasure_chest_roottrunk", "closed")
