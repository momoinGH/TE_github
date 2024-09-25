local componentPre = debug.getinfo(1, 'S').source:match("([^/]+)_consumable%.lua$") --当前文件前缀
local componentName = componentPre .. "_consumable"

local function DefaultTargetCheckFn(inst, doer, target)
    return doer == target
end

--- 通用消耗品组件，主客机通用组件
--- 该组件和trader组件功能有些重叠
local Consumable = Class(function(self, inst)
    self.inst = inst

    -- 3个限制
    inst:AddTag(componentName)                --根据标签判断是否可以消耗，默认可以
    self.userCheckFn = nil
    self.targetCheckFn = DefaultTargetCheckFn --默认只能自己用

    self.state = "domediumaction"             --使用执行的state，建议give/domediumaction
    self.str = nil
    self.extra_arrive_dist = nil

    if not TheWorld.ismastersim then return end

    self.onUseFn = nil  --使用时执行函数，必须赋值，道具的删除要在里面自己写
    self.useSound = nil --使用音效
end)

function Consumable:Use(doer, target)
    local status, msg
    if self.onUseFn then
        status, msg = self.onUseFn(self.inst, doer, target)
    else
        status, msg = false, "NOT_INIT" --不应该发生
    end

    if status and self.useSound then
        if doer and doer.SoundEmitter then
            doer.SoundEmitter:PlaySound(self.useSound)
        elseif self.inst.SoundEmitter then
            self.inst.SoundEmitter:PlaySound(self.useSound)
        end
    end

    return status, msg
end

return Consumable
