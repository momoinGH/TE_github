modimport "modmain/common/tro_componentaction"          --一个功能比较强大的组件，可以在预制件里定义ACTION的逻辑
modimport "modmain/common/standardcomponents"
modimport "scripts/prefabs/tropical_farm_plant_defs"    --定义新植物
modimport "scripts/prefabs/sw_fertilizer_nutrient_defs" --肥料值定义
modimport "modmain/common/natureskin_variants"          --和自然皮肤切换相关的所有内容
modimport "modmain/common/wx78_moduledefs"
modimport "modmain/common/entityscript"

----------------------------------------------------------------------------------------------------

modimport "modmain/common/components/locomotor"
modimport "modmain/common/components/birdspawner"
modimport "modmain/common/components/playervision"
modimport "modmain/common/components/temperature"
modimport "modmain/common/components/walkableplatformplayer"
--[[
modimport "modmain/common/components/soundemitter"
modimport "modmain/common/components/ambientlighting"
modimport "modmain/common/components/colourcube"
modimport "modmain/common/components/mapstyle"
modimport "modmain/common/components/ambientsound"
modimport "modmain/common/components/dynamicmusic"
]]
modimport "modmain/common/components/map"        --theworld.map相关
modimport "modmain/common/components/deployable" -- 让某些地形不能部署、建造、种东西
modimport "modmain/common/components/spooked"    --黄蘑菇孢子
modimport("modmain/common/components/ambientlighting")
modimport "modmain/common/components/inventory"
modimport "modmain/common/components/inventory_replica"
modimport "modmain/common/components/armor"
modimport "modmain/common/components/boatphysics"
modimport "modmain/common/components/combat"
modimport "modmain/common/components/hounded" --猎犬袭击
modimport "modmain/common/components/plantregrowth.lua"
modimport "modmain/common/components/areaaware.lua"
modimport "modmain/common/components/oar.lua"



----------------------------------------------------------------------------------------------------


modimport "modmain/common/prefabs/oceanfishdef"
modimport "modmain/common/prefabs/player"
--modimport "modmain/common/prefabs/player_classified"
modimport "modmain/common/prefabs/world"
--modimport "modmain/common/poisonable"
modimport("modmain/common/prefabs/guard_corp")               --守卫保护作物、高草转化、草大风摇晃？
modimport("modmain/common/prefabs/player_vision_post")       --四眼镜、蝙蝠帽所用
modimport "modmain/common/prefabs/farm_plant_randomseed.lua" --植物再生
modimport "modmain/common/prefabs/dock_kit.lua"              --码头套件
modimport "modmain/common/prefabs/mosquitosack.lua"
modimport "modmain/common/prefabs/mushroom_farm.lua"
modimport "modmain/common/prefabs/warningshadow.lua"
modimport "modmain/common/prefabs/wobster.lua"



AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end

    if TheWorld.components.tro_tempentitytracker and TheWorld.components.tro_tempentitytracker:KeyExists(inst.prefab) then
        TheWorld.components.tro_tempentitytracker:OnEntSpawned(inst)
    end
end)
