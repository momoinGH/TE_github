-- 修改瓶中信内容，加入一些boss位置
AddComponentPostInit("messagebottlemanager", function(self)
    Hooks.FnDecorator(self, "UseMessageBottle", function(self, ...)
        if TheWorld.components.tro_messagebottlemanager then
            local pos = TheWorld.components.tro_messagebottlemanager:UseMessageBottle(...)
            if pos then
                return { pos }, true
            end
        end
    end)
end)
