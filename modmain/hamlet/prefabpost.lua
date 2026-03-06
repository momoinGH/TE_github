local Utils = require "tropical_utils/utils"

if TUNING.tropical.only_hamlet then
    modimport "modmain/hamlet/sim_ham" --ham cloud
end

AddReplicableComponent("hayfever")

modimport "modmain/hamlet/simutil"
modimport "modmain/common/poisonable"


modimport "modmain/hamlet/components/inventory_replica"
modimport "modmain/hamlet/components/builder"
modimport "modmain/hamlet/components/builder_replica"


modimport "modmain/hamlet/AddIronLordHandlers" --活性机甲处理
modimport "modmain/hamlet/AddIronLordPostinit" --活性机甲构造


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

AddComponentPostInit("autoterraformer", function(self)
    Utils.FnDecorator(self, "DoTerraform", function(_self, px, py, pz, _x, _y)
        local tile = TheWorld.Map:GetTileAtPoint(px, py, pz)
        if tile == GROUND.GASRAINFOREST or tile == GROUND.DEEPRAINFOREST then return nil, true end
    end)
end)

local Unwrappable = require "components/unwrappable"
Utils.FnDecorator(Unwrappable, "_ctor", nil, function(rets, self, inst)
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
