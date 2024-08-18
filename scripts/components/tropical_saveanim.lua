--- 保存动画数据并在加载时重新设置
--- data属性会在保存时一起保存，因此可便捷的保存一些简单的额外变量，加载后也能获取
local SaveAnim = Class(function(self, inst)
    self.inst = inst

    self.bank = nil
    self.build = nil
    self.anim = nil
    self.scale = nil
    self.isloopplay = nil
    self.isdelayset = nil
    self.rotation = nil

    self.onSet = nil
end)

function SaveAnim:ReSet()
    local inst = self.inst
    if inst.AnimState then
        if self.bank then
            inst.AnimState:SetBank(FunctionOrValue(self.bank, self.inst))
        end
        if self.build then
            inst.AnimState:SetBuild(FunctionOrValue(self.build, self.inst))
        end
        if self.anim then
            inst.AnimState:PlayAnimation(FunctionOrValue(self.anim, self.inst), self.isloopplay)
        end
        if self.scale then
            inst.AnimState:SetScale(unpack(FunctionOrValue(self.scale, self.inst)))
        end
    end
    if inst.Transform then
        if self.rotation then
            inst.Transform:SetRotation(FunctionOrValue(self.rotation, self.inst))
        end
    end

    if self.onSet then
        self.onSet(inst)
    end
end

--- 初始化
function SaveAnim:Init(bank, build, anim, scale, isloopplay, isdelayset, rotation, onSet)
    self.bank = bank
    self.build = build
    self.anim = anim
    self.scale = scale
    self.isloopplay = isloopplay
    self.isdelayset = isdelayset
    self.rotation = rotation
    self.onSet = onSet
    self:ReSet()
end

function SaveAnim:OnSave()
    return {
        bank = self.bank,
        build = self.build,
        anim = self.anim,
        scale = self.scale,
        isloopplay = self.isloopplay,
        isdelayset = self.isdelayset,
        rotation = self.rotation
    }
end

function SaveAnim:OnLoad(data)
    if not data then return end

    self.bank = data.bank
    self.build = data.build
    self.anim = data.anim
    self.scale = data.scale
    self.isloopplay = data.isloopplay
    self.isdelayset = data.isdelayset
    self.rotation = data.rotation

    if self.isdelayset then
        self.inst:DoTaskInTime(0, function() self:ReSet() end)
    else
        self:ReSet()
    end
end

return SaveAnim
