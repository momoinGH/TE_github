--最好不合法的先打印再报错，因为加载布局、room、task时报错不会给原因的，得自己找问题

local StaticLayout = require("map/static_layout")
Hooks.FnDecorator(StaticLayout, "Get", function(layoutsrc)
    print("添加layout：" .. tostring(layoutsrc)) --打印一下，在报错的时候好排查问题
end)

local map_tags
local node_tags = {}
Hooks.FnDecorator(env, "AddRoom", function(name, room)
    print("添加room：" .. tostring(name))

    if not room.value then
        TroErrorHandle(string.trofmt("必须给room指定一个地皮，{}忘了指定", name), false)
        error("")
    end

    -- 给room添加标签，方便查看当前位置属于什么room
    node_tags[name] = true
    room.tags = room.tags or {}
    table.insert(room.tags, name)

    -- 检查room的标签是否都加过处理函数
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
end)

Hooks.FnDecorator(env, "AddTask", function(name, task)
    print("添加task：", tostring(name))

    if not task.room_bg then
        TroErrorHandle("必须给task指定一个room_bg字段表示默认地皮，" .. name .. "忘了指定", false)
        error("")
    end
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
