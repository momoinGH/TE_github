local function OnWorldEntsSpawned()
    print("所有实体创建完成，开始根据地形替换皮肤")

    for guid, ent in pairs(Ents) do
        if ent.prefab == "grass" and ent:IsInHamletArea() then
            -- TODO 这皮肤系统是不是有问题，下线再上线就没了？
            TheSim:ReskinEntity(guid, nil, "grass_green")
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
