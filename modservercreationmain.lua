GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- 预加载的资源，在世界生成设置界面显示图片
FrontEndAssets = {
    Asset("ATLAS", "images/scrapbook_tropical/scrapbook_hamlet.xml")
}
ReloadFrontEndAssets()
