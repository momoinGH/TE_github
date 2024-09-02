-- TODO 虚空小地图，还没写，示例代码先放这里

GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })


-- 获取所有预制件对象的小地图图标，变量为_map_icon
-- _map_icon只赋值一次，避免二次调用SetIcon影响其他inst，因此只能获取第一次设置的图片名
-- 只对主客机公共区域添加小地图图标、AddMiniMapEntity和SetIcon之间没有创建其他预制件对象的预制件有效，也不支持中途修改图标
-- 所有对象entity和MiniMapEntity的元表都是共用的，因此获取一次就行了，第一次获取的才是初始的函数，也避免了层层包装的导致inst值不正确
local OldAddMiniMapEntity, OldSetIcon
Utils.FnDecorator(GLOBAL, "CreateEntity", nil, function(retTab, name)
    local inst = retTab[1]

    if not OldAddMiniMapEntity then
        OldAddMiniMapEntity = getmetatable(inst.entity).__index["AddMiniMapEntity"]
    end

    getmetatable(inst.entity).__index["AddMiniMapEntity"] = function(self, ...)
        local MiniMapEntity = OldAddMiniMapEntity(self, ...)
        if not OldSetIcon then
            OldSetIcon = getmetatable(MiniMapEntity).__index["SetIcon"]
        end
        getmetatable(MiniMapEntity).__index["SetIcon"] = function(self, icon, ...)
            if inst.MiniMapEntity and inst.MiniMapEntity == self then --以防在AddMiniMapEntity和SetIcon之间又创建其他有小地图图标的预制件对象
                inst._map_icon = inst._map_icon or icon               --只赋值一次
            end
            return OldSetIcon(self, icon, ...)
        end

        return val
    end

    return retTab
end)

----------------------------------------------------------------------------------------------------

PrefabFiles = {
}

Assets = {
    Asset("ATLAS", "levels/textures/tro_map_interior/exit.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/frame.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_antcave_floor.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_floor_marble_royal.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_ruins_slab.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_vamp_cave_noise.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/passage_blocked.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/passage_unknown.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/passage.xml"),
}

modimport "modmain/minimap"

local Image = require "widgets/image"

local function AppendRoomTexture(self)
    for i = -1, 1 do
        for j = -1, 1 do
            local floor = self:AddChild(Image("levels/textures/tro_map_interior/mini_ruins_slab.xml",
                "mini_ruins_slab.tex"))
            floor:SetHAnchor(ANCHOR_MIDDLE)
            floor:SetVAnchor(ANCHOR_MIDDLE)
            floor:SetPosition(i * 64, j * 64)
            floor:SetScale(1.02, 1.02, 1) --不放大一点儿中间有缝
            table.insert(self.houseimags, floor)
        end
    end
    local frame = self:AddChild(Image("levels/textures/tro_map_interior/frame.xml", "frame.tex"))
    frame:SetHAnchor(ANCHOR_MIDDLE)
    frame:SetVAnchor(ANCHOR_MIDDLE)
    -- frame.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)
    table.insert(self.houseimags, frame)
end

AddClassPostConstruct("widgets/mapwidget", function(self)
    self.houseimags = {}

    function self:UpdateTexture()
        print("更新一次")

        for _, v in ipairs(self.houseimags) do
            v:Kill()
        end

        AppendRoomTexture(self)
    end
end)

-- local function SetIcon(self, icon)

-- end

-- local MyMiniMapEntity = require("MyMiniMapEntity")


-- inst.MiniMap:AddAtlas(resolvefilepath("minimap/minimap_data1.xml"))
-- inst.MiniMap:AddAtlas(resolvefilepath("minimap/minimap_data2.xml"))
-- for _, atlases in ipairs(ModManager:GetPostInitData("MinimapAtlases")) do
--     for _, path in ipairs(atlases) do
--         inst.MiniMap:AddAtlas(resolvefilepath(path))
--     end
-- end


-- minimap/minimap_data2.xml
-- grass.png






-- TheFrontEnd:PopScreen();
-- local mapwidget = TheFrontEnd:GetActiveScreen().minimap;
-- local Image = require "widgets/image";
-- mapwidget.grass = mapwidget:AddChild(Image("levels/textures/tropical_map_interior/mini_ruins_slab.xml",
--     "mini_ruins_slab.tex"));
-- mapwidget.grass:SetHAnchor(ANCHOR_MIDDLE);
-- mapwidget.grass:SetVAnchor(ANCHOR_MIDDLE);
-- mapwidget.grass.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive);

-- - 拿到所有预制件的小地图图片
-- - 准备所有小房子地板的低分辨率图片
-- - 摆放图片
-- - 处理缩放、拖动、每个房子相对位置的逻辑
