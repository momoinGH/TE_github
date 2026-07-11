local Quagmire_Stewer = Class(function(self, inst)
    self.inst = inst

    self.stationname = nil
end)

function Quagmire_Stewer:OnSave()

end

function Quagmire_Stewer:OnLoad(data)
    if not data then return end
end

return Quagmire_Stewer
