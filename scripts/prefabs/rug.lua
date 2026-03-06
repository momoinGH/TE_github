local assets =
{
    Asset("ANIM", "anim/rugs.zip"),
    Asset("ANIM", "anim/interior_wall_decals_mayorsoffice.zip"),
    Asset("ANIM", "anim/interior_wall_decals_palace.zip"),
}

----------------------------------------------------------------------------------------------------
local function OnBuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
end

local function OnHammered(inst)
    local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    collapse_fx:SetMaterial("wood")
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function MakeRug(name, data)
    data = data or {}

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank(data.bank or "rugs")
        inst.AnimState:SetBuild(data.build or "rugs")
        inst.AnimState:PlayAnimation(data.anim or name)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)

        if data.face == 2 then
            inst.Transform:SetTwoFaced()
        end

        inst:AddTag("NOBLOCK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("lootdropper")
        inst:AddComponent("tro_saveanim")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnWorkCallback(OnHammered)

        inst:ListenForEvent("onbuilt", OnBuilt)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeRug("rug_round"),
    MakeRug("rug_oval"),
    MakeRug("rug_square"),
    MakeRug("rug_rectangle"),
    MakeRug("rug_leather"),
    MakeRug("rug_fur"),
    MakeRug("rug_circle", { anim = "half_circle" }),
    MakeRug("rug_hedgehog"),
    MakeRug("rug_porcupuss", { face = 2 }),
    MakeRug("rug_hoofprint", { anim = "rug_hoofprints" }),
    MakeRug("rug_octagon"),
    MakeRug("rug_swirl"),
    MakeRug("rug_catcoon"),
    MakeRug("rug_rubbermat"),
    MakeRug("rug_web"),
    MakeRug("rug_metal"),
    MakeRug("rug_wormhole"),
    MakeRug("rug_braid"),
    MakeRug("rug_beard"),
    MakeRug("rug_nailbed"),
    MakeRug("rug_crime"),
    MakeRug("rug_tiles"),
    MakeRug("rug_cityhall_corners", { anim = "corner_back", build = "interior_wall_decals_mayorsoffice", bank = "wall_decals_mayorsoffice" }),
    MakeRug("rug_palace_corners", { anim = "floortrim_corner", build = "interior_wall_decals_palace", bank = "wall_decals_palace" }),
    MakeRug("rug_palace_runner", { anim = "rug_throneroom" })
