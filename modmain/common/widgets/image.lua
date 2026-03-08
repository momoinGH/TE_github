AddClassPostConstruct("widgets/image", function(self)
    Utils.FnDecorator(self, "SetTexture", function(atlas, tex, default_tex, ...)
        atlas = atlas or tex and GetInventoryItemAtlas(tex) or default_tex and GetInventoryItemAtlas(default_tex)
        return nil, false, { atlas, tex, default_tex, ... }
    end)
end)
