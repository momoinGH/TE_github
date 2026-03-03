TUNING.TRO_ROOM_DEBUG = false

GLOBAL.c_setroomdebug = function(enable_debug)
    TUNING.TRO_ROOM_DEBUG = enable_debug or false
end

GLOBAL.c_printroominfo = function()
    local room_center = ThePlayer:TroGetRoomCenter()
    if not room_center then
        print("玩家不在房间内！")
        return
    end

    print(room_center)
end
