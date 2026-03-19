-- 给AddTask添加set_pieces字段，因为联机版没有这个字段，该字段可以为静态布局创建对应的room并添加到task里
local Rooms = require "map/rooms"
Hooks.FnDecorator(env, "AddTask", function(name, data)
    if not data.set_pieces then
        return
    end

    for _, piece in ipairs(data.set_pieces) do
        local room_name = name .. piece.name --每个task有自己的room，因为这里要指定colour和value值，不知道这两个值是不是可以不传
        if not Rooms.GetRoomByName(room_name) then
            AddRoom(room_name, {
                colour = data.colour,
                value = data.room_bg,
                contents = {
                    countstaticlayouts = { [piece.name] = 1 }
                }
            })
        end

        data.room_choices = data.room_choices or {}
        data.room_choices[room_name] = 1
    end
end)

----------------------------------------------------------------------------------------------------
