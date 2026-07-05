modimport "modmain/common/poisonable"
modimport "modmain/hamlet/oinc.lua"       --呼噜币换算
modimport "modmain/hamlet/farm_guard.lua" --采摘农场的东西会被打


modimport "modmain/hamlet/components/builder"
modimport "modmain/hamlet/components/builder_replica"
modimport "modmain/hamlet/components/edible"
modimport "modmain/hamlet/components/autoterraformer.lua" --刮地皮头盔组件
modimport "modmain/hamlet/components/playervision.lua"


modimport "modmain/hamlet/prefabs/molehat.lua" --鼹鼠帽
modimport "modmain/hamlet/prefabs/player.lua"
modimport "modmain/hamlet/prefabs/world.lua"
modimport "modmain/hamlet/prefabs/forest.lua"
modimport "modmain/hamlet/prefabs/statueruins.lua" --联机洞穴雕像也能考古


if TUNING.tropical.hayfever then
    modimport "modmain/hamlet/hayfever" --花粉症
end
if TUNING.tropical.fog then
    modimport "modmain/hamlet/fog" --大雾
end
if TUNING.tropical.aporkalypse then
    modimport "modmain/hamlet/aporkalypse.lua" --大灾变
end

modimport "modmain/hamlet/living_artifact.lua" --活性机甲

----------------------------------------------------------------------------------------------------
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
