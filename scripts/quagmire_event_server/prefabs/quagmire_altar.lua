local function OnSnackrifice(inst)
    inst.AnimState:PlayAnimation("teleport")
    inst.AnimState:PushAnimation("idle_empty")
end

-- inst.entity:AddMiniMapEntity()
-- inst.MiniMapEntity:SetIcon("quagmire_altar.png")
return {
    master_postinit = function(inst)
        inst:AddComponent("inspectable")
        inst:AddComponent("quagmire_altar")
        inst.components.quagmire_altar.onsnackrificefn = OnSnackrifice

        -- inst:AddComponent("snackrificer")
        -- inst.components.snackrificer.onsnackrificefn = OnSnackrifice
        -- inst.components.snackrificer:PickCraving()
    end
}
