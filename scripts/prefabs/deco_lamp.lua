local DecoCreator = require "prefabs/deco_util"

local function CoomonInit(inst)
    inst.AnimState:SetMultColour(.7, .7, .7, 1)

    inst:AddTag("structure")
    inst:AddTag("lamp")

    MakeSnowCoveredPristine(inst)
end

local function OnBuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/mushroom_lamp/craft_1")
end

local function OnSave(inst, data)
    data.playercrafted = inst:HasTag("playercrafted") or nil
end

local function OnLoad(inst, data)
    if not data then return end
    if data.playercrafted then
        inst:AddTag("playercrafted")
    end
end

local function MasterInit(inst)
    MakeSmallPropagator(inst)
    MakeHauntableWork(inst)
    MakeSnowCovered(inst)

    inst:ListenForEvent("onbuilt", OnBuilt)

    inst.OnSvae = OnSave
    inst.OnLoad = OnLoad
end

-- 这里把灯的亮度级别都从SMALL改为GENERAL
return
    DecoCreator:Create("deco_lamp_fringe", "interior_floorlamp", "interior_floorlamp", "floorlamp_fringe", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_stainglass", "interior_floorlamp", "interior_floorlamp", "floorlamp_stainglass", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_downbridge", "interior_floorlamp", "interior_floorlamp", "floorlamp_downbridge", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_2embroidered", "interior_floorlamp", "interior_floorlamp", "floorlamp_2embroidered", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_ceramic", "interior_floorlamp", "interior_floorlamp", "floorlamp_ceramic", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_glass", "interior_floorlamp", "interior_floorlamp", "floorlamp_glass", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_2fringes", "interior_floorlamp", "interior_floorlamp", "floorlamp_2fringes", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_candelabra", "interior_floorlamp", "interior_floorlamp", "floorlamp_candelabra", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_elizabethan", "interior_floorlamp", "interior_floorlamp", "floorlamp_elizabethan", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_gothic", "interior_floorlamp", "interior_floorlamp", "floorlamp_gothic", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_orb", "interior_floorlamp", "interior_floorlamp", "floorlamp_orb", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_bellshade", "interior_floorlamp", "interior_floorlamp", "floorlamp_bellshade", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_crystals", "interior_floorlamp", "interior_floorlamp", "floorlamp_crystals", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_upturn", "interior_floorlamp", "interior_floorlamp", "floorlamp_upturn", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_2upturns", "interior_floorlamp", "interior_floorlamp", "floorlamp_2upturns", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_spool", "interior_floorlamp", "interior_floorlamp", "floorlamp_spool", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_edison", "interior_floorlamp", "interior_floorlamp", "floorlamp_edison", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_adjustable", "interior_floorlamp", "interior_floorlamp", "floorlamp_adjustable", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_rightangles", "interior_floorlamp", "interior_floorlamp", "floorlamp_rightangles", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_lamp_hoofspa", "interior_floor_decor", "interior_floor_decor", "lamp", {
        physics = "post_physics",
        light = DecoCreator:GetLights().GENERAL,
        tags = { "furniture", "playercrafted" },
        onbuilt = true,
        coomonInit = CoomonInit,
        masterInit = MasterInit,
    }),
    DecoCreator:Create("deco_plantholder_winterfeasttree", "interior_floorlamp", "interior_floorlamp", "festivetree_idle",
        {
            physics = "big_post_physics",
            light = DecoCreator:GetLights().FESTIVETREE,
            tags = { "furniture", "playercrafted" },
            onbuilt = true,
            loopanim = true,
            blink = true,
            coomonInit = CoomonInit,
            masterInit = MasterInit,
        })
