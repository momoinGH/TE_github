local function CloseContainer(inst)
    inst.components.container:Close()
    inst.AnimState:Show("Lid")
end

local function OnOpen(inst, data)
    inst.AnimState:Hide("Lid")

    if not data or not data.slot then
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.components.inventoryitem:GetContainer() then
        inst.components.container:Open(inst.components.inventoryitem.owner)
        inst.components.inventoryitem:RemoveFromOwner()
        inst.components.inventoryitem:DoDropPhysics(x, y, z, true, .5)
    end
end

local function OnClose(inst)
    inst.AnimState:Show("Lid")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function OnItemLose(inst)
    if inst:HasTag("soiled") then
        inst:RemoveTag("soiled")
        inst.AnimState:Hide("goop")
        inst.components.inventoryitem:ChangeImageName(inst.prefab)
    end
end

return {
    master_postinit = function(inst, suffix, numslots)
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetOnPickupFn(CloseContainer)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("quagmire_pot" .. suffix)
        inst.components.container.onopenfn = OnOpen
        inst.components.container.onclosefn = OnClose

        -- inst:AddComponent("specialstewer_dish")
        -- inst.components.specialstewer_dish:SetDishType("quagmire_pot")

        inst:AddComponent("quagmire_stewer")
        inst.components.quagmire_stewer.stationname = "pot"

        inst:ListenForEvent("itemget", OnOpen)
        inst:ListenForEvent("itemlose", OnItemLose)
    end,
}
