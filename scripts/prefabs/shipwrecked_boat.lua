local assets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_armored_build.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_row.zip"),
    Asset("ANIM", "anim/corkboat.zip"),
    Asset("ANIM", "anim/coracle_boat_build.zip"),
    Asset("ANIM", "anim/rowboat_cargo_build.zip"),
    Asset("ANIM", "anim/boat_hud_cargo.zip"),
    Asset("ANIM", "anim/rowboat_encrusted_build.zip"),
    Asset("ANIM", "anim/boat_hud_encrusted.zip"),
    Asset("ANIM", "anim/rowboat_build.zip"),
    Asset("ANIM", "anim/pirate_boat_build.zip"),
    Asset("ANIM", "anim/pirate_boat_placer.zip"),

    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_build.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
}

local sounds = {
    place = "turnoftides/common/together/boat/place",
    creak = "turnoftides/common/together/boat/creak",
    damage = "turnoftides/common/together/boat/damage",
    sink = "turnoftides/common/together/boat/sink",
    hit = "turnoftides/common/together/boat/hit",
    thunk = "turnoftides/common/together/boat/thunk",
    movement = "turnoftides/common/together/boat/movement",
}


local function OnDismantle(inst, doer)
    if inst.components.health and not inst.components.health:IsDead() then
        local items = inst.components.container and inst.components.container:RemoveAllItems() or {}
        table.insert(items, SpawnPrefab(inst.dismantlePrefab))
        local x, y, z = inst.Transform:GetWorldPosition()
        for _, v in ipairs(items) do
            if not doer.components.inventory or not doer.components.inventory:GiveItem(v) then
                v.Transform:SetPosition(x, y, z)
                v.components.inventoryitem:OnDropped()
            end
        end
        -- inst.SoundEmitter:PlaySound("meta4/winona_catapult/collapse")
        inst:Remove()
    end
    return true
end

