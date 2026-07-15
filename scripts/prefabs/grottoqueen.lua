local assets =
{
    Asset("ANIM", "anim/grotto_mowlth_basic.zip"),
}

local prefabs =
{
    "beeguard",
    "honey_trail",
    "splash_sink",
    "royal_jelly",
    "honeycomb",
    "honey",
    "stinger",
    "hivehat",
    "bundlewrap_blueprint",
    "chesspiece_beequeen_sketch",
}

SetSharedLootTable('grottoqueen',
    {
        { 'royal_jelly',                1.00 },
        { 'royal_jelly',                1.00 },
        { 'royal_jelly',                1.00 },
        { 'royal_jelly',                1.00 },
        { 'royal_jelly',                1.00 },
        { 'royal_jelly',                1.00 },
        { 'royal_jelly',                0.50 },
        { 'honeycomb',                  1.00 },
        { 'honeycomb',                  0.50 },
        { 'honey',                      1.00 },
        { 'honey',                      1.00 },
        { 'honey',                      1.00 },
        { 'honey',                      0.50 },
        { 'stinger',                    1.00 },
        { 'hivehat',                    1.00 },
        { 'bundlewrap_blueprint',       1.00 },
        { 'chesspiece_beequeen_sketch', 1.00 },
    })

local brain = require("brains/grottoqueenbrain")

--------------------------------------------------------------------------

local function PushMusic(inst)
    if ThePlayer == nil or inst:HasTag("flight") then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", { name = "beequeen" })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 50) then
        inst._playingmusic = false
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst.DynamicShadow:SetSize(4, 2)

    MakeFlyingGiantCharacterPhysics(inst, 500, 1.4)

    inst.AnimState:SetBank("mowlth")
    inst.AnimState:SetBuild("grotto_mowlth_basic")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("epic")
    inst:AddTag("noepicmusic")
    inst:AddTag("insect")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")

    inst.entity:SetPristine()

    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        inst._playingmusic = false
        inst:DoPeriodicTask(1, PushMusic, 0)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('grottoqueen')

    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }
    inst.components.locomotor.walkspeed = TUNING.BEEQUEEN_SPEED

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BEEQUEEN_HEALTH)
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")

    inst:AddComponent("sanityaura")

    inst:AddComponent("knownlocations")

    MakeLargeBurnableCharacter(inst, "swap_fire")
    MakeHugeFreezableCharacter(inst, "hive_body")
    inst.components.freezable.diminishingreturns = true

    inst:SetStateGraph("SGgrottoqueen")
    inst:SetBrain(brain)

    return inst
end

return Prefab("grottoqueen", fn, assets, prefabs)
