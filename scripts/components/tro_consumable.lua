local componentPre = debug.getinfo(1, 'S').source:match("([^/]+)_consumable%.lua$") --当前文件前缀
local componentName = componentPre .. "_consumable"

local function DefaultTargetCheckFn(inst, doer, target)
    return doer == target
end

--- 通用消耗品组件，主客机通用组件
--- 该组件和trader组件功能有些重叠，两者的区别在于trader组件功能强大，但是不够灵活，比如trader必须在给予方添加tradable组件，不能修改动作，
--      一次只能给一个，不能在客机拦截显示，tradable的东西对所有trader的东西都能互动，即便有时候不想显示文本也不行，也不能修改显示的文本，
--      trader是站在被给予方进行判断的，该组件是站在给予方进行判断的
--- 该组件也有缺点，必须在主客机添加并分别配置，功能单一，有时候想站在被给予方进行判断会比较麻烦，比如让肉类可与一个建筑互动，就得给所有有
--      肉类标签的对象添加组件并判断（虽然trader也类似，不过判断方是建筑）
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
