local BasicWorkable = require("components/tro_basicworkable")

--- 可以剪
local Shearable = Class(BasicWorkable, function(self, inst)
    BasicWorkable._ctor(self, inst, "shearable", "onshear", "onshearfinished")

    if troisdev then
        inst:DoTaskInTime(0, function(inst)
            if not inst.components.workable then
                TroErrorHandle("workable没有被占用的话建议使用workable，workable和其他预制体配合更好" .. tostring(inst), false)
            end
        end)
    end
end)

return Shearable
