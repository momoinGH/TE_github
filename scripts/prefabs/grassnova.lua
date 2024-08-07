local Constructor = require("tropical_utils/constructor")

local assets =
{
    Asset("ANIM", "anim/grassgreen_build.zip"),
    Asset("ANIM", "anim/grass_diseased_build.zip"),
}

local function Init(inst)
    inst.MiniMapEntity:SetIcon("grassGreen.png")

    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("grassgreen_build")
end

return Constructor.CopyPrefab("grassnova", "grass", { init = Init, assets = assets })
