--- 哈姆雷特居民
local HamletCivilized = Class(function(self, inst)
    self.inst = inst


end)


function HamletCivilized:OnSave()
    return {
    }
end

function HamletCivilized:OnLoad(data)
    if not data then return end


end

return HamletCivilized
