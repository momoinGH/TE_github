local Utils = require "tropical_utils/utils"

AddClassPostConstruct("widgets/image", function(self)
    Utils.FnDecorator(self, "SetTexture", function(atlas, tex, default_tex)
        return nil, false, {atlas or tex and GetInventoryItemAtlas(tex) or
                            default_tex and GetInventoryItemAtlas(default_tex),
                            tex, default_tex}
    end)
end)