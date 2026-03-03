GLOBAL.c_printroominfo = function()
    local room_center = ThePlayer:TroGetRoomCenter()
    if not room_center then
        print("玩家不在房间内！")
        return
    end

    print(room_center)
end
