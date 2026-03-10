local Utils = require "tropical_utils/utils"

AddReplicableComponent("hayfever")
AddReplicableComponent("hayfever")

if TUNING.tropical.only_hamlet then
    modimport "modmain/hamlet/sim_ham" --ham cloud
end


modimport "modmain/hamlet/simutil"
modimport "modmain/common/poisonable"

modimport "modmain/hamlet/components/inventory_replica"
modimport "modmain/hamlet/components/builder"
modimport "modmain/hamlet/components/builder_replica"
modimport "modmain/hamlet/components/edible"
modimport "modmain/hamlet/components/grogginess.lua"      --眩晕、减速
modimport "modmain/hamlet/components/autoterraformer.lua" --刮地皮头盔组件

modimport "modmain/hamlet/AddIronLordHandlers"            --活性机甲处理
modimport "modmain/hamlet/AddIronLordPostinit"            --活性机甲构造
modimport "modmain/hamlet/prefabs/molehat.lua"            --鼹鼠帽
modimport "modmain/hamlet/prefabs/player.lua"
modimport "modmain/hamlet/prefabs/world.lua"
modimport "modmain/hamlet/prefabs/forest.lua"
modimport "modmain/hamlet/prefabs/player_classified.lua" --玩家网络变量

----------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    if TUNING.tropical.hayfever ~= 0 then
        inst:AddComponent("hayfever")
    end
end)


AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    TheWorld.components.tro_tempentitytracker:AddKey("pig_ruins_exits") --遗迹出口
    TheWorld.components.tro_tempentitytracker:AddKey("cave_exit_roc")   --洞穴出口
    TheWorld.components.tro_tempentitytracker:AddKey("anthill_exit")    --蚁穴出口
end)

local Unwrappable = require "components/unwrappable"
Hooks.FnDecorator(Unwrappable, "_ctor", nil, function(rets, self, inst)
    if TheWorld.ismastersim and inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
    return rets
end)

----------------------------------------------------------------------------------------------------

local _OnCreep = GroundCreep.OnCreep
function GroundCreep:OnCreep(x, y, z, ...)
    return _OnCreep(self, x, y, z, ...) and not TheWorld.Map:TroGetRoomCenter(x, y, z)
end
