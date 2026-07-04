-- 提供一个控制台面板，并且hook一些容易导致游戏崩溃的地方，让其只打印在屏幕上不崩溃

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"


local log_data = {}  -- 所有日志数据: { {text=, colour=}, ... }
local log_panel
local cache_log = {} --缓存的日志，等面板打开塞进去

local LogPanel = Class(Widget, function(self)
    Widget._ctor(self, "LogPanel")

    local w, h = TheSim:GetScreenSize()
    local res_scale = math.max(w / RESOLUTION_X, h / RESOLUTION_Y)

    self.panel_width = 500 * res_scale
    self.panel_height = 300 * res_scale
    self.font = DEFAULTFONT
    self.font_size = 20 * res_scale
    self.line_height = 24 * res_scale -- 默认行高
    self.padding = 8 * res_scale      -- 内边距
    self.max_lines = 200              -- 最大保留日志条数
    self.default_colour = { 1, 1, 1, 1 }
    self.scroll_per_click = 1         -- 每次滚轮滚动行数

    -- 平滑滚动：参考 ChatScrollList 的 current/target 机制
    self.current_scroll_pos = 0 -- 当前实际渲染位置
    self.target_scroll_pos = 0  -- 目标滚动位置

    -- 可见区域能容纳的行数
    self.visible_lines = math.floor((self.panel_height - self.padding * 2) / self.line_height)

    -- 背景
    self.bg = self:AddChild(Image("images/ui.xml", "black.tex"))
    self.bg:SetSize(self.panel_width, self.panel_height)
    self.bg:SetTint(0, 0, 0, 0.75)

    -- 裁剪容器，防止文本溢出面板
    self.scissor_root = self:AddChild(Widget("scissor_root"))
    self.scissor_root:SetScissor(
        -self.panel_width / 2,
        -self.panel_height / 2,
        self.panel_width,
        self.panel_height
    )

    -- 文本行容器（通过移动此容器实现平滑滚动）
    self.line_root = self.scissor_root:AddChild(Widget("line_root"))

    -- 预创建可见行的 Text 控件（多创建1行用于滚动过渡）
    self.line_widgets = {}
    for i = 1, self.visible_lines + 1 do
        local txt = self.line_root:AddChild(Text(self.font, self.font_size))
        txt:SetHAlign(ANCHOR_LEFT)
        txt:SetRegionSize(self.panel_width - self.padding * 2, self.line_height)
        local y = -self.panel_height / 2 + self.padding + (i - 1) * self.line_height + self.line_height / 2
        txt:SetPosition(0, y, 0)
        txt:SetString("")
        self.line_widgets[i] = txt
    end

    -- 关闭按钮（右上角）
    self.close_btn = self:AddChild(ImageButton("images/global_redux.xml", "close.tex"))
    self.close_btn:SetPosition(self.panel_width / 2 - 15, self.panel_height / 2 - 15, 0)
    self.close_btn:SetNormalScale(0.4 * res_scale)
    self.close_btn:SetFocusScale(0.45 * res_scale)
    self.close_btn:SetImageNormalColour(0.8, 0.8, 0.8, 1)
    self.close_btn:SetImageFocusColour(1, 1, 1, 1)
    self.close_btn:SetOnClick(function() self:Kill() end)

    -- 启动每帧更新（用于平滑滚动插值）
    self:StartUpdating()
end)

--- 每帧更新：平滑滚动插值（参考 ChatScrollList:OnUpdate）
function LogPanel:OnUpdate(dt)
    if self.current_scroll_pos == self.target_scroll_pos then
        return
    end

    -- 使用 Lerp 平滑过渡，差距很小时直接到位
    if math.abs(self.current_scroll_pos - self.target_scroll_pos) > 0.01 then
        self.current_scroll_pos = Lerp(self.current_scroll_pos, self.target_scroll_pos, 0.25)
    else
        self.current_scroll_pos = self.target_scroll_pos
    end

    self:RefreshView()
