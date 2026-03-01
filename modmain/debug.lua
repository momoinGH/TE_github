local Utils = require("tropical_utils/utils")

local is_print_click_actions = false
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
