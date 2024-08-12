local DecoCreator = require "prefabs/deco_util"

local function OnBuilt(inst, data)
    inst.SoundEmitter:PlaySound("dontstarve/common/repair_stonefurniture")

    local builder = (data and data.builder) or nil
    TheWorld:PushEvent("CHEVO_makechair", { target = inst, doer = builder })
end

local function CommonInit(inst)
    inst.AnimState:SetFinalOffset(-1)
end

local function MasterInit(inst)
    inst:AddComponent("sittable")

    inst:ListenForEvent("onbuilt", OnBuilt)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
end

local function MakeChair(name, anim, data)
    data = data or {}
    return DecoCreator:Create(name, data.build or "interior_chair", data.bank or "interior_chair", anim,
        {
            physics = data.physics or "chair_physics_small",
            tags = { "furniture" },
            decal = true,
            onbuilt = true,
            commonInit = CommonInit,
            masterInit = MasterInit
        })
end

return MakeChair("deco_chair_classic", "chair_classic"),
    MakeChair("deco_chair_corner", "chair_corner"),
    MakeChair("deco_chair_bench", "chair_bench"),
    MakeChair("deco_chair_horned", "chair_horned"),
    MakeChair("deco_chair_footrest", "chair_footrest"),
    MakeChair("deco_chair_lounge", "chair_lounge"),
    MakeChair("deco_chair_massager", "chair_massager"),
    MakeChair("deco_chair_stuffed", "chair_stuffed"),
    MakeChair("deco_chair_rocking", "chair_rocking"),
    MakeChair("deco_chair_ottoman", "chair_ottoman"),
    MakeChair("deco_chaise", "chaise", { build = "interior_floor_decor", bank = "interior_floor_decor", physics = "sofa_physics", })
