local DecoCreator = require "prefabs/deco_util"
local InteriorSpawnerUtils = require("interiorspawnerutils")

-- 构建后我需要根据所在墙面初始化bank和旋转方向
local function OnBuilt(inst)
    local bank = inst.AnimState:GetCurrentBankName()
    local side = InteriorSpawnerUtils.TestWallOrnamentPos(inst)

    if side == 1 or side == 3 then
        bank = bank .. "_side"
        if side == 3 then

        end
    end
end

-- 检查朝向生成对应的光线
local function SpawnLight(inst)
    local prefab = string.match(inst.prefab, "_backwall$") and "window_round_light_backwall" or "window_round_light"

    local light = SpawnPrefab(prefab)
    light.Transform:SetPosition(inst.Transform:GetWorldPosition())
    local scale = FunctionOrValue(inst.components.tropical_saveanim.scale, inst)
    if scale then
        light.AnimState:SetScale(unpack(scale))
    end
end

local function MasterInit(inst)
    inst:ListenForEvent("onbuilt", OnBuilt)

    inst:DoTaskInTime(0, SpawnLight)
end

local function MakeWindow(name, build, bank, anim)
    local data = {
        decal = true,
        loopanim = true,
        dayevents = true,
        background = 3,
        curtains = true,
        tags = { "NOBLOCK", "wallsection" },
        onbuilt = true,
        masterInit = MasterInit,
    }

    return DecoCreator:Create(name, build, bank, anim, data)
end

return
    MakeWindow("window_round", "interior_window", "interior_window_side", "day_loop"),
    MakeWindow("window_round_backwall", "interior_window", "interior_window", "day_loop"),
    MakeWindow("window_round_curtains_nails", "interior_window", "interior_window_side", "day_loop"),
    MakeWindow("window_round_curtains_nails_backwall", "interior_window", "interior_window", "day_loop"),
    MakeWindow("window_round_burlap", "interior_window_burlap", "interior_window_burlap_side", "day_loop"),
    MakeWindow("window_round_burlap_backwall", "interior_window_burlap", "interior_window_burlap", "day_loop"),
    MakeWindow("window_small_peaked", "interior_window_small", "interior_window_small_side", "day_loop"),
    MakeWindow("window_small_peaked_backwall", "interior_window_small", "interior_window_small", "day_loop"),
    MakeWindow("window_large_square", "interior_window_large", "interior_window_side", "day_loop"),
    MakeWindow("window_large_square_backwall", "interior_window_large", "interior_window", "day_loop"),
    MakeWindow("window_tall", "interior_window_tall", "interior_window_tall_side", "day_loop"),
    MakeWindow("window_tall_backwall", "interior_window_tall", "interior_window_tall", "day_loop"),
    MakeWindow("window_round_arcane", "window_arcane_build", "interior_window_large_side", "day_loop"),
    MakeWindow("window_round_arcane_backwall", "window_arcane_build", "interior_window_large", "day_loop"),
    MakeWindow("window_small_peaked_curtain", "interior_window_small", "interior_window_side", "day_loop"),
    MakeWindow("window_small_peaked_curtain_backwall", "interior_window_small", "interior_window", "day_loop"),
    MakeWindow("window_large_square_curtain", "interior_window_large", "interior_window", "day_loop"),
    MakeWindow("window_large_square_curtain_backwall", "interior_window_large", "interior_window_large", "day_loop"),
    MakeWindow("window_tall_curtain", "interior_window_tall", "interior_window_tall_side", "day_loop"),
    MakeWindow("window_tall_curtain_backwall", "interior_window_tall", "interior_window_tall", "day_loop"),
    MakeWindow("window_square_weapons", "window_weapons_build", "interior_window_large_side", "day_loop"),
    MakeWindow("window_square_weapons_backwall", "window_weapons_build", "interior_window_large", "day_loop"),
    -- 日光
    DecoCreator:Create("window_round_light", "interior_window", "interior_window_light_side", "day_loop",
        { loopanim = true, decal = true, light = true, dayevents = true, followlight = "natural", windowlight = true, dustzmod = 1.3, tags = { "NOBLOCK", "NOCLICK" } }),
    DecoCreator:Create("window_round_light_backwall", "interior_window", "interior_window_light", "day_loop",
        { loopanim = true, decal = true, light = true, dayevents = true, followlight = "natural", windowlight = true, dustxmod = 1.3, tags = { "NOBLOCK", "NOCLICK" } })
