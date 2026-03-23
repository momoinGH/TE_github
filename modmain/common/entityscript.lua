require("entityscript")

-- 设置player_classified网络变量的值
function EntityScript:TroSetPlayerClassifiedNetVar(name, val, setdirty)
    if not self.player_classified then
        return false
    end

    local netvar = self.player_classified[name]
    -- if not trodevassert(netvar, "你没定义" .. name .. "这个网络变量") then
    if not netvar then
        return false
    end

    if netvar.push then --是net_bool类型
        netvar:push()
        return true
    end

    if setdirty then --强制同步值
        netvar:set_local(val)
    end
    netvar:set(val)
    return true
end

-- 获取player_classified网络变量的值
function EntityScript:TroGetPlayerClassifiedNetVar(name)
    if not self.player_classified then
        return nil
    end

    local netvar = self.player_classified[name]
    if not trodevassert(netvar, "你没定义" .. name .. "这个网络变量") then
        return nil
    end

    return netvar:value()
end

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

function EntityScript:IsInWindyArea()
    local tile_id = TheWorld.Map:GetTileAtPoint(self.Transform:GetWorldPosition())
    return tile_id == WORLD_TILES.WINDY
end

----------------------------------------------------------------------------------------------------

-- 获取玩家身上的小船
function EntityScript:TroGetSWBoat()
    if TheWorld.ismastersim then
        return self.components.tro_driver and self.components.tro_driver.boat or nil
    else
        return self.replica.tro_driver and self.replica.tro_driver:GetBoat() or nil
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
        return self:TroGetPlayerClassifiedNetVar("tro_fog")
    end
    --不是玩家
    if GLOBAL.TroInHamlteFogImple then
        return TroInHamlteFogImple(self)
    end
    return false
end
