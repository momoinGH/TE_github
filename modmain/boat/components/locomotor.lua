-- 用来在OnUpdate中跳到岸上用的
local function GetCurrentPlatform(inst)
    return inst:_pro_GetCurrentPlatform() or inst:TroGetSWBoat()
end

local function OnUpdateBefore(self)
    if TheWorld.ismastersim then -- 如果开了延迟补偿的话就不处理了，禁止通过移动的方式跳到岸上，因为我不会处理
        self.inst._pro_GetCurrentPlatform = self.inst.GetCurrentPlatform
        self.inst.GetCurrentPlatform = GetCurrentPlatform
    end
end

local function OnUpdateAfter(retTab, self)
    self.inst.GetCurrentPlatform = self.inst._pro_GetCurrentPlatform or self.inst.GetCurrentPlatform
    self.inst._pro_GetCurrentPlatform = nil
    return retTab
end

-- 划船时返回船的移速
local function RunSpeedBefore(self)
    local boat = self.inst:TroGetSWBoat()
    if boat and boat.runspeed then
        return { boat.runspeed }, true
    end
end

AddComponentPostInit("locomotor", function(self)
    if self.inst:HasTag("player") then
        Utils.FnDecorator(self, "OnUpdate", OnUpdateBefore, OnUpdateAfter)
        Utils.FnDecorator(self, "RunSpeed", RunSpeedBefore)
    end
end)
