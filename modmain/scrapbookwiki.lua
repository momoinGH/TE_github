---用图鉴的形式展示wiki，一般来说只在最开始的时候调用一次，调用该方法需要设置env
---实现该功能不得不覆盖了ScrapbookScreen的MakeSideBar方法，追加图鉴分类，这导致以后可能需要维护

table.insert(Assets, Asset("ANIM", "anim/pigman_tribe.zip")) --图鉴wiki默认动画


WIKI_DATA = {}                    --配置
troimportmodulefile("modwiki")
local scrapbook_type = "tropical" --新增的图鉴分类，建议与mod名保持一致，需要初始化STRINGS.SCRAPBOOK.CATS.XXX变量，XXX是这里的key大写形式


RegisterScrapbookIconAtlas("images/inventoryimages3.xml", "unknown_hand.tex")
-- 添加分类
table.insert(SCRAPBOOK_CATS, scrapbook_type)


-- 设置数据
local dataset = require("screens/redux/scrapbookdata")
for key, d in pairs(WIKI_DATA) do
    dataset[key] = d

    -- 偷个懒，设置默认值
    d.type = scrapbook_type
    d.name = d.name or key
    d.specialinfo = d.specialinfo or string.upper(key)
    d.prefab = d.prefab or key
    d.build = d.build or ""
    d.bank = d.bank or ""
    d.anim = d.anim or ""
    d.tex = d.tex or "unknown_hand.tex"

    -- 图鉴图标
    if d.atlas then
        RegisterScrapbookIconAtlas(d.atlas, d.tex)
    end
end

-- 追加图鉴分类
local ScrapbookScreen = require("screens/redux/scrapbookscreen")
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local PANEL_HEIGHT = 530
Hooks.FnDecorator(ScrapbookScreen, "MakeSideBar", nil, function(retTab, self)
    local colors = {
        { 114 / 255, 56 / 255, 56 / 255 },
        { 111 / 255, 85 / 255, 47 / 255 },
        { 137 / 255, 126 / 255, 89 / 255 },
        { 95 / 255, 123 / 255, 87 / 255 },
        { 113 / 255, 127 / 255, 126 / 255 },
        { 74 / 255, 84 / 255, 99 / 255 },
        { 79 / 255, 73 / 255, 107 / 255 },
    }

    local button = { name = scrapbook_type, filter = scrapbook_type }
    local index = #self.menubuttons + 1 --索引

    local idx = index % #colors
    if idx == 0 then idx = #colors end
    button.color = colors[idx]


    local buttonwidth = 252 / 2.2  --75
    local buttonheight = 112 / 2.2 --30
    local totalheight = PANEL_HEIGHT - 100

    local MakeButton = function(idx, data)
        local y = totalheight / 2 - ((totalheight / 7) * idx - 1) + 50

        local buttonwidget = self.root:AddChild(Widget())

        local button = buttonwidget:AddChild(ImageButton("images/scrapbook.xml", "tab.tex"))
        button:ForceImageSize(buttonwidth, buttonheight)
        button.scale_on_focus = false
        button.basecolor = { data.color[1], data.color[2], data.color[3] }
        button:SetImageFocusColour(math.min(1, data.color[1] * 1.2), math.min(1, data.color[2] * 1.2),
            math.min(1, data.color[3] * 1.2), 1)
        button:SetImageNormalColour(data.color[1], data.color[2], data.color[3], 1)
        button:SetImageSelectedColour(data.color[1], data.color[2], data.color[3], 1)
        button:SetImageDisabledColour(data.color[1], data.color[2], data.color[3], 1)
        button:SetOnClick(function()
            self:SelectSideButton(data.filter)
            self.current_dataset = self:CollectType(dataset, data.filter)
            self.current_view_data = self:CollectType(dataset, data.filter)
            self:SetGrid()
        end)

        buttonwidget.focusimg = button:AddChild(Image("images/scrapbook.xml", "tab_over.tex"))
        buttonwidget.focusimg:ScaleToSize(buttonwidth, buttonheight)
        buttonwidget.focusimg:SetClickable(false)
        buttonwidget.focusimg:Hide()

        buttonwidget.selectimg = button:AddChild(Image("images/scrapbook.xml", "tab_selected.tex"))
        buttonwidget.selectimg:ScaleToSize(buttonwidth, buttonheight)
        buttonwidget.selectimg:SetClickable(false)
        buttonwidget.selectimg:Hide()

        buttonwidget:SetOnGainFocus(function()
            buttonwidget.focusimg:Show()
        end)
        buttonwidget:SetOnLoseFocus(function()
            buttonwidget.focusimg:Hide()
        end)

        local text = button:AddChild(Text(HEADERFONT, 12, STRINGS.SCRAPBOOK.CATS[string.upper(data.name)],
            UICOLOURS.WHITE))
        text:SetPosition(10, -8)
        buttonwidget:SetPosition(522 + buttonwidth / 2, y)

        local total = 0
        local count = 0
        for i, set in pairs(dataset) do
            if set.type == data.filter then
                total = total + 1
                if set.knownlevel > 0 then
                    count = count + 1
                end
            end
        end
        if total > 0 then
            local percent = (count / total) * 100
            if percent < 1 then
                percent = math.floor(percent * 100) / 100
            else
                percent = math.floor(percent)
            end

            local progress = buttonwidget:AddChild(Text(HEADERFONT, 18, percent .. "%", UICOLOURS.GOLD))
            progress:SetPosition(15, 17)
        end

        buttonwidget.newcreatures = {}

        buttonwidget.flash = buttonwidget:AddChild(UIAnim())
        buttonwidget.flash:GetAnimState():SetBank("cookbook_newrecipe")
        buttonwidget.flash:GetAnimState():SetBuild("cookbook_newrecipe")
        buttonwidget.flash:GetAnimState():PlayAnimation("anim", true)
        buttonwidget.flash:GetAnimState():SetScale(0.15, 0.15, 0.15)
        buttonwidget.flash:SetPosition(40, 0, 0)
        buttonwidget.flash:Hide()
        buttonwidget.flash:SetClickable(false)

        buttonwidget.filter = data.filter
        buttonwidget.focus_forward = button

        table.insert(self.menubuttons, buttonwidget)
    end

    MakeButton(index, button)
end)

Hooks.FnDecorator(ScrapbookScreen, "SetPlayerKnowledge", nil, function()
    for _, d in pairs(WIKI_DATA) do
        d.knownlevel = 2 --默认解锁
    end
end)