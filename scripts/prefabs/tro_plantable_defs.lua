---dug_预制件制作
---@param data.bank string
---@param data.build string
---@param data.floater table 漂浮偏移
---@param data.inspectoverride string 检查名
---@param data.mediumspacing boolean 更大的种植间距
local function make_plantable(name, data, common_post, master_post)
    data = data or {}
    local build = data.build or name
    local assets =
    {
        Asset("ANIM", "anim/" .. build .. ".zip"),
    }

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab(name, inst.linked_skinname, inst.skin_id)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            if tree.components.pickable ~= nil then
                tree.components.pickable:OnTransplant()
            end
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                --V2C: WHY?!! because many of the plantables don't
                --     have SoundEmitter, and we don't want to add
                --     one just for this sound!
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end

            if TheWorld.components.lunarthrall_plantspawner and tree:HasTag("lunarplant_target") then
                TheWorld.components.lunarthrall_plantspawner:setHerdsOnPlantable(tree)
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant")

        inst.AnimState:SetBank(data.bank or name)
        inst.AnimState:SetBuild(data.build or name)
        inst.AnimState:PlayAnimation("dropped")
        inst.scrapbook_anim = "dropped"

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        if common_post then
            common_post(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = data.inspectoverride or ("dug_" .. name)
        inst:AddComponent("inventoryitem")

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end

        -- 可以用月亮喷雾变成别的
        -- if data.halloweenmoonmutable_settings ~= nil then
        --     inst:AddComponent("halloweenmoonmutable")
        --     inst.components.halloweenmoonmutable:SetPrefabMutated(data.halloweenmoonmutable_settings.prefab)
        -- end

        if master_post then
            master_post(inst)
        end

        return inst
    end

    return Prefab("dug_" .. name, fn, assets)
end

return make_plantable
