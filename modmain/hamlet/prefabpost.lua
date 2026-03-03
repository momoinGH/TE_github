local Utils = require "tropical_utils/utils"

if TUNING.tropical.only_hamlet then
    modimport "modmain/hamlet/sim_ham" --ham cloud
end




AddReplicableComponent("hayfever")

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

modimport "modmain/common/AddIronLordHandlers" --活性机甲处理
modimport "modmain/common/AddIronLordPostinit" --活性机甲构造
modimport "scripts/ArtifactControls"           --活性机甲控制

----------------------------------------------------------------------------------------------------

local _OnCreep = GroundCreep.OnCreep
function GroundCreep:OnCreep(x, y, z, ...)
    return _OnCreep(self, x, y, z, ...) and not TheWorld.Map:TroGetRoomCenter(x, y, z)
end
