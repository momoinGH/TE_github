-- 检查布局文件有没有重的
local StaticLayout = require("map/static_layout")
-- local OldGet = StaticLayout.Get
-- local required_layout_files = {}
-- StaticLayout.Get = function(layoutsrc, ...)
--     assert(layoutsrc and not required_layout_files[layoutsrc], "重复加载了布局文件" .. tostring(layoutsrc))
--     return OldGet(layoutsrc, ...)
-- end

Hooks.FnDecorator(StaticLayout, "Get", function(layoutsrc)
    print("开始加载布局文件" .. tostring(layoutsrc)) --打印一下，在报错的时候好排查问题
end)


-- 检查room的标签是否都加过处理函数
local map_tags
Hooks.FnDecorator(GLOBAL.AddRoom, "AddRoom", function(name, room)
    if not room.tags then return end

    if not map_tags then
        require("map/storygen")
        local story = Story(0, {}, nil, {}, 0) --构造一个假的Story对象，拿到地形标签表，检查里面的标签是不是都定义过
        map_tags = story.map_tags
    end

    for _, tag in ipairs(room.tags) do
        assert(map_tags.Tag[tag], "你忘了给这个room标签" .. tag .. "定义处理函数了，请在modmain/map/storygen.lua文件中定义")
    end
end)
