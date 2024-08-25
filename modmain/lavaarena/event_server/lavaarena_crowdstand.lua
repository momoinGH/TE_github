local assets =
{
    Asset("ANIM", "anim/lavaarena_boaraudience1.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_1.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_2.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_3.zip"),
    Asset("ANIM", "anim/lavaarena_decor.zip"),
    Asset("ANIM", "anim/lavaarena_banner.zip"),
}

local function stand_postinit(inst)

end

----------------------------------------------------------------------------------------------------

local function OnActivate(inst, doer)
    local altar = GetClosestInstWithTag("recipientedosmobs", inst, 80)
    if altar then
        altar.spider = 0
        altar.hound = 0
        altar.merm = 0
        altar.knight = 0
        altar.boar = 0
        altar.lizard = 0
        inst.bossboar = 0
        inst.rhinocebros = 0
        inst.beetletaur = 0
        altar.arenaativa = 0
        altar.AnimState:PlayAnimation("open", false)
        altar.AnimState:PushAnimation("idle_open", true)
    end

    local pt = inst:GetPosition()
    local procurainimigos = TheSim:FindEntities(pt.x, pt.y, pt.z, 100, { "Arena" })
    for k, achei in pairs(procurainimigos) do
        if achei then
            local a, b, c = achei.Transform:GetWorldPosition()
            local efeito = SpawnPrefab("lavaarena_creature_teleport_small_fx")
            achei:Remove()
            efeito.Transform:SetPosition(a, b, c)
        end
    end

    local a, b, c = inst.Transform:GetWorldPosition()
    local efeito = SpawnPrefab("lavaarena_creature_teleport_small_fx")
    efeito.Transform:SetPosition(a, b, c)
    inst:Remove()
end

local function spectator_postinit(inst)
    inst:RemoveTag("NOCLICK")

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true

    inst:AddComponent("inspectable")
end
add_event_server_data("lavaarena", "prefabs/lavaarena_crowdstand", {
    -- stand_postinit = stand_postinit,
    spectator_postinit = spectator_postinit
}, assets)
