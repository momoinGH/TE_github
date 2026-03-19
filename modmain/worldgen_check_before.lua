local StaticLayout = require("map/static_layout")
-- Hooks.FnDecorator(StaticLayout, "Get", function(layoutsrc)
--     print("开始加载布局文件" .. tostring(layoutsrc)) --打印一下，在报错的时候好排查问题
-- end)


-- 检查room的标签是否都加过处理函数
local map_tags
Hooks.FnDecorator(env, "AddRoom", function(name, room)
    -- print("开始注册room：" .. name)

    if room.tags then
        if not map_tags then
            require("map/storygen")
            local story = Story(0, {}, nil, {}, 0) --构造一个假的Story对象，拿到地形标签表，检查里面的标签是不是都定义过
            map_tags = story.map_tags
        end

        for _, tag in ipairs(room.tags) do
            assert(map_tags.Tag[tag], "你忘了给这个room标签" .. tag .. "定义处理函数了，请在modmain/map/storygen.lua文件中定义")
        end
    end

    assert(room.value, "必须给room指定一个地皮，" .. name .. "忘了指定")
end)

Hooks.FnDecorator(env, "AddTask", function(name, task)
    assert(task.room_bg, "必须给task指定一个room_bg字段表示默认地皮，" .. name .. "忘了指定")
end)
