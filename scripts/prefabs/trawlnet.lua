local net_assets =
{
    Asset("ANIM", "anim/swap_trawlnet.zip"),
    Asset("ANIM", "anim/swap_trawlnet_half.zip"),
    Asset("ANIM", "anim/swap_trawlnet_full.zip"),
}


local net_prefabs =
{
    "trawlnetdropped"
}

local dropped_assets =
{
    Asset("ANIM", "anim/swap_trawlnet.zip"),
    Asset("ANIM", "anim/ui_chest_3x2.zip"),
}


local TRAWL_SINK_TIME = 30 * 3

local loot_defs = require("prefabs/trawlnet_loot_defs")

local loot = loot_defs.LOOT
local hurricaneloot = loot_defs.HURRICANE_LOOT
local dryloot = loot_defs.DRY_LOOT
local uniqueItems = loot_defs.UNIQUE_ITEMS
local specialCasePrefab = loot_defs.SPECIAL_CASE_PREFABS

local function gettrawlbuild(inst)
    local fullness = inst.components.inventory:NumItems() / inst.components.inventory.maxslots
    if fullness <= 0.33 then
        inst.build = "swap_trawlnet"
    elseif fullness <= 0.66 then
        inst.build = "swap_trawlnet_half"
    else
        inst.build = "swap_trawlnet_full"
    end
    return inst.build
end

local function ontrawlpickup(inst)
    local owner = inst.components.inventoryitem.owner
    if owner then
        owner.AnimState:OverrideSymbol("swap_trawlnet", gettrawlbuild(inst), "swap_trawlnet")
        -- driver:PushEvent("trawlitem") --TODO 勾引海妖和海狗
    end
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/trawl_net/collect")
end

local function updatespeedmult(inst)
    local fullpenalty = TUNING.TRAWLING_SPEED_MULT
    local penalty = fullpenalty * (inst.components.inventory:NumItems() / TUNING.TRAWLNET_MAX_ITEMS)
    inst.components.shipwreckedboatparts:SetSpeedMult(1 - penalty)
end

--- 捕获一个物品
local function pickupitem(inst, pickup)
    inst.components.inventory:GiveItem(pickup)
    ontrawlpickup(inst)

    if inst.components.inventory:IsFull() then
        local owner = inst.components.inventoryitem.owner
        if owner then
            owner.components.container:DropItem(inst)
        end
    else
        updatespeedmult(inst)
    end
end

local function stoptrawling(inst)
    inst.trawling = false
    if inst.trawltask then
        inst.trawltask:Cancel()
        inst.trawltask = nil
    end
end

local function getLootList(inst)
    local loottable = TheWorld.state.issummer and hurricaneloot
        or TheWorld.state.iswinter and dryloot
        or loot

    local tile = TheWorld.Map:GetTileAtPoint(inst.Transform:GetWorldPosition())
    if tile == GROUND.OCEAN_MEDIUM then
        return loottable.medium
    elseif tile == GROUND.OCEAN_DEEP then
        return loottable.deep
    else
        return loottable.shallow
    end
end

local function isItemUnique(item)
    for i = 1, #uniqueItems do
        if uniqueItems[i] == item then
            return true
        end
    end
    return false
end

local function hasUniqueItem(inst)
    return inst.components.inventory:FindItem(function(ent)
        return table.contains(uniqueItems, ent)
    end) ~= nil
end

local function selectLoot(inst)
    local total = 0
    local lootList = getLootList(inst)

    for i = 1, #lootList do
        total = total + lootList[i][2]
    end

    local choice = math.random(0, total)
    total = 0
    for i = 1, #lootList do
        total = total + lootList[i][2]
        if choice <= total then
            local loot = lootList[i][1]

            --Check if the player has already found one of these
            if isItemUnique(loot) and hasUniqueItem(inst) then
                --If so, pick a different item to give
                loot = selectLoot(inst)
                --NOTE - Possible infinite loop here if only possible loot is unique items.
            end

            return loot
        end
    end
end

