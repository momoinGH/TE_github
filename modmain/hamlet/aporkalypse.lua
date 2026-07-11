AddPrefabPostInit("forest", function(inst)
    inst:AddComponent("aporkalypse")
end)

-- 直接给TheWorld.state.isaporkalypse赋值，并且给客户端也推送begin和end事件
local function OnIsAporkalypseChange(inst)
    if not TheWorld.ismastersim then
        if inst.tro_isaporkalypse:value() then
            TheWorld:PushEvent("beginaporkalypse")
        else
            TheWorld:PushEvent("endaporkalypse")
        end
    end
end


-- world没有网络组件，得用forest_network
AddPrefabPostInit("forest_network", function(inst)
    inst.tro_isaporkalypse = net_bool(inst.GUID, "tro_isaporkalypse", "tro_isaporkalypse")
    inst:ListenForEvent("tro_isaporkalypse", OnIsAporkalypseChange)
end)


----------------------------------------------------------------------------------------------------

-- 大灾变时花都变成恶魔花
for _, v in ipairs({
    "flower",
    "flower_rose",
    "planted_flower"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("beginaporkalypse", function()
            if inst:IsInHamletArea() and inst:IsValid() then
                RemoveFromRegrowthManager(inst) --花移除前要调用这个移除onremove的监听，不然会在附近再生的
                inst:DoTaskInTime(0, ReplacePrefab, "flower_evil")
            end
        end, TheWorld)
    end)
end

AddPrefabPostInit("flower_evil", function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("endaporkalypse", function()
        if inst:IsInHamletArea() and inst:IsValid() then
            RemoveFromRegrowthManager(inst)
            inst:DoTaskInTime(0, ReplacePrefab, "flower")
        end
    end, TheWorld)
end)

----------------------------------------------------------------------------------------------------

-- 血月
local luavermelha = require "widgets/bloodmoon"
AddClassPostConstruct("widgets/uiclock", function(self)
    self.luadesangue = self:AddChild(luavermelha(self.owner))
end)