end

--- 处理控制输入（滚轮）
function LogPanel:OnControl(control, down)
    if LogPanel._base.OnControl(self, control, down) then return true end

    if down and self.focus then
        if control == CONTROL_SCROLLBACK then
            self:Scroll(self.scroll_per_click)
            return true
        elseif control == CONTROL_SCROLLFWD then
            self:Scroll(-self.scroll_per_click)
            return true
        end
    end

    return false
end

function LogPanel:OnGainFocus()
    LogPanel._base.OnGainFocus(self)
    -- 欺骗 DoCameraControl，让它以为制作菜单有焦点，从而跳过镜头缩放，或者hook playercontroller的DoCameraControl也能实现
    local hud = ThePlayer and ThePlayer.HUD
    if hud and hud.controls and hud.controls.craftingmenu then
        self._saved_craftingmenu_focus = hud.controls.craftingmenu.focus
        hud.controls.craftingmenu.focus = true
    end
end

function LogPanel:OnLoseFocus()
    LogPanel._base.OnLoseFocus(self)
    -- 恢复 craftingmenu 的焦点状态
    local hud = ThePlayer and ThePlayer.HUD
    if hud and hud.controls and hud.controls.craftingmenu and self._saved_craftingmenu_focus ~= nil then
        hud.controls.craftingmenu.focus = self._saved_craftingmenu_focus
        self._saved_craftingmenu_focus = nil
    end
end

