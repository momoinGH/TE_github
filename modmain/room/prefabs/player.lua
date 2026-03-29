TroAddPlayerClassifiedNetVar(net_entity, "tro_curroomcenter") --玩家当前所处的房间对象

-- 刷帧检测玩家是否在虚空房子里
local function CheckPlayerInRoom(inst)
    local room_center = inst:TroGetRoomCenter()
    if room_center then
        room_center:AddTag("room_explored") --可以绘制小地图了
    end
    inst:TroSetPlayerClassifiedNetVar("tro_curroomcenter", room_center)
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    inst:DoPeriodicTask(15 * FRAMES, CheckPlayerInRoom)
end)
