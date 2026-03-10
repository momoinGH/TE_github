---这个函数在modmain运行正常，thesim只在modmain存在
function ModGetLevelDataOverride()
    print("TA Mod Loading Custom Presets Manager33333")

    local filename = "../leveldataoverride.lua"
    local success, savedata

    local shardGameIndex = ShardGameIndex
    if not shardGameIndex then
        require("shardindex")
        shardGameIndex = ShardIndex()
        shardGameIndex:Load()
    end

    local function onload(load_success, str)
        if load_success == true then
            success, savedata = RunInSandboxSafe(str)
            if success and string.len(str) > 0 then
                print("TA Mod Found a level data override file with these contents:")
                if savedata ~= nil then
                    print("TA Mod Loaded and applied level data override from " .. filename)
                    return
                end
            else
                print("ERROR: Failed to load " .. filename)
            end
        end
        print("Not applying level data overrides.")
    end

    local slot = shardGameIndex:GetSlot()
    local shard = shardGameIndex:GetShard()
    local session_id = shardGameIndex:GetSession()

    if session_id ~= nil then ---只有服务器需要这个
        TheSim:GetPersistentStringInClusterSlot(slot, shard, filename, onload)
    else
        TheSim:GetPersistentString(filename, onload)
    end

    return savedata
end
