require("entityscript")

-- 我们mod定义的区域，海难、哈姆雷特、火山、热带等等
function EntityScript:IsInTropicalArea()
    if self.components.areaaware then
        return (self.components.areaaware:CurrentlyInTag("tropical")
                or self.components.areaaware:CurrentlyInTag("ForceDisconnected"))
            and true
            or false
    end
    return TheWorld.Map:IsTropicalAreaAtPoint(self.Transform:GetWorldPosition())
end

-- 海难区域
function EntityScript:IsInShipwreckedArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("shipwrecked") and true or false
    end
    return TheWorld.Map:IsShipwreckedAreaAtPoint(self.Transform:GetWorldPosition())
end

--哈姆雷特区域
function EntityScript:IsInHamletArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("hamlet") and true or false
    end
    return TheWorld.Map:IsHamletAreaAtPoint(self.Transform:GetWorldPosition())
end

--火山区域
function EntityScript:IsInVolcanoArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("volcano") and true or false
    end
    return TheWorld.Map:IsVolcanoAreaAtPoint(self.Transform:GetWorldPosition())
end

-- TODO 等待给地形加个tag，现在用地皮判断
-- 水下区域
function EntityScript:IsInUnderWaterArea()
    local tile_id = TheWorld.Map:GetTileAtPoint(self.Transform:GetWorldPosition())
    return tile_id == WORLD_TILES.UNDERWATER_SANDY or tile_id == WORLD_TILES.UNDERWATER_ROCKY
end

-- 冰岛区域
function EntityScript:IsInFrostisLandArea()
    local tile_id = TheWorld.Map:GetTileAtPoint(self.Transform:GetWorldPosition())
    return tile_id == WORLD_TILES.ICELAND or tile_id == WORLD_TILES.SNOWLAND
end

-- 根据定义的文件获取事件回调函数，尽量少用，因为文件里定义多个监听时获取的不一定是自己想要的
-- 可以使用require预制件文件用FindUpvalue拿到回调
function EntityScript:GetEventCallback(event, source, source_file, test_fn)
    source = source or self

    if not self.event_listening[event] or not self.event_listening[event][source] then
        return
    end

    for _, fn in ipairs(self.event_listening[event][source]) do
        if source_file then
            local info = debug.getinfo(fn, "S")
            if info and (info.source == source_file) and (not test_fn or test_fn(fn)) then
                return fn
            end
        elseif (not test_fn or test_fn(fn)) then
            return fn
        end
    end
end

-- 获取玩家身上的小船
function EntityScript:TroGetSWBoat()
    if TheWorld.ismastersim then
        return self.components.pro_driver and self.components.pro_driver.boat or nil
    else
        return self.replica.pro_driver and self.replica.pro_driver:GetBoat() or nil
    end
end

-- 获取玩家所处房子对象
function EntityScript:TroGetRoomCenter()
    if not TheWorld.Map.TroGetRoomCenter then
        return nil --没加载room模块
    end
    return TheWorld.Map:TroGetRoomCenter(self.Transform:GetWorldPosition())
end

-- 是否在哈姆雷特雾气中
function EntityScript:TroInHamletFog()
    if self.player_classified then
        return self.player_classified.pro_fog and self.player_classified.pro_fog:value() or false
    end
    --不是玩家
    if GLOBAL.TroInHamlteFogImple then
        return TroInHamlteFogImple(self)
    end
    return false
end
