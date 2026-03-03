require("entityscript")

function EntityScript:IsInTropicalArea()
    return TheWorld.Map:IsTropicalAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInShipwreckedArea()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInHamletArea()
    return TheWorld.Map:IsHamletAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInVolcanoArea()
    return TheWorld.Map:IsVolcanoAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInWorld()
    local x, y, z = self.Transform:GetWorldPosition()
    return math.abs(x) <= 1350 and math.abs(z) <= 1350
end

----area aware related--------------------
function EntityScript:AwareInTropicalArea() ----减少计算量
    return self.components.areaaware and
        (self.components.areaaware:CurrentlyInTag("tropical")
            or self.components.areaaware:CurrentlyInTag("ForceDisconnected")) and
        true or false
end

function EntityScript:AwareInShipwreckedArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("shipwrecked") and true
    return aware or false
end

function EntityScript:AwareInHamletArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("hamlet") and true
    return aware or false
end

function EntityScript:AwareInVolcanoArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("volcano") and true
    return aware or false
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
