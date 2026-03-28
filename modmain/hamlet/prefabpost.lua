if TUNING.tropical.only_hamlet then
    modimport "modmain/hamlet/sim_ham" --ham cloud
end

modimport "modmain/common/poisonable"
modimport "modmain/hamlet/oinc.lua"             --呼噜币换算
modimport "modmain/hamlet/aporkalypse.lua" --大灾变
modimport "modmain/hamlet/farm_guard.lua"       --采摘农场的东西会被打


modimport "modmain/hamlet/components/builder"
modimport "modmain/hamlet/components/builder_replica"
modimport "modmain/hamlet/components/edible"
modimport "modmain/hamlet/components/autoterraformer.lua" --刮地皮头盔组件
modimport "modmain/hamlet/components/playervision.lua"


modimport "modmain/hamlet/prefabs/molehat.lua" --鼹鼠帽
modimport "modmain/hamlet/prefabs/player.lua"
modimport "modmain/hamlet/prefabs/world.lua"
modimport "modmain/hamlet/prefabs/forest.lua"
modimport "modmain/hamlet/prefabs/player_classified.lua" --玩家网络变量
modimport "modmain/hamlet/prefabs/statueruins.lua" --联机洞穴雕像也能考古


if TUNING.tropical.hayfever then
    modimport "modmain/hamlet/hayfever" --花粉症
end
if TUNING.tropical.fog then
    modimport "modmain/hamlet/fog"             --大雾
end
modimport "modmain/hamlet/living_artifact.lua" --活性机甲

----------------------------------------------------------------------------------------------------


AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    TheWorld.components.tro_tempentitytracker:AddKey("cave_exit_roc") --洞穴出口
    TheWorld.components.tro_tempentitytracker:AddKey("anthill_exit")  --蚁穴出口
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
