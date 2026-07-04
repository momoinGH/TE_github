modimport "modmain/common/stategraphs/SGwilson"
modimport "modmain/common/stategraphs/SGwilson_client"

-- 我希望海浪翻滚动画循环播放
AddStategraphPostInit("wave", function(sg)
    Hooks.FnDecorator(sg.states["idle"], "onenter", nil, function(retTab, inst)
        if inst.AnimState:IsCurrentAnimation("idle") then
            inst.AnimState:PlayAnimation("idle", true)
        end
    end)
end)
