-- 自定义打印函数，就是简单的把内容拼接在一起，和科雷不同的事不会在每个元素之间加空格
function conprint(...)
    local result = ""
    for i, arg in ipairs({ ... }) do
        result = result .. tostring(arg)
    end
    print(result)
end

GLOBAL.conprint = conprint
