-- 修复父类定义props时子类报错的问题
local OldClass = Class
GLOBAL.Class = function(base, _ctor, props, ...)
    if type(base) == 'table' and base._tro_props then
        props = props or {}
        table.trodeep_merge(props, base._tro_props)
    end

    local c = OldClass(base, _ctor, props, ...)

    c._tro_props = props
    return c
end
