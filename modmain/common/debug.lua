local is_print_click_actions = false

-- 打印左键和右键的Action，本地执行
GLOBAL.c_setprintclickactions = function(is_print)
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
    Hooks.FnDecorator(self, "GetLeftClickActions", nil, function(retTab, self, position, target)
        if not is_print_click_actions then
            return retTab
        end

        print("左键Action，" .. PrintActions(retTab, self, target))
        return retTab
    end)
    Hooks.FnDecorator(self, "GetRightClickActions", nil, function(retTab, self, position, target, spellbook)
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

GLOBAL.c_testanim = function(anim, loop)
    ThePlayer.AnimState:PlayAnimation(anim, loop)
end

GLOBAL.c_gotopoint = function()
    local pos = ConsoleWorldPosition()
    ThePlayer.Transform:SetPosition(pos.x, pos.y, pos.z)
end

----------------------------------------------------------------------------------------------------
local is_show_prefab_details = false

-- 显示鼠标处实体的详细信息
GLOBAL.c_setshowprefabdetails = function(is_show)
    is_show_prefab_details = is_show
end

local function GetBuild(inst)
    local strnn = ""
    local str = inst.entity:GetDebugString()

    if not str then
        return nil
    end
    local bank, build, anim = str:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")

    if bank ~= nil and build ~= nil then
        strnn = strnn .. "动画bank: anim/" .. bank .. ".zip"
        strnn = strnn .. "\n" .. "贴图build: anim/" .. build .. ".zip"
    end
    return strnn
end


AddClassPostConstruct("widgets/hoverer", function(self)
    local old_SetString = self.text.SetString
    self.text.SetString = function(text, str, ...)
        if not is_show_prefab_details then
            return old_SetString(text, str, ...)
        end

        local target = TheInput:GetHUDEntityUnderMouse()
        if target ~= nil then
            target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
        else
            target = TheInput:GetWorldEntityUnderMouse()
        end
        if target and target.entity ~= nil then
            if target.prefab ~= nil then
                str = str .. "\n" .. "代码:" .. target.prefab
            end
            local build = GetBuild(target)
            if build ~= nil then
                str = str .. "\n" .. build
            end
            local skin = target:GetSkinName(target)
            if skin ~= nil then
                str = str .. "\n" .. "皮肤:" .. skin
            end

            local skinid = target.skin_id
            if skinid ~= nil then
                str = str .. "\n" .. "皮肤ID:" .. skinid
            end
        end
        return old_SetString(text, str, ...)
    end
end)

----------------------------------------------------------------------------------------------------

local profiler = nil
-- 开启和关闭性能分析，可以打印开启期间所调用函数的执行时间，用来检查哪里造成了卡顿
GLOBAL.c_setprofile = function(enable)
    if (enable or false) == (profiler ~= nil) then
        return
    end

    require("profiler")
    if enable then
        profiler = newProfiler()
        profiler:start()
    else
        profiler:stop()

        local tmp = {}
        profiler:lua_report(tmp)
        print("性能分析日志打印开始")
        for k, v in pairs(tmp) do
            print(k, v)
        end
        print("性能分析日志打印结束")
        profiler = nil
    end
end

----------------------------------------------------------------------------------------------------
-- 玩家地图右键传送
local map_right_teleport = true --默认开启
GLOBAL.c_setmaprightteleport = function(enable)
    map_right_teleport = enable or false
end
AddModRPCHandler(modname, "DebugMapTeleport", function(player, x, z)
    if map_right_teleport and type(x) == "number" and type(z) == "number" and player.Physics then
        player.Physics:Teleport(x, 0, z)
    end
end)

TheInput:AddMouseButtonHandler(function(button, down)
    if not map_right_teleport then
        return
    end
    if not (not down and button == MOUSEBUTTON_RIGHT and TheFrontEnd and ThePlayer and ThePlayer.HUD:IsMapScreenOpen()) then
        return
    end

    local mapscreen = TheFrontEnd:GetActiveScreen()
    local x, y, z = mapscreen:GetWorldPositionAtCursor()
    TheFrontEnd:PopScreen()
    c_announce("（debug指令）玩家地图传送：" .. tostring(x) .. "," .. tostring(z))
    SendModRPCToServer(MOD_RPC[modname]["DebugMapTeleport"], x, z)
end)

----------------------------------------------------------------------------------------------------
local last_teleport_node_id = nil
-- 传送到指定标签的区域，可以用来判断有没有生成某个区域
GLOBAL.c_teleportareahastag = function(tag)
    node_id = nil
    for id, node in pairs(TheWorld.topology.nodes) do
        if node.tags and table.contains(node.tags, tag) then
            node_id = id
            if last_teleport_node_id ~= id then
                break --不是上一个，直接返回
            end
        end
    end

    last_teleport_node_id = node_id
    if node_id then
        local ct = TheWorld.topology.nodes[node_id].cent
        ThePlayer.Physics:Teleport(ct[1], 0, ct[2])
    else
        c_announce("未找到指定标签" .. tostring(tag) .. "的区域")
        print("未找到指定标签" .. tostring(tag) .. "的区域")
    end
end

----------------------------------------------------------------------------------------------------
-- 打印鼠标位置的地皮
GLOBAL.c_printtile = function()
    local tile_id = TheWorld.Map:GetTileAtPoint(ConsoleWorldPosition():Get())
    for k, v in pairs(WORLD_TILES) do
        if v == tile_id then
            print(k, v)
        end
    end
end

----------------------------------------------------------------------------------------------------

-- 如果c_goto参数是数字先检查是不是实体id
Hooks.FnDecorator(GLOBAL, "c_goto", function(dest, inst, ...)
    if type(dest) == "number" and Ents[dest] then
        return nil, false, { dest, inst, ... }
    end
end)
