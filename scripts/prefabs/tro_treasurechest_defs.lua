local function onopen(inst)
    if inst:HasTag("burnt") then
        return
    end
    inst.AnimState:PlayAnimation("open")

    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsOceanAtPoint(x, y, z) then
        inst.AnimState:PushAnimation("opened", true)
    end

    inst.SoundEmitter:PlaySound(inst.opensound)
end

local function onclose(inst)
    if inst:HasTag("burnt") then
        return
    end

    inst.AnimState:PlayAnimation("close")

    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsOceanAtPoint(x, y, z) then
        inst.AnimState:PushAnimation("closed", true)
    end

    inst.SoundEmitter:PlaySound(inst.closesound)
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end
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
        if inst.components.container then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/craftable/chest")
end

---@class chest_data data数据
---@field assets table|nil
---@field bank string|nil
---@field build string|nil
---@field minimap string|nil
---@field opensound string|nil
---@field closesound string|nil
---@field prefabs table|nil
---@field burnable boolean|nil
---@field workable boolean|nil


---制作箱子预制件
---@param data chest_data
local function MakeChest(name, data, common_post_fn, master_post_fn)
    local build = data.build or name

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        if data.minimap then
            inst.entity:AddMiniMapEntity()
            inst.MiniMapEntity:SetIcon(data.minimap)
        end

        inst.AnimState:SetBank(data.bank or name)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("closed", true)

        inst:AddTag("structure")
        inst:AddTag("chest")

        MakeSnowCoveredPristine(inst)

        if common_post_fn then
            common_post_fn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.opensound = data.opensound or "dontstarve/wilson/chest_open"
        inst.closesound = data.closesound or "dontstarve/wilson/chest_close"

        inst:AddComponent("inspectable")

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("treasurechest")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose

        if data.workable then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)
        end

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)
        if data.burnable then
            MakeSmallBurnable(inst, nil, nil, true)
            MakeSmallPropagator(inst)
        end

        if master_post_fn then
            master_post_fn(inst)
        end

        return inst
    end

    local assets = data.assets or {
        Asset("ANIM", "anim/" .. build .. ".zip"),
    }

    return Prefab(name, fn, assets, data.prefabs)
end

return MakeChest
