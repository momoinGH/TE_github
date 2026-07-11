local sounds =
{
    close = "dontstarve/common/trap_close",
    rustle = "dontstarve/common/trap_rustle",
}

local function onharvested(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function on_float(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function on_not_float(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function on_usedup(inst)
    -- NOTES(JBK): There is a case where traps can reach here while in a container and cause issues later. This is a temporary fix until the source of that is found.
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:RemoveFromOwner()
    end
    inst:Remove()
end

return {
    master_postinit = function(inst)
        inst.AnimState:OverrideSymbol("shell", "quagmire_pebble_crab", "shell")

        inst.sounds = sounds

        inst:AddComponent("inventoryitem")
        inst:AddComponent("inspectable")

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.TRAP_USES)
        inst.components.finiteuses:SetUses(TUNING.TRAP_USES)
        inst.components.finiteuses:SetOnFinished(on_usedup)

        inst:AddComponent("trap")
        -- inst.components.trap.targettag = "crab"
        inst.components.trap.targettag = "canbetrapped"
        inst.components.trap:SetOnHarvestFn(onharvested)
        inst.components.trap.baitsortorder = 1

        inst:ListenForEvent("floater_startfloating", on_float)
        inst:ListenForEvent("floater_stopfloating", on_not_float)

        MakeHauntableLaunch(inst)

        inst:SetStateGraph("SGtrap")
    end
}
