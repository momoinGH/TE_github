local StaticLayout = require("map/static_layout")
Hooks.FnDecorator(StaticLayout, "Get", function(layoutsrc)
    print("添加layout" .. tostring(layoutsrc)) --打印一下，在报错的时候好排查问题
end)
Hooks.FnDecorator(env, "AddRoom", function(name, room)
    print("添加room：" .. name)
end)
Hooks.FnDecorator(env, "AddTask", function(name, task)
    print("添加task", name)
end)
----------------------------------------------------------------------------------------------------

-- 给room添加标签，方便查看当前位置属于什么room
local node_tags = {}
Hooks.FnDecorator(env, "AddRoom", function(name, room)
    node_tags[name] = true
    room.tags = room.tags or {}
    table.insert(room.tags, name)
end)

AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    for name, _ in pairs(node_tags) do
        self.map_tags.Tag[name] = function(tagdata) return "TAG", name end
    end
end)

-- 打印当前区域tags
GLOBAL.c_printcurareatags = function()
    print(PrintTable(ThePlayer.components.areaaware.current_area_data.tags))
end

----------------------------------------------------------------------------------------------------
-- 检查room的标签是否都加过处理函数
-- local map_tags
Hooks.FnDecorator(env, "AddRoom", function(name, room)
    -- if room.tags then
    --     if not map_tags then
    --         require("map/storygen")
    --         local story = Story(0, {}, nil, {}, 0) --构造一个假的Story对象，拿到地形标签表，检查里面的标签是不是都定义过
    --         map_tags = story.map_tags
    --     end

    --     for _, tag in ipairs(room.tags) do
    --         assert(map_tags.Tag[tag], "你忘了给这个room标签" .. tag .. "定义处理函数了，请在modmain/map/storygen.lua文件中定义")
    --     end
    -- end

    assert(room.value, "必须给room指定一个地皮，" .. name .. "忘了指定")
end)

Hooks.FnDecorator(env, "AddTask", function(name, task)
    assert(task.room_bg, "必须给task指定一个room_bg字段表示默认地皮，" .. name .. "忘了指定")
end)

----------------------------------------------------------------------------------------------------

