--[[
科雷有自带的创建世界时初始化一次方法，是在在静态布局文件里定义scenario字段，但是要针对每个静态布局和每个预制件都写一下还是有点儿麻烦
科雷有自己的scenariorunner组件，虽然我们也能定义自己的组件，如果下面这个hook以后失效了可以定义自己的组件
]]

local skin_nature_defs = require("datadefs/skin_nature_defs")

local function OnWorldEntsSpawned()
    if TUNING.tropical.sea then
        require("tro_seaworldinit")()
    end

    print("所有实体创建完成，开始根据地形替换皮肤")
    --检查皮肤是否满足条件，满足就替换皮肤
    for guid, ent in pairs(Ents) do
        if skin_nature_defs.skinlist[ent.prefab] then
            for skin_name, skin_data in pairs(skin_nature_defs.skinlist[ent.prefab]) do
                if skin_data.skintype and skin_nature_defs.testfns[skin_data.skintype] and skin_nature_defs.testfns[skin_data.skintype](ent) then
                    TheSim:ReskinEntity(guid, ent.skinname, skin_name)
                end
            end
        end
    end


    print("给猪镇上的东西加个标记，表示属于猪人的")
    for guid, ent in pairs(Ents) do
        if ent.Transform then
            local x, y, z = ent.Transform:GetWorldPosition()
            if TheWorld.Map:FindVisualNodeAtPoint(x, y, z, "City1") then
                ent:TroAddSaveTag("city1") --用这个标签替代citypossession组件
            elseif TheWorld.Map:FindVisualNodeAtPoint(x, y, z, "City2") then
                ent:TroAddSaveTag("city2")
            end
        end
    end
end



require("shardindex")
local OldOnGenerateNewWorld = ShardIndex.OnGenerateNewWorld
function ShardIndex:OnGenerateNewWorld(savedata, metadataStr, session_identifier, cb, ...)
    local function new_cb()
        if cb then
            cb()
        end
        OnWorldEntsSpawned()
    end
    OldOnGenerateNewWorld(self, savedata, metadataStr, session_identifier, new_cb, ...)
end
