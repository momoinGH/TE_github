--- 导入对应模块的文件，不需要的文件可以不存在
local function Modimport(dirc)

    if troisdev then
        trosafemodimport("modmain/" .. dirc .. "/debug")  --注册一些c_指令，用于控制台调试
    end
end

for _, m in pairs(tro_modules) do
    if TUNING.tropical[m] then
        Modimport(m)
    end
end




-- wiki
table.insert(Assets, Asset("ANIM", "anim/pigman_tribe.zip")) --图鉴wiki默认动画
