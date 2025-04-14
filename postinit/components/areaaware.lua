-- 用于控制熊大和巨鹿刷新条件，组件没有可以hook的方法，只好通过该方式来阻止生成
local Utils = require("tropical_utils/utils")

local function AreaAwareCurrentlyInTagBefore(self, tag)
    if tag == "nohasslers" and (
            self:CurrentlyInTag("shipwrecked")
            or self:CurrentlyInTag("hamlet")
            or self:CurrentlyInTag("frost")
        )
    then
        return { true }, true
    end
end

AddComponentPostInit("areaaware", function(self)
    Utils.FnDecorator(self, "CurrentlyInTag", AreaAwareCurrentlyInTagBefore)
end)