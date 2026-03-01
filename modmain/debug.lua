local Utils = require("tropical_utils/utils")

local is_print_click_actions = false

-- 打印左键和右键的Action，本地执行
GLOBAL.c_printclickactions = function(is_print)
    is_print_click_actions = is_print
end

local function PrintActions(retTab, self, target)
    local actions = retTab[1]
    local s = "目标：" .. tostring(target) .. ", Action列表："
    if #actions > 0 then
        for _, buf in ipairs(actions) do
            s = s .. tostring(buf.action.id) .. ", "
        end
    else
        s = s .. "空"
    end
    return s
end

AddComponentPostInit("playeractionpicker", function(self)
    Utils.FnDecorator(self, "GetLeftClickActions", nil, function(retTab, self, position, target)
        if not is_print_click_actions then
            return retTab
        end

        print("左键Action，" .. PrintActions(retTab, self, target))
        return retTab
    end)
    Utils.FnDecorator(self, "GetRightClickActions", nil, function(retTab, self, position, target, spellbook)
        if not is_print_click_actions then
            return retTab
        end

        print("右键Action，" .. PrintActions(retTab, self, target))
        return retTab
    end)
end)


--- 判断鼠标对象有没有指定标签
GLOBAL.c_hastag = function(tag)
    print(c_select():HasTag(tag))
end

--- 打印鼠标对象的当前状态
GLOBAL.c_ptstate = function()
    local bu = ThePlayer:GetBufferedAction()
    print(ThePlayer.sg.currentstate.name)
    print(bu, bu and bu.action and bu.action.id)
end

-- 测试音频
GLOBAL.c_testsound = function(sound)
    ThePlayer.SoundEmitter:PlaySound(sound)
end
