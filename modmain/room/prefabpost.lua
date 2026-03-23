modimport "modmain/room/interiorminimap" --绘制小房间内的小地图
modimport "modmain/room/entityscript"
modimport "modmain/room/roomcamera.lua"  --玩家室内摄像机




modimport "modmain/room/components/map"





----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--室内避雨？
local function ShelteredOnUpdateBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if not self.mounted
        and TheWorld.Map:TroIsWorldOut(x, 0, z)
    then
        self:SetSheltered(true)
        return nil, true
    end
end

AddComponentPostInit("sheltered", function(self)
    Hooks.FnDecorator(self, "OnUpdate", ShelteredOnUpdateBefore)
end)

----------------------------------------------------------------------------------------------------
--室内屏蔽花粉、雪、雨粒子？
AddSimPostInit(function()
    EmitterManager.old_updatefuncs = { snow = nil, rain = nil, pollen = nil }
    Hooks.FnDecorator(EmitterManager, "PostUpdate", function(self, ...)
        for inst, data in pairs(self.awakeEmitters.infiniteLifetimes) do
            if inst.prefab == "pollen" or inst.prefab == "snow" or inst.prefab == "rain" then
                if self.old_updatefuncs[inst.prefab] == nil then
                    self.old_updatefuncs[inst.prefab] = data.updateFunc
                end
                local x, y, z = inst.Transform:GetWorldPosition()
                if TheWorld.Map:TroIsWorldOut(x, 0, z) then
                    data.updateFunc = function() end -- empty function
                else
                    data.updateFunc = self.old_updatefuncs[inst.prefab] ~= nil and self.old_updatefuncs[inst.prefab] or
                        function() end -- the original one
                end
            end
        end
    end)
end)

----------------------------------------------------------------------------------------------------

local function WorldPushEventBefore(inst, event, pos)
    if event == "ms_sendlightningstrike" and pos and TheWorld.Map:TroGetRoomCenter(pos:Get()) then
        return nil, true --你不能在屋子里打雷，或许可以在这里只打个响儿
    end
end

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("tro_roomspawner")


    Hooks.FnDecorator(inst, "PushEvent", WorldPushEventBefore)
end)


----------------------------------------------------------------------------------------------------
