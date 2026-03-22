local BasicWorkable = require("components/tro_basicworkable")

--- 可以劈砍，简易组件，如果要更多功能可以加个pickable作为辅助组件
local Hackable = Class(BasicWorkable, function(self, inst)
    BasicWorkable._ctor(self, inst, "hackable", "onhacked", "onhackfinished")

    if troisdev then
        inst:DoTaskInTime(0, function(inst)
            if not inst.components.workable then
                TroErrorHandle("workable没有被占用的话建议使用workable，workable和其他预制体配合更好" .. tostring(inst), false, false)
            end
        end)
    end
end)

return Hackable
