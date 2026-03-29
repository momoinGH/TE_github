-- 动态加载开发，功能开发完再删掉
print("加载小地图文件")

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local RoomUtils = require("tropical_utils/room_utils")

-- 拟定的房子大小
local WORLD_TO_MAP_SCALE = 15
local function AddImage(room_root, atlas, tex, offset_x, offset_y, scale_x, scale_y)
    local img = room_root:AddChild(Image(atlas, tex))
    img:SetHAnchor(ANCHOR_MIDDLE)
    img:SetVAnchor(ANCHOR_MIDDLE)
    img:SetPosition(room_root.room_offset_x + offset_x * WORLD_TO_MAP_SCALE * room_root.ratio,
        room_root.room_offset_y + offset_y * WORLD_TO_MAP_SCALE)
    if scale_x or scale_y then
        img:SetScale(scale_x or 1, scale_y, 1)
    end
    return img
end

local function AddPassage(room_root, rotate, cell_width, cell_depth)
    local passage = AddImage(room_root, "levels/textures/tro_map_interior/passage.xml", "passage.tex", 0, 0)
    if rotate then
        passage:SetRotation(rotate)
    end
    local cx, cy = passage:GetPositionXYZ()
    passage:SetPosition(cx + (cell_width or 0) / 2, cy + (cell_depth or 0) / 2) --原来的位置再多加半个间距
    return passage
end

--- 绘制房间
--- 以相对坐标决定绘制的坐标，需要注意的是x差值和z差值对应的是image的y和x，而且使用RoomUtils.DIR时别忘了房子的坐标轴和image坐标轴的转换
local function AppendRoomTexture(self, start_room, room_offset_x, room_offset_y)
    local width = start_room.room_width:value()        --z
    local depth = start_room.room_depth:value()        --x
    local width_radio = width / TUNING.ROOM_TINY_WIDTH --里面的固定数字都是按照小房子改的，房间变大时也变大
    local depth_ratio = depth / TUNING.ROOM_TINY_DEPTH
    local ratio = width / depth                        --长宽比，小房子会更长点
    local room_gap = 60                                --房间边界处的间隔，为0时房间挨着房间
    local player_image = {}
    local passage_image = {}
    local room_grid, start_x, start_y = RoomUtils.GetCurrentRoomsGrid(start_room)

    for grid_x, row in ipairs(room_grid) do
        for grid_y, room_data in ipairs(row) do
            if room_data
            -- and room_data.ent:HasTag("room_explored")
            then
                local cell_width = width * WORLD_TO_MAP_SCALE * ratio + room_gap
                local cell_depth = depth * WORLD_TO_MAP_SCALE + 60 * depth_ratio + room_gap --多加一点儿，保证gap为0时上下左右房间都贴合
                room_offset_x = (grid_y - start_y) * cell_width
                room_offset_y = (start_x - grid_x) * cell_depth

                local rx, _, rz = room_data.ent.Transform:GetWorldPosition()

                local room_root = self:AddChild(Widget("ROOT"))
                room_root.room_offset_x = room_offset_x
                room_root.room_offset_y = room_offset_y
                room_root.ratio = ratio
                self._tro_houseimags[room_data.ent] = room_root
                -- room_node:SetPosition(room_offset_x, room_offset_y)--修改父对象坐标好像不会影响子坐标

                --地板
                for j = -1, 1 do
                    for i = -1, 1 do
                        AddImage(room_root, "levels/textures/tro_map_interior/mini_ruins_slab.xml", "mini_ruins_slab.tex",
                            j * 4.3 * width_radio, i * 4.3 * depth_ratio,
                            1.04 * ratio * width_radio, 1.04 * depth_ratio)
                    end
                end

                --房间边框
                AddImage(room_root, "levels/textures/tro_map_interior/frame.xml", "frame.tex", 0, 0, width_radio * ratio, depth_ratio * 1)
                -- frame.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

                --把房间里所有有小地图图标的画出来
                local room_ents = RoomUtils.FindRoomEnts(room_data.ent)
                for _, v in ipairs(room_ents) do
                    local icon = v.tro_minimap_icon
                    local atlas = icon and GetMinimapAtlas(icon)
                    if atlas                                                             --找到图集才显示
                        and (not v.GetDoorOrientation or v:HasTag("interior_houseexit")) --对于墙上的门只显示出口的门，因为被箭头替代了
                    then
                        local vx, _, vz = v.Transform:GetWorldPosition()
                        local image = AddImage(room_root, atlas, icon, vz - rz, rx - vx)
                        if v:HasTag("player") then
                            table.insert(player_image, image)
                        end
                    end
                end

                -- 上面和右边的箭头
                if room_data.north then
                    table.insert(passage_image, AddPassage(room_root, 90, 0, cell_depth))
                end
                if room_data.east then
                    table.insert(passage_image, AddPassage(room_root, 0, cell_width, 0))
                end
                -- 下面和左边的箭头只有没探索过的房间才绘制
                if room_data.south and room_grid[grid_x + 1] and room_grid[grid_x + 1][grid_y] and not room_grid[grid_x + 1][grid_y].ent:HasTag("room_explored") then
                    table.insert(passage_image, AddPassage(room_root, 90, 0, -cell_depth))
                end
                if room_data.west and room_grid[grid_x] and room_grid[grid_x][grid_y - 1] and not room_grid[grid_x][grid_y - 1].ent:HasTag("room_explored") then
                    table.insert(passage_image, AddPassage(room_root, 0, -cell_width, 0))
                end
            end
        end
    end

    for _, image in ipairs(passage_image) do
        image:MoveToFront() --这个置顶好像还是会被边框覆盖掉，为什么？
    end
    for _, image in ipairs(player_image) do
        image:MoveToFront() --玩家图片要放在最前面
    end
end


return AppendRoomTexture
