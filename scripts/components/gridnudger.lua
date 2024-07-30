local Gridnudger = Class(function(self, inst)
    self.inst = inst

    self.inst.gridnudgetask = self.inst:DoTaskInTime(0, function() self:fixposition() end)
end)

function Gridnudger:OnSave()
    local data = {}
    return data
end

function Gridnudger:OnLoad(data)
    if self.inst.gridnudgetask then
        self.inst.gridnudgetask:Cancel()
        self.inst.gridnudgetask = nil
    end
end

function Gridnudger:fixposition()
    local inst = self.inst
    local function normalize(coord)
        local temp = coord % 0.5
        coord = coord + 0.5 - temp

        if coord % 1 == 0 then
            coord = coord - 0.5
        end

        return coord
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    x = normalize(x)
    z = normalize(z)
    inst.Transform:SetPosition(x, y, z)
    if inst.setobstical then
        inst.setobstical(inst)
    end
end

return Gridnudger
