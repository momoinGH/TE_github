local DecoCreator = require "prefabs/deco_util"
local InteriorSpawnerUtils = require("interiorspawnerutils")

-- 贴纸构建后我需要根据所在墙面初始化bank和旋转方向
local function OnBuilt(inst)
    local bank = inst.AnimState:GetCurrentBankName()
    local side = InteriorSpawnerUtils.TestWallOrnamentPos(inst)

    if side == 1 or side == 3 then
        inst.initData = {
            animdata = {
                bank = (side == 1 or side == 3) and bank .. "_side" or nil,
                flip = side == 3 or nil
            }
        }
        InteriorSpawnerUtils.InitHouseInteriorPrefab(inst, inst.initData)
    end
end

local function MasterInit(inst)
    inst:ListenForEvent("onbuilt", OnBuilt)
end

local function MakeWallOrnament(name, anim)
    return DecoCreator:Create(name, "interior_wallornament", "interior_wallornament", anim,
        { decal = true, tags = { "wallsection", "NOBLOCK" }, onbuilt = true, masterInit = MasterInit })
end

return
    MakeWallOrnament("deco_wallornament_photo", "photo"),
    MakeWallOrnament("deco_wallornament_fulllength_mirror", "fulllength_mirror"),
    MakeWallOrnament("deco_wallornament_embroidery_hoop", "embroidery_hoop"),
    MakeWallOrnament("deco_wallornament_mosaic", "mosaic"),
    MakeWallOrnament("deco_wallornament_wreath", "wreath"),
    MakeWallOrnament("deco_wallornament_axe", "axe"),
    MakeWallOrnament("deco_wallornament_hunt", "hunt"),
    MakeWallOrnament("deco_wallornament_periodic_table", "periodic_table"),
    MakeWallOrnament("deco_wallornament_gears_art", "gears_art"),
    MakeWallOrnament("deco_wallornament_cape", "cape"),
    MakeWallOrnament("deco_wallornament_no_smoking", "no_smoking"),
    MakeWallOrnament("deco_wallornament_black_cat", "black_cat"),
    MakeWallOrnament("deco_antiquities_beefalo", "beefalo"),
    MakeWallOrnament("deco_antiquities_wallfish", "fish")
