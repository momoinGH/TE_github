require("entityscript")

-- 设置player_classified网络变量的值
function EntityScript:TroSetPlayerClassifiedNetVar(name, val, setdirty)
    if not self.player_classified then
        return false
    end

    local netvar = self.player_classified[name]
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
    if not netvar then
        TroErrorHandle("你没定义" .. name .. "这个网络变量", false)
        return nil
    end

    return netvar:value()
end

----------------------------------------------------------------------------------------------------
-- 是不是在水上
function EntityScript:GetIsOnWater(allow_boats)
    local x, y, z = self.Transform:GetWorldPosition()
    return TheWorld.Map:IsOceanAtPoint(x, y, z, allow_boats)
end

-- 我们mod定义的区域，海难、哈姆雷特、火山、热带等等
function EntityScript:IsInTropicalArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("tropical") and true or false
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

-- 水下区域
function EntityScript:IsInUnderWaterArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("underwater") and true or false
    end
    return TheWorld.Map:IsUnderWaterAreaAtPoint(self.Transform:GetWorldPosition())
end

-- 冰岛区域
function EntityScript:IsInFrostisLandArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("frost") and true or false
    end
    return TheWorld.Map:IsFrostisLandAreaAtPoint(self.Transform:GetWorldPosition())
end

-- 大风平原区域
function EntityScript:IsInWindyArea()
    if self.components.areaaware then
        return self.components.areaaware:CurrentlyInTag("windy") and true or false
    end
    return TheWorld.Map:IsWindyAreaAtPoint(self.Transform:GetWorldPosition())
end

function EntityScript:TroIsWorldOut()
    local x, y, z = self.Transform:GetWorldPosition()
    return TheWorld.Map:TroIsWorldOut(x, y, z)
end

----------------------------------------------------------------------------------------------------

-- 判断实体所在位置是否是冬天
function EntityScript:TroIsWinter()
    if self.components.areaaware then
        if TheWorld.state.iswinter then
            return not self.components.areaaware:CurrentlyInTag("No_Winter")
        else
            return self.components.areaaware:CurrentlyInTag("Always_Winter")
        end
    end
    return TheWorld.Map:TroIsWinterAtPoint(self.Transform:GetWorldPosition())
end

function EntityScript:TroIsSummer()
    if self.components.areaaware then
        if self.components.areaaware:CurrentlyInTag("Always_Winter") then
            return false
        end
        if TheWorld.state.issummer then
            return not self.components.areaaware:CurrentlyInTag("No_Summer")
        else
            return false
        end
    end
    return TheWorld.Map:TroIsSummerAtPoint(self.Transform:GetWorldPosition())
end

-- 获取骑的牛
function EntityScript:TroGetMount()
    return self.replica.rider and self.replica.rider:GetMount()
end

-- 是不是在大灾变中，如果不需要判断地形可以直接用TheWorld.state.isaporkalypse
function EntityScript:TroIsAporkalypse()
    return TheWorld.net and TheWorld.net.tro_isaporkalypse and TheWorld.net.tro_isaporkalypse:value()
        and (self:IsInHamletArea() or self:TroGetRoomCenter() ~= nil)
end

-- 是否在哈姆雷特雾气中
function EntityScript:TroInHamletFog()
    if self.player_classified then
        return self:TroGetPlayerClassifiedNetVar("tro_fog")
    end
    --不是玩家
    return TroInHamletFogImple(self)
end

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

----------------------------------------------------------------------------------------------------

-- 给雪等级事件回调封装一层，如果实体在冰岛那拿到的snowlevel值会是最大值
Hooks.FnDecorator(EntityScript, "WatchWorldState", function(self, var, fn)
    if var == "snowlevel" then
        local new_fn = function(inst, snowlevel, ...)
            if inst:IsInFrostisLandArea() then
                snowlevel = 1
            end
            return fn(inst, snowlevel, ...)
        end
        return { self, var, new_fn }, true
    end
end)

----------------------------------------------------------------------------------------------------
-- 同单机，在ACTION执行成功后推送一下事件，用来在玩家执行一些操作时触发什么事件，比如召唤虎鲨
local OldPerformBufferedAction = EntityScript.PerformBufferedAction
function EntityScript:PerformBufferedAction(...)
    local action = self.bufferedaction
    local success = OldPerformBufferedAction(self, ...)
    if success then
        self:PushEvent("actionsuccess", { action = action })
    end
    return success
end

----------------------------------------------------------------------------------------------------

-- 重定向熔炉、暴食的文件，请求不到时就在本地找找
-- 可以少写一写代码，但也不是万能的，有些地方用了TheNet:GetServerGameMode() == "quagmire"判断执行什么代码，可能并不是想要的
local old_requireeventfile = GLOBAL.requireeventfile
GLOBAL.requireeventfile = function(path)
    local res = old_requireeventfile(path)
    if (not res or not next(res)) and softresolvefilepath("scripts/" .. path .. ".lua") ~= nil then
        print("eventfile加载本地文件", path)
        res = require(path)
    end
    return res
end
