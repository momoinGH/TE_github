local assets = {
    Asset("ANIM", "anim/ant_chest.zip"),
    Asset("ANIM", "anim/ant_chest_honey_build.zip"),
    Asset("ANIM", "anim/ant_chest_nectar_build.zip"),
    Asset("ANIM", "anim/ant_chest_pollen_build.zip"),
    Asset("ANIM", "anim/ant_chest_royal_build.zip"),
    Asset("ANIM", "anim/honey_chest.zip"),
    Asset("ANIM", "anim/honey_chest_honey_build.zip"),
    Asset("ANIM", "anim/honey_chest_nectar_build.zip"),
    Asset("ANIM", "anim/honey_chest_pollen_build.zip"),
    Asset("ANIM", "anim/honey_chest_royal_build.zip"),
}

local loot = { "chitin", "chitin", "chitin", "beeswax", "honey", "honey", "rocks" -- "flint",
}

local function UpdateNameFn(inst)
    if inst.components.upgradeable.upgradetype == nil then
        return subfmt(STRINGS.NAMES.UPDATEDCHEST, { container = STRINGS.NAMES[inst.prefab:upper()] })
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PushAnimation("open", false)
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/honey_chest/open")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close", true)
        inst.AnimState:PushAnimation("closed", true)
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/honey_chest/close")
    end
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container then
        inst.components.container:DropEverything()
    end
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", true)
        inst.SoundEmitter:PlaySound("waterlogged1/common/use_figjam")
        if inst.components.container then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/place")
end

local function converttocollapsed(inst, droploot, burnt)
    local x, y, z = inst.Transform:GetWorldPosition()
    if droploot then
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(x, y, z)
        fx:SetMaterial("wood")
        inst.components.lootdropper.min_speed = 2.25
        inst.components.lootdropper.max_speed = 2.75
        inst.components.lootdropper:DropLoot()
        inst.components.lootdropper.min_speed = nil
        inst.components.lootdropper.max_speed = nil
    end

    inst.components.container:Close()
    inst.components.workable:SetWorkLeft(2)

    local pile = SpawnPrefab("collapsed_honeychest")
    pile.Transform:SetPosition(x, y, z)
    pile:SetChest(inst, burnt)
end

local function Upgrade_onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.container then
            inst.components.container:DropEverything(nil, true)
            inst.components.container:Close()
        end
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
    end
end

local function shouldcollapse(inst)
    if inst.components.container and inst.components.container.infinitestacksize then
        --NOTE: should already have called DropEverything(nil, true) (worked or burnt or deconstructed)
        --      so everything remaining counts as an "overstack"
        local overstacks = 0
        for k, v in pairs(inst.components.container.slots) do
            local stackable = v.components.stackable
            if stackable then
                overstacks = overstacks +
                    math.ceil(stackable:StackSize() / (stackable.originalmaxsize or stackable.maxsize))
                if overstacks >= TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD then
                    return true
                end
            end
        end
    end
    return false
end

local function Upgrade_onhammered(inst, worker)
    if shouldcollapse(inst) then
        if TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
            inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_MAX_EXCESS_STACKS_DROPS)
            if not inst.components.container:IsEmpty() then
                converttocollapsed(inst, true, false)
                return
            end
        else
            --sunk, drops more, but will lose the remainder
            inst.components.lootdropper:DropLoot()
            inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD)
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx:SetMaterial("wood")
            inst:Remove()
            return
        end
    end
    onhammered(inst, worker)
end

local function Upgrade_onrestoredfromcollapsed(inst)
    -- inst.AnimState:PlayAnimation("rebuild")
    inst.AnimState:PushAnimation("closed", false)
    -- if inst.skin_place_sound then
    -- 	inst.SoundEmitter:PlaySound(inst.skin_place_sound)
    -- else
    -- 	inst.SoundEmitter:PlaySound(inst.sounds.built)
    -- end
end

local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
    if numupgrades == 1 then
        if inst.components.container ~= nil then
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
        end
        -- if upgraded_from_item then
        -- end
    end
    inst.components.upgradeable.upgradetype = nil
    inst.displaynamefn = UpdateNameFn
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({ "alterguardianhatshard" })
    end
    inst.components.workable:SetOnWorkCallback(Upgrade_onhit)
    inst.components.workable:SetOnFinishCallback(Upgrade_onhammered)
    inst:ListenForEvent("restoredfromcollapsed", Upgrade_onrestoredfromcollapsed)
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
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        OnUpgrade(inst)
    end
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
    local prefix = inst.prefab:sub(1, -6) .. "_" .. inst.prefab:sub(-5)
    -- local prefix = inst.prefab == "antchest" and "ant_chest" or "honey_chest"
    local buildIdx = 0
    local itemPrefab = { "nectar_pod", "pollen_item", "honey", "royal_jelly", "medal_withered_royaljelly" } -- Priority: Low -> High
    local buildName = { "nectar", "pollen", "honey", "royal", "royal" }
    for _, item in pairs(container.slots) do
        for idx, prf in ipairs(itemPrefab) do
            if item.prefab == prf then
                buildIdx = buildIdx > idx and buildIdx or idx
                break
            end
        end
    end
    inst.AnimState:SetBuild(prefix .. (buildIdx > 0 and "_" .. buildName[buildIdx] .. "_build" or "")) -- "ant_chest_honey_build" etc.
    -- inst.MiniMapEntity:SetIcon(prefix .. (buildIdx > 0 and "_" .. buildName[buildIdx] or "") .. ".png") -- "antchest_honey.png" etc.
end

local function Common(icon, bank, build, widget)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon(icon)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("closed", true)

    inst:AddTag("structure")
    inst:AddTag("chest")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup(widget)
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    MakeSnowCovered(inst, .01)

    MakeSmallPropagator(inst)

    inst:DoTaskInTime(0, LoadHoneyFirstTime)

    inst:ListenForEvent("itemget", RefreshAntChestBuild)
    inst:ListenForEvent("itemlose", RefreshAntChestBuild)
    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function fn()
    return Common("ant_chest.png", "ant_chest", "ant_chest", "antchest")
end

local function fn1()
    local inst = Common("honey_chest.png", "honey_chest", "honey_chest", "honeychest")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
    inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)

    return inst
end

return Prefab("common/antchest", fn, assets),
    Prefab("common/honeychest", fn1, assets),
    MakePlacer("common/honeychest_placer", "honey_chest", "honey_chest", "closed")
