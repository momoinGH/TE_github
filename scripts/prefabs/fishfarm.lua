local assets =
{
    Asset("ANIM", "anim/fish_farm.zip"),
    Asset("MINIMAP_IMAGE", "fish_farm"),
}

local prefabs =
{
    "fish_farm_sign"
}

local loots =
{
    "silk",
    "rope",
    "coconut",
    "coconut",
}

local FISHS = { --其实这几个鱼概率不一样
    "fish2",    --蓝色
    "fish3",    --紫色
    "fish3",    --紫色
    "fish5",    --清色
}

local function lootsetfn(self)
    local l = shallowcopy(loots)
    for i = 1, self.produce do
        table.insert(l, self.product)
    end
    self:SetLoot(l)
end

local function onRemove(inst)
    if inst.sign_prefab then
        inst.sign_prefab:Remove()
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function resetArt(inst)
    inst.AnimState:Hide("sign")
    inst.AnimState:Hide("fish_1")
    inst.AnimState:Hide("fish_2")
    inst.AnimState:Hide("fish_3")
    inst.AnimState:Hide("fish_4")
    inst.AnimState:Hide("fish_5")
    inst.AnimState:Hide("fish_6")
    inst.AnimState:Hide("fish_7")
    inst.AnimState:Hide("fish_8")
    inst.AnimState:Hide("fish_9")
end

local function refreshArt(inst)
    resetArt(inst)
    local produce = inst.components.harvestable.produce
    for i = 1, produce do
        inst.AnimState:Show("fish_" .. i * 2 - 1)
        inst.AnimState:Show("fish_" .. i * 2)
    end
    if produce == 4 then
        inst.AnimState:Show("fish_" .. 9)
    end
end

local function AbleToAcceptTest(inst, item)
    return item.prefab == "roe"
end

local function AcceptTest(inst, item)
    return not inst.components.harvestable.task
end

local function SpawnFishSign(inst)
    local sign = SpawnPrefab("fish_farm_sign")
    sign.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sign.parent = inst
    sign:resetArt()
    inst.sign_prefab = sign
end

local function OnGetItemFromPlayer(inst, giver, item)
    inst.fish = FISHS[math.random(#FISHS)]
    inst.components.harvestable:Grow()
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/pickobject_water")

    SpawnFishSign(inst)
end

local function getstatus(inst)
    local produce = inst.components.harvestable.produce
    if produce > 0 then
        if produce == 1 then
            return "ONEFISH"
        elseif produce == 2 then
            return "TWOFISH"
        elseif produce == 3 then
            return "REDFISH"
        elseif produce == 4 then
            return "BLUEFISH"
        end
    else
        if inst.components.harvestable.task then
            return "STOCKED"
        else
            return "EMPTY"
        end
    end
end

local function onharvest(inst, picker, produce)
    local item = SpawnPrefab(inst.fish)
    if not picker or not picker.components.inventory or not picker.components.inventory:GiveItem(item) then
        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
        item.components.inventoryitem:OnDropped()
    end

    if produce <= 1 then
        -- 你把独苗收走了
        inst.components.harvestable:SetGrowTime(nil)
        inst.fish = nil
        inst.harvested = false
        refreshArt(inst)
        if inst.sign_prefab then
            inst.sign_prefab:Remove()
            inst.sign_prefab = nil
        end
    else
        inst.components.harvestable.produce = produce - 1
        inst.harvested = true
        if inst.sign_prefab then
            inst.sign_prefab:resetArt()
        end
    end
end

local function ongrow(inst, produce)
    refreshArt(inst)
    inst.components.harvestable:SetGrowTime((math.random() * (0.75 - 0.5) + 0.5) * TUNING.TOTAL_DAY_TIME)
end

local function domagicgrowth(inst, doer)
    if inst.components.harvestable:Grow() then
        inst.components.harvestable:Disable()
        inst.components.trader:Disable()

        inst:DoTaskInTime(0.5, domagicgrowth)
    else
        inst.components.harvestable:Enable()
    end
end

local function OnSave(inst, data)
    data.fish = inst.fish
    data.harvested = inst.harvested
end

local function OnLoad(inst, data)
    if not data then return end

    inst.harvested = data.harvested or inst.harvested

    if data.fish then
        inst.fish = data.fish
        SpawnFishSign(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("structure")
    inst:AddTag("fishfarm")
    inst:AddTag("ignorewalkableplatforms")

    inst.AnimState:SetBank("fish_farm")
    inst.AnimState:SetBuild("fish_farm")
    inst.AnimState:PlayAnimation("idle", true)
    --anim:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:Hide("mouseover")

    inst.MiniMapEntity:SetIcon("fish_farm.png")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.fish = nil        --鱼的种类
    inst.harvested = false --是否收取过，收取过牌子才会显示颜色

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "FISH_FARM"
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("harvestable")
    inst.components.harvestable:SetProduct(nil, 4)
    inst.components.harvestable:SetOnGrowFn(ongrow)
    inst.components.harvestable:SetOnHarvestFn(onharvest)
    inst.components.harvestable:SetDoMagicGrowthFn(domagicgrowth)
    inst.components.harvestable:SetGrowTime((math.random() * (0.75 - 0.5) + 0.5) * TUNING.TOTAL_DAY_TIME)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLootSetupFn(lootsetfn)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst.volume = 0
    inst.usedFishStates = {}
    inst.unusedFishStates = { 1, 2, 3, 4, 5, 6, 7, 8 }

    inst.OnRemoveEntity = onRemove

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    resetArt(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("fish_farm", fn, assets, prefabs),
    MakePlacer("fish_farm_placer", "fish_farm", "fish_farm", "idle")
