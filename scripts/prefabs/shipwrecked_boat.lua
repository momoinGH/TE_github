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

local function common(minimap, bank, build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    if minimap then
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

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
    inst.AnimState:SetFinalOffset(1)
    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst.entity:SetPristine()

    return inst
end

---fn
---@param minimap string|nil
---@param bank string
---@param build string
---@param loots table
---@param data table health:血量；dismantlePrefab:收回后的预制体；container：容器；
local function common_fn(minimap, bank, build, loots, data)
    local inst = common(minimap, bank, build)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(data.health or TUNING.BOAT.HEALTH)
    inst.components.health.nofadeout = true

    if loots then
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loots)
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

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.SWBOAT

    inst:AddComponent("shipwreckedboat")

    inst.sounds = sounds

    return inst
end


local BOATS = {}

local function MakeBoat(name, minimap, bank, build, loots, data, prefabs, init)
    data = data or {}

    local function fn()
        local inst = common_fn(minimap, bank, build, loots, data)
        if init then
            init(inst)
        end
        return inst
    end

    local function fake_fn()
        local inst = common(minimap, bank, build)

        inst:SetPrefabNameOverride(name)

        inst:AddTag("pro_fakeboat")          --玩家不能上这个船

        inst:AddComponent("container_proxy") --用来给船体复制体使用的
        inst.components.container_proxy:SetCanBeOpened(false)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst.sounds = sounds
        inst.persists = false --有AddChild，不加也不会保存

        return inst
    end

    table.insert(BOATS, Prefab(name, fn, assets, prefabs))
    table.insert(BOATS, Prefab(name .. "_fake", fake_fn, assets, prefabs))
end

----------------------------------------------------------------------------------------------------

local armouredboat_loots = {
    "boards", "boards", "boards", "rope", "seashell", "seashell", "seashell", "seashell", "seashell",
}
local armouredboat_prefabs = {
    "boards", "rope", "seashell"
}
MakeBoat("armouredboat", "armouredboat.png", "rowboat", "rowboat_armored_build", armouredboat_loots,
    { health = 150, dismantlePrefab = "porto_armouredboat", container = "armouredboat" }, armouredboat_prefabs)


local corkboat_loots = {
    "cork"
}
local corkboat_prefabs = {
    "cork"
}
MakeBoat("corkboat", "coracle_boat.png", "rowboat", "coracle_boat_build", corkboat_loots,
    { health = 80, dismantlePrefab = "corkboatitem", container = "corkboat" }, corkboat_prefabs)


local cargoboat_loots = {
    "boards", "boards", "boards", "rope"
}
local cargoboat_prefabs = {
    "boards", "rope"
}

MakeBoat("cargoboat", "cargo.png", "rowboat", "rowboat_cargo_build", cargoboat_loots,
    { health = 300, dismantlePrefab = "porto_cargoboat", container = "cargoboat" }, cargoboat_prefabs)


local encrustedboat_loots = {
    "limestone", "limestone", "boards", "boards", "boards"
}
local encrustedboat_prefabs = {
    "limestone", "boards"
}

MakeBoat("encrustedboat", "encrustedboat.png", "rowboat", "rowboat_encrusted_build", encrustedboat_loots,
    { health = 800, dismantlePrefab = "porto_encrustedboat", container = "encrustedboat" }, encrustedboat_prefabs)

local rowboat_loots = {
    "boards", "vine", "vine"
}
local rowboat_prefabs = {
    "boards", "vine",
}

MakeBoat("rowboat", "rowboat.png", "rowboat", "rowboat_build", rowboat_loots,
    { health = 250, dismantlePrefab = "porto_rowboat", container = "rowboat" }, rowboat_prefabs)

local surfboard_loots = {
    "seashell"
}
local surfboard_prefabs = {
    "seashell"
}

MakeBoat("surfboard", "surfboard.png", "raft", "raft_surfboard_build", surfboard_loots,
    { health = 100, dismantlePrefab = "porto_surfboard" }, surfboard_prefabs, function(inst)
        inst:AddTag("surf") --冲浪板
    end)


local woodlegsboat_loots = {
    "boards", "boards", "dubloon", "dubloon"
}
local woodlegsboat_prefabs = {
    "boards", "dubloon"
}

MakeBoat("woodlegsboat", "woodlegsboat.png", "rowboat", "pirate_boat_build", woodlegsboat_loots,
    { health = 500, dismantlePrefab = "porto_woodlegsboat", container = "woodlegsboat" }, woodlegsboat_prefabs)


local shadowwaxwellboat_loots = {
    "papyrus", "nightmarefuel", "nightmarefuel"
}
local shadowwaxwellboat_prefabs = {
    "papyrus", "nightmarefuel"
}

MakeBoat("shadowwaxwellboat", "shadowboat.png", "rowboat", "waxwell_shadowboat_build", shadowwaxwellboat_loots,
    { health = 150, dismantlePrefab = "porto_shadowboat", container = "shadowwaxwellboat" }, shadowwaxwellboat_prefabs, function(inst)
        inst.AnimState:SetMultColour(0, 0, 0, .4)
    end)


local raft_old_loots = {
    "vine", "bamboo", "bamboo"
}
local raft_old_prefabs = {
    "vine", "bamboo"
}

MakeBoat("raft_old", "raft.png", "raft", "raft_build", raft_old_loots, { health = 150 }, raft_old_prefabs)

local lograft_old_loots = {
    "log", "log", "log", "cutgrass", "cutgrass"
}

local lograft_old_prefabs = {
    "log", "cutgrass"
}

MakeBoat("lograft_old", "lograft.png", "raft", "raft_log_build", lograft_old_loots, { health = 150 }, lograft_old_prefabs)

local woodlegsboatamigo_loots = {
    "log"
}

local woodlegsboatamigo_prefabs = {
    "log"
}

MakeBoat("woodlegsboatamigo", "woodlegsboat.png", "rowboat", "pirate_boat_build", woodlegsboatamigo_loots,
    { health = 150, container = "woodlegsboatamigo" }, woodlegsboatamigo_prefabs, function(inst)
        if not TheWorld.ismastersim then return end
        inst.components.health:SetInvincible(true)
    end)


return unpack(BOATS)
