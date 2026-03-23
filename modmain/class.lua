-- 修复父类定义props子类没定义props时报错的问题，初始化时在__newindex(t, k, v)函数里会报错
local OldClass = Class
GLOBAL.Class = function(base, _ctor, props, ...)
    if type(base) == 'table' and base._tro_props then
        props = MergeMaps(base._tro_props, props or {}) --props放后面，子类可以覆盖父类
    end

    local c = OldClass(base, _ctor, props, ...)

    c._tro_props = props
    return c
end
