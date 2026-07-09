local assets =
{
    --	Asset("ANIM", "anim/obsidbombactive.zip"),
    Asset("ANIM", "anim/coconade_obsidian.zip"),
}

local prefabs =
{
    "explode_small",
}

local COCONADE_OBSIDIAN_DAMAGE = 350
local COCONADE_OBSIDIAN_EXPLOSIONRANGE = 9
local COCONADE_OBSIDIAN_BUILDINGDAMAGE = 15

local function ondropped(inst)
    if inst:IsOnOcean() then
        inst.AnimState:PlayAnimation("idle_water", true)
    else
        inst.AnimState:PlayAnimation("idle", true)
    end
end

local FADE_FRAMES = 5
local FADE_INTENSITY = .8
local FADE_RADIUS = 1.5
local FADE_FALLOFF = .5

local function OnUpdateFade(inst)
    local k
    if inst._fade:value() <= FADE_FRAMES then
        inst._fade:set_local(math.min(inst._fade:value() + 1, FADE_FRAMES))
        k = inst._fade:value() / FADE_FRAMES
    else
        inst._fade:set_local(math.min(inst._fade:value() + 1, FADE_FRAMES * 2 + 1))
        k = (FADE_FRAMES * 2 + 1 - inst._fade:value()) / FADE_FRAMES
    end

    inst.Light:SetIntensity(FADE_INTENSITY * k)
    inst.Light:SetRadius(FADE_RADIUS * k)
    inst.Light:SetFalloff(1 - (1 - FADE_FALLOFF) * k)

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._fade:value() > 0 and inst._fade:value() <= FADE_FRAMES * 2)
    end

    if inst._fade:value() == FADE_FRAMES or inst._fade:value() > FADE_FRAMES * 2 then
        inst._fadetask:Cancel()
        inst._fadetask = nil
    end
end

local function FadeOut(inst)
    inst._fade:set(FADE_FRAMES + 1)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
end


local function CreateGroundFX(bomb)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.AnimState:SetBank("coconade_obsidian")
    inst.AnimState:SetBuild("coconade_obsidian")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:ListenForEvent("animover", inst.Remove)

    inst.Transform:SetPosition(bomb.Transform:GetWorldPosition())
end



local function OnIgniteFn(inst)
    inst._fx = SpawnPrefab("torchfire")
    inst._fx.entity:SetParent(inst.entity)
    inst._fx.entity:AddFollower()
    inst._fx.Follower:FollowSymbol(inst.GUID, "coconade01", 40, -105, 0)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
end

local function Explode(inst)
    if inst:IsOnOcean() then
        TroSpawnAttackWavesForEnt(inst, nil, nil, 8, 360, 6, "rogue_wave")
    end
    local prefab = "mushroombomb"
    local fx = SpawnPrefab(prefab)
    fx.Transform:SetPosition(x, y, z)
    fx.AnimState:PlayAnimation("explode")
    fx.Transform:SetScale(2.5, 2.5, 2.5)
    fx:DoTaskInTime(fx.AnimState:GetCurrentAnimationLength(), fx.Remove)
    fx.persists = false

    fx._explode:push()
    FadeOut(fx)

    if not TheNet:IsDedicated() then
        CreateGroundFX(fx)
    end

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_explode")
    inst.SoundEmitter:KillSound("hiss")
    inst.components.explosive:OnBurnt()
end


local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("coconade_obsidian")
    inst.AnimState:SetBuild("coconade_obsidian")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("explosive")
    inst:AddTag("SCARYTOPREY")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("explosive")
    inst.components.explosive.explosivedamage = COCONADE_OBSIDIAN_DAMAGE
    inst.components.explosive.explosiverange = COCONADE_OBSIDIAN_EXPLOSIONRANGE
    inst.components.explosive.buildingdamage = COCONADE_OBSIDIAN_BUILDINGDAMAGE

    inst._light = nil

    inst:DoTaskInTime(0, OnIgniteFn)
    inst:DoTaskInTime(3, Explode)
    inst:DoTaskInTime(0, ondropped)
    return inst
end

return Prefab("obsidiancoconadeactive", fn, assets)
