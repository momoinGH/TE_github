AddComponentPostInit("oar", function(self, inst)
    inst:AddTag("oar") --科雷真抠门，桨连个自己的标签也没有，客户端需要知道玩家是否装备了桨
    Utils.FnDecorator(self, "OnRemoveFromEntity", function(self)
        self.inst:RemoveTag("oar")
    end)
end)
