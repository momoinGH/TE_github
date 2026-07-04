local assets =
{
    Asset("ANIM", "anim/volcano_altar_fx.zip"), --祭坛
    Asset("ANIM", "anim/volcano_altar.zip"),    --石碑
    Asset("ANIM", "anim/altar_meter.zip"),      --指示牌
}


local prefabs = {

}

local function UpdateMeter(inst)
    local vm = TheWorld.components.volcanomanager
    if vm:IsFireRaining() then
        inst.components.volcanometer.targetseg = 0
    elseif TheWorld.state.issummer then
        inst.components.volcanometer.maxseg = vm:GetNumSegmentsOfEruption() or 67
        inst.components.volcanometer.targetseg = vm:GetNumSegmentsUntilEruption() or inst.components.volcanometer.maxseg
    else
        inst.components.volcanometer.maxseg = 10
        inst.components.volcanometer.targetseg = 10
    end
    inst.components.volcanometer:Start()
end

----------------------------------------------------------------------------------------------------

local function AcceptTest(inst, item, giver)
    return TheWorld.components.volcanomanager
        and inst.sg.currentstate.name == "opened"
        and item.components.appeasement
end

local function OnGetItemFromPlayer(inst, giver, item)
    local vm = TheWorld.components.volcanomanager
    if not vm then return end
    local appeasesegs = item.components.appeasement.appeasementvalue
    vm:Appease(appeasesegs)

    if inst.meterprefab then
        UpdateMeter(inst.meterprefab)
    end

    if appeasesegs > 0 then
        inst.sg:GoToState("appeased")
    else
        if giver and giver.components.health then
            giver.components.health:DoFireDamage(TUNING.VOLCANO_ALTAR_DAMAGE, inst, true)
        end
        inst.sg:GoToState("unappeased")
    end

    print(string.format("Volcano Altar takes your %d seg appeasement from %s\n", appeasesegs, tostring(item.prefab)))
end

-- 背后的石碑
local function CreateTower()
    local inst = CreateEntity()
    inst:AddTag("FX")
    if not TheWorld.ismastersim then
        inst.entity:SetCanSleep(false)
    end
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.Transform:SetScale(1, 1, 1)

    inst.AnimState:SetBank("volcano_altar")
    inst.AnimState:SetBuild("volcano_altar")
    inst.AnimState:PlayAnimation("idle_close")
    inst.AnimState:SetFinalOffset(0)
    return inst
end

----------------------------------------------------------------------------------------------------

local function CreateMeter(inst)
    local meter = SpawnPrefab("volcano_altar_meter")
    inst.meterprefab = meter
    meter.entity:SetParent(inst.entity)
    UpdateMeter(meter)
    meter.components.volcanometer.curseg = meter.components.volcanometer.targetseg
    meter.components.volcanometer:UpdateMeter()
end

local function SetIsOpen(inst)
    local vm = TheWorld.components.volcanomanager
    if vm
        and not inst:FullAppeased()
        and TheWorld.state.issummer
        and not vm:IsFireRaining()
    then
        if not inst.sg:HasStateTag("open") then
            inst.sg:GoToState("open")
        end
        inst.components.trader:Enable()
    else
        if not inst.sg:HasStateTag("close") then
            inst.sg:GoToState("close")
        end
        inst.components.trader:Disable()
    end
end

local function FullAppeased(inst)
    return inst.meterprefab and
        inst.meterprefab.components.volcanometer.targetseg >= inst.meterprefab.components.volcanometer.maxseg
end

local function base_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("volcano_altar.png")

    MakeObstaclePhysics(inst, 2.0, 1.2)

    inst.AnimState:SetBank("volcano_altar_fx")
    inst.AnimState:SetBuild("volcano_altar_fx")
    inst.AnimState:PlayAnimation("idle_close")
    inst.AnimState:SetFinalOffset(2)

    inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(197 / 255, 197 / 255, 50 / 255)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(2)

    inst:AddTag("altar")
    inst:AddTag("structure")
    inst:AddTag("stone")

    inst.entity:SetPristine()

    if not TheNet:IsDedicated() then
        inst.towerprefab = CreateTower()
        inst.towerprefab.entity:SetParent(inst.entity)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.FullAppeased = FullAppeased

    inst:AddComponent("inspectable")

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.acceptnontradable = true
    inst.components.trader:Disable()

    inst:SetStateGraph("SGvolcanoaltar")

    inst:DoPeriodicTask(1, SetIsOpen)
    inst:DoTaskInTime(0, CreateMeter)

    return inst
end

local function meter_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("volcano_altar")
    inst.AnimState:SetBuild("volcano_altar")
    inst.AnimState:PlayAnimation("meter")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetPercent("meter", 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("volcanometer")
    inst.components.volcanometer.targetseg = 66 --66 seems to the longest time between eruptions but this number really shouldn't be hardcoded.
    inst.components.volcanometer.curseg = 66
    inst.components.volcanometer.maxseg = 66
    inst.components.volcanometer.updatemeterfn = function(inst, perc)
        inst.AnimState:SetPercent("meter", perc)
    end
    inst.components.volcanometer.updatedonefn = function(inst)
        inst:PushEvent("MeterDone")
    end

    inst:DoPeriodicTask(1, UpdateMeter)

    inst.persists = false

    inst:WatchWorldState("season", function(inst, season)
        UpdateMeter(inst)
        if season == SEASONS.SUMMER then
            inst.components.volcanometer.curseg = inst.components.volcanometer.targetseg
        end
    end)

    return inst
end

return Prefab("volcano_altar", base_fn, assets, prefabs),    --祭坛
    Prefab("volcano_altar_meter", meter_fn, assets, prefabs) --上面的指示器