local function common(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    if data.minimap then
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("armouredboat.png")
        inst.MiniMapEntity:SetPriority(-1)
    end
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.entity:AddPhysics()

    inst:AddTag("shipwrecked_boat")
    inst:AddTag("ignorewalkableplatforms")

    inst:AddTag("boat")
    inst:AddTag("wood")

    inst.AnimState:SetBank(data.bank)
    inst.AnimState:SetBuild(data.build)
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(1)
    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst.entity:SetPristine()

    return inst
end

----------------------------------------------------------------------------------------------------

local function OnDeath(inst)
    if inst.components.container then
        inst.components.container:DropEverything()
    end
    if inst.debris then --生成残骸
        SpawnAt(inst.debris, inst)
    end

    ReplacePrefab(inst, "collapse_small")
    inst:Remove()
end

local function onhammered(inst, worker)
    if worker and worker.SoundEmitter then
        worker.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    end
    OnDeath(inst)
end

---fn
---@param data table health:血量；dismantlePrefab:收回后的预制体；container：容器；
local function common_fn(data)
    local inst = common(data)

    local max_health = data.health or TUNING.BOAT.HEALTH
    inst:AddComponent("healthsyncer")
    inst.components.healthsyncer.max_health = max_health

    inst.runspeed = data.runspeed --移动速度

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(max_health)
    inst.components.health.nofadeout = true

    if data.loots then
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(data.loots)
    end

    if data.dismantlePrefab then --表示可收回
        inst.dismantlePrefab = data.dismantlePrefab
        inst:AddComponent("pro_portablestructure")
        inst.components.pro_portablestructure:SetOnDismantleFn(OnDismantle)
    end

    if data.container then
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(data.container)
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.nobounce = true --脱下的时候不希望有自由落体的过程

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.SWBOAT

    inst:AddComponent("shipwreckedboat")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst.sounds = sounds
    inst.debris = data.debris

    inst:ListenForEvent("death", OnDeath)

    return inst
end


local BOATS = {}

-- local function MakeBoat(name, minimap, bank, build, loots, data, prefabs, init)
local function MakeBoat(name, data, init)
    data = data or {}

    local function fn()
        local inst = common_fn(data)
        if init then
            init(inst)
        end
        return inst
    end

    local function fake_fn()
        local inst = common(data)
        if init then
            init(inst)
        end

        inst:SetPrefabNameOverride(name)

        inst:AddTag("pro_fakeboat")              --玩家不能上这个船

        if data.container then                   --没有container就没有container_proxy，这里主要是兼容insight，那个mod会报错
            inst:AddComponent("container_proxy") --用来给船体复制体使用的
            inst.components.container_proxy:SetCanBeOpened(false)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst.sounds = sounds
        inst.persists = false --有AddChild，不加也不会保存

        return inst
    end

    table.insert(BOATS, Prefab(name, fn, assets, data.prefabs))
    table.insert(BOATS, Prefab(name .. "_fake", fake_fn, assets, data.prefabs))
end

----------------------------------------------------------------------------------------------------

MakeBoat("lograft_old", {
    minimap = "lograft.png",
    bank = "raft",
    build = "raft_log_build",
    loots = {
        "log", "log", "log", "cutgrass", "cutgrass"
    },
    health = 150,
    debris = "flotsam_bamboo_build",
    runspeed = 4,
    prefabs = {
        "log", "cutgrass"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("raft_old", {
    minimap = "raft.png",
    bank = "raft",
    build = "raft_build",
    loots = {
        "vine", "bamboo", "bamboo"
    },
    health = 150,
    debris = "flotsam_bamboo_build",
    runspeed = 5,
    prefabs = {
        "vine", "bamboo"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("rowboat", {
    minimap = "rowboat.png",
    bank = "rowboat",
    build = "rowboat_build",
    loots = {
        "boards", "vine", "vine"
    },
    health = 250,
    container = "rowboat",
    debris = "flotsam_rowboat_build",
    runspeed = 6,
    prefabs = {
        "boards", "vine"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("cargoboat", {
    minimap = "cargo.png",
    bank = "rowboat",
    build = "rowboat_cargo_build",
    loots = {
        "boards", "boards", "boards", "rope"
    },
    health = 300,
    container = "cargoboat",
    debris = "flotsam_cargo_build",
    runspeed = 5,
    prefabs = {
        "boards", "rope"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("armouredboat", {
    minimap = "armouredboat.png",
    bank = "rowboat",
    build = "rowboat_armored_build",
    loots = {
        "boards", "boards", "boards", "rope", "seashell", "seashell", "seashell", "seashell", "seashell",
    },
    health = 500,
    container = "armouredboat",
    debris = "flotsam_armoured_build",
    runspeed = 6,
    prefabs = {
        "boards", "rope", "seashell"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("encrustedboat", {
    minimap = "encrustedboat.png",
    bank = "rowboat",
    build = "rowboat_encrusted_build",
    loots = {
        "limestone", "limestone", "boards", "boards", "boards"
    },
    health = 800,
    container = "encrustedboat",
    debris = "flotsam_armoured_build",
    runspeed = 4,
    prefabs = {
        "limestone", "boards"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("corkboat", {
    minimap = "corkboat.png",
    bank = "rowboat",
    build = "coracle_boat_build",
    loots = {
        "cork"
    },
    health = 80,
    dismantlePrefab = "corkboatitem",
    container = "corkboat",
    debris = "flotsam_corkboat_build",
    runspeed = 4,
    prefabs = {
        "cork"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("surfboard", {
    minimap = "surfboard.png",
    bank = "raft",
    build = "raft_surfboard_build",
    loots = {
        "seashell"
    },
    health = 100,
    dismantlePrefab = "porto_surfboard",
    debris = "flotsam_surfboard_build",
    runspeed = 6,
    prefabs = {
        "seashell"
    },
}, function(inst)
    inst:AddTag("surf") --冲浪板
end)

----------------------------------------------------------------------------------------------------

MakeBoat("woodlegsboat", {
    minimap = "woodlegsboat.png",
    bank = "rowboat",
    build = "pirate_boat_build",
    loots = {
        "boards", "boards", "dubloon", "dubloon"
    },
    health = 500,
    dismantlePrefab = "porto_woodlegsboat",
    container = "woodlegsboat",
    debris = "flotsam_armoured_build",
    runspeed = 6,
    prefabs = {
        "boards", "dubloon"
    },
})

----------------------------------------------------------------------------------------------------

MakeBoat("shadowwaxwellboat", {
    minimap = "shadowboat.png",
    bank = "rowboat",
    build = "waxwell_shadowboat_build",
    loots = {
        "papyrus", "nightmarefuel", "nightmarefuel"
    },
    health = 150,
    container = "shadowwaxwellboat",
    runspeed = 6,
    prefabs = {
        "papyrus", "nightmarefuel"
    },
}, function(inst)
    inst.AnimState:SetMultColour(0, 0, 0, .4)
end)

----------------------------------------------------------------------------------------------------

MakeBoat("woodlegsboatamigo", {
    minimap = "woodlegsboat.png",
    bank = "rowboat",
    build = "pirate_boat_build",
    loots = {
        "log"
    },
    health = 150,
    container = "woodlegsboatamigo",
    debris = "flotsam_armoured_build",
    prefabs = {
        "log"
    },
}, function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.health then
        inst.components.health:SetInvincible(true)
    end
end)


return unpack(BOATS)
