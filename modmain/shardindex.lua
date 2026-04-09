local skin_nature_defs = require("datadefs/skin_nature_defs")


local function OnWorldEntsSpawned()
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


    print("给世界上的渡渡鸟分配公母")
    local doydoy_count = 0
    for guid, ent in pairs(Ents) do
        if ent.prefab == "doydoy" then
            doydoy_count = doydoy_count + 1
            if math.fmod(doydoy_count, 2) == 0 then
                ent:AddTag("daddy")
                ent.components.named:SetName("Doydoy(M)")
            else
                ent:AddTag("mommy")
                ent.components.named:SetName("DoyDoy(F)")
            end
        end
    end


    -- OCEAN_COASTAL
    -- print("替换海洋地皮为联机海洋地皮")
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
