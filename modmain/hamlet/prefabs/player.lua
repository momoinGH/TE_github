local function OnStartFogGrog(inst, data)
    inst.components.grogginess:ProStartFoggrog()
end
local function OnStopFogGrog(inst, data)
    inst.components.grogginess:ProStopFoggrog()
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.infestable == nil then
        inst:AddComponent("infestable") --虫子感染
    end
    if inst.components.shopper == nil then
        inst:AddComponent("shopper") --购买商品
    end

    inst:ListenForEvent("startfoggrog", OnStartFogGrog)
    inst:ListenForEvent("stopfoggrog", OnStopFogGrog)
end)