local function isBehind(inst, tar)
    local pt = inst:GetPosition()
    local hp = tar:GetPosition()

    local heading_angle = -(inst.Transform:GetRotation())
    local dir = Vector3(math.cos(heading_angle * DEGREES), 0, math.sin(heading_angle * DEGREES))

    local offset = (hp - pt):GetNormalized()
    local dot = offset:Dot(dir)

    local dist = pt:Dist(hp)

    return dot <= 0 and dist >= 1
end

local function updateTrawling(inst)
    if not inst.trawling then
        return
    end

    local boat = inst.components.shipwreckedboatparts:GetBoat()
    local driver = boat.components.shipwreckedboat:GetDriver()

    if not driver then --拖网没有玩家，出问题啦！
        stoptrawling(inst)
        return
    end

    local pickup = nil
    local pos = inst:GetPosition()
    local displacement = pos - inst.lastPos
    inst.distanceCounter = inst.distanceCounter + displacement:Length()

    if inst.distanceCounter > TUNING.TRAWLNET_ITEM_DISTANCE then --生成一个
        pickup = SpawnPrefab(selectLoot(inst))
        inst.distanceCounter = 0
    end

    inst.lastPos = pos

    pickup = pickup or FindEntity(driver, 2, function(ent)
        return isBehind(driver, ent)
            and ((ent.components.inventoryitem
                    and not ent.components.inventoryitem:IsHeld()
                    and ent.components.inventoryitem.cangoincontainer)
                or specialCasePrefab[ent.prefab] ~= nil)
    end, nil, { "trap", "player" })


    if pickup and specialCasePrefab[pickup.prefab] then
        pickup = specialCasePrefab[pickup.prefab](pickup, inst)
    end

    if pickup then
        pickupitem(inst, pickup)
    end
end

local function starttrawling(inst)
    inst.trawling = true
    inst.lastPos = inst:GetPosition()
    inst.trawltask = inst:DoPeriodicTask(FRAMES * 5, updateTrawling)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/trawl_net/attach")
end

local function droploot(inst, boat)
    local chest = SpawnPrefab("trawlnetdropped")
    local pt = inst.lastPos
    chest:DoDetach()

    chest.Transform:SetPosition(pt.x, pt.y, pt.z)

    for k, v in pairs(inst.components.inventory.itemslots) do
        chest.components.container:GiveItem(v)
    end

    local driver = boat and boat.components.shipwreckedboat:GetDriver()
    if driver then
        local angle = driver.Transform:GetRotation()
        local dist = -3
        local offset = Vector3(dist * math.cos(angle * DEGREES), 0, -dist * math.sin(angle * DEGREES))
        local chestpos = pt + offset
        chest.Transform:SetPosition(chestpos:Get())
        chest:FacePoint(pt:Get())
    end
end

local function OnEquipped(inst, data)
    local owner = data.owner
    owner.AnimState:OverrideSymbol("swap_trawlnet", gettrawlbuild(inst), "swap_trawlnet")
    updatespeedmult(inst)
    starttrawling(inst)
end

local function OnUnEquipped(inst, data)
    local boat = data.owner
    boat.AnimState:ClearOverrideSymbol("swap_trawlnet")

    stoptrawling(inst)
    droploot(inst, boat)
    inst:DoTaskInTime(2 * FRAMES, inst.Remove)
end

local function OnPlayerMounted(inst, boat, player)
    -- player.AnimState:OverrideSymbol("swap_trawlnet", gettrawlbuild(item), "swap_trawlnet") --玩家替换有什么用吗？
    starttrawling(inst)
    updatespeedmult(inst)
end

local function OnPlayerDismounted(inst, boat, player)
    player.AnimState:ClearOverrideSymbol("swap_trawlnet")
    stoptrawling(inst)
end

