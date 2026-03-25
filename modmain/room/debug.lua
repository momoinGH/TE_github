-- 重新设置房内装饰相对于中心点的偏移量，可以在客户端调整调整位置然后填到room数据里
GLOBAL.c_resetroomentoffset = function(offset_x, offset_y, offset_z)
    local ent = c_select()
    if not ent then return end

    local room_center = ThePlayer:TroGetRoomCenter()
    if not room_center then
        print("玩家不在房间内！")
        return
    end

    local x, y, z = ent.Transform:GetWorldPosition()
    local cx, cy, cz = room_center.Transform:GetWorldPosition()
    print(string.trofmt("旧偏移量：{0}, {1}, {2}, 新偏移量：{3}, {4}, {5}", x - cx, y - cy, z - cz, offset_x, offset_y, offset_z))

    if offset_x == nil and offset_y == nil and offset_z == nil then
        return --仅打印
    end

    ent.Transform:SetPosition(cx + (offset_x or 0), (offset_y or 0), cz + (offset_z or 0))
end