--- 滚动指定行数（正数向下/新日志，负数向上/旧日志）
function LogPanel:Scroll(delta)
    local max_offset = math.max(0, #log_data - self.visible_lines)
    self.target_scroll_pos = math.clamp(self.target_scroll_pos + delta, 0, max_offset)
end

--- 滚动到最底部（最新日志）
function LogPanel:ScrollToBottom()
    self.target_scroll_pos = 0
    self.current_scroll_pos = 0
    self:RefreshView()
end

--- 滚动到最顶部（最旧日志）
function LogPanel:ScrollToTop()
    self.target_scroll_pos = math.max(0, #log_data - self.visible_lines)
end

--- 刷新显示（支持亚像素级平滑滚动）
function LogPanel:RefreshView()
    local total = #log_data
    -- current_scroll_pos 的整数部分 = 跳过的完整行数，小数部分 = 行内偏移
    local scroll_int = math.floor(self.current_scroll_pos)
    local scroll_frac = self.current_scroll_pos - scroll_int

    for i = 1, self.visible_lines + 1 do
        local widget = self.line_widgets[i]
        -- 从底部开始：第1个widget显示最新的（考虑滚动偏移）
        local data_index = total - scroll_int - (i - 1)
        if data_index >= 1 and data_index <= total then
            local entry = log_data[data_index]
            widget:SetString(entry.text)
            widget:SetColour(unpack(entry.colour))
            widget:Show()
        else
            widget:SetString("")
            widget:Hide()
        end
    end

    -- 通过移动 line_root 实现小数部分的平滑偏移
    self.line_root:SetPosition(0, -scroll_frac * self.line_height, 0)
end

--- 添加一条日志消息（核心接口）
-- @param text 日志文本
-- @param colour 颜色表（可选），如 {1, 0, 0, 1} 表示红色
function LogPanel:AddMessage(text, colour)
    colour = colour or self.default_colour
    local str = tostring(text)

    -- 利用临时 Text 控件将长文本按面板宽度自动拆行（参考官方 SplitMultilineString）
    local max_width = self.panel_width - self.padding * 2
    local temp = Text(self.font, self.font_size)
    temp:SetMultilineTruncatedString(str, 100, max_width, nil, false)
    local wrapped = temp:GetString()
    temp:Kill()

    local lines = wrapped:split("\n")
    if lines == nil or #lines == 0 then
        lines = { str }
    end

    for _, line in ipairs(lines) do
        table.insert(log_data, {
            text = line,
            colour = colour,
        })
    end

    -- 超过最大行数时移除最旧的
    while #log_data > self.max_lines do
        table.remove(log_data, 1)
        if self.target_scroll_pos > 0 then
            self.target_scroll_pos = self.target_scroll_pos - 1
            self.current_scroll_pos = math.max(0, self.current_scroll_pos - 1)
        end
    end

    -- 如果用户没有在翻旧日志，自动滚动到底部
    if self.target_scroll_pos == 0 then
        self:RefreshView()
    else
        -- 用户在看旧日志，不打扰，但偏移+1保持视角不变
        self.target_scroll_pos = self.target_scroll_pos + 1
        self.current_scroll_pos = self.current_scroll_pos + 1
        local max_offset = math.max(0, #log_data - self.visible_lines)
        self.target_scroll_pos = math.min(self.target_scroll_pos, max_offset)
        self.current_scroll_pos = math.min(self.current_scroll_pos, max_offset)
    end
end

--- 清空所有日志
function LogPanel:Clear()
    log_data = {}
    self.target_scroll_pos = 0
    self.current_scroll_pos = 0
    self:RefreshView()
end

--- 获取当前日志条数
function LogPanel:GetMessageCount()
    return #log_data
end

--- 设置面板背景透明度
function LogPanel:SetBackgroundAlpha(alpha)
    self.bg:SetTint(0, 0, 0, alpha)
end

function LogPanel:Kill()
    log_panel = nil
    self:OnLoseFocus()
    LogPanel._base.Kill(self)
end

----------------------------------------------------------------------------------------------------

local function ToggleLogPanel()
    -- 如果面板已存在，关闭它
    if log_panel then
        log_panel:Kill()
        log_panel = nil
        return
    end

    if not ThePlayer then
        return
    end

    -- 创建面板
    log_panel = ThePlayer.HUD:AddChild(LogPanel())
    local w, h = TheSim:GetScreenSize()
    log_panel:SetPosition(w / 2, h / 2, 0)
    log_panel:ScrollToBottom() -- 刷新显示已有日志
    for _, data in ipairs(cache_log) do
        log_panel:AddMessage(data.msg, data.color)
    end
    cache_log = {}
end

-- 开发环境下才能打开面板
TheInput:AddKeyDownHandler(KEY_F11, function()
    ToggleLogPanel()
end)

-- 刚进游戏如果有报错自动打开面板
AddPrefabPostInit("world", function(inst)
    inst:DoTaskInTime(3, function()
        if #cache_log > 0 and not log_panel then
            ToggleLogPanel()
        end
    end)
end)

----------------------------------------------------------------------------------------------------
local function ClientShowLog(msg, level)
    -- 在日志面板显示
    local color = { 1, 0, 0, 1 }
    if level == "info" then
        color = nil
    elseif level == "warn" then
        color = { 1, 1, 0, 1 }
    end
    if log_panel then
        log_panel:AddMessage(msg, color)
    else
        table.insert(cache_log, { msg = msg, color = color })
    end

    --公告提示一下
    if ChatHistory then
        ChatHistory:SendCommandResponse(msg)
    end
end

AddClientModRPCHandler("TE", "LogToClient", function(msg, level)
    if msg then
        ClientShowLog(msg, level)
    end
end)

---错误处理
---@param msg string 错误消息
---@param has_trace boolean 是否打印堆栈，默认true
OnTroErrorHandle = function(msg, has_trace, level)
    if TheWorld and TheWorld.ismastersim then
        SendModRPCToClient(GetClientModRPC("TE", "LogToClient"), nil, msg, level) -- 发到本地去
        return
    end

    ClientShowLog(msg, level)
end


----------------------------------------------------------------------------------------------------
-- 防止一些报错导致游戏崩溃，仅打印就行了

local OldDoTaskInTime = EntityScript.DoTaskInTime
function EntityScript:DoTaskInTime(time, fn, ...)
    local new_fn = function(inst, ...)
        local success, err = pcall(fn, inst, ...)
        if not success then
            TroErrorHandle(err, false)
            StackTraceToLog()
        end
    end
    return OldDoTaskInTime(self, time, new_fn, ...)
end

local OldDoPeriodicTask = EntityScript.DoPeriodicTask
function EntityScript:DoPeriodicTask(time, fn, initialdelay, ...)
    local new_fn = function(inst, ...)
        local success, err = pcall(fn, inst, ...)
        if not success then
            TroErrorHandle(err, false)
            StackTraceToLog()
        end
    end
    return OldDoPeriodicTask(self, time, new_fn, initialdelay, ...)
end

local OldPushEvent_Internal = EntityScript.PushEvent_Internal
function EntityScript:PushEvent_Internal(event, data, immediate)
    local success, err = pcall(OldPushEvent_Internal, self, event, data, immediate)
    if not success then
        TroErrorHandle(err, false)
        StackTraceToLog()
    end
end

for action_id, data in pairs(ACTIONS) do
    local old_fn = data.fn
    data.fn = function(...)
        local results = { pcall(old_fn, ...) }
        if not results[1] then
            TroErrorHandle(results[2], false)
            StackTraceToLog()
        else
            return unpack(results, 2)
        end
    end
end

local can_zero_prefabs = {
    roottrunk = true
}

local OldSpawnPrefabFromSim = SpawnPrefabFromSim
GLOBAL.SpawnPrefabFromSim = function(name, ...)
    local success, err = pcall(OldSpawnPrefabFromSim, name, ...)
    if not success then
        TroErrorHandle(err, false)
        StackTraceToLog()
        return
    end

    local guid = err
    if guid == -1 then
        TroErrorHandle(string.trofmt("错误：预制件{}生成失败", name), false, "warn")
    elseif TheWorld and TheWorld.ismastersim then
        -- 主机预制件坐标检查
        local ent = Ents[guid]
        if ent and ent.prefab
            and ent.Transform
            and ent.AnimState --看得见的
            and not can_zero_prefabs[ent.prefab]
        then
            ent:DoTaskInTime(0, function()
                local x, y, z = ent.Transform:GetWorldPosition()
                if x == 0 and y == 0 and z == 0
                    and not ent:HasTag("INLIMBO") --没有被隐藏
                then
                    TroErrorHandle(string.trofmt("预制件{}坐标在零点，是不是忘了初始化了？", ent), false, "warn")
                end
            end)
        end
    end
    return guid
end

require("stategraph")
local OldGoToState = StateGraphInstance.GoToState
function StateGraphInstance:GoToState(statename, ...)
    local success, err = pcall(OldGoToState, self, statename, ...)
    if not success then
        TroErrorHandle(err, false)
        StackTraceToLog()
    end
end

local OldUpdateState = StateGraphInstance.UpdateState
function StateGraphInstance:UpdateState(dt)
    local success, err = pcall(OldUpdateState, self, dt)
    if not success then
        TroErrorHandle(err, false)
        StackTraceToLog()
    end
end

-- 检查保存数据中是否有不合法对象
local function CheckData(self, data)
    for k, v in pairs(data) do
        if EntityScript.is_instance(k) or EntityScript.is_instance(v) then
            TroErrorHandle(string.trofmt("你不能直接保存一个实体对象{}, {}, {}", self, k, v), true)
            StackTraceToLog()
        end
        if type(k) == "userdata" or type(v) == "userdata" then
            TroErrorHandle(string.trofmt("你不能直接保存一个userdata对象{}, {}, {}", self, k, v), true)
            StackTraceToLog()
        end
        if type(k) == "table" then
            CheckData(self, k)
        end
        if type(v) == "table" then
            CheckData(self, v)
        end
    end
end

local OldGetPersistData = EntityScript.GetPersistData
function EntityScript:GetPersistData()
    local data, references = OldGetPersistData(self)
    if data then
        CheckData(self, data)
    end
    return data, references
end