local function net()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("trawlnet")
    inst.AnimState:SetBuild("swap_trawlnet")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("trawlnet")
    inst:AddTag("aquatic")
    inst:AddTag("shipwrecked_boat_tail")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.lastPos = nil       --坐标记录
    inst.distanceCounter = 0 --移动距离计数器
    inst.trawltask = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = TUNING.TRAWLNET_MAX_ITEMS
    inst.components.inventory.show_invspace = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

    inst:AddComponent("shipwreckedboatparts")
    inst.components.shipwreckedboatparts.move_sound = "dontstarve_DLC002/common/trawl_net/move_LP"
    inst.components.shipwreckedboatparts.onplayermountedfn = OnPlayerMounted
    inst.components.shipwreckedboatparts.onplayerdismountedfn = OnPlayerDismounted

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    -- Used in trawlnet_loot_defs.lua
    inst.pickupitem = pickupitem

    updatespeedmult(inst)

    inst:ListenForEvent("boat_equipped", OnEquipped)
    inst:ListenForEvent("boat_unequipped", OnUnEquipped)

    return inst
end


local function sink(inst, instant)
    if not instant then
        inst.AnimState:PlayAnimation("sink_pst")
        inst:ListenForEvent("animover", function()
            inst.components.container:DropEverything()
            inst:Remove()
        end)
    else
        -- this is to catch the nets that for some reason dont have the right timer save data.
        inst.components.container:DropEverything()
        inst:Remove()
    end
end

local function getsinkstate(inst)
    if inst.components.timer:TimerExists("sink") then
        return "sink"
    elseif inst.components.timer:TimerExists("startsink") then
        return "full"
    end
    return "sink"
end

local function startsink(inst)
    inst.AnimState:PlayAnimation("full_to_sink")
    inst.components.timer:StartTimer("sink", TRAWL_SINK_TIME * 1 / 3)
    inst.AnimState:PushAnimation("idle_" .. getsinkstate(inst), true)
end


local function dodetach(inst)
    inst.components.timer:StartTimer("startsink", TRAWL_SINK_TIME * 2 / 3)
    inst.AnimState:PlayAnimation("detach")
    inst.AnimState:PushAnimation("idle_" .. getsinkstate(inst), true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/trawl_net/detach")
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("interact_" .. getsinkstate(inst)) --TODO: uncomment this when this anim exists
    inst.AnimState:PushAnimation("idle_" .. getsinkstate(inst), true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/trawl_net/open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("interact_" .. getsinkstate(inst)) --TODO: uncomment this when this anim exists
    inst.AnimState:PushAnimation("idle_" .. getsinkstate(inst), true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/trawl_net/close")
end

local function ontimerdone(inst, data)
    if data.name == "startsink" then
        startsink(inst)
    end

    if data.name == "sink" then
        sink(inst)
    end
    -- These are sticking around some times.. maybe the timer name is being lost somehow? This will catch that?
    if data.name ~= "sink" and data.name ~= "startsink" then
        sink(inst)
    end
end


local function getstatusfn(inst, viewer)
    local sinkstate = getsinkstate(inst)
    local timeleft = (inst.components.timer and inst.components.timer:GetTimeLeft("sink")) or TRAWL_SINK_TIME
    if sinkstate == "sink" then
        return "SOON"
    elseif sinkstate == "full" and timeleft <= (TRAWL_SINK_TIME * 0.66) * 0.5 then
        return "SOONISH"
    else
        return "GENERIC"
    end
end

local function onloadtimer(inst)
    if not inst.components.timer:TimerExists("sink") and not inst.components.timer:TimerExists("startsink") then
        print("TRAWL NET HAD NO TIMERS AND WAS FORCE SUNK")
        sink(inst, true)
    end
end

local function onload(inst, data)
    inst.AnimState:PlayAnimation("idle_" .. getsinkstate(inst), true)
end

local function dropped_net()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("trawlnet")
    inst.AnimState:SetBuild("swap_trawlnet")
    inst.AnimState:PlayAnimation("idle_full", true)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatusfn

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("trawlnetdropped")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("timer")

    inst.OnLoad = onload
    inst.DoDetach = dodetach

    -- this task is here because sometimes the savedata on the timer is empty.. so no timers are reloaded.
    -- when that happens, the nets sit around forever.
    inst:DoTaskInTime(0, onloadtimer)

    inst:ListenForEvent("timerdone", ontimerdone)

    return inst
end

return Prefab("trawlnet", net, net_assets, net_prefabs),
    Prefab("trawlnetdropped", dropped_net, dropped_assets)
