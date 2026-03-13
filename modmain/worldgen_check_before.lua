local StaticLayout = require("map/static_layout")
local OldGet = StaticLayout.Get
local required_layout_files = {}
StaticLayout.Get = function(layoutsrc, ...)
    -- assert(layoutsrc and not required_layout_files[layoutsrc], "重复加载了布局文件" .. tostring(layoutsrc))
    return OldGet(layoutsrc, ...)
end
