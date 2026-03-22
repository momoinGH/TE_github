local MakeWorkable = require("components/tro_basicworkable")

--- 可以剪
local Shearable = MakeWorkable({
    workable_tag       = "shearable",
    worked_event       = "onshear",
    workfinished_event = "onshearfinished"
}, function(self, inst)
    if troisdev then
        inst:DoTaskInTime(0, function(inst)
            if not inst.components.workable then
                TroErrorHandle("workable没有被占用的话建议使用workable，workable和其他预制体配合更好" .. tostring(inst), false, false)
            end
        end)
    end
end)

return Shearable
